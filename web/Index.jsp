<%-- 
    Document   : Index 
    Created on : May 13, 2018, 12:39:37 PM
    Author     : Hasanka Wijesinghe
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="Database.DbConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Statement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import= "java.util.Iterator" %>
<%@page import= "java.util.List" %>

<!DOCTYPE html>
<% if(session.getAttribute("userid")==null){
    request.getRequestDispatcher("/Login.jsp").forward(request, response);
}
          
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
       
<title>Home | Hadamu.lk</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="js/script.js"></script>
<script type="text/javascript" src="js/cufon-yui.js"></script>
<script type="text/javascript" src="js/arial.js"></script>
<script type="text/javascript" src="js/cuf_run.js"></script>

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.1.1.slim.min.js" integrity="sha384-A7FZj7v+d/sdmMqp/nOQwliLvUsJfDHW+k9Omg/a/EheAdgtzNs3hpfag6Ed950n" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>

<script>
    <% String err;
        if(request.getAttribute("autherrMsg")==null){
        err="";
    }
        else{
            err=request.getAttribute("autherrMsg").toString();
        }
    %>
    
    var s ="<%= err %>";
    if(s !== ""){
        
        alert(s);
    }
        
    
</script>
    </head>
    <body>
        <div class="main">
  <div class="main_resize">
    <div class="header">
      <div class="logo">
        <h1><a href="#"><span>Hadamu</span>.lk</a></h1>
      </div>
      <div class="search">
        
        <!--/searchform -->
        <div class="clr"></div>
      </div>
        
        <% 
            PreparedStatement pst =null;
            Statement st =null;
                 
        Connection con = null;
        ResultSet rs =null;
        ResultSet rrs =null;
        int log_user=Integer.parseInt(session.getAttribute("userid").toString());
        con=DbConnection.createConnection();
        
            pst = con.prepareStatement("SELECT COUNT(status) as total FROM to_friends where  user_one_id=? and status=0");
            pst.setInt(1, log_user);
            rrs = pst.executeQuery();
            if(rrs.next()){
            
        %>
      <div class="clr"></div>
      <div class="menu_nav">
           <form method="get" action="logOutCon">
        <ul>
          <li class="active"><a href="Index.jsp">Home</a></li>
          
          <li><a href="request.jsp">Requests <span class="badge badge-success"><%= rrs.getInt("total") %></span></a></li>
          <li><a href="profile.jsp">My Profile</a></li>
          <li><button class="btn btn-danger" >Logout</button></li>
        </ul>
           </form>
          <% } %>
        <div class="clr"></div>
      </div>
      <div class="hbg"><img src="images/1.jpg" width="923" height="291" alt="" /></div>
    </div>
    <div class="content">
      <div class="content_bg">
        <div class="mainbar">
            <%-- <% 
                ArrayList postList = new ArrayList();
                if(request.getAttribute("posts")!=null){
                postList = (ArrayList)request.getAttribute("posts");
                }
                Iterator it = postList.iterator();
                while(it.hasNext()){
                %>--%>
            <%
                 
            st=con.createStatement();
            rs=st.executeQuery("SELECT post_id,post_body,post_c, post_title, user_id,date,post_type,p_image,name,Id FROM post,users where users.Id=post.user_id ORDER BY post_id DESC");
            
            while(rs.next()){
                
                //post_body
               String a = rs.getString("post_body");
               //find length of the body and substring
               int maxLength =(a.length()<400)?a.length():400;
               //make it short
               String subPost=a.substring(0, maxLength);
               rs.getBlob("p_image");
               HttpSession userId = request.getSession();
               userId.setAttribute("user_id",rs.getInt("user_id"));
            %>
            
          <div class="article">
              <h2><span><%=rs.getString("post_title") %>   </span></h2>
            <div class="clr"></div>
            <p class="post-data"><span class="date"> <%=rs.getString("date") %>  </span> &nbsp;|&nbsp; Posted by <a href="CheckUser?id=<%=rs.getInt("Id") %>"> <%=rs.getString("name") %>  </a> &nbsp;|&nbsp; Category <a href="#"> <%=rs.getString("post_c") %> </a></p>
            <div style="width: 200px; float: left;"><img src="GetImageCon?post_id=<%= rs.getString("post_id") %>" width="200" height="193"  /></div>
            <div style="width: auto;float: left; margin-left:  25px;"><p> <%= subPost %>...  </p></div>
            <div  style="width: 100%; float:left;"> <p class="spec" style="float: right;"><a href="CheckPost?post_id=<%= rs.getString("post_id") %>&post_type=<%= rs.getString("post_type") %>" class="rm fl">Read more</a></p></div>
            <div class="clr"></div>
           
          </div>
         <%  } %>
         
        
        </div>
        <div class="sidebar">
          <div class="gadget">
            <h2 class="star"><span>Sidebar</span> Menu</h2>
            <div class="clr"></div>
            <ul class="sb_menu">
              <li class="active"><a href="newpost.jsp">+Add Post</a></li>
              <li><a href="freinds.jsp">Friends</a></li>
              <li><a href="mypost.jsp">My Posts</a></li>
              
            </ul>
           
          </div>
         
        </div>
        <div class="clr"></div>
      </div>
    </div>
  </div>

</div>
<div class="footer">
  <div class="footer_resize">
    <p class="lf">&copy; Copyright <a href="#">Hadamu.lk</a>.</p>
    <p class="rf">Layout by Masterminds</a></p>
    <div class="clr"></div>
  </div>
</div>
    </body>
</html>
