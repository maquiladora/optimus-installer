<?php
  if (!isset($_COOKIE['token']))
    include('login.php');
?>

<html>
  <body>

    <div id="container" style="height:80vh;display:flex;justify-content:center;align-items:center;flex-direction:column">

      <input type="button" style="position:fixed;top:5px;right:5px" value="logout" onclick="logout()"/>

      <a href="https://webmail.$DOMAIN" target="_blank">WEBMAIL ROUNDCUBE</a>
      <a href="https://cloud.$DOMAIN" target="_blank">CLIENT WEBDAV BASIC</a>
      <a href="https://optimus.$DOMAIN/modules/filexplorer" target="_blank">CLIENT WEBDAV JAVASCRIPT</a>
      <a href="https://optimus.$DOMAIN" target="_blank">OPTIMUS (LOCAL)</a>
      <a href="https://v4.optimus-avocats.fr" target="_blank">>OPTIMUS (DISTANT)</a>

    </div>

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
