-- sample.sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  active BOOLEAN DEFAULT TRUE
);

INSERT INTO users (id, name, active)
VALUES (1, 'Ada', TRUE), (2, 'Linus', FALSE);

SELECT id, name FROM users WHERE active = TRUE ORDER BY name;
