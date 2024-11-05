const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

const dbConfig = {
  host: 'sysmedicalapp.mysql.dbaas.com.br',
  user: 'sysmedicalapp',
  password: 'SysMedical123!',
  database: 'sysmedicalapp'
};

const pool = mysql.createPool(dbConfig);

const conectarBancoDeDados = () => {
  return new Promise((resolve, reject) => {
    pool.getConnection((err, connection) => {
      if (err) reject(err);
      else resolve(connection);
    });
  });
};

const verificarOuCriarTabela = async () => {
  const conn = await conectarBancoDeDados();

  conn.query("SHOW TABLES LIKE 'usuarios';", (err, results) => {
    if (err) throw err;
    if (results.length === 0) {
      conn.query(`
        CREATE TABLE usuarios (
          id INT AUTO_INCREMENT PRIMARY KEY,
          nome VARCHAR(100) NOT NULL,
          email VARCHAR(100) UNIQUE NOT NULL,
          celular VARCHAR(15),
          senha VARCHAR(100) NOT NULL,
          status VARCHAR(50),
          adm INT(11) NOT NULL
        );
      `, (err) => {
        if (err) throw err;
        console.log("Tabela 'usuarios' criada com sucesso.");
      });
    } else {
      console.log("Tabela 'usuarios' já existe.");
    }
    conn.release();
  });
};

const criarTabelaChamado = async () => {
  const conn = await conectarBancoDeDados();

  conn.query("SHOW TABLES LIKE 'chamados';", (err, results) => {
    if (err) throw err;
    if (results.length === 0) {
      conn.query(`
        CREATE TABLE chamados (
          id INT AUTO_INCREMENT PRIMARY KEY,
          tipo VARCHAR(50) NOT NULL,
          chamado VARCHAR(50) UNIQUE NOT NULL,
          cliente VARCHAR(50) NOT NULL,
          equipamento VARCHAR(100) NOT NULL,
          data DATETIME,
          endereco VARCHAR(100) NOT NULL,
          celular VARCHAR(11) NOT NULL,
          link VARCHAR(150),
          observacao VARCHAR(200),
          tecnico VARCHAR(100) NOT NULL,
          status VARCHAR(50) NOT NULL
        );
      `, (err) => {
        if (err) throw err;
        console.log("Tabela 'chamados' criada com sucesso.");
      });
    } else {
      console.log("Tabela 'chamados' já existe.");
    }
    conn.release();
  });
};

app.post('/inserir-usuario', async (req, res) => {
  const db = await conectarBancoDeDados();

  const { nome, email, celular, senha } = req.body;
  const sql = 'INSERT INTO usuarios (nome, email, celular, senha, adm) VALUES (?, ?, ?, ?, 0)';
  db.query(sql, [nome, email, celular, senha], (err, result) => {
    if (err) return res.status(500).send('Erro ao inserir usuário');
    res.send({ success: true, insertId: result.insertId });
  });
});

app.post('/criar-chamado', async (req, res) => {
  const db = await conectarBancoDeDados();

  const { tipo, chamado, cliente, equipamento, data, endereco, celular, link, observacao, tecnico, status } = req.body;
  const sql = 'INSERT INTO chamados (tipo, chamado, cliente, equipamento, data, endereco, celular, link, observacao, tecnico, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
  db.query(sql, [tipo, chamado, cliente, equipamento, data, endereco, celular, link, observacao, tecnico, status], (err, result) => {
    if (err) return res.status(500).send('Erro ao criar chamado');
    res.send({ success: true, insertId: result.insertId });
  });
});

app.get('/chamados', async (req, res) => {
  const db = await conectarBancoDeDados();

  const sql = 'SELECT * FROM chamados';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).send('Erro ao buscar chamados');
    res.send(results);
  });
});

app.get('/api/tecnicos', async (req, res) => {
  const db = await conectarBancoDeDados();

  const query = 'SELECT * FROM usuarios WHERE adm != 1';
  db.query(query, (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Erro ao buscar técnicos.' });
    }
    res.json(results);
  });
});

app.get('/api/chamados/:tecnico', async (req, res) => {
  const db = await conectarBancoDeDados();
  const tecnico = req.params.tecnico;

  const sql = `
    SELECT * 
    FROM chamados 
    WHERE tecnico = ?
  `;

  db.query(sql, [tecnico], (err, results) => {
    if (err) {
      console.error('Erro ao buscar chamados:', err);
      return res.status(500).json({ error: 'Erro ao buscar chamados.' });
    }
    res.json(results);
  });
});

app.put('/api/tecnicos/:nome', async (req, res) => {
  const db = await conectarBancoDeDados();
  const nome = req.params.nome;
  const { email, celular, status, chamadosAtribuidos } = req.body;

  const sql = `
    UPDATE usuarios 
    SET email = ?, celular = ?
    WHERE nome = ?
  `;

  db.query(sql, [email, celular, status, chamadosAtribuidos, nome], (err, result) => {
    if (err) {
      console.error('Erro ao atualizar técnico:', err);
      return res.status(500).json({ error: 'Erro ao atualizar técnico.' });
    }
    res.json({ success: true });
  });
});

app.delete('/api/tecnicos/:nome', async (req, res) => {
  const db = await conectarBancoDeDados();
  const nome = req.params.nome;

  const sql = 'DELETE FROM usuarios WHERE nome = ?';

  db.query(sql, [nome], (err, result) => {
    if (err) {
      console.error('Erro ao excluir técnico:', err);
      return res.status(500).json({ error: 'Erro ao excluir técnico.' });
    }
    res.json({ success: true });
  });
});

app.post('/verificar-credenciais', async (req, res) => {
  const db = await conectarBancoDeDados();

  const { email, senha } = req.body;
  const sql = 'SELECT * FROM usuarios WHERE email = ? AND senha = ?';
  db.query(sql, [email, senha], (err, result) => {
    if (err) return res.status(500).send('Erro ao verificar credenciais');
    if (result.length > 0) {
      res.send({ success: true });
    } else {
      res.send({ success: false });
    }
  });
});

app.listen(3000, () => {
  console.log('Servidor rodando na porta 3000');
  verificarOuCriarTabela();
  criarTabelaChamado();
});