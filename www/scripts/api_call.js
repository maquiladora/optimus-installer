function api_call(endpoint, method, data)
{
  if (typeof login_iframe === 'object')
    return setTimeout("api_call('" + endpoint + "', '" + method + "', '" + data + "')",500);

  var fetch_options = {headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, method: method, credentials: "include"};
  if (method != 'GET')
    fetch_options.push = {body: data};
  fetch(endpoint,fetch_options)
  .then(response => response.json())
  .then(function(response)
  {
    if (response.message == 'Access denied' && response.error == 'No Token')
    {
      login_open('$DOMAIN');
      return setTimeout("api_call('" + endpoint + "', '" + method + "', '" + data + "')",500);
    }
    else
      return response;
  })
  .catch(error => console.log("Error : " + error));
}

function login_open(domain)
{
  curtain = document.createElement('div');
  curtain.style.position = 'fixed';
  curtain.style.left = '0';
  curtain.style.top = '0';
  curtain.style.width = '100%';
  curtain.style.height = '100%';
  curtain.style.opacity = '0.5';
  curtain.style.background = '#000000';
  document.body.appendChild(curtain);
  document.getElementById('container').style.filter = 'blur(3px)';
  login_iframe = document.createElement('iframe');
  login_iframe.style.position = 'fixed';
  login_iframe.style.left = '0';
  login_iframe.style.top = '0';
  login_iframe.style.width = '100%';
  login_iframe.style.height = '100%';
  login_iframe.frameBorder=0;
  login_iframe.src = "https://" + domain;
  document.body.appendChild(login_iframe);
}

function login_close()
{
  login_iframe.parentNode.removeChild(login_iframe);
  login_iframe = undefined;
  document.body.removeChild(curtain);
  document.getElementById('container').style.filter = 'blur(0px)';
}

var messageEventHandler = function(event)
{
  if(event.data == 'logged')
    login_close();
}

window.addEventListener('message', messageEventHandler,false);
