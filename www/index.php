<html>
  <body>
    <label for="email">Email :</label><br><input id="email" name="email"/>
    <br/>
    <label for="password">Password :</label><br><input id="password" name="password"/>
    <br/>
    <input type="submit" onclick="login()"/>
  </body>

  <script>

  function login()
  {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", 'https://api.$DOMAIN/allspark/login', true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE && this.status === 200)
      {
        alert(ajax.responseText);
      }
    }
    xhr.send("email="+document.getElementById('email').value+"&password="+document.getElementById('password').value);
  }

  </script>
</html>
