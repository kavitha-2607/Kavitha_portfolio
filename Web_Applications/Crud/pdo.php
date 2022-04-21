<?php
$hostName = "localhost";
   $dbName = "misc";
   $userName = "kavitha";
   $password = "kavitha";

   try {
       $pdo = new PDO("mysql:host=$hostName; port=3306; dbname=$dbName",$userName,$password);

       //ERRMODE_SILENT is default.
       //ERRMODE_WARNING will still keep executing code.
       $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

   } catch(PDOException $e) {
       echo "Connection failed: " . $e->getMessage();
   }

 ?>
