<?php
$file_url = 'https://onedrive.live.com/upload?cid=YOUR_CID&resid=YOUR_RESID&authkey=YOUR_AUTHKEY';

$ch = curl_init($file_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, [
    'file' => new CURLFile('path_to_file/filename.extension')
]);

$response = curl_exec($ch);
curl_close($ch);

if ($response) {
    echo 'Arquivo enviado com sucesso!';
} else {
    echo 'Falha no upload.';
}
