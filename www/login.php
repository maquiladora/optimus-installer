<html>

  <body>
    <div id="container" style="height:80vh;display:flex;justify-content:center;align-items:center;flex-direction:column">
      <?='$DOMAIN'?><br/><br>
      <label for="email">Email :</label>
      <input id="email" type="text" onkeypress="if (event.keyCode === 13) login()"/>
      <br/>
      <label for="password">Password :</label>
      <input id="password" type="password" onkeypress="if (event.keyCode === 13) login()"/>
      <br/>
      <input type="button" value="login" onclick="login()"/>
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
  document.getElementById('email').focus();
  </script>

</html>

<?php exit; ?>
