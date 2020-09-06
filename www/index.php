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
          document.cookie = 'token='+JSON.parse(request.responseText).token+'; expires=Fri, 31 Dec 9999 23:59:59 GMT; domain=$DOMAIN';
        else if (request.responseText)
          alert('Erreur ' + this.status + "\n" + request.responseText);
      }
    }
    var data = JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value});
    request.send(data);
  }

  function logout()
  {
    document.cookie = 'token=; expires=Thu, 01 Jan 1970 00:00:00 GMT';
  }

  function server_status()
  {
    alert(document.cookies.get('token'));
    
  }

  </script>
</html>
