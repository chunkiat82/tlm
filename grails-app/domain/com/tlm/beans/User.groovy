package com.tlm.beans

import java.util.Map;

import com.tlm.utils.EncodingUtil;

class User {
	static searchable = true
	static Integer PENDING = 1
	static Integer ACTIVE = 0
	static Integer DISABLED = -1
	
	static transients = ['password', 'confirmPassword', 'fullName', 'accountStatusLabel','displayColumns','nonSubscribers']

    static constraints = {
		userName(blank:false, nullable: false, unique: true)
		salt(blank:true, nullable: false) // blank salt or no salt allowed
		hashPassword(blank:false, nullable: false)
		
		honorific(nullable: false)
		firstName(nullable: false, blank: false)
		lastName(nullable: false, blank: false)
		email(nullable: false, blank: false, email: true)
		gender(nullable: false, blank: false)
		
		company(nullable: true, blank: true)
		jobFunction(nullable: true)
		jobPosition(nullable: true)
		
		address(nullable: true, blank: true)
		postal(nullable: true, blank: true)
		city(nullable: true, blank: true)
		state(nullable: true, blank: true)
		country(nullable: false)
		
		telephone(nullable: false, blank: false)
		fax(nullable: true, blank: true)
		mobile(nullable: true, blank: true)

        accountStatus(nullable: false)
		activationCode(nullable: true)

        // validates transients
		password(blank: false, minSize:3, validator:{val,obj -> 
			obj.properties['confirmPassword'] == val
		})
		
	}
    static hasMany = [subscriptions:Subscription, roles: Role, downloadCounts: DownloadCount]
    static belongsTo = [Role]


    
    // login details
    String userName
    String salt
    String hashPassword
	
	// TRANSIENTS
	String password
	String confirmPassword
	
    // basic particulars
    LookupHonorific honorific
    String firstName
    String lastName                      
    String email
	String gender
	
	// employment details
    String company	
    JobFunction jobFunction
    JobPosition jobPosition
	
	// location details
    String address
    String postal
    String city
    String state
    Country country
	
	// contact details
    String telephone
    String fax
    String mobile
	
	// record details (automatically set by grails)
	Date dateCreated
	Date lastUpdated
	
	Integer accountStatus
	String activationCode
	
	Boolean enabled = true
	
	String toString()
	{
		return "$lastName, $firstName ($userName)"
	}

	/**
	 * Overrides the default setPassword generated by grails.
	 * 
	 * @param textPassword
	 */
	void setPassword(String textPassword)
	{
		password = textPassword
		salt = EncodingUtil.generateSalt()
		hashPassword = (salt + textPassword).encodeAsMD5()
	}
	
	/**
	 * Helper method to assist in logging in.
	 * 
	 * @param password
	 * @return
	 */
	boolean checkPassword(String password)
	{
		return (salt + password).encodeAsMD5().equals(hashPassword) 
	}
	
	String getFullName() {
		"${honorific?.type} ${firstName} ${lastName}"
	}
	
	String getAccountStatusLabel() {
		switch (accountStatus) {
			case ACTIVE: return "Active"
			case PENDING: return "Pending"
			case DISABLED: return "Disabled"
		}
	}
	
	static Map<String,String> getDisplayColumns(){
		
		Map<String,String> mp=new LinkedHashMap<String, String>();			
		mp.put("email","User Name")
		mp.put("honorific","Honorific")
		mp.put("firstName","First Name")
		mp.put("lastName","Last Name")
		mp.put("company","Company")
		mp.put("jobFunction", "Job Funtion")
		mp.put("jobPosition", "Job Position")
		mp.put("address","Address")
		mp.put("postal","Postal Code")
		mp.put("state","State")
		mp.put("country","Country")
		mp.put("telephone","Telephone")
		mp.put("fax","Fax")
		mp.put("mobile","Mobile")
		mp.put("dateCreated","Joined Date")
		
		return mp;
	}
	
	static List<User> getNonSubscribers()
	{
		def users = User.createCriteria().listDistinct{
			roles { ne('roleName', Role.SUBSCRIBER) }
		}
		return users;
	}
	void setSubscriptions(input){
		this.subscriptions=input	
	}
	
	List getUserDownloadStatics()
	{
		return (DownloadCount.createCriteria().list(){	
			projections {
				property("issue")
				groupProperty("year")
				groupProperty("month")
				sum("downloadCount")
				groupProperty("issue.id")											
				order("year","desc")
				order("month","desc")
			}
			user{
				eq("id",this.id)
			}
			gt("year",(Calendar.getInstance().get(Calendar.YEAR)-5))
		})
	}
}
