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
    xhr.setRequestHeader('content-type', 'application/json');
    xhr.onreadystatechange = function()
    {
      if (this.readyState === XMLHttpRequest.DONE && this.status === 200)
      {
        alert(xhr.responseText);
      }
    }
    var data = new FormData();
    data.append('email', 'prime@demoptimus.fr');
    data.append('password', 'W26b3RTE8mj4L3Su6GJBjz0qXtPIcNaM');
    alert(JSON.stringify(data));
    xhr.send(JSON.stringify(data));
  }

  </script>
</html>
