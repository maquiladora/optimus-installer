<html>
  <body>
    <form>
    <label for="email">Email :</label><br><input id="email" name="email"/>
    <br/>
    <label for="password">Password :</label><br><input id="password" name="password"/>
    <br/>
    <input type="submit" onclick="login()"/>
    </form>
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
    var formdata = new FormData();
    formdata.append('email', 'prime@demoptimus.fr');
    formdata.append('password', 'W26b3RTE8mj4L3Su6GJBjz0qXtPIcNaM');
    alert(formdata);
    xhr.send(formdata);
  }

  </script>
</html>
