<html>
  <body>
    <label for="email">Email :</label><br><input id="email" name="email"/>
    <br/><br/>
    <label for="password">Password :</label><br><input id="password" name="password"/>
    <br/><br/>
    <input type="submit" value="login" onclick="login()"/>
    <br/><br/>
    <input type="submit" value="logout" onclick="logout()"/>
    <br/><br/>
    <input type="submit" value="server_status" onclick="server_status()"/>
  </body>

  <script>

  function login()
  {
    var request = new XMLHttpRequest();
    request.open("POST", 'https://api.$DOMAIN/allspark/login', true);
    request.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
    request.withCredentials = true;
    request.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE)
      {
        if (this.status === 200 && request.responseText)
          document.cookie = 'token='+JSON.parse(request.responseText).token+'; max-age=3600; domain=$DOMAIN, HttpOnly';
        else if (request.responseText)
          alert('Error ' + this.status + "\n" + request.responseText);
      }
    }
    var data = JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value});
    request.send(data);
  }

  function logout()
  {
    document.cookie = 'token=; expires=Thu, 01 Jan 1970 00:00:00 GMT; domain=$DOMAIN';
  }

  function server_status()
  {
    var request = new XMLHttpRequest();
    request.open("GET", 'https://api.$DOMAIN/allspark/status', true);
    request.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
    request.setRequestHeader('Authorization', 'Bearer ' + get_cookie('token'));
    request.withCredentials = true;
    request.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE)
      {
        if (this.status === 200 && request.responseText)
          alert(request.responseText);
        else if (request.responseText)
          alert('Error ' + this.status + "\n" + request.responseText);
      }
    }
    request.send();
  }

  function get_cookie(name)
  {
    var cookies = document.cookie.split(";");
    for(var i = 0; i < cookies.length; i++)
    {
      var cookievalue = cookies[i].split("=");
      if(name == cookievalue[0].trim())
        return decodeURIComponent(cookievalue[1]);
    }
    return null;
  }

  </script>
</html>
