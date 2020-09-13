function api_call(endpoint, method, data)
{
  if (typeof login_iframe === 'object')
    return setTimeout("api_call('" + endpoint + "', '" + method + "', '" + data + "')",500);

  domain = new URL(endpoint);
  domain = domain.hostname.split('.');
  domain = domain[domain.length-2] + '.' + domain[domain.length-1];

  var fetch_options = {headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, method: method, credentials: "include"};
  if (method != 'GET')
    fetch_options.push = {body: data};
  fetch(endpoint,fetch_options)
  .then(response => response.json())
  .then(function(response)
  {
    if (response.message == 'Access denied' && response.error == 'No Token')
    {
      login_open(domain);
      return setTimeout("api_call('" + endpoint + "', '" + method + "', '" + data + "')",500);
    }
    else
      return response;
  })
  .catch(error => console.log("Error : " + error));
}

function login_open(domain)
{
  login_iframe = document.createElement('iframe');
  login_iframe.style.position = 'fixed';
  login_iframe.style.left = '0';
  login_iframe.style.top = '0';
  login_iframe.style.width = '100%';
  login_iframe.style.height = '100%';
  login_iframe.frameBorder=0;
  login_iframe.style.backdropFilter = 'blur(3px)';
  login_iframe.src = "https://" + domain;
  document.body.appendChild(login_iframe);
}

function login_close()
{
  login_iframe.parentNode.removeChild(login_iframe);
  login_iframe = undefined;
}

var messageEventHandler = function(event)
{
  if(event.data == 'logged')
    login_close();
}

window.addEventListener('message', messageEventHandler,false);
