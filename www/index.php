<?php
  if (!isset($_COOKIE['token']))
    include('login.php');
?>

<html>
  <body>

      <input type="button" style="position:fixed;top:5px;right:5px" value="logout" onclick="logout()"/>
      <a href="https://webmail.demoptimus.fr">WEBMAIL ROUNDCUBE</a>
      <br/>
      <a href="https://cloud.demoptimus.fr">CLIENT WEBDAV HTTP</a>


  </body>

  <script>

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
      if (response.status === 200)
      {
        parent.postMessage('loggedout','*');
        window.location.reload();
      }
		})
		.catch(error => console.log("Erreur : " + error));
  }

  </script>
</html>
