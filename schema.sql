-- CFnew 多 key 账号密码系统 D1 schema
-- 使用：wrangler d1 execute cfnew_db --file=schema.sql

-- 账号表（管理登录）
CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,        -- SHA-256(salt + password) 的 hex
  salt TEXT NOT NULL,                  -- 随机 16 字节 hex
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- key 表（每个 key = UUID，归属某账号）
CREATE TABLE IF NOT EXISTS keys (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  uuid TEXT UNIQUE NOT NULL,           -- key 本体，UUID v4 格式
  name TEXT DEFAULT '',               -- 备注
  enabled INTEGER DEFAULT 1,           -- 1启用 0停用
  upload INTEGER DEFAULT 0,           -- 累计上行字节
  download INTEGER DEFAULT 0,         -- 累计下行字节
  trojan_hash TEXT,                    -- SHA-224(uuid) hex，Trojan 握手查表用
  xhttp_bytes BLOB,                   -- UUID 解析后的 16 字节，xhttp 握手查表用
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_used_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_keys_trojan_hash ON keys(trojan_hash);
CREATE INDEX IF NOT EXISTS idx_keys_xhttp_bytes ON keys(xhttp_bytes);
CREATE INDEX IF NOT EXISTS idx_keys_account ON keys(account_id);
CREATE INDEX IF NOT EXISTS idx_keys_uuid ON keys(uuid);

-- 每 key 的国家分布聚合
CREATE TABLE IF NOT EXISTS key_countries (
  key_id INTEGER NOT NULL REFERENCES keys(id) ON DELETE CASCADE,
  country TEXT NOT NULL,              -- CF-IPCountry 二字码（如 CN、US）
  hit_count INTEGER DEFAULT 0,        -- 该 key 在该国家的连接次数
  bytes INTEGER DEFAULT 0,            -- 该 key 在该国家累计的流量字节
  PRIMARY KEY (key_id, country)
);
