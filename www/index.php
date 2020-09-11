<html>
  <body>
    <div style="text-align:center">
      <label for="email">Email :</label><br><input id="email" type="text" onkeypress="if (event.keyCode === 13) login()"/>
      <br/><br/>
      <label for="password">Password :</label><br><input id="password" type="password" onkeypress="if (event.keyCode === 13) login()"/>
      <br/><br/>
      <input type="button" value="login" onclick="login()"/>
      <br/><br/>
      <input type="button" value="logout" onclick="logout()"/>
    </div>
  </body>

  <script>

  function login()
  {
    fetch('https://api.$DOMAIN/allspark/login',
		{
			headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
			method: "POST",
			credentials: "include",
      body: JSON.stringify({"email": document.getElementById('email').value, "password": document.getElementById('password').value})
		})
		.then(function(response)
		{
      if (response.status === 200)
      {
        parent.postMessage('logged','*');
        window.location.reload();
      }
      else
        return response.json();
		})
    .then(function(response)
    {
      if (response.message)
        alert(response.message);
    })
		.catch(error => console.log("Erreur : " + error));
  }

  function logout()
  {
    fetch('https://api.$DOMAIN/allspark/logout',
    {
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      method: 'POST',
      credentials: "include"
    })
		.then(function(response)
		{
      if (response.status === 200))
      {
        parent.postMessage('loggedout','*');
        window.location.reload();
      }
		})
		.catch(error => console.log("Erreur : " + error));
  }

  document.getElementById('email').focus();

  </script>
</html>
