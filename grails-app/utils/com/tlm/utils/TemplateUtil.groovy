package com.tlm.utils

import java.util.Map;
import org.springframework.core.io.ClassPathResource

class TemplateUtil {
	
	static String USER_NAME = "{userName}"
	static String UNSUBSCRIBE_LINK = "{unsubscribeLink}"
	static String FORWARD_LINK = "{forwardLink}"
	static String VIEW_ONLINE_LINK = "{viewOnlineLink}"
	
	private static final String EMAIL_TEMPLATE;
	private static final String FORWARD_ELEMENT;
	private static final String GREETING_ELEMENT;
	private static final String UNSUBSCRIBE_ELEMENT;
	private static final String VIEW_ONLINE_ELEMENT;
	
	static {
		EMAIL_TEMPLATE = new ClassPathResource("email_template.html").getFile().getText()
		FORWARD_ELEMENT = new ClassPathResource("forward_element.html").getFile().getText()
		GREETING_ELEMENT = new ClassPathResource("greeting_element.html").getFile().getText()
		UNSUBSCRIBE_ELEMENT = new ClassPathResource("unsubscribe_element.html").getFile().getText()
		VIEW_ONLINE_ELEMENT = new ClassPathResource("view_online_element.html").getFile().getText()
	}
	
	static def processTemplate(String templateHtml, Map<String, String> dynamicData) {
		String finalHtml = EMAIL_TEMPLATE
		
		// insert a greeting if needed
		String greeting = dynamicData.get(USER_NAME) ? GREETING_ELEMENT.replace(USER_NAME, dynamicData.get(USER_NAME)) : ""
		finalHtml = finalHtml.replace("{greetingElement}", greeting)
		
		// insert a forward-to-friend if needed
		String forward = dynamicData.get(FORWARD_LINK) ? FORWARD_ELEMENT.replace(FORWARD_LINK, dynamicData.get(FORWARD_LINK)) : ""
		finalHtml = finalHtml.replace("{forwardElement}", forward)
		
		// insert a unsubscribe if needed
		String unsubscribe = dynamicData.get(UNSUBSCRIBE_LINK) ? UNSUBSCRIBE_ELEMENT.replace(UNSUBSCRIBE_LINK, dynamicData.get(UNSUBSCRIBE_LINK)) : ""
		finalHtml = finalHtml.replace("{unsubscribeElement}", unsubscribe)
		
		// insert a view online if needed
		String viewOnline = dynamicData.get(VIEW_ONLINE_LINK) ? VIEW_ONLINE_ELEMENT.replace(VIEW_ONLINE_LINK, dynamicData.get(VIEW_ONLINE_LINK)) : ""
		finalHtml = finalHtml.replace("{viewOnlineElement}", viewOnline)
		
		// finally, throw in the actual html template stuff
		finalHtml = finalHtml.replace("{templateContent}", templateHtml)
		
		return finalHtml;

	}

}
