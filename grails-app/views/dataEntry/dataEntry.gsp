<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="main" />
    <script type="text/javascript" src="../js/ext-base.js"></script>
	<!-- ENDLIBS -->
	
	<script type="text/javascript" src="../js/ext-all.js"></script>
	<script type="text/javascript" src="../js/ext-basex.js"></script>
	<link rel="stylesheet" type="text/css" href="../style/ext-all.css" />
	<style type="text/css">
	
		body {
			font-family: Verdana, sans-serif;
			font-size: 10pt;
		}
		.table {
			width: 60em;
			font-size: 10pt;
		}		
		
		.fieldrow {
			display: block;
			width: 100%;
			clear: both;
		}
		
		.field {
			padding: 0.2em;
			float: left;
			display: inline;
			width: 20em;
		}
		
		.required {
			font-weight: bold;			
		}
		
		.fieldname {
			text-align: left;
			display: block;
			clear: both;
			font-variant: small-caps;
			margin-bottom: 0.5em;
		}
		
		.fieldinput {
			text-align: left;
			display: block;	
			border: 0px;
			float: right;
			background: #eeeeee;
			font-size: 1.5em;
			width: 100%;
			height: 2em;
			padding: 0.2em;
			
		}
		
		.fielderror {
			text-align: right;
			color: red;
			font-weight: bold;
			display: block;
			clear; both;
			font-size: 0.7em;
		}
		
		.error {
			/*border: 1px solid red;*/
			background-color: #ffd7d7;
		}		
		
	</style>
	<script language="javascript">
	function checkUserId(input)
	{
		Ext.Ajax.request ({url: '/tlm/json/userIdCheck?userId='+input,
	        async : true,
	        method: 'GET',
	        success: function(responseObject) {
	           var inputData= eval('(' + responseObject.responseText +')');
	           var x = Ext.get('userFoundMessage');
	           x.show();	           
	           if (inputData.success=='true'){
	           		
          			x.update('User already exist');
	           }
	           else{
	        	   x.update('User not found');
	           }
	           
	        },
	        failure: function() {
	               Ext.Msg.alert('Status', 'Unable to show history at this time. Please try again later.');
	       }
	    });
    }
	</script>
</head>
<body>

<div class="body">
<h2>User data entry</h2>
<hr/>
<g:if test="${flash.message}">
  <div class="message">${flash.message}</div>
</g:if>
<div class="message" id="userFoundMessage" style="display:none">UserId not entered</div>
<g:form action="save" method="post">

<div class="table">
	<div class="fieldrow">
		<div class="field ${hasErrors(bean: user, field: 'email', 'error')}" style="width: 59em;">
			<span class="fieldname">E-mail*</span>
			<g:textField onblur="checkUserId(Ext.get('email').getValue());return false;" class="fieldinput" name="email" value="${user?.email}" />
			
			<span class="fielderror">${renderErrors(bean: user, field: 'email')}</span>
			
		</div>
		<!--<div class="field ${hasErrors(bean: user, field: 'gender', 'error')}" style="width: 11em">
			<span class="fieldname">Check</span>
			<span style="width: 14em"><button onclick="checkUserId(Ext.get('email').getValue());return false;">Check UserId Availability</button></span>
		</div>	
	--></div>
	<div class="fieldrow">
		<div class="field ${hasErrors(bean: user, field: 'gender', 'error')}" style="width: 9em">
			<span class="fieldname">Gender*</span>
			<g:select class="fieldInput" name="gender" from="${['Male','Female']}" keys="${['M', 'F']}" value="${user?.gender}" noSelection="['': '']" />
			<span class="fielderror">${renderErrors(bean: user, field: 'gender')}</span>
		</div>	
		<div class="field ${hasErrors(bean: user, field: 'honorific', 'error')}" style="width: 9em">
			<span class="fieldname">Honorific*</span>
			<g:select class="fieldinput" name="honorific.id" from="${com.tlm.beans.LookupHonorific.list()}" optionKey="id" value="${user?.honorific?.id}" noSelection="['': '']" />
			<span class="fielderror">${renderErrors(bean: user, field: 'honorific')}</span>
		</div>	
		<div class="field ${hasErrors(bean: user, field: 'firstName', 'error')}" style="width: 20em">
			<span class="fieldname">First Name*</span>
			<g:textField class="fieldinput" name="firstName" value="${user?.firstName}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'firstName')}</span>
		</div>			
		<div class="field ${hasErrors(bean: user, field: 'lastName', 'error')}" style="width: 20em">
			<span class="fieldname">Last Name*</span>
			<g:textField class="fieldinput" name="lastName" value="${user?.lastName}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'lastName')}</span>
		</div>
	</div>
	<div class="fieldrow">
		<div class="field ${hasErrors(bean: user, field: 'company', 'error')}">
			<span class="fieldname">Company</span>
			<g:textField class="fieldinput" name="company" value="${user?.company}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'company')}</span>
		</div>
		<div class="field ${hasErrors(bean: user, field: 'jobFunction', 'error')}" style="width: 16em;">
			<span class="fieldname">Job Function*</span>
			<g:select class="fieldInput" name="jobFunction.id" from="${com.tlm.beans.JobFunction.list()}" optionKey="id" value="${user?.jobFunction?.id}" noSelection="['': '']" />
			<span class="fielderror">${renderErrors(bean: user, field: 'jobFunction')}</span>
		</div>	
		<div class="field ${hasErrors(bean: user, field: 'jobPosition', 'error')}" style="width: 16em;">
			<span class="fieldname">Job Position*</span>
			<g:select class="fieldInput" name="jobPosition.id" from="${com.tlm.beans.JobPosition.list()}" optionKey="id" value="${user?.jobPosition?.id}" noSelection="['': '']" />
			<span class="fielderror">${renderErrors(bean: user, field: 'jobPosition')}</span>
		</div>	
	</div>	
	
	<div class="fieldrow">
		<div class="field ${hasErrors(bean: user, field: 'address', 'error')}" style="width: 40em;">
			<span class="fieldname" >Address</span>
			<g:textField class="fieldinput" name="address" value="${user?.address}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'address')}</span>
		</div>
		<div class="field ${hasErrors(bean: user, field: 'postal', 'error')}" style="width: 10em;">
			<span class="fieldname" >Postal</span>
			<g:textField class="fieldinput" name="postal" value="${user?.postal}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'postal')}</span>
		</div>		
	</div>
	<div class="fieldrow">
		<div class="field ${hasErrors(bean: user, field: 'country', 'error')}" style="width: 12em;">
			<span class="fieldname" >Country*</span>
            <g:select class="fieldinput" name="country.id" from="${com.tlm.beans.Country.list()}" optionKey="id" value="${user?.country?.id}" noSelection="['': '']" />
			<span class="fielderror">${renderErrors(bean: user, field: 'country')}</span>
		</div>	
		<div class="field ${hasErrors(bean: user, field: 'city', 'error')}" style="width: 10em;">
			<span class="fieldname" >City</span>
			<g:textField class="fieldinput" name="city" value="${user?.city}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'city')}</span>
		</div>
		<div class="field ${hasErrors(bean: user, field: 'state', 'error')}" style="width: 10em;">
			<span class="fieldname" >State</span>
			<g:textField class="fieldinput" name="state" value="${user?.state}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'state')}</span>
		</div>			
	</div>
	<div class="fieldrow">
		<div class="field ${hasErrors(bean: user, field: 'telephone', 'error')}" style="width: 10em;">
			<span class="fieldname">Telephone*</span>
			<g:textField class="fieldinput" name="telephone" value="${user?.telephone}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'telephone')}</span>
		</div>	
		<div class="field ${hasErrors(bean: user, field: 'fax', 'error')}" style="width: 10em;">
			<span class="fieldname">Fax</span>
			<g:textField class="fieldinput" name="fax" value="${user?.fax}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'fax')}</span>
		</div>	
		<div class="field ${hasErrors(bean: user, field: 'mobile', 'error')}" style="width: 10em;">
			<span class="fieldname">Mobile</span>
			<g:textField class="fieldinput" name="mobile" value="${user?.mobile}" />
			<span class="fielderror">${renderErrors(bean: user, field: 'mobile')}</span>
		</div>				
	</div>
	<g:submitButton name="save" value="Save" style="float: right;" />
	<div class="fieldrow">
		<g:each in="${publicationList}" var="pubItem">
			<div class="field" style="width: 8em">
				<span class="fieldname" style="height: 4em;">${pubItem.pubLongName}</span>
				<span class="fieldinput" style="text-align: center; width: 95%">
					<g:checkBox name="selectedIds" checked="${selectedIds?.contains(pubItem.id)}" value="${pubItem.id}"/>
				</span>
				
			</div>
		</g:each>
	</div>
	

</div>

</g:form>
</div>
</body>