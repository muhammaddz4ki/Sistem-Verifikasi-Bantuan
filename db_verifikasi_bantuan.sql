-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 13 Jun 2025 pada 08.39
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_verifikasi_bantuan`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `aid_histories`
--

CREATE TABLE `aid_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `recipient_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('diberikan','ditolak') NOT NULL,
  `remarks` text DEFAULT NULL,
  `verified_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `aid_histories`
--

INSERT INTO `aid_histories` (`id`, `recipient_id`, `user_id`, `status`, `remarks`, `verified_at`) VALUES
(9, 18, 5, 'diberikan', NULL, '2025-06-12 18:52:40'),
(10, 19, 1, 'ditolak', NULL, '2025-06-12 18:59:52'),
(11, 20, 1, 'diberikan', NULL, '2025-06-13 02:03:43');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '0001_01_01_000002_create_jobs_table', 1),
(3, '2025_06_11_041954_create_users_table', 1),
(4, '2025_06_11_041955_create_recipients_table', 1),
(5, '2025_06_11_041956_create_aid_histories_table', 1),
(6, '2025_06_11_042239_create_personal_access_tokens_table', 2),
(7, '2025_06_13_015033_create_verifications_table', 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '880fd17b2a80356c4477184eb329023f0d3a88f2bdac1e017705faeb35edd59f', '[\"*\"]', NULL, NULL, '2025-06-10 22:26:38', '2025-06-10 22:26:38'),
(2, 'App\\Models\\User', 1, 'auth_token', '74df7d4a07022097b36ed72378ea510e31468bd702399f962c404fe9f5c3604c', '[\"*\"]', NULL, NULL, '2025-06-10 22:39:10', '2025-06-10 22:39:10'),
(3, 'App\\Models\\User', 1, 'auth_token', '67348f072d59acc3d05368f2f96634b0b7132914acd9bcaf598b57ff54a422cf', '[\"*\"]', NULL, NULL, '2025-06-10 22:39:12', '2025-06-10 22:39:12'),
(4, 'App\\Models\\User', 1, 'auth_token', '33897164dcfcaf66e2e4f7ae16f6d8b02e5b53c46ade354770f932dbdf6c3d40', '[\"*\"]', '2025-06-10 22:54:38', NULL, '2025-06-10 22:39:13', '2025-06-10 22:54:38'),
(5, 'App\\Models\\User', 2, 'auth_token', '81c219182f66824cbd4eadfd44b641608ad6ada723dfc415b9927947d6cef16b', '[\"*\"]', '2025-06-11 22:22:23', NULL, '2025-06-10 22:55:33', '2025-06-11 22:22:23'),
(6, 'App\\Models\\User', 1, 'auth_token', 'cf2e832a2cc17cf3c54f1cdce54d08089dd2565df4a747b890428b529d26ef08', '[\"*\"]', NULL, NULL, '2025-06-10 23:52:15', '2025-06-10 23:52:15'),
(7, 'App\\Models\\User', 1, 'auth_token', '234e993145246b31ab6bcb817bf22cb4c26e52292012349f7355961291ff24eb', '[\"*\"]', NULL, NULL, '2025-06-10 23:52:17', '2025-06-10 23:52:17'),
(8, 'App\\Models\\User', 1, 'auth_token', '146556883376cc454dd58245a7e6f3ab9406e595c5914d989f0057ec2ac2bf0e', '[\"*\"]', NULL, NULL, '2025-06-10 23:52:45', '2025-06-10 23:52:45'),
(9, 'App\\Models\\User', 1, 'auth_token', '0eb14b1bf134cbcfb8eb17e85d4189892ca742f7f446f4e26343a744d662f8b1', '[\"*\"]', NULL, NULL, '2025-06-10 23:55:58', '2025-06-10 23:55:58'),
(10, 'App\\Models\\User', 1, 'auth_token', '48e26fdabbd1c4ce931b0c8f6ba55d4d3c942954d2c2ce5fb3df946fbc1d46da', '[\"*\"]', NULL, NULL, '2025-06-10 23:56:27', '2025-06-10 23:56:27'),
(11, 'App\\Models\\User', 1, 'auth_token', '70f2b82906fa54b786c9e2b4fa38b269413f0e5508d2bdfe7ccdb249f2152bb6', '[\"*\"]', NULL, NULL, '2025-06-10 23:57:16', '2025-06-10 23:57:16'),
(12, 'App\\Models\\User', 1, 'auth_token', '57e0f149116d4d01f68c60ea2c725567f0ead6c2963cba3f37375a516a08cfe1', '[\"*\"]', '2025-06-11 00:12:58', NULL, '2025-06-11 00:11:22', '2025-06-11 00:12:58'),
(13, 'App\\Models\\User', 1, 'auth_token', '6bf97b16bf56c4d00ac76d84e3171ed9dc02c77ff61e38b1f5a7882a0daa1a58', '[\"*\"]', NULL, NULL, '2025-06-11 01:11:37', '2025-06-11 01:11:37'),
(14, 'App\\Models\\User', 1, 'auth_token', '4ea4730ff2a453bf3243de57c7ebe27fc25a23a60acfb8a7b05a00865430a061', '[\"*\"]', '2025-06-11 03:51:23', NULL, '2025-06-11 03:49:47', '2025-06-11 03:51:23'),
(15, 'App\\Models\\User', 2, 'auth_token', '1e7d80cd9d25f2f5e318737f06f115dff9d8b95fa47c7770b06941f48e94a7ac', '[\"*\"]', NULL, NULL, '2025-06-11 04:07:30', '2025-06-11 04:07:30'),
(16, 'App\\Models\\User', 1, 'auth_token', '1731581c69bf3b891c26ff1787fa02550f4fb047479be9b1b51f39b4ba63d680', '[\"*\"]', '2025-06-11 04:23:37', NULL, '2025-06-11 04:23:30', '2025-06-11 04:23:37'),
(17, 'App\\Models\\User', 1, 'auth_token', '5d693bcdafc665ec1e0f8c4614e589bf2a839b19fccd4e1dffdc5ef2c7d290e2', '[\"*\"]', '2025-06-11 04:27:55', NULL, '2025-06-11 04:24:40', '2025-06-11 04:27:55'),
(18, 'App\\Models\\User', 1, 'auth_token', '24876cf897c77d262c7df3a0627cfbb06a3cd19e8bec25e8e6ba7f2af2242ab2', '[\"*\"]', '2025-06-11 04:28:32', NULL, '2025-06-11 04:28:30', '2025-06-11 04:28:32'),
(19, 'App\\Models\\User', 1, 'auth_token', '218d6c5f727b8313d6998fa78123d1e491551dd07ec2dd190f4c85a16eece71e', '[\"*\"]', '2025-06-11 04:40:25', NULL, '2025-06-11 04:40:22', '2025-06-11 04:40:25'),
(20, 'App\\Models\\User', 1, 'auth_token', '5d63fdda13ef546eb1f763f3f685f286cad92d775e7ad4cc3131d9372ebedd8d', '[\"*\"]', '2025-06-11 04:42:10', NULL, '2025-06-11 04:41:52', '2025-06-11 04:42:10'),
(21, 'App\\Models\\User', 1, 'auth_token', '20984e29b675365708dddc6026f8ce72c0148f0f5204f82eef452e075115bd8f', '[\"*\"]', '2025-06-11 04:45:00', NULL, '2025-06-11 04:44:34', '2025-06-11 04:45:00'),
(22, 'App\\Models\\User', 1, 'auth_token', 'c9694a38668f55920e5bba97019ac80247620becc91fb90d25c46b8ecccd3259', '[\"*\"]', '2025-06-11 19:28:54', NULL, '2025-06-11 19:28:48', '2025-06-11 19:28:54'),
(23, 'App\\Models\\User', 1, 'auth_token', '08c06cc2d74c6acffe2b6c160a5962771e4b7485dc6fcfd6b5d80d4ebb65b46b', '[\"*\"]', '2025-06-11 19:31:07', NULL, '2025-06-11 19:30:06', '2025-06-11 19:31:07'),
(24, 'App\\Models\\User', 1, 'auth_token', '5ee4ea03dbf0b2806ea25d1e7a9cdf00aa26704863c604a956a233447a7c710a', '[\"*\"]', '2025-06-11 19:33:23', NULL, '2025-06-11 19:33:20', '2025-06-11 19:33:23'),
(25, 'App\\Models\\User', 1, 'auth_token', '6975182dfc4bfbc97062c4fff92a8daa966797fe9213e2042eab5872bcfa5877', '[\"*\"]', '2025-06-11 19:34:14', NULL, '2025-06-11 19:34:11', '2025-06-11 19:34:14'),
(26, 'App\\Models\\User', 1, 'auth_token', 'e64403732b65cd97e0d828949ce0794f8722207e96def63b678c9995aec63ed4', '[\"*\"]', '2025-06-11 19:35:12', NULL, '2025-06-11 19:34:47', '2025-06-11 19:35:12'),
(27, 'App\\Models\\User', 1, 'auth_token', '2831ee832de8c1e471487e2acfded287f5c7f19fe1bb3df4d79c0f0aab4dacc8', '[\"*\"]', '2025-06-11 19:37:08', NULL, '2025-06-11 19:36:40', '2025-06-11 19:37:08'),
(28, 'App\\Models\\User', 2, 'auth_token', 'a13e4d475a3feed4bf96d385bf550efa9fa6b55691a33f8e0cf58d86cb135a47', '[\"*\"]', NULL, NULL, '2025-06-11 20:06:40', '2025-06-11 20:06:40'),
(29, 'App\\Models\\User', 2, 'auth_token', '26db2d5c65226914e9e537b94ba79758a2a82f9e6e518f8d171571b2028b9b2c', '[\"*\"]', NULL, NULL, '2025-06-11 20:07:04', '2025-06-11 20:07:04'),
(30, 'App\\Models\\User', 2, 'auth_token', 'c1f1c7733139d771790a93b1ac2ea1b2909f137f46cf3be95f4d2ca7a2d0203a', '[\"*\"]', '2025-06-11 20:53:56', NULL, '2025-06-11 20:13:44', '2025-06-11 20:53:56'),
(31, 'App\\Models\\User', 1, 'auth_token', '59e17750b8801b4e32c3f6dd96bd165a4a3f9eb970b10adbfd12a11b8d2701d8', '[\"*\"]', '2025-06-11 20:54:48', NULL, '2025-06-11 20:54:38', '2025-06-11 20:54:48'),
(32, 'App\\Models\\User', 2, 'auth_token', 'e28f0c48685e2eb7f79f0268d149d19d3da04ed494a766aa5cf2e26b07ba5905', '[\"*\"]', '2025-06-11 22:09:28', NULL, '2025-06-11 20:54:58', '2025-06-11 22:09:28'),
(33, 'App\\Models\\User', 2, 'auth_token', '8399ec2bab294bef40e54fc39b6fb2dbcdbe7fe9eaecac4dda4b35cd63695be4', '[\"*\"]', '2025-06-11 22:10:30', NULL, '2025-06-11 22:10:06', '2025-06-11 22:10:30'),
(34, 'App\\Models\\User', 2, 'auth_token', '0bcbf05db2749818c93ac97a6259f9d167d8bf15652400e8eb10ac4f7601bdeb', '[\"*\"]', '2025-06-11 23:42:55', NULL, '2025-06-11 22:10:39', '2025-06-11 23:42:55'),
(35, 'App\\Models\\User', 1, 'auth_token', 'a588a2ba1443b22f03284e6a89a3e2c5d6673f8f62c5894099981de66dce223a', '[\"*\"]', '2025-06-11 22:48:16', NULL, '2025-06-11 22:36:40', '2025-06-11 22:48:16'),
(36, 'App\\Models\\User', 1, 'auth_token', '55b07efe1ee2ebc7b958ea8a7fdad7bd30902f4ed0304724009abc42f1c62888', '[\"*\"]', NULL, NULL, '2025-06-11 23:36:59', '2025-06-11 23:36:59'),
(37, 'App\\Models\\User', 1, 'auth_token', '72a90517076d2f644651c3c94d135775e98a7893a6f19b7e9b97af4d681dd16d', '[\"*\"]', NULL, NULL, '2025-06-11 23:37:21', '2025-06-11 23:37:21'),
(38, 'App\\Models\\User', 1, 'auth_token', '7af892348c7a1f95389f4e9d2a54a544b22cbd086e070d370b86acebccdccbe5', '[\"*\"]', '2025-06-11 23:52:45', NULL, '2025-06-11 23:37:48', '2025-06-11 23:52:45'),
(39, 'App\\Models\\User', 2, 'auth_token', '358cc9b7201e648262949a1b571589ce8f7a3d768504b282412849dfdadbb438', '[\"*\"]', '2025-06-12 07:11:59', NULL, '2025-06-11 23:44:44', '2025-06-12 07:11:59'),
(40, 'App\\Models\\User', 3, 'auth_token', '8a9a695b63aa81f3dd1c8eb6272226d9e9eb45efc9acbcc153e2a6a9e5888aab', '[\"*\"]', '2025-06-12 00:19:32', NULL, '2025-06-12 00:19:04', '2025-06-12 00:19:32'),
(41, 'App\\Models\\User', 1, 'auth_token', '90559ced0e49ca53fe8690aa6b11956b3e8f61761ba04cf447a7a5b231973643', '[\"*\"]', '2025-06-12 00:20:19', NULL, '2025-06-12 00:20:09', '2025-06-12 00:20:19'),
(42, 'App\\Models\\User', 1, 'auth_token', '7bbe91cb7da34c3adbf7bed74ece70e75bb6badbd3632f95cb3618c12ebb7b35', '[\"*\"]', '2025-06-12 00:24:56', NULL, '2025-06-12 00:21:10', '2025-06-12 00:24:56'),
(43, 'App\\Models\\User', 1, 'auth_token', '20b615e9197901501fac17676c348d4f59579266251f6bdf8ec50e807682be12', '[\"*\"]', '2025-06-12 00:26:46', NULL, '2025-06-12 00:26:40', '2025-06-12 00:26:46'),
(44, 'App\\Models\\User', 1, 'auth_token', '956af718122036a61811abc149488202a9dc475a2aeaa71357f762f3ff2ac011', '[\"*\"]', '2025-06-12 00:34:04', NULL, '2025-06-12 00:33:28', '2025-06-12 00:34:04'),
(45, 'App\\Models\\User', 1, 'auth_token', 'f89790b4e3dc2e5575510dfd9facb0ce9a7cc76033446f2b2638ed47f3295926', '[\"*\"]', '2025-06-12 00:37:00', NULL, '2025-06-12 00:36:56', '2025-06-12 00:37:00'),
(46, 'App\\Models\\User', 1, 'auth_token', '5941f2a877fd66b6154e119e2162f0304080524bc72acd323c05ae88f1276621', '[\"*\"]', '2025-06-12 00:42:00', NULL, '2025-06-12 00:41:27', '2025-06-12 00:42:00'),
(47, 'App\\Models\\User', 1, 'auth_token', 'ff6caaab6b2830cb6ea883caf740ea1f821657e8f87e5730a28c0f78bbafa882', '[\"*\"]', '2025-06-12 00:46:30', NULL, '2025-06-12 00:46:26', '2025-06-12 00:46:30'),
(48, 'App\\Models\\User', 1, 'auth_token', 'c5540bb923ca02a2c9925e349430eb797f04aa067bce39b44a4177573b97161f', '[\"*\"]', '2025-06-12 00:52:08', NULL, '2025-06-12 00:51:55', '2025-06-12 00:52:08'),
(49, 'App\\Models\\User', 1, 'auth_token', '5f63d79a3356521faa24edf960364257cd481f5fa2521b2a3a66625dc5fcd256', '[\"*\"]', '2025-06-12 01:02:21', NULL, '2025-06-12 00:54:15', '2025-06-12 01:02:21'),
(50, 'App\\Models\\User', 1, 'auth_token', '559aa73869384d589d454dbdafde4b132e358061c2a3a88b9e694734754e5b4b', '[\"*\"]', '2025-06-12 01:02:55', NULL, '2025-06-12 01:02:48', '2025-06-12 01:02:55'),
(51, 'App\\Models\\User', 1, 'auth_token', 'e1b4c410eaeedb27616b4d9162761bbbd10bb73fa6681690a612dee3968c3144', '[\"*\"]', '2025-06-12 01:03:51', NULL, '2025-06-12 01:03:43', '2025-06-12 01:03:51'),
(52, 'App\\Models\\User', 1, 'auth_token', 'c2e3b866270365ad6182f9ab962a0f6c9428d9d1002a9bb4f344ba0f96be844f', '[\"*\"]', '2025-06-12 01:09:44', NULL, '2025-06-12 01:06:52', '2025-06-12 01:09:44'),
(53, 'App\\Models\\User', 1, 'auth_token', '9021d697482e01c1cebf0a0cb6e51bf139bdb41e4414aa42841ab8683770610f', '[\"*\"]', '2025-06-12 01:10:07', NULL, '2025-06-12 01:09:58', '2025-06-12 01:10:07'),
(54, 'App\\Models\\User', 1, 'auth_token', '93f8ef8ae174d2fd3359201b27beea4318550c4d13502c6c2992c37de482c945', '[\"*\"]', '2025-06-12 01:21:42', NULL, '2025-06-12 01:20:57', '2025-06-12 01:21:42'),
(55, 'App\\Models\\User', 1, 'auth_token', 'fd9c7461d815104697a2415000b7ec28c169678de4783dcf77721b39022b267c', '[\"*\"]', '2025-06-12 01:26:50', NULL, '2025-06-12 01:23:15', '2025-06-12 01:26:50'),
(56, 'App\\Models\\User', 1, 'auth_token', '1d1ce6bd9d9d9c6ad80e1f968e8295d2412949f094f74797331116d1c48b7997', '[\"*\"]', '2025-06-12 02:24:01', NULL, '2025-06-12 01:27:06', '2025-06-12 02:24:01'),
(57, 'App\\Models\\User', 1, 'auth_token', '293a1838e86a8934761d4e10077d5ba2e9c967ba223e817921cf5d0a4a50d4bb', '[\"*\"]', '2025-06-12 02:39:10', NULL, '2025-06-12 02:28:46', '2025-06-12 02:39:10'),
(58, 'App\\Models\\User', 1, 'auth_token', '0f641a7fd55aab6f01e3b11c2893f16f9ce597d60b783a8adf4ddf08e846d8da', '[\"*\"]', '2025-06-12 02:39:26', NULL, '2025-06-12 02:32:49', '2025-06-12 02:39:26'),
(59, 'App\\Models\\User', 5, 'auth_token', 'ad716d4a1284b2668c671f9398e1be6d9a2d724b1d04c9eb838b86fc34aa0612', '[\"*\"]', '2025-06-12 02:43:42', NULL, '2025-06-12 02:43:30', '2025-06-12 02:43:42'),
(60, 'App\\Models\\User', 1, 'auth_token', 'fcdd3dfe1c4d2d350fdfd6f785eadf979351945a646b033e4930b3075e94cbc2', '[\"*\"]', '2025-06-12 07:11:23', NULL, '2025-06-12 07:10:05', '2025-06-12 07:11:23'),
(61, 'App\\Models\\User', 2, 'auth_token', '01e4ce6ac3035a142a475b9b1078f36879391f543a5612efefd9cb2c11f744ad', '[\"*\"]', '2025-06-12 07:16:39', NULL, '2025-06-12 07:16:01', '2025-06-12 07:16:39'),
(62, 'App\\Models\\User', 1, 'auth_token', '871259dcaac6d74431a6ea0e3077ba68e46d0d83359d8f402c83136ba60a34fa', '[\"*\"]', '2025-06-12 07:17:07', NULL, '2025-06-12 07:16:36', '2025-06-12 07:17:07'),
(63, 'App\\Models\\User', 2, 'auth_token', 'f84ae5e8315c172c4bcfe2deede6520237352efd241be534024b73748019c9c1', '[\"*\"]', '2025-06-13 03:20:16', NULL, '2025-06-12 18:39:41', '2025-06-13 03:20:16'),
(64, 'App\\Models\\User', 5, 'auth_token', '7b1b9fc80291f57e13c313ac6681bf6cffe6b5ce89f5e2d0d880dd6ae8d303e5', '[\"*\"]', '2025-06-12 18:52:40', NULL, '2025-06-12 18:52:31', '2025-06-12 18:52:40'),
(65, 'App\\Models\\User', 1, 'auth_token', 'c7a0e81eaee7468117e2cfe826c42ac6b1b2f4e3f97436d1f8728ca36e54c701', '[\"*\"]', '2025-06-13 02:03:46', NULL, '2025-06-12 18:59:46', '2025-06-13 02:03:46'),
(66, 'App\\Models\\User', 2, 'auth_token', '3bc115c5c2145de61ce81f573143a8add529f2783f7ca0ee0769a6b7f62685c6', '[\"*\"]', '2025-06-13 04:41:50', NULL, '2025-06-13 03:20:39', '2025-06-13 04:41:50'),
(67, 'App\\Models\\User', 1, 'auth_token', 'bb9382d7b728f582edcca7c6331550ab5a3b22c4f70c14c3ac5ad48224a5ee48', '[\"*\"]', NULL, NULL, '2025-06-13 03:57:59', '2025-06-13 03:57:59'),
(68, 'App\\Models\\User', 1, 'auth_token', '008221b742a4566e5b28e6e5912efd08734093d69002ed6bcf4ba45ed6728e97', '[\"*\"]', NULL, NULL, '2025-06-13 04:02:19', '2025-06-13 04:02:19'),
(69, 'App\\Models\\User', 1, 'auth_token', '5a94c81975f1025fc94c07c6ae0f257e8c6b3e2287223c97fc691201ae2c510f', '[\"*\"]', NULL, NULL, '2025-06-13 04:02:58', '2025-06-13 04:02:58'),
(70, 'App\\Models\\User', 1, 'auth_token', 'f34a8a9bde6735399ca73184fab7874b2ed21b2eaba85361bf29b6635efe811f', '[\"*\"]', '2025-06-13 04:03:27', NULL, '2025-06-13 04:03:24', '2025-06-13 04:03:27'),
(71, 'App\\Models\\User', 1, 'auth_token', 'af05fa5cbc3600a68082c89fa2c61a63d832abeebd562ab4fd94187ba253e218', '[\"*\"]', '2025-06-13 04:04:49', NULL, '2025-06-13 04:04:47', '2025-06-13 04:04:49'),
(72, 'App\\Models\\User', 1, 'auth_token', 'ce5aad2922bceaa2645e56dffa22f864652b08cc6af91f896a978a14412c1e4f', '[\"*\"]', '2025-06-13 04:06:44', NULL, '2025-06-13 04:06:20', '2025-06-13 04:06:44'),
(73, 'App\\Models\\User', 1, 'auth_token', '91f215aa06ecbd6bb4dbccfe1e5f58f6e22177746d3608c16d32faa99b0f0c38', '[\"*\"]', '2025-06-13 04:13:21', NULL, '2025-06-13 04:12:48', '2025-06-13 04:13:21'),
(74, 'App\\Models\\User', 1, 'auth_token', '7144b352467ded87a56884fce2f9bc8e4792420e81eecd47ce4ccaf594f337b8', '[\"*\"]', '2025-06-13 04:14:34', NULL, '2025-06-13 04:14:24', '2025-06-13 04:14:34'),
(75, 'App\\Models\\User', 1, 'auth_token', 'ddd9f6e87c4c3ffd3ecb8d0d59846fadc5098cda4dc04c05e161a3ec60984da2', '[\"*\"]', '2025-06-13 04:22:47', NULL, '2025-06-13 04:21:41', '2025-06-13 04:22:47'),
(76, 'App\\Models\\User', 2, 'auth_token', '82dc9f2ba2c86aa0699680fa6a87b52571be2e5d4bd950f2f499e2d0acb027df', '[\"*\"]', '2025-06-13 06:21:00', NULL, '2025-06-13 04:45:10', '2025-06-13 06:21:00'),
(77, 'App\\Models\\User', 1, 'auth_token', '21484cf78a27973995463363da3f1a1d6ca06341018f6344bb70377c50ecfcb2', '[\"*\"]', '2025-06-13 05:45:32', NULL, '2025-06-13 05:45:02', '2025-06-13 05:45:32');

-- --------------------------------------------------------

--
-- Struktur dari tabel `recipients`
--

CREATE TABLE `recipients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nik` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `qr_code_identifier` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `recipients`
--

INSERT INTO `recipients` (`id`, `nik`, `name`, `address`, `qr_code_identifier`, `created_at`, `updated_at`) VALUES
(18, '1771020406040005', 'Dzaki', 'tess dongg', '1771020406040005', '2025-06-12 18:51:39', '2025-06-12 18:51:39'),
(19, '1771020406040008', 'naufal', 'yayayaya', '1771020406040008', '2025-06-12 18:58:40', '2025-06-12 18:58:40'),
(20, '1771020406040004', 'depal', 'jalan sukajadi', '1771020406040004', '2025-06-13 02:03:33', '2025-06-13 02:03:33');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('petugas','admin','pemda') NOT NULL DEFAULT 'petugas',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'upang', 'petugas1@pos.id', NULL, '$2y$12$bDCZv.qHzegfixM8kI3iGuOwXFY8mQeTP7z8JafvUCxbKtujfzPIi', 'petugas', NULL, '2025-06-11 04:54:56', '2025-06-12 01:19:25'),
(2, 'dzaki', 'admin@sistem.id', NULL, '$2y$12$w4pyQvTDIKQDiQZyxa.Z6.tgCOut5WjQqpkMfsp3AjoVlWHYg9IQq', 'admin', NULL, '2025-06-11 05:50:09', '2025-06-11 05:50:09'),
(5, 'Dzaki', 'superadmin@gmail.com', NULL, '$2y$12$BJHfAxct20RFRGTzQGQYaeZ8TFsKLuyrNlhxBNvY7ihsY/QonS7YG', 'petugas', NULL, '2025-06-12 02:42:52', '2025-06-12 18:51:54'),
(7, 'salim', 'admin2@sistem.id', NULL, '$2y$12$HQ4MJi9vfe7O9nIJg4HCM.KOJfeG4OTfqIGfpSg0Fk0OcvmFHRghW', 'admin', NULL, '2025-06-13 06:20:59', '2025-06-13 06:20:59');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `aid_histories`
--
ALTER TABLE `aid_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aid_histories_recipient_id_foreign` (`recipient_id`),
  ADD KEY `aid_histories_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indeks untuk tabel `recipients`
--
ALTER TABLE `recipients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `recipients_nik_unique` (`nik`),
  ADD UNIQUE KEY `recipients_qr_code_identifier_unique` (`qr_code_identifier`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `aid_histories`
--
ALTER TABLE `aid_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT untuk tabel `recipients`
--
ALTER TABLE `recipients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `aid_histories`
--
ALTER TABLE `aid_histories`
  ADD CONSTRAINT `aid_histories_recipient_id_foreign` FOREIGN KEY (`recipient_id`) REFERENCES `recipients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `aid_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
