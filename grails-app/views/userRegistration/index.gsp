<html>
	<body>
	<h1>User Registration Form</h1>
	<g:if test="${flash.message}">
	  <div id="flashMessage">${flash.message}</div>
	</g:if>
	<g:if test="${user?.errors}">
	  <div id="errors">
	    <g:renderErrors bean="${user}" as="list" />
	  </div>
	</g:if>
	
	<g:form controller="userRegistration" action="save" method="post">
	  <p>Login Information</p>
	  <table>
	    <tr>	    
	      <td>User Name*</td>
	      <td><input type="text" name="userName" size="20" value="${user?.userName}"/></td>
	    </tr>
	    
	    <tr>
	      <td>Password*</td>
	      <td><input type="password" name="password" size="20" /></td>
	    </tr>
	    
	    <tr>
	      <td>Confirm Password*</td>
	      <td><input type="password" name="confirmPassword" size="20" /></td>
	    </tr>
	  </table>
	  
	  <p>Personal Particulars</p>
	  <table>
	    <tr>
	      <td>Honorific*</td>
	      <td>
            <g:select optionKey="id"
                    optionValue="type"
	                       from="${com.tlm.beans.LookupHonorific.list()}"
	                       name="honorific.id"
	                      value="${user?.honorific?.id}" />
	      </td>
	    </tr>
	    
	    <tr>
	      <td>First Name*</td>
	      <td><input type="text" name="firstName" value="${user?.firstName}" }/></td>
	    </tr>
	    
	    <tr>
	      <td>Last Name*</td>
	      <td><input type="text" name="lastName" value="${user?.lastName}"/></td>
	    </tr>
	    
	    <tr>
	      <td>E-mail*</td>
	      <td><input type="text" name="email" value="${user?.email}"/></td>
	    </tr>
	    
	    <tr>
	      <td>Gender*</td>
	      <td>Male <g:radio name="gender" value="M" checked="${user?.gender == 'M'}" /> | Female <g:radio name="gender" value="F" checked="${user?.gender == 'F'} "/></td>
	    </tr>
	    
	  </table>
	  
	  <p>Employment Details</p>
	  
	  <table>
	  
	    <tr>
	      <td>Company </td>
	      <td><input type="text" name="company" value="${user?.company}" /></td>
	    </tr>
	    	  
	    <tr>
	      <td>Job Function </td>
	      <td>
            <g:select optionKey="id"
                    optionValue="title"
	                       from="${com.tlm.beans.JobFunction.list()}"
	                       name="jobFunction.id"
	                      value="${user?.jobFunction?.id}" />
	      </td>
	    </tr>
	    
	    <tr>
	      <td>Job Position </td>
	      <td>
            <g:select optionKey="id"
                    optionValue="title"
	                       from="${com.tlm.beans.JobPosition.list()}"
	                       name="jobPosition.id"
	                      value="${user?.jobPosition?.id}" />
	      </td>
	    </tr>	    
	    
	  </table>
	  
	  <p>Location</p>
	  <table>
	  	<tr>
	      <td>Address </td>
	      <td><textarea name="address" >${user?.address}</textarea></td>
	    </tr>
	    
	    <tr>
	      <td>Postal Code </td>
	      <td><input type="text" name="postal" value="${user?.postal}" /></td>
	    </tr>
	    
	    <tr>
	      <td>City </td>
	      <td><input type="text" name="city" value="${user?.city}" /></td>
	    </tr>
	    
	    <tr>
	      <td>State </td>
	      <td><input type="text" name="state" value="${user?.state}"/></td>
	    </tr>
	    
	    <tr>
	      <td>Country*</td>
	      <td>
            <g:select optionKey="id"
                    optionValue="title"
	                       from="${com.tlm.beans.Country.list()}"
	                       name="country.id"
	                      value="${user?.country?.id}" />
	      </td>
	    </tr>  
	  </table>
	  
	  <p>Contact Information</p>
	  
	  <table>
	  	<tr>
	      <td>Telephone </td>
	      <td><input type="text" name="telephone" value="${user?.telephone}"/></td>
	    </tr>
	    
	    <tr>
	      <td>Fax </td>
	      <td><input type="text" name="fax" value="${user?.fax}" /></td>
	    </tr>
	    
	    <tr>
	      <td>Mobile*</td>
	      <td><input type="text" name="mobile" value="${user?.mobile}"/></td>
	    </tr>
	    
	  </table>
	  
	  <input type="submit" value="Submit" />	  
	</g:form>
	</body>
</html>