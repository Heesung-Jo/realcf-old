<!DOCTYPE HTML>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<head>
    <title id="pageTitle">Create Event</title>

 
</head>
<body>

<div class="container">
 
    <form action="#" action="/realform" name ="signupForm" method="post" >
        <errors path="*" element="div" cssClass="alert alert-error"/>
        <fieldset>
            <legend>User Information</legend>

            <div class="control-group">
                <label class="control-label" for="name">Name</label>
                <div class="controls">
                    <input class="input-xlarge"  name ="name" id="name"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="email">Email (Username)</label>
                <div class="controls">
                    <input class="input-xlarge" name ="email" id="email"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="password">Password</label>
                <div class="controls">
                    <input type="password" class="input-xlarge" name ="password" id="password"/>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <input id="submit" class="btn" type="submit" value="Create Account"/>
                </div>
            </div>
        </fieldset>
    </form>

</div>


</body>
</html>
