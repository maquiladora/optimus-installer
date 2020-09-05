<html>
  <body>
    <label for="email">Email :</label><br><input name="email"/>
    <label for="password">Password :</label><br><input name="password"/>
    <input type="submit" onclick="login()"/>
  </body>

  <script>

  function login()
  {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", '/server', true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE && this.status === 200)
      {
        alert(ajax.responseText);
      }
    }
    xhr.send("email="+email.value+"&password="+password.value);
  }

  </script>
</html>
