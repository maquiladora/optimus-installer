<?php
namespace Allspark\DAVACL\FS;

class HomeCollection extends \Sabre\DAVACL\FS\HomeCollection
{
	function getName()
	{
		return 'files';
	}
}
?>
