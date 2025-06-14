-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for handmadestore
CREATE DATABASE IF NOT EXISTS `handmadestore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `handmadestore`;

-- Dumping structure for table handmadestore.order_images
CREATE TABLE IF NOT EXISTS `order_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imagePath` varchar(255) NOT NULL,
  `productId` int(11) DEFAULT NULL,
  `orderDate` timestamp NULL DEFAULT current_timestamp(),
  `tel` varchar(12) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  `recieveDate` timestamp NULL DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `otherCustom` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_images_fkproduct` (`productId`),
  KEY `order_images_fkuser` (`userId`),
  CONSTRAINT `order_images_fkproduct` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_images_fkuser` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table handmadestore.order_images: ~7 rows (approximately)
INSERT INTO `order_images` (`id`, `imagePath`, `productId`, `orderDate`, `tel`, `note`, `userId`, `status`, `recieveDate`, `address`, `otherCustom`) VALUES
	(1, 'images/custom/Dương Trí Nguyên_3_20250531192721_1.png', 3, NULL, NULL, NULL, NULL, 4, NULL, NULL, NULL),
	(2, 'images/custom/Dương Trí Nguyên_49_20250531210657_1.png', 49, '2025-05-31 14:06:57', NULL, NULL, NULL, 1, NULL, NULL, NULL),
	(3, 'images/custom/Dương Trí Nguyên_49_20250531210657_2.png', 49, '2025-05-31 14:06:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(4, 'images/custom/Dương Trí Nguyên_1_20250601144113_1.png', 1, '2025-06-01 07:41:13', '0944126980', NULL, NULL, NULL, NULL, NULL, NULL),
	(5, 'images/custom/Dương Trí Nguyên_3_20250601144630_1.png', 3, '2025-06-01 07:46:30', '0944126980', NULL, NULL, NULL, NULL, NULL, NULL),
	(6, 'images/custom/Dương Trí Nguyên_3_20250602171429_1.png', 3, '2025-06-02 10:14:29', '0944126980', NULL, NULL, 4, NULL, NULL, NULL),
	(7, 'images/custom/Dương Trí Nguyên_5_20250602171805_1.png', 5, '2025-06-02 10:18:05', '0944126980', NULL, 20, 1, NULL, NULL, NULL),
	(8, 'images/custom/Dương Trí Nguyên_48_20250603202946_1.png', 48, '2025-06-03 13:29:46', '091429412', NULL, 22, 1, NULL, NULL, NULL),
	(9, 'images/custom/Dương Trí Nguyên_3_20250605194406_1.jpg', 3, '2025-06-05 12:44:06', '0944126980', '123', 20, 0, '2025-06-05 17:00:00', '123, Xã Suối Nghệ, Huyện Châu Đức, Bà Rịa - Vũng Tàu', 'Hình thức đóng gói: normal, màu sắc: red');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
