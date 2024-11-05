<?php
include 'db.php';

$data = json_decode(file_get_contents("php://input"), true);
$sql = 'INSERT INTO usuarios (nome, email, celular, senha, adm) VALUES (?, ?, ?, ?, 0)';
$stmt = $db->prepare($sql);
if ($stmt->execute([$data['nome'], $data['email'], $data['celular'], $data['senha']])) {
    echo json_encode(['success' => true, 'insertId' => $db->lastInsertId()]);
} else {
    echo json_encode(['error' => 'Erro ao inserir usuário']);
}
?>