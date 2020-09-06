<html>
  <body>
    <label for="email">Email :</label><br><input id="email" name="email"/>
    <br/><br/>
    <label for="password">Password :</label><br><input id="password" name="password"/>
    <br/><br/>
    <input type="submit" onclick="login()"/>
  </body>

  <script>

  function login()
  {
    var request = new XMLHttpRequest();
    request.open("POST", 'https://api.$DOMAIN/allspark/login', true);
    request.setRequestHeader('Accept', 'application/json, text/plain, */*"');
    request.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
    request.withCredentials = true;
    request.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE)
      {
        if (this.status === 200 && request.responseText)
        {
          answer = JSON.parse(request.responseText)
          document.cookie = 'token='+answer.token+"; expires=Fri, 31 Dec 9999 23:59:59 GMT; domain=$DOMAIN";
        }
        else if (this.status === 401)
          alert('Accès refusé');
        else if (request.responseText)
          alert('Erreur ' + this.status + "\n" + request.responseText);
      }
    }
    var data = JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value});
    request.send(data);
  }

  </script>
</html>
