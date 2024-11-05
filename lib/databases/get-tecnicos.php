<?php
include 'db.php';

try {
    $sql = 'SELECT * FROM usuarios WHERE adm != 1';
    $stmt = $db->query($sql);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($results);
} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>