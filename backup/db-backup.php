<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/2000/REC-xhtml1-20000126/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style="overflow:auto;background-color:#000000;color:#C0C0C0;font:normal 12px Terminal">
        <head>
                <title>BACKUP</title>
        </head>
        <body>
                <?php
                $connection = mysqli_connect('localhost','optimus','zufs3t2$4');
                ini_set('track_errors', 1);
                ini_set('max_execution_time', 1800);
                ini_set('memory_limit', '256M');

                $zip = new ZipArchive();
                $zip -> open('/srv/db-backup/' . date("Y-m-d") . '.zip',ZIPARCHIVE::CREATE);
                echo 'Archive created : /srv/db-backup/' . date("Y-m-d") . '.zip<br/><br/>';flush();
                $databases_query = mysqli_query("SHOW DATABASES",$connection);
                while ($databases = mysqli_fetch_array($databases_query,$connection))
                {
                        $database = $databases['Database'];
                        if ($database!='information_schema')
                        {
                                system("mysqldump --host=localhost --user='optimus' --password='zufs3t2$4' --complete-insert --skip-extended-insert --skip-comments --skip-add-locks --skip-quote-names " . $database . " > /srv/tmp/".$database.".sql");
                                sleep(1);
                                $zip -> addFile('/srv/tmp/'.$database.'.sql',date("Y-m-d")." - ".$database.".sql");
                                sleep(1);
                                echo 'Backup of database "' . $database . '" successfully completed !<br/>';flush();
                        }
                        else
                                echo 'Backup of database "' . $database . '" ommited ...<br/>';flush();
                }



               mysqli_close();
                              $zip -> close();
                              echo "<br/>";

                              $handler = opendir('/srv/tmp/');
                              while (false !== ($file = readdir($handler)))
                              {
                                      if($file=='.' || $file=='..')
                                              continue;
                                      unlink('/srv/tmp/'.$file);
                              }
                              closedir($handler);
                              echo 'TEMPORARY FILES REMOVED<br/>'; flush();

                              echo 'BACKUP COMPLETE !<br/>'; flush();

                              if ($php_errormsg)
                                      mail('postmaster@$DOMAIN','DATABASE BACKUP COMPLETE (with errors)',$php_errormsg,'From: postmaster@$DOMAIN');
                              else
                                      mail('postmaster@$DOMAIN','DATABASE BACKUP COMPLETE','NO ERROR','From: postmaster@$DOMAIN');
                              ?>
                      </body>
              </html>
