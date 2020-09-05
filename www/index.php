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
    xhr.setRequestHeader('Accept', 'application/json, text/plain, */*"');
    xhr.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
    xhr.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE && this.status === 200)
      {
        alert(xhr.responseText);
      }
    }
    var data = "{\"email\":\"prime@demoptimus.fr\",\"password\":\"W26b3RTE8mj4L3Su6GJBjz0qXtPIcNaM\"}";
    xhr.send(data);
  }

  </script>
</html>
