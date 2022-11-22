CREATE DATABASE projetos

GO

use projetos

GO

CREATE TABLE projects(
id			INT				IDENTITY (10001, 1)			NOT NULL,
name		VARCHAR(45)									NOT NULL,
description VARCHAR(45)									NOT NULL,
date		DATE	CHECK(date > '2014-09-01')			NOT NULL
PRIMARY KEY (id)
)

GO

CREATE TABLE users(
id			INT			IDENTITY (1,1)					NOT NULL,
name		VARCHAR(45)									NOT NULL,
username	VARCHAR(45)									NOT NULL,
password	VARCHAR(45)	DEFAULT '123mudar'				NOT NULL,
email		VARCHAR(45)									NOT NULL
PRIMARY KEY (id),
)

GO

CREATE TABLE users_hars_projects (
users_id		INT						NOT NULL,
projects_id		INT						NOT NULL
PRIMARY KEY(users_id, projects_id)
FOREIGN KEY(users_id) REFERENCES users (id),
FOREIGN KEY(projects_id) REFERENCES projects (id)
)

GO

ALTER TABLE users
ALTER COLUMN username VARCHAR(10)									NOT NULL 

GO

ALTER TABLE users
ADD CONSTRAINT user_unico  UNIQUE(username)

GO

ALTER TABLE users
ALTER COLUMN password  VARCHAR(8)									NOT NULL 

GO

INSERT INTO users VALUES 
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

GO

INSERT INTO	projects VALUES
('Re-folha', 'Refatoração das folhas', '05-09-2014'),
('Manutenção PCs ', 'Manutenção PCs', '06-09-2014'),
('Auditoria', '', '07-09-2014')

GO

INSERT INTO users_hars_projects (users_id, projects_id)
VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

GO

UPDATE projects
SET date = '12/09/2014'
WHERE id = 10002

GO

UPDATE users
SET username = 'Rh_cido'
WHERE id = 5

GO

UPDATE users
SET password = '888@*'
WHERE id = 1 AND password = '123mudar'

GO

DELETE users_hars_projects
WHERE users_id = 2

GO

SELECT id, name, email, username,
CASE WHEN password = '123mudar'
THEN + password
ELSE  '********'
END AS password
FROM users

GO

SELECT id, name, description,
 + CONVERT(char(10), date, 103) AS data, DATEADD(day, 15, date) AS data_Final
FROM projects 
WHERE id in 
(
SELECT DISTINCT projects_id
FROM users_hars_projects
WHERE users_id IN
(
SELECT DISTINCT id
FROM users
WHERE email like 'aparecido@empresa.com'
	)
)

GO

SELECT name, email
FROM users
WHERE id in
(
SELECT users_id
FROM users_hars_projects
WHERE projects_id in
 (
	SELECT id
	FROM projects
	WHERE name like '%Auditoria%'
	)
)

GO

SELECT id, name, description,
	+ CONVERT(char(10), date, 103) AS Data,
	+ '16/09/2014' AS data_final,
	   DATEDIFF(DAY,date, '20140916')* 79.85 AS custo_total
FROM projects
WHERE name like '%Manutenção%'

INSERT INTO users
VALUES ('João', 'TI_joao', '123mudar', 'joao@empresa.com')
GO

--SET IDENTITY_INSERT nome_da_tabela OFF
INSERT INTO projects
VALUES ('Atualização de Sistemas' , 'Modificação de Sistemas Operacionais nos PCs' , '12/09/2014')

GO

SELECT DISTINCT us.id, us.name, us.email, pj.id, pj.name, pj.description, pj.date
FROM users us, projects pj, users_hars_projects uspj
WHERE us.id = uspj.users_id
and pj.id = uspj.projects_id
and pj.name = 'Re-folha'

SELECT DISTINCT pj.name
FROM projects pj LEFT OUTER JOIN users_hars_projects uspj
ON pj.id = uspj.projects_id
WHERE uspj.users_id IS NULL

SELECT us.name
FROM users us LEFT OUTER JOIN users_hars_projects uspj
ON us.id = uspj.users_id
WHERE uspj.projects_id IS NULL

SELECT COUNT (id) AS qty_projects_no_users
FROM users Left Outer Join users_hars_projects
ON users.id = users_hars_projects.users_id
WHERE projects_id Is Null

SELECT projects.id, projects.name, COUNT(users.id) AS qty_users_project
FROM projects Inner Join users_hars_projects
ON projects.id = users_hars_projects.projects_id
Inner Join users 
ON users.id = users_hars_projects.users_id
WHERE projects.id Is Not Null
GROUP BY projects.id, projects.name
ORDER BY projects.name


