<?php
namespace Optimus\DAVACL\FS;

class HomeCollection extends \Sabre\DAVACL\FS\HomeCollection
{
	function getName()
	{
		return 'files';
	}
}
?>