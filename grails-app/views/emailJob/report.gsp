<%@ page import="com.tlm.beans.EmailJob" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'emailJob.label', default: 'EmailJob')}" />
        <title>Job Report</title>
        
        	<style type="text/css">
        	
        		.filterBar {
        			text-align: center;
        			display: block;
        			clear: both;  
        			float: left;
        			width: 120px;  			
        		}
        		
        		.filterButton {
        			text-align: center;
        			display: block;
        			margin: 15px;
        			padding-bottom: 10px;
        			padding-top: 10px;        			
        		}
        		
        		.unselected {
        			background: none repeat scroll 0 0 #F7F7F7;
        			border: #DDDDDD;
        		}
        		
        		.selected {
        			background: none repeat scroll 0 0 #ffc9c9;
        			border: red;
        		}
        		
        		.jobSummary {
        			float: right;
        			width: 500px;
        		}
        		
        		.jobSummary p + p {
        			margin-top: 0.5em; 
        		}

 		
        	</style>        
        
    </head>
    <body>
        <div class="body">
        	<div style="display: block; height: 100px; clear: both;" >
            	<h1 style="float: left; width: 150px;">Job Report</h1>
            	<div class="jobSummary">
            		<p><span style="font-weight: bold">Description: </span>${emailJob.description}</p>
            		<p><span style="font-weight: bold">Date Started: </span>${emailJob.dateCreated}</p>
            		<p><span style="font-weight: bold">Date Completed: </span>${emailJob.dateCompleted}</p>
            	</div>
            </div>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            

        	
        	<div class="nav">
            	<span class="menuButton"><a class="home" href="${createLink(uri: '/admin')}">Admin Menu</a></span>
            	<span class="menuButton"><g:link action="show" class="list" id="${jobId}">Back</g:link></span>
            	<span class="menuButton"><a class="create" href="${createLink(controller: 'template', action: 'massmail')}">Create ad-hoc job</a></span>
        	</div>
        	
           	<div class="filterBar">
           		<a class="filterButton ${groupBy == 'all' || !groupBy ? 'selected': 'unselected'}" href="?groupBy=all">
           			<img src="${resource(dir:'images/webicons',file:'by_all.png')}" /><br/>
           			All
           		</a>
           		<a class="filterButton ${groupBy == 'country' ? 'selected': 'unselected'}" href="?groupBy=country">
           			<img src="${resource(dir:'images/webicons',file:'by_country.png')}" /><br/>
           			By Country
           		</a>
           		<a class="filterButton ${groupBy == 'jobFunction' ? 'selected': 'unselected'}" href="?groupBy=jobFunction">
           			<img src="${resource(dir:'images/webicons',file:'by_job_function.png')}" /><br/>
           			By Job Function
           		</a>
           		<a class="filterButton ${groupBy == 'jobPosition' ? 'selected': 'unselected'}" href="?groupBy=jobPosition">
           			<img src="${resource(dir:'images/webicons',file:'by_job_position.png')}" /><br/>
           			By Job Position
           		</a>
        	</div>        	
        	
            <div class="list" style="float: right; width: 680px">
                <table>
                    <thead>
                        <tr>
                        	<th>
                        		<g:if test="${groupBy == 'country' }">
                        		  Country
                        		</g:if>
                        		<g:elseif test="${groupBy == 'jobFunction' }">
                        		  Job Function
                        		</g:elseif>
                        		<g:elseif test="${groupBy == 'jobPosition' }">
                        		  Job Position
                        		</g:elseif>
                        	</th>
                        	<th>Sent</th>
                        	<th>Failed</th>
                        	<th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${report}" status="i" var="row">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	<td>${row.category}</td>
                        	<td>${row.sent}</td>
                        	<td>${row.failed}</td>
                        	<td>${row.total}</td>
                        </tr>   
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
