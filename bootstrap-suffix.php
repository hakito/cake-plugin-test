CakePlugin::loadAll(array(array('bootstrap' => true, 'routes' => true, 'ignoreMissing' => true)));
Configure::write('Security.useOpenSsl', true);

// Load Composer autoload.
require APP . 'Vendor/autoload.php';

// Remove and re-prepend CakePHP's autoloader as Composer thinks it is the
// most important.
// See: http://goo.gl/kKVJO7
spl_autoload_unregister(array('App', 'load'));
spl_autoload_register(array('App', 'load'), true, true);