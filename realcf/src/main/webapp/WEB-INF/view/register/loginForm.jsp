<%@ page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인 양식</title>
</head>

<script>



</script>

<body>
    
    <form name = "form" action = "login" method = "post">
    
    <p> 이름
         <input type = "text" name ="username" />
    </p>
    <p> 부서
        <input type = "text" name = "division" />
    </p>
    <p> 비밀번호
        <input type = "text" name = "password" />
    </p>

    <input type="submit" value = "제출">
    </form>
</body>
</html>
