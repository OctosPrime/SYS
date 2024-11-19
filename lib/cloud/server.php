<?php
// server.php

header('Content-Type: application/json');

// Refresh token armazenado (substitua pelo seu token)
$refreshToken = 'YOUR_STORED_REFRESH_TOKEN';

// Configurações da sua aplicação
$tenantID = 'YOUR_TENANT_ID';
$clientID = 'YOUR_CLIENT_ID';
$scope = 'https://graph.microsoft.com/.default';

$url = "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token";

$data = array(
    'client_id' => $clientID,
    'scope' => $scope,
    'refresh_token' => $refreshToken,
    'grant_type' => 'refresh_token'
);

$options = array(
    'http' => array(
        'header'  => "Content-Type: application/x-www-form-urlencoded",
        'method'  => 'POST',
        'content' => http_build_query($data)
    )
);

$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);

if ($result === FALSE) {
    http_response_code(500);
    echo json_encode(array('error' => 'Erro ao renovar o token de acesso'));
} else {
    $response = json_decode($result, true);
    $newAccessToken = $response['access_token'];
    $newRefreshToken = $response['refresh_token'];

    // Atualize o refresh token armazenado
    // Aqui você deve salvar o novo refresh token de forma segura

    echo json_encode(array('access_token' => $newAccessToken));
}
