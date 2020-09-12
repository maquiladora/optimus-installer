<?php
class allspark_autologin extends rcube_plugin
{
  public $task = 'login';

  function init()
  {
    $this->load_config();
    $this->add_hook('startup', array($this, 'startup'));
    $this->add_hook('authenticate', array($this, 'authenticate'));
  }

  function startup($args)
  {
    if (empty($_SESSION['user_id']) && !empty($_GET['_autologin']))
      $args['action'] = 'login';

    return $args;
  }

  function authenticate($args)
  {
    include_once 'plugins/allspark_autologin/JWT.php';
    use allspark\JWT\JWT;

    if (isset($_COOKIE['token']))
    {
    	$payload = (new JWT('$API_SHA_KEY', 'HS512', 3600, 10))->decode($_COOKIE['token']);
    	$args['user'] = $payload['user']->email];
    }

    $rcmail	= rcmail::get_instance();
    $db	= $rcmail->get_dbh();
    $result	= $db->query("SELECT AES_DECRYPT(password,'$AES_KEY') as password FROM users.users WHERE email = '" . $args['user'] . "'");
    $data	= $db->fetch_assoc($result);

    $args['pass'] = $data['password'];
    $args['cookiecheck'] = false;
    $args['valid'] = true;

    return $args;
  }

  protected function get_config($key)
  {

  }
}
?>
