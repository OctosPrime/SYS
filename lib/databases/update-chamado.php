<?php
include 'db.php';

// Obtém o ID do chamado a partir do URL
$chamadoId = $_GET['id'];
$data = json_decode(file_get_contents("php://input"), true);

$sql = 'UPDATE chamados SET 
            cliente = ?, 
            equipamento = ?, 
            endereco = ?, 
            celular = ?, 
            link = ?, 
            observacao = ?, 
            data = ?, 
            tipo = ?, 
            status = ?,
            chamado = ?, 
            tecnico = ? 
        WHERE id = ?';

$stmt = $db->prepare($sql);
if (
    $stmt->execute([
        $data['cliente'],
        $data['equipamento'],
        $data['endereco'],
        $data['celular'],
        $data['link'],
        $data['observacao'],
        $data['data'],
        $data['tipo'],
        $data['status'],
        $data['chamado'],
        $data['tecnico'],
        $chamadoId
    ])
) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['error' => 'Erro ao atualizar chamado']);
}
?>