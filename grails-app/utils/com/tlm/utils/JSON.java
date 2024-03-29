package com.tlm.utils;

import grails.util.GrailsWebUtil;
import groovy.lang.Closure;
import groovy.util.BuilderSupport;

import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.io.Writer;
import java.sql.Blob;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.groovy.grails.commons.ApplicationHolder;
import org.codehaus.groovy.grails.web.converters.Converter;
import org.codehaus.groovy.grails.web.converters.ConverterUtil;
import org.codehaus.groovy.grails.web.converters.configuration.ConverterConfiguration;
import org.codehaus.groovy.grails.web.converters.configuration.ConvertersConfigurationHolder;
import org.codehaus.groovy.grails.web.converters.configuration.DefaultConverterConfiguration;
import org.codehaus.groovy.grails.web.converters.exceptions.ConverterException;
import org.codehaus.groovy.grails.web.converters.marshaller.ClosureOjectMarshaller;
import org.codehaus.groovy.grails.web.converters.marshaller.ObjectMarshaller;
import org.codehaus.groovy.grails.web.json.JSONArray;
import org.codehaus.groovy.grails.web.json.JSONElement;
import org.codehaus.groovy.grails.web.json.JSONException;
import org.codehaus.groovy.grails.web.json.JSONObject;
import org.codehaus.groovy.grails.web.json.JSONTokener;
import org.codehaus.groovy.grails.web.json.JSONWriter;
import org.codehaus.groovy.grails.web.json.PathCapturingJSONWriterWrapper;
import org.codehaus.groovy.grails.web.json.PrettyPrintJSONWriter;
import org.hibernate.SessionFactory;
import org.springframework.context.ApplicationContext;

/**
 * A converter that converts domain classes, Maps, Lists, Arrays, POJOs and POGOs to JSON
 *
 * @author Siegfried Puchbauer
 * @author Graeme Rocher
 */
public class JSON extends grails.converters.JSON {

    private final static Log log = LogFactory.getLog(JSON.class);

    private Object target;
    private final String encoding;

    protected JSONWriter writer;

    protected Stack<Object> referenceStack;

    private static final String CACHED_JSON = "org.codehaus.groovy.grails.CACHED_JSON_REQUEST_CONTENT";

    private final ConverterConfiguration<grails.converters.JSON> config;

    private final CircularReferenceBehaviour circularReferenceBehaviour;

    private boolean prettyPrint;
    
    private static final String JAVASSIST_START_TOKEN = "_$$_"; 
    
    private SessionFactory   sessionFactory;

    protected ConverterConfiguration<grails.converters.JSON> initConfig() {
        return ConvertersConfigurationHolder.getConverterConfiguration(grails.converters.JSON.class);
    }

    /**
     * Default Constructor for a JSON Converter
     */
    public JSON() {
        config = initConfig();
        this.encoding = config!= null ? this.config.getEncoding() : "UTF-8";
        this.circularReferenceBehaviour = config!= null ? this.config.getCircularReferenceBehaviour() : CircularReferenceBehaviour.DEFAULT;
        this.prettyPrint = config != null && this.config.isPrettyPrint();
        this.target = null;
    }

    /**
     * Creates a new JSON Converter for the given Object
     *
     * @param target the Object to convert
     */
    public JSON(Object target) {
        this();
        setTarget(target);
    }

    public void setPrettyPrint(boolean prettyPrint) {
        this.prettyPrint = prettyPrint;
    }

    private void prepareRender(Writer out) {
        this.writer = this.prettyPrint ?
                new PrettyPrintJSONWriter(out) :
                new JSONWriter(out);
        if(this.circularReferenceBehaviour == CircularReferenceBehaviour.PATH) {
            if(log.isInfoEnabled()) {
                log.info(String.format("Using experimental CircularReferenceBehaviour.PATH for %s", getClass().getName()));
            }
            this.writer = new PathCapturingJSONWriterWrapper(this.writer);
        }
        referenceStack = new Stack<Object>();
    }

    private void finalizeRender(Writer out) {
        try {
            out.flush();
            out.close();
        }
        catch (Exception e) {
            log.warn("Unexpected exception while closing a writer: " + e.getMessage());
        }
    }

    /**
     * Directs the JSON Writer to the given Writer
     *
     * @param out the Writer
     * @throws org.codehaus.groovy.grails.web.converters.exceptions.ConverterException
     *
     */
    public void render(Writer out) throws ConverterException {
        prepareRender(out);
        try {
            value(this.target);
        }
        finally {
            finalizeRender(out);
        }
    }

    /**
     * Directs the JSON Writer to the Outputstream of the HttpServletResponse and sets the Content-Type to application/json
     *
     * @param response a HttpServletResponse
     * @throws ConverterException
     */
    public void render(HttpServletResponse response) throws ConverterException {
        response.setContentType(GrailsWebUtil.getContentType("application/json", this.encoding));
        try {
            render(response.getWriter());
        }
        catch (IOException e) {
            throw new ConverterException(e);
        }
    }

    public JSONWriter getWriter() throws ConverterException {
        return writer;
    }

    public void convertAnother(Object o) throws ConverterException {
        value(o);
    }

    public void build(Closure c) throws ConverterException {
        new Builder(this).execute(c);
    }
    
    private Long getIdIfAny(Object bean) {
    	PropertyDescriptor descriptors[] = PropertyUtils.getPropertyDescriptors(bean);
    	Long targetId = null;
    	for (PropertyDescriptor descriptor : descriptors) {
    		if (descriptor.getName().equals("id") && descriptor.getPropertyType().equals(Long.class)) {
    			try {
					targetId = (Long) PropertyUtils.getProperty(bean, "id");
					
				} catch (Exception ex) {
					ex.printStackTrace();
					throw new RuntimeException(ex);
				}
				break;
    		}
    	}
    	
    	return targetId;
    }
    
    private boolean advancedContains(Stack<Object> stack, Object obj) {
    	// do a straightforward contains first.  if it is true, just return true
    	if (stack.contains(obj)) {
    		return true;
    	}
    	
    	// force a stop at 5 levels deep
    	if (stack.size() > 5) {
    		return true;
    	}
    	
    	// otherwise, do a deeper compare
    	Long targetId = getIdIfAny(obj);
    	
    	
    	if (targetId == null) {
    		return false;
    	} else {
    		// get class names without any javassist nonsense
    		String rawClassName = obj.getClass().getCanonicalName();
    		String cleanClassName = rawClassName.contains(JAVASSIST_START_TOKEN) ? rawClassName.substring(0, rawClassName.indexOf(JAVASSIST_START_TOKEN)) : rawClassName;
    		
    		// compare with each object in the stack
    		for (Object pop : stack) {
    			Long popId = getIdIfAny(obj);
    			String popRawClassName = pop.getClass().getCanonicalName();
    			String popCleanClassName = popRawClassName.contains(JAVASSIST_START_TOKEN) ? popRawClassName.substring(0, popRawClassName.indexOf(JAVASSIST_START_TOKEN)) : popRawClassName;
    			
    			if (cleanClassName.equals(popCleanClassName) && targetId.equals(popId)) {
    				//System.out.println("Found an interesting match.  Class " + rawClassName + " with id "+ targetId +" matches class " +popRawClassName + " with id "+popId);
    				return true;
    			}
    		}
    	}
    	
    	return false;

    	

    }

    /**
     * @param o
     * @throws ConverterException
     */
    public void value(Object o) throws ConverterException {
    	//if (o != null) {
    	  // System.out.println("Converting an object of class " + o.getClass().getCanonicalName());
    	//}
    	
        try {
            if (o == null || o.equals(JSONObject.NULL)) {
                writer.value(null);
            } else if (o instanceof CharSequence) {
                writer.value(o);
            } else if (o instanceof Class<?>) {
                writer.value(((Class<?>) o).getName());
            }
            else if (o instanceof Date){
            	Format formatter = new SimpleDateFormat("E, dd MMM yyyy HH:mm:ss Z"); 
            	writer.value(formatter.format((Date)o));
            }
            else if (o instanceof Blob){
                	writer.value(null);                
            } else if ((o.getClass().isPrimitive() && !o.getClass().equals(byte[].class))
                    || o instanceof Number || o instanceof Boolean) {
                writer.value(o);
            }             	           
            else{
            	
//            	boolean found=false;
//            	if ( o instanceof com.tlm.beans.Subscription){
//            		if (getDepth()>1)
//            		{
//                		writer.value(null);
//                		found=true;
//            		}
//            	}
//            	if (!found){
                //if (referenceStack.contains(o) ) {
	            	if (advancedContains(referenceStack, o)) {
	                    handleCircularRelationship(o);
	                } else {
                		if (o instanceof com.tlm.beans.Publication)
                		{
                			com.tlm.beans.Publication pub = (com.tlm.beans.Publication)o;
                			pub.setSubscriptions(null);
                			pub.setSuppliers(null);

                			pub.setMastHead(null);
                			pub.setMediaKit(null);
                			pub.setEvents(null);
                			pub.setNews(null);
                			pub.setAds(null);
                			pub.setAdvertiser(null);
                			pub.setIssues(null);
                			if (this.getDepth()>1)
                				pub.setHtmlWriteUp(null);
                			
                		}
                		if (o instanceof com.tlm.beans.LookupHonorific)
                		{
                			com.tlm.beans.LookupHonorific pub = (com.tlm.beans.LookupHonorific)o;
                			pub.setUsers(null);
                		}
                		if (o instanceof com.tlm.beans.JobFunction)
                		{
                			com.tlm.beans.JobFunction job = (com.tlm.beans.JobFunction)o;
                			job.setUsers(null);
                		}
                		if (o instanceof com.tlm.beans.JobPosition)
                		{
                			com.tlm.beans.JobPosition job = (com.tlm.beans.JobPosition)o;
                			job.setUsers(null);
                		}
                		if (o instanceof com.tlm.beans.LookupHonorific)
                		{
                			com.tlm.beans.LookupHonorific pub = (com.tlm.beans.LookupHonorific)o;
                			pub.setUsers(null);
                		}
                		if (o instanceof com.tlm.beans.Country)
                		{
                			com.tlm.beans.Country pub = (com.tlm.beans.Country)o;
                			pub.setUsers(null);
                		}
                		if (o instanceof com.tlm.beans.User)
                		{
                			com.tlm.beans.User pub = (com.tlm.beans.User)o;
                			pub.setSubscriptions(null);
                		}
                		if (o instanceof com.tlm.beans.Role)
                		{
                			com.tlm.beans.Role pub = (com.tlm.beans.Role)o;
                			pub.setUsers(null);
                		}
                		if (o instanceof com.tlm.beans.Issue)
                		{
                			com.tlm.beans.Issue issue = (com.tlm.beans.Issue)o;
                			issue.setDownloadCounts(null);
                			issue.setPublication(null);
                			issue.setThumbnail(null);
                		}
                		if (o instanceof com.tlm.beans.Document)
                		{
                			com.tlm.beans.Document document = (com.tlm.beans.Document)o;
                			document.setFileData(null);
                		}
                			                    
	                    referenceStack.push(o);                    
	                    ObjectMarshaller<grails.converters.JSON> marshaller = config.getMarshaller(o);
	                    if (marshaller == null) {
	                        throw new ConverterException("Unconvertable Object of class: " + o.getClass().getName());
	                    }
	                    marshaller.marshalObject(o, this);
	                                       
	                    referenceStack.pop();
	                   
	                }
	            }
//            }
          
        }
        catch (ConverterException ce) {
            throw ce;
        }
        catch (JSONException e) {
            throw new ConverterException(e);
        }
        if (referenceStack.size() == 0) 
        {
	        try {
	            ApplicationContext ctx = ApplicationHolder.getApplication().getMainContext();
	    		sessionFactory = (SessionFactory) ctx.getBean("sessionFactory");          
	            sessionFactory.getCurrentSession().clear();
	        }catch (Exception e){
	        	e.printStackTrace();	                    
	        }
    	}
    }

    public ObjectMarshaller<grails.converters.JSON> lookupObjectMarshaller(Object target) {
        return config.getMarshaller(target);
    }

    public int getDepth() {
        return referenceStack.size();
    }

    public void property(String key, Object value) throws JSONException, ConverterException {
        writer.key(key);
        value(value);
    }

    /**
     * Performs the conversion and returns the resulting JSON as String
     *
     * @param prettyPrint true, if the output should be indented, otherwise false
     * @return a JSON String
     * @throws JSONException
     */
    public String toString(boolean prettyPrint) throws JSONException {
        String json = super.toString();
        if (prettyPrint) {
            Object jsonObject = new JSONTokener(json).nextValue();
            if (jsonObject instanceof JSONObject)
                return ((JSONObject) jsonObject).toString(3);
            else if (jsonObject instanceof JSONArray)
                return ((JSONArray) jsonObject).toString(3);
        }
        return json;
    }

    /**
     * Parses the given JSON String and returns ether a JSONObject or a JSONArry
     *
     * @param reader JSON source
     * @return ether a JSONObject or a JSONArray - depending on the given JSON
     * @throws ConverterException when the JSON content is not valid
     */
    public static JSONElement parse(Reader reader) throws ConverterException {
//        TODO: Migrate to new javacc based parser         
//        JSONParser parser = new JSONParser(reader);
//        try {
//            return parser.parseJSON();
//        }
//        catch (ParseException e) {
//            throw new ConverterException("Error parsing JSON: " + e.getMessage(), e);
//        }

        try {
            return parse(IOUtils.toString(reader));
        }
        catch (IOException e) {
            throw new ConverterException(e);
        }
    }

    /**
     * Parses the given JSON String and returns ether a JSONObject or a JSONArry
     *
     * @param source A string containing some JSON
     * @return ether a JSONObject or a JSONArray - depending on the given JSON
     * @throws ConverterException when the JSON content is not valid
     */
    public static JSONElement parse(String source) throws ConverterException {
        // TODO: Migrate to new javacc based parser
        try {
            final Object value = new JSONTokener(source).nextValue();
            if(value instanceof JSONElement)
                return (JSONElement) value;
            else {
                // return empty object
                return new JSONObject();
            }

        }
        catch (JSONException e) {
            throw new ConverterException("Error parsing JSON", e);
        }
    }

    /**
     * Parses the given JSON and returns ether a JSONObject or a JSONArry
     *
     * @param is       An InputStream which delivers some JSON
     * @param encoding the Character Encoding to use
     * @return ether a JSONObject or a JSONArray - depending on the given JSON
     * @throws ConverterException when the JSON content is not valid
     */
    public static JSONElement parse(InputStream is, String encoding) throws ConverterException {
//        TODO: Migrate to new javacc based parser
//        JSONParser parser = new JSONParser(is, encoding);
//        try {
//            return parser.parseJSON();
//        }
//        catch (ParseException e) {
//            throw new ConverterException("Error parsing JSON: " + e.getMessage(), e);
//        }
        try {
            return parse(IOUtils.toString(is, encoding));
        }
        catch (IOException e) {
            throw new ConverterException(e);
        }
    }

//    public static Object oldParse(InputStream is, String encoding) throws ConverterException {
//        try {
//            return parse(IOUtils.toString(is, encoding));
//        }
//        catch (IOException e) {
//            throw new ConverterException("Error parsing JSON", e);
//        }
//    }

    /**
     * Parses the given request's InputStream and returns ether a JSONObject or a JSONArry
     *
     * @param request the JSON Request
     * @return ether a JSONObject or a JSONArray - depending on the given JSON
     * @throws ConverterException when the JSON content is not valid
     */
    public static Object parse(HttpServletRequest request) throws ConverterException {
        Object json = request.getAttribute(CACHED_JSON);
        if (json != null) return json;
        String encoding = request.getCharacterEncoding();
        if (encoding == null)
            encoding = Converter.DEFAULT_REQUEST_ENCODING;
        try {
            json = parse(request.getInputStream(), encoding);
            request.setAttribute(CACHED_JSON, json);
            return json;
        }
        catch (IOException e) {
            throw new ConverterException("Error parsing JSON", e);
        }
    }

    /**
     * Sets the Object which is later converted to JSON
     *
     * @param target the Object
     * @see org.codehaus.groovy.grails.web.converters.Converter
     */
    public void setTarget(Object target) {
        this.target = target;

    }

    protected void handleCircularRelationship(Object o) throws ConverterException {
        switch (circularReferenceBehaviour) {
            case DEFAULT:
                {
                    if(!(Map.class.isAssignableFrom(o.getClass())||Collection.class.isAssignableFrom(o.getClass()))) {
                        Map<String, Object> props = new HashMap<String, Object>();
                        props.put("class", o.getClass());
                        StringBuilder ref = new StringBuilder();
                        int idx = referenceStack.indexOf(o);
                        for (int i = referenceStack.size() - 1; i > idx; i--) {
                            ref.append("../");
                        }
                        props.put("_ref", ref.substring(0, ref.length() - 1));
                        value(props);
                    }
                }
                break;
            case EXCEPTION:
                throw new ConverterException("Circular Reference detected: class " + o.getClass().getName());
            case INSERT_NULL:
                value(null);
                break;
            case PATH:
                {
                    Map<String, Object> props = new HashMap<String, Object>();
                    props.put("class", o.getClass());
                    int idx = referenceStack.indexOf(o);
                    PathCapturingJSONWriterWrapper pcWriter = (PathCapturingJSONWriterWrapper) this.writer;
                    props.put("ref", String.format("root%s", pcWriter.getStackReference(idx)));
                    value(props);
                }
                break;
            case IGNORE:
                break;
        }
    }

    public static ConverterConfiguration<grails.converters.JSON> getNamedConfig(String configName) throws ConverterException {
        ConverterConfiguration<grails.converters.JSON> cfg = ConvertersConfigurationHolder.getNamedConverterConfiguration(configName, grails.converters.JSON.class);
        if (cfg == null)
            throw new ConverterException(String.format("Converter Configuration with name '%s' not found!", configName));
        return cfg;
    }

    public static Object use(String configName, Closure callable) throws ConverterException {
        ConverterConfiguration<JSON> old = ConvertersConfigurationHolder.getThreadLocalConverterConfiguration(JSON.class);
        ConverterConfiguration<grails.converters.JSON> cfg = getNamedConfig(configName);
        ConvertersConfigurationHolder.setTheadLocalConverterConfiguration(grails.converters.JSON.class, cfg);
        try {
            return callable.call();
        }
        finally {
            ConvertersConfigurationHolder.setTheadLocalConverterConfiguration(JSON.class, old);
        }
    }

    public static void use(String cfgName) throws ConverterException {
        if (cfgName == null || "default".equals(cfgName))
            ConvertersConfigurationHolder.setTheadLocalConverterConfiguration(JSON.class, null);
        else
            ConvertersConfigurationHolder.setTheadLocalConverterConfiguration(grails.converters.JSON.class, getNamedConfig(cfgName));
    }

    public static void registerObjectMarshaller(Class<?> clazz, Closure callable) throws ConverterException {
        registerObjectMarshaller(new ClosureOjectMarshaller<JSON>(clazz, callable));
    }

    public static void registerObjectMarshaller(Class<?>clazz, int priority, Closure callable) throws ConverterException {
        registerObjectMarshaller(new ClosureOjectMarshaller<JSON>(clazz, callable), priority);
    }

    public static void registerObjectMarshaller(ObjectMarshaller<JSON> om) throws ConverterException {
        ConverterConfiguration<JSON> cfg = ConvertersConfigurationHolder.getConverterConfiguration(JSON.class);
        if (cfg == null)
            throw new ConverterException("Default Configuration not found for class " + JSON.class.getName());
        if (!(cfg instanceof DefaultConverterConfiguration)) {
            cfg = new DefaultConverterConfiguration<JSON>(cfg);
            ConvertersConfigurationHolder.setDefaultConfiguration(JSON.class, cfg);
        }
        ((DefaultConverterConfiguration<JSON>) cfg).registerObjectMarshaller(om);
    }

    public static void registerObjectMarshaller(ObjectMarshaller<JSON> om, int priority) throws ConverterException {
        ConverterConfiguration<JSON> cfg = ConvertersConfigurationHolder.getConverterConfiguration(JSON.class);
        if (cfg == null)
            throw new ConverterException("Default Configuration not found for class " + JSON.class.getName());
        if (!(cfg instanceof DefaultConverterConfiguration)) {
            cfg = new DefaultConverterConfiguration<JSON>(cfg);
            ConvertersConfigurationHolder.setDefaultConfiguration(JSON.class, cfg);
        }
        ((DefaultConverterConfiguration<JSON>) cfg).registerObjectMarshaller(
                om, priority
        );
    }

    public static void createNamedConfig(String name, Closure callable) throws ConverterException {
        DefaultConverterConfiguration<JSON> cfg = new DefaultConverterConfiguration<JSON>(ConvertersConfigurationHolder.getConverterConfiguration(JSON.class));
        try {
            callable.call(cfg);
            ConvertersConfigurationHolder.setNamedConverterConfiguration(JSON.class, name, cfg);
        }
        catch (Exception e) {
            throw ConverterUtil.resolveConverterException(e);
        }
    }

    public static void withDefaultConfiguration(Closure callable) throws ConverterException {
        ConverterConfiguration<JSON> cfg = ConvertersConfigurationHolder.getConverterConfiguration(JSON.class);
        if (!(cfg instanceof DefaultConverterConfiguration)) {
            cfg = new DefaultConverterConfiguration<JSON>(cfg);

        }
        try {
            callable.call(cfg);
            ConvertersConfigurationHolder.setDefaultConfiguration(JSON.class, cfg);
            ConvertersConfigurationHolder.setDefaultConfiguration(JSON.class, cfg);
        }
        catch (Throwable t) {
            throw ConverterUtil.resolveConverterException(t);
        }
    }

    public class Builder extends BuilderSupport {

        private JSON json;

        public Builder(JSON json) {
            this.json = json;
            this.writer = json.writer;
        }

        public void execute(Closure callable) {
            callable.setDelegate(this);
//            callable.setDelegate(Closure.DELEGATE_FIRST);
            this.invokeMethod("json", new Object[] { callable });
        }
        
        private Stack<BuilderMode> stack = new Stack<BuilderMode>();

        private boolean start = true;

        private JSONWriter writer;

        protected Object createNode(Object name) {
            int retVal = 1;
            try {
                if( start ){
                    start = false;
                    writeObject();
                }else{
                    if( getCurrent() == null && stack.peek() == BuilderMode.OBJECT) throw new IllegalArgumentException( "only call to [element { }] is allowed when creating array");
                    if (stack.peek() == BuilderMode.ARRAY) {
                        writeObject();
                        retVal = 2;
                    }
                    writer.key(String.valueOf(name)).array();
                    stack.push(BuilderMode.ARRAY);
                }
            } catch (JSONException e) {
                throw new IllegalArgumentException( "invalid element" );
            }

            return retVal;
        }

        protected Object createNode(Object key, Map valueMap) {
            try {
                if( stack.peek().equals(BuilderMode.OBJECT) ) writer.key(String.valueOf(key));
                writer.object();
                for (Object o : valueMap.entrySet()) {
                    Map.Entry element = (Map.Entry) o;
                    writer.key(String.valueOf(element.getKey()));//.value(element.getValue());
                    json.convertAnother(element.getValue());
                }
                writer.endObject();
                return null;
            } catch (JSONException e) {
                throw new IllegalArgumentException( "invalid element" );
            }
        }

        protected Object createNode(Object arg0, Map arg1, Object arg2) {
            throw new IllegalArgumentException( "not implemented" );
        }

        protected Object createNode(Object key, Object value) {
            if( getCurrent() == null && stack.peek()== BuilderMode.OBJECT) throw new IllegalArgumentException( "only call to [element { }] is allowed when creating array");
            try {
                int retVal = 0;
                if( stack.peek().equals(BuilderMode.ARRAY) ){
                    writeObject();
                    retVal = 1;
                }
                if(value instanceof Collection) {
                    Collection c = (Collection)value;
                    writer.key(String.valueOf(key));
                    handleCollectionRecurse(c);
                }
                else {
                    writer.key(String.valueOf(key));
                    json.convertAnother(value); //.value(value);
                }
                return retVal != 0 ? retVal : null;
            } catch (JSONException e) {
                throw new IllegalArgumentException( "invalid element");
            }
        }

        private void handleCollectionRecurse(Collection c) throws JSONException {
            writer.array();
            for (Object element : c) {
                if (element instanceof Collection) {
                    handleCollectionRecurse((Collection) element);
                } else {
                    json.convertAnother(element);
                }
            }
            writer.endArray();
        }

        protected void nodeCompleted(Object parent, Object node) {
            Object last = null;

            if( node != null ){
                try {
                    int i = ((Integer)node);
                    while( i-- > 0 ){
                        last = stack.pop();
                        if( BuilderMode.ARRAY == last ) writer.endArray();
                        if( BuilderMode.OBJECT == last ) writer.endObject();
                    }
                }
                catch (JSONException e) {
                    throw new IllegalArgumentException( "invalid element on the stack" );
                }
            }
        }

        protected void setParent(Object arg0, Object arg1) {
            /* do nothing */
        }

        private void writeObject() throws JSONException {
            writer.object();
            stack.push(BuilderMode.OBJECT);
        }
    }

    private enum BuilderMode {
        ARRAY,
        OBJECT
    }
    
 

}
