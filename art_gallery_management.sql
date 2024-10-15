-- Create the schema for the art gallery database
CREATE SCHEMA `art_gallery`;

-- Use the newly created schema
USE `art_gallery`;

-- Creating the 'artist' table
CREATE TABLE `art_gallery`.`artist` (
  `artist_id` INT NOT NULL AUTO_INCREMENT,
  `artist_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`artist_id`),
  UNIQUE INDEX `artist_id_UNIQUE` (`artist_id` ASC) VISIBLE
);

-- Creating the 'gallery' table with a foreign key constraint linking to 'artist'
CREATE TABLE `art_gallery`.`gallery` (
  `art_id` INT NOT NULL AUTO_INCREMENT,
  `art_dsc` VARCHAR(45) NOT NULL,
  `art_price` INT NULL,
  `artist_id` INT NOT NULL,
  `is_avail` BIT NOT NULL,
  PRIMARY KEY (`art_id`),
  UNIQUE INDEX `art_id_UNIQUE` (`art_id` ASC) VISIBLE,
  CONSTRAINT `fk_gallery_artist` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`)
);

-- Creating the 'customer' table
CREATE TABLE `art_gallery`.`customer` (
  `customer_id` INT NOT NULL,
  `customer_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customer_id`)
);

-- Creating the 'purchase' table with foreign key constraints linking to 'customer' and 'gallery'
CREATE TABLE `art_gallery`.`purchase` (
  `purchase_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `art_id` INT NOT NULL,
  PRIMARY KEY (`purchase_id`),
  CONSTRAINT `fk_purchase_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `fk_purchase_gallery` FOREIGN KEY (`art_id`) REFERENCES `gallery` (`art_id`)
);

-- Modifying 'is_avail' column in 'gallery' to have a default value of 1
ALTER TABLE `art_gallery`.`gallery` 
CHANGE COLUMN `is_avail` `is_avail` BIT(1) NOT NULL DEFAULT 1;

-- Making 'purchase_id' in 'purchase' table auto-increment
ALTER TABLE `art_gallery`.`purchase` 
CHANGE COLUMN `purchase_id` `purchase_id` INT NOT NULL AUTO_INCREMENT;

-- Adding a unique index on 'art_id' in the 'purchase' table
ALTER TABLE `art_gallery`.`purchase` ADD UNIQUE INDEX `art_id_UNIQUE` (`art_id` ASC) VISIBLE;

-- Creating a trigger that updates the 'is_avail' field in 'gallery' to 0 after a purchase
DELIMITER //
CREATE TRIGGER purchase_trigger AFTER INSERT ON purchase
FOR EACH ROW
BEGIN
    UPDATE gallery
    SET is_avail = 0
    WHERE art_id = NEW.art_id;
END;
//
DELIMITER ;

-- Inserting sample values into the 'artist' table
INSERT INTO `art_gallery`.`artist` (`artist_name`) VALUES
('John Doe'),
('Jane Smith');

-- Inserting sample values into the 'gallery' table
INSERT INTO `art_gallery`.`gallery` (`art_dsc`, `art_price`, `artist_id`, `is_avail`) VALUES
('Painting 1', 1000, 1, 1),
('Sculpture 1', 800, 2, 0);

-- Inserting sample values into the 'customer' table
INSERT INTO `art_gallery`.`customer` (`customer_id`, `customer_name`) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Williams');

-- Inserting sample values into the 'purchase' table
INSERT INTO `art_gallery`.`purchase` (`purchase_id`, `customer_id`, `art_id`) VALUES
(102, 2, 2);
