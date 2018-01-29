<?php

/* Shell Command */

// shell_exec() 
// passthru()   
// system()     
// exec()       
// popen()      
// proc_open()  

$access = new csvLogic();

$comm   = csvLogic::getShell();
$output = shell_exec($comm);

echo $output;

class csvLogic	{
	function getShell()	{
		try {
			$string = 'sh ./csv_capture.sh " ';
			
			$getSql = csvLogic::getsql();
			//print($getSql);
			
			$string .= $getSql;
			$string .= ' " ';
			
			$string .= ' "';
			$string .= csvLogic::getval();
			$string .= '" ';
			
			// echo $string;
			return $string;
		} catch (PDOException $e) {
			print('ERROR: ');
			echo 'ERROR: ';
			return null;
		}
	}
	
	//getparameter (sql)
	function getsql()	{
		if(isset($_GET['sql'])) {
			//URL_sql EUC-JP
			$sql = mb_convert_encoding(rawurldecode($_GET['sql']), "eucJP-win", "UTF-8");
			//echo $sql;
			return $sql;
		} else {
			return '';
		}
	}
	
	//getparameter(val)
	function getval()	{
		if(isset($_GET['val'])) {
			//URL_val EUC-JP
			$val = mb_convert_encoding(rawurldecode($_GET['val']), "eucJP-win", "UTF-8");
			//echo $val;
			return $val;
		} else {
			return '';
		}
	}
}

?>
