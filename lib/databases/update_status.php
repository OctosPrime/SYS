<?php
include 'db.php';

header('Content-Type: application/json');

try {
    $db = new PDO($dsn, $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

try {
    $data = json_decode(file_get_contents("php://input"), true);
    $chamadoId = isset($data['id']) ? $data['id'] : null;
    $status = isset($data['status']) ? $data['status'] : null;

    if ($chamadoId === null || $status === null) {
        echo json_encode(['error' => 'Chamado ID and status are required']);
        exit();
    }

    $sql = 'UPDATE chamados SET status = ? WHERE id = ?';
    $stmt = $db->prepare($sql);
    $stmt->execute([$status, $chamadoId]);

    if ($stmt->rowCount() > 0) {
        echo json_encode(['success' => 'Status updated successfully']);
    } else {
        echo json_encode(['error' => 'Failed to update status or no change detected']);
    }
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>