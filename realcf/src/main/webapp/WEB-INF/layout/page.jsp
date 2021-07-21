<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ page session="false" %>
<html>
<head>
    <title>원장분석</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- ë³¸ë¬¸ììë ë¤ë£¨ì§ ìì ì½ëìëë¤. ë¶ë¡ Aìì ì´í´ë³´ë íë¬ê·¸ì¸ìëë¤. -->
    <!--  êµ¬ ë²ì ì ì¸í°ë· ìµì¤íë¡ë¬ìì HTML5 íê·¸ë¥¼ ì¸ìíê² í©ëë¤. -->
    <!--[if lt IE 9]>
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <!-- ì´ê¸°í -->
    <style>
        * { margin: 0; padding: 0; }
        body { font-family: 'Helvetica', sans-serif; }
        li { list-style: none; }
        a { text-decoration: none; }
    </style>
    <!-- í¤ë -->
    <style>

    </style>
    <!-- ë¤ë¹ê²ì´ì -->
    <style>
        #main_gnb {
            overflow: hidden;
            border-bottom: 1px solid black;
            background: #32394A;
        }
        #main_gnb > ul.left {
            overflow: hidden;
            float: left;
        }
        #main_gnb > ul.right {
            overflow: hidden;
            float: right;
        }
        #main_gnb > ul.left > li { float: left; }
        #main_gnb > ul.right > li { float: left; }

        /* a íê·¸ ì¤ì  */
        #main_gnb a {
            /* ë ì´ìì ì¤ì  */
            display: block;
            padding: 10px 20px;

            /* ìì ì¤ì  */
            border-left: 1px solid #5F6673;
            border-right: 1px solid #242A37;
            color: white;
            font-weight: bold;
        }
        body { min-width: 760px; }
    </style>
    <!-- ì½íì¸  -->
    <style>
        #wrap { overflow: hidden; }
        #wrap > #main_lnb { 
            float: left;
            width: 200px;
        }
        #wrap > #content_wrap {
            float: left;
            width: 100%;
            *width: 99.9%;
            margin-right: -200px;
        }
        #wrap > #content_wrap > #content { padding-right: 200px; }
    </style>
    <!-- ìì§ ëª©ë¡ -->
    <style>
        #wrap { background: #71B1D1; }
        #main_lnb > ul > li > a {
            display: block;
            height:40px; line-height: 40px;
            padding-left: 15px;

            border-top: 1px solid #96D6F6;
            border-bottom: 1px solid #6298B2;
            color: white;
            font-weight: bold;
        }
    </style>
    <!-- ë³¸ë¬¸ -->
    <style>
        #content {
            background: white;
            border-left: 1px solid black;
        }
        article { padding: 10px; }
    </style>
    <!-- í¸í° -->
    <style>
        #main_footer {
            padding: 10px;
            border-top: 3px solid black;
            text-align: center;
        }
        


 
  * {
       margin: 0; padding: 0;
       font: normal 12px 'Dotum';
   }
  a { text-decoration: none; }
  img { border: 0; }
  ul { list-style: none; }

  body {
    width: 100%;
    margin: 0 auto; 
  }
        
        
    </style>
</head>

    
    <t:insertAttribute name="header" />
    


    <div id="wrap">
        <nav id="main_lnb">
            <ul>
               <t:insertAttribute name="menu" />  
            </ul>
         </nav>
       <div id="content_wrap">
            <t:insertAttribute name="body" />
       </div>
    </div>

 
</body>
</html>
