<?php
$servername = "localhost";
$username = "moneymon_mytutor_278366";
$password = "bJ=s;^m*1EW}";
$dbname = "moneymon_278366_mytutordb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
 die("Connection failed: " . $conn->connect_error);
}
?>