<?php
if ( ! isset($_GET['name']) || strlen($_GET['name']) < 1  ) {
    die('Name parameter missing');
}
if(isset($_POST['logout'])) {
   header('Location: index.php');
   return;
}
function check() {
    $ran = array("Rock", "Paper", "Scissors");
    $computer = array_rand($ran);
    $human = $_POST['strategy'];
  if ($strategy == "Paper" && $rand == "Rock" ){
    print "Human= $strategy Computer= $rand";
    return "Result= You Win";
  } else if ($strategy == "Scissors" && $rand == "Rock"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Lose";
  } else if ($strategy == "Rock" && $rand == "Paper"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Tie";
  } else if ($strategy == "Paper" && $rand == "Paper"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Win";
  } else if ($strategy == "Scissors" && $rand == "Paper"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Lose";
  } else if ($strategy == "Rock" && $rand == "Scissors"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Tie";
  } else if ($strategy == "Paper" && $rand == "Scissors"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Win";
  } else if ($strategy == "Scissors" && $rand = "Scissors"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Lose";
  } else if ($strategy == "Rock" && $rand = "Rock"){
    print "Human= $strategy Computer= $rand";
    return "Result=You Tie";
  }
  }

if (isset($_POST['play'])) {
  check();
}
$result = check();
 ?>
<!DOCTYPE html>
<html>
<head>
<title> Kavitha Raghunath Rock Paper Scissors </title>
</head>
<body>
<div class = "container">
<h1> Rock Paper Scissors </h1>
<?php
if ( isset($_REQUEST['name']) ) {
    echo "<p>Welcome: ";
    echo htmlentities($_REQUEST['name']);
    echo "</p>\n";
}
?>
<select id = "strategy" name = "strategy">
  <option value = "-1"> Select </option>
  <option value = "0"> Rock </option>
  <option value = "1"> Paper </option>
  <option value = "2"> Scissors </option>
  <option value = "3"> Test </option>
<input type = "submit" name = "play" value = "Play">
<input type = "submit" name = "logout" values = "Logout">
</div>
<pre>
<?php
if ( $Human == -1 ) {
    print "Please select a strategy and press Play.\n";
} else if ( $human == 3 ) {
    for($c=0;$c<3;$c++) {
        for($h=0;$h<3;$h++) {
            $r = check($c, $h);
            print "Human=$names[$h] Computer=$names[$c] Result=$r\n";
        }
    }
} else {
    print "Your Play=$human[$computer] Computer Play=$human[$computer] Result=$result\n";
}
?>
</pre>
</body>
</html>
