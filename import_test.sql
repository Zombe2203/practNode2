-- Creation of a test base...

CREATE DATABASE bank;

CREATE TABLE individuals (
  id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  middle_name VARCHAR(30),
  passport VARCHAR(10) NOT NULL,
  taxpayer_number VARCHAR(12) NOT NULL,
  insurance_number VARCHAR(11) NOT NULL,
  driver_licence VARCHAR(10),
  extra_documents VARCHAR(255),
  notes VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

INSERT INTO individuals (first_name, last_name, middle_name, passport, taxpayer_number, insurance_number, driver_licence, extra_documents, notes) VALUES
('Ivan', 'Ivanov', 'Ivanovich', '1234567890', '123456789012', '12345678901', null, null, null),
('Petr', 'Petrov', 'Petrovich', '2345678901', '234567890123', '23456789012', null, null, null),
('Oleg', 'Olegov', 'Olegovich', '3456789012', '345678901234', '34567890123', null, null, null),
('Roman', 'Romanov', 'Romanovich', '4567890123', '456789012345', '45678901234', null, null, null),
('Stepan', 'Stepanov', 'Stepanovich', '5678901234', '567890123456', '56789012345', null, null, null);

CREATE TABLE borrowers (
  borrower_id INT NOT NULL AUTO_INCREMENT,
  taxpayer_number VARCHAR(12) NOT NULL,
  is_legal_entity BIT NOT NULL,
  address VARCHAR(255) NOT NULL,
  amount INT NOT NULL,
  conditions VARCHAR(255) NOT NULL,
  legal_notes VARCHAR(255),
  contracts_list VARCHAR(255),
  PRIMARY KEY (borrower_id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE loans (
  id INT NOT NULL AUTO_INCREMENT,
  individual_id INT NOT NULL,
  amount INT NOT NULL,
  interest DEC(5,2) NOT NULL,
  term TIMESTAMP NOT NULL,
  conditions VARCHAR(255) NOT NULL,
  notes VARCHAR(255) NOT NULL,
  borrower_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (individual_id) REFERENCES individuals(id),
  FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE companies_loans (
  id INT NOT NULL AUTO_INCREMENT,
  company_id INT NOT NULL,
  individual_id INT NOT NULL,
  amount INT NOT NULL,
  term TIMESTAMP NOT NULL,
  interest DEC(5,2) NOT NULL,
  conditions VARCHAR(255) NOT NULL,
  notes VARCHAR(255),
  PRIMARY KEY (id),
  FOREIGN KEY (individual_id) REFERENCES individuals(id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
