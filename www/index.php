<html>
  <body>
    <div style="text-align:center">
      <label for="email">Email :</label><br><input id="email" type="text" onkeypress="if (event.keyCode === 13) login()"/>
      <br/><br/>
      <label for="password">Password :</label><br><input id="password" type="password" onkeypress="if (event.keyCode === 13) login()"/>
      <br/><br/>
      <input type="submit" value="login" onclick="login()"/>
      <br/><br/>
      <input type="submit" value="logout" onclick="logout()"/>
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
        parent.postMessage('logged in','*');
    }
    var data = JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value});
    request.send(data);
  }

  function logout()
  {
    fetch('https://api.$DOMAIN/allspark/logout');
      parent.postMessage('logged out','*');
  }

  <?php if ($_GET['action']=='logout') echo "logout()"?>

  document.getElementById('email').focus();

  </script>
</html>
