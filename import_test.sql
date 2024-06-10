-- Creation of a test base...

CREATE DATABASE lookout;

CREATE TABLE sectors (
  id INT NOT NULL AUTO_INCREMENT,
  coordinates VARCHAR(20) NOT NULL,
  luminous INT NOT NULL,
  obstacles VARCHAR(255),
  objects_number INT NOT NULL,
  unidentified_objects INT NOT NULL,
  identified_objects INT NOT NULL,
  observ_date TIMESTAMP NOT NULL,
  notes VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

INSERT INTO sectors (coordinates, luminous, obstacles,objects_number, unidentified_objects, identified_objects, observ_date, notes) VALUES
('234:567', 120000, 1, 5, 3, 2, '2024-01-01 12:00:00', null);

CREATE TABLE objects (
  id INT NOT NULL AUTO_INCREMENT,
  object_type VARCHAR(45),
  accuracy DEC(5,4) NOT NULL,
  quantity INT NOT NULL,
  observ_time TIME NOT NULL,
  observ_date TIMESTAMP NOT NULL,
  notes VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE natural_objects (
  id INT NOT NULL AUTO_INCREMENT,
  object_type VARCHAR(45),
  galaxy VARCHAR(45),
  accuracy DEC(5,4) NOT NULL,
  luminous INT NOT NULL,
  conjugated_objects VARCHAR(255),
  notes VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE positions (
  id INT NOT NULL AUTO_INCREMENT,
  earth_pos VARCHAR(60),
  sol_pos VARCHAR(60),
  moon_pos VARCHAR(60),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

INSERT INTO positions (earth_pos, sol_pos, moon_pos) VALUES
("123`456", "234`561", "345`612");

CREATE TABLE connections (
  id INT NOT NULL AUTO_INCREMENT,
  id_sectors INT,
  id_objects INT,
  id_natural_objects INT,
  id_positions INT,
  PRIMARY KEY (id),
  FOREIGN KEY (id_sectors) REFERENCES sectors(id),
  FOREIGN KEY (id_objects) REFERENCES objects(id),
  FOREIGN KEY (id_natural_objects) REFERENCES natural_objects(id),
  FOREIGN KEY (id_positions) REFERENCES positions(id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

INSERT INTO connections (id_sectors, id_objects, id_natural_objects, id_positions) VALUES
(1, null, null, 1);


DELIMITER //

CREATE PROCEDURE proc1 (table1 VARCHAR(255), table2 VARCHAR(255))
BEGIN
    IF table1 = "Sectors" THEN
        IF table2 = "Objects" THEN
            SELECT s.*, o.* FROM sectors s
            INNER JOIN connections c ON s.id = c.id_sectors
            INNER JOIN objects o ON c.id_objects = o.id;
        END IF;
        IF table2 = "Positions" THEN
            SELECT s.*, p.* FROM sectors s
            INNER JOIN connections c ON s.id = c.id_sectors
            INNER JOIN positions p ON c.id_positions = p.id;
        END IF;
        IF table2 = "Natural_objects" THEN
            SELECT s.*, n.* FROM sectors s
            INNER JOIN connections c ON s.id = c.id_sectors
            INNER JOIN natural_objects n ON c.id_natural_objects = n.id;
        END IF;
     END IF;
     IF table1 = "Objects" THEN
        IF table2 = "Sectors" THEN
            SELECT o.*, s.* FROM objects o
            INNER JOIN c ON o.id = c.id_objects
            INNER JOIN sectors s ON c.id_sectors = s.id;
        END IF;
        IF table2 = "Positions" THEN
            SELECT o.*, p.* FROM objects o
            INNER JOIN connections c ON o.id = c.id_objects
            INNER JOIN positions p ON c.id_positions = p.id;
        END IF;
        IF table2 = "Natural_objects" THEN
            SELECT o.*, n.* FROM objects o
            INNER JOIN connections c ON o.id = c.id_objects
            INNER JOIN natural_objects n ON c.id_natural_objects = n.id;
        END IF;
      END IF;
      IF table1 = "Positions" THEN
        IF table2 = "Sectors" THEN
            SELECT p.*, s.* FROM positions p
            INNER JOIN connections c ON p.id = c.id_positions
            INNER JOIN sectors s ON c.id_sectors = s.id;
        END IF;
        IF table2 = "Objects" THEN
            SELECT p.*, o.* FROM positions p
            INNER JOIN connections c ON p.id = c.id_positions
            INNER JOIN objects o ON c.id_objects = o.id;
        END IF;
        IF table2 = "Natural_objects" THEN
            SELECT p.*, n.* FROM positions p
            INNER JOIN connections c ON p.id = c.id_positions
            INNER JOIN natural_objects n ON c.id_natural_objects = n.id;
        END IF;
      END IF;
      IF table1 = "Natural_objects" THEN
        IF table2 = "Sectors" THEN
            SELECT n.*, s.* FROM natural_objects n
            INNER JOIN connections c ON n.id = c.id_natural_objects
            INNER JOIN sectors s ON c.id_sectors = s.id;
        END IF;
        IF table2 = "Objects" THEN
            SELECT n.*, o.* FROM natural_objects n
            INNER JOIN connections c ON n.id = c.id_natural_objects
            INNER JOIN objects o ON c.id_objects = o.id;
        END IF;
        IF table2 = "Positions" THEN
            SELECT n.*, p.* FROM natural_objects n
            INNER JOIN connections c ON n.id = c.id_natural_objects
            INNER JOIN positions p ON c.id_positions = p.id;
        END IF;
      END IF;
END //
DELIMITER ;