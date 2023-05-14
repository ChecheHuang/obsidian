-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2023-05-13 17:06:43
-- 伺服器版本： 10.4.24-MariaDB
-- PHP 版本： 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `chat`
--

-- --------------------------------------------------------

--
-- 資料表結構 `message`
--

CREATE TABLE `message` (
  `messageId` int(10) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `receiver` varchar(20) NOT NULL,
  `message` varchar(100) NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 傾印資料表的資料 `message`
--

INSERT INTO `message` (`messageId`, `sender`, `receiver`, `message`, `time`) VALUES
(1, 'test', 'Carl', 'wef', '2022-10-25 23:24:30'),
(2, '', 'Carl', 'wefwef', '2022-10-25 23:28:40'),
(3, '', 'Allen', 'wefwef', '2022-10-25 23:29:11'),
(4, '', 'Allen', 'sdcsdc', '2022-10-25 23:29:14'),
(5, '123', 'test', 'test', '2022-10-26 21:10:24'),
(6, '123', 'test', 'fewf', '2022-10-26 22:35:29'),
(7, 'test', '123', 'fewfwef', '2022-10-26 22:35:40'),
(8, 'test', '123', 'wefw', '2022-10-26 22:37:23'),
(9, '123', 'test', 'wefwef', '2022-10-26 22:37:35'),
(10, 'test', '1', 'test', '2022-10-26 22:38:18'),
(11, '1', '123', 'wef', '2022-10-26 22:38:37'),
(12, '1', 'test', 'wef', '2022-10-26 22:38:43'),
(13, '1', 'test', 'qwd', '2022-10-26 22:38:58'),
(14, '1', 'test', 'test', '2022-10-26 22:40:51'),
(15, '1', 'test', 'test', '2022-10-26 22:42:14'),
(16, '1', 'test', 'test', '2022-10-26 22:43:58'),
(17, '1', 'test', 'wef', '2022-10-26 22:44:48'),
(18, '1', 'test', 'wef', '2022-10-26 22:44:51'),
(19, 'test', '1', 'wefwef', '2022-10-26 22:45:00'),
(20, 'test', '1', 'wefwef', '2022-10-26 22:45:04'),
(21, 'test', '123', 'wefwef', '2022-10-26 22:45:10'),
(22, 'test', '123', 'wefwf', '2022-10-26 22:45:13'),
(23, 'test', '123', 'qwddw', '2022-10-26 22:45:16'),
(24, 'test', '1', 'qwd', '2022-10-26 22:45:27'),
(25, 'test', '1', 'f', '2022-10-26 22:46:51'),
(26, 'test', '1', 'test', '2022-10-26 22:49:51'),
(27, '1', 'test', 'c c c c c ', '2022-10-26 22:50:04'),
(28, 'test', '1', 'qwdqwd', '2022-10-26 22:50:07'),
(29, '1', 'test', 'qweqwe', '2022-10-26 22:50:10');

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

CREATE TABLE `users` (
  `userName` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `isOnline` tinyint(1) NOT NULL DEFAULT 0,
  `currentTime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 傾印資料表的資料 `users`
--

INSERT INTO `users` (`userName`, `password`, `isOnline`, `currentTime`) VALUES
('1', '1', 0, '2022-10-26 22:38:00'),
('123', '1234', 0, '2022-10-26 21:08:24'),
('test', '123', 0, '2022-10-25 22:55:22');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`messageId`);

--
-- 資料表索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userName`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `message`
--
ALTER TABLE `message`
  MODIFY `messageId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
