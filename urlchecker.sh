#!/usr/local/bin/php

<?php

error_reporting(E_ALL & ~ (E_WARNING | E_NOTICE | E_STRICT | E_DEPRECATED));  
ini_set('display_startup_errors',0);  
ini_set('display_errors',0);  
ini_set('log_errors',0); 

$argv0 = $argv[0];
$argv1 = $argv[1]??null;

function isUrl(string $url): bool
{
	$url= strtolower($url);
	$pattern1 = "/^http(s)?\:\/\/(www\.)?[\w-]+\.\w+$/";
	$pattern2 = "/^http(s)?\:\/\/(www\.)?[\w-]+\.[\w-]+\.\w+$/";
        $pattern3 = "/^http(s)?\:\/\/(www\.)?[\w-]+\.[\w-]+\.[\w-]+\.\w+$/";
	if (preg_match($pattern1, $url) || preg_match($pattern2, $url) || preg_match($pattern3, $url)) {
	 $retval=true;
	} else {
	 $retval=false;
	}
	return $retval;
}

function left(?string $string, int $length): string
{
	if (!isset($string) || $string === "") {
	 return "";
	}
	return mb_substr($string, 0, $length);
}

if (is_null($argv1)) {
  echo("0");
  exit;
}

$argv1 = strtolower($argv1); 

if ((left($argv1, 7) !== "http://") && (left($argv1, 8) !== "https://")) {
  echo("0 = $argv1 [invalid scheme]");
  exit;
}

if (!isurl($argv1)) {
  echo("0 = $argv1 [invalid url]");
  exit;
}

$cont = file_get_contents($argv1, false);
if ($cont) {
  echo("1 = $argv1 [valid]");
} else {
  echo("0 = $argv1 [invalid failed]");
}

exit;
?>
