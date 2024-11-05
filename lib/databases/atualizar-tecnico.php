<?php
include 'db.php';

try {
    if (!isset($_GET['tecnico'])) {
        throw new Exception('Parâmetro "tecnico" não fornecido');
    }

    $tecnico = $_GET['tecnico'];
    $sql = 'SELECT * FROM chamados WHERE tecnico = ?';
    $stmt = $db->prepare($sql);
    $stmt->execute([$tecnico]);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($results);
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>