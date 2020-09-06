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
    var xhr = new XMLHttpRequest();
    xhr.open("POST", 'https://api.$DOMAIN/allspark/login', true);
    xhr.setRequestHeader('Accept', 'application/json, text/plain, */*"');
    xhr.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
    xhr.withCredentials = true;
    xhr.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE)
      {
        if (this.status === 200 && xhr.responseText)
          document.cookie = 'token='+JSON.parse(xhr.responseText).token+"; expires=Fri, 31 Dec 9999 23:59:59 GMT; domain=$DOMAIN";
        else if (this.status === 401)
          alert('Accès refusé');
        else if (xhr.responseText)
          alert('Erreur ' + this.status + "\n" + xhr.responseText);
      }
    }
    var data = JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value});
    xhr.send(data);
  }

  </script>
</html>
