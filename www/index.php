<html>
  <body>
    <div style="text-align:center">
      <label for="email">Email :</label><br><input id="email" name="email"/>
      <br/><br/>
      <label for="password">Password :</label><br><input id="password" name="password"/>
      <br/><br/>
      <input type="submit" value="login" onclick="login()"/>
      <br/><br/>
      <input type="submit" value="logout" onclick="logout()"/>
      <br/><br/>
      <input type="submit" value="close" onclick="close()"/>
    </div>
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
      if (this.readyState === XMLHttpRequest.DONE && this.status != 200 && request.responseText)
        alert('Error ' + this.status + "\n" + request.responseText);

      if (this.readyState === XMLHttpRequest.DONE && this.status === 200)
        close();
    }
    var data = JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value});
    request.send(data);
  }

  function logout()
  {
    document.cookie = 'token=; expires=Thu, 01 Jan 1970 00:00:00 GMT; domain=$DOMAIN';
  }

  function close()
  {
    document.getElementById('iframe').parentNode.removeChild(document.getElementById('iframe'));
  }

  </script>
</html>
