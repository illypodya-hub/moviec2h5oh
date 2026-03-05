<?php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!$data || empty($data['name']) || empty($data['text'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing data']);
    exit;
}

$name = htmlspecialchars(trim($data['name']));
$text = htmlspecialchars(trim($data['text']));
$time = date('Y-m-d H:i:s');

$line = "[$time] $name: $text\n";

file_put_contents('suggestions.txt', $line, FILE_APPEND | LOCK_EX);

echo json_encode(['success' => true]);
