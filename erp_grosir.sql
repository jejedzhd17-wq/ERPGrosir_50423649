-- Database ERP-Grosir CV Sumber Makmur
-- Jeremy Nathanael Sahertian - 50423649
-- Import lewat phpMyAdmin (tab Import) atau: mysql -u root < erp_grosir.sql

CREATE DATABASE IF NOT EXISTS erp_grosir;
USE erp_grosir;

CREATE TABLE user (
    id_user   INT AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(30) NOT NULL UNIQUE,
    password  CHAR(64) NOT NULL,              -- hash SHA-256
    role      ENUM('Admin', 'Kasir', 'Gudang') NOT NULL
);

CREATE TABLE barang (
    kode_barang  VARCHAR(10) PRIMARY KEY,
    nama_barang  VARCHAR(100) NOT NULL,
    kategori     VARCHAR(50) NOT NULL,
    harga_beli   DECIMAL(12,2) NOT NULL CHECK (harga_beli >= 0),
    harga_jual   DECIMAL(12,2) NOT NULL CHECK (harga_jual >= 0),
    stok         INT NOT NULL DEFAULT 0 CHECK (stok >= 0),
    stok_minimum INT NOT NULL DEFAULT 0 CHECK (stok_minimum >= 0)
);

CREATE TABLE pelanggan (
    kode_pelanggan VARCHAR(10) PRIMARY KEY,
    nama_pelanggan VARCHAR(100) NOT NULL,
    alamat         VARCHAR(255),
    telepon        VARCHAR(20)
);

CREATE TABLE supplier (
    kode_supplier VARCHAR(10) PRIMARY KEY,
    nama_supplier VARCHAR(100) NOT NULL,
    alamat        VARCHAR(255),
    telepon       VARCHAR(20)
);

CREATE TABLE penjualan (
    no_faktur      VARCHAR(15) PRIMARY KEY,
    tanggal        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kode_pelanggan VARCHAR(10) NOT NULL,
    id_user        INT NOT NULL,
    total          DECIMAL(14,2) NOT NULL DEFAULT 0,
    INDEX (tanggal),
    FOREIGN KEY (kode_pelanggan) REFERENCES pelanggan(kode_pelanggan),
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE detail_penjualan (
    id_detail   INT AUTO_INCREMENT PRIMARY KEY,
    no_faktur   VARCHAR(15) NOT NULL,
    kode_barang VARCHAR(10) NOT NULL,
    harga       DECIMAL(12,2) NOT NULL,             -- harga jual saat transaksi
    harga_beli  DECIMAL(12,2) NOT NULL,             -- modal saat transaksi, untuk laporan laba rugi
    qty         INT NOT NULL CHECK (qty > 0),
    subtotal    DECIMAL(14,2) NOT NULL,
    FOREIGN KEY (no_faktur) REFERENCES penjualan(no_faktur) ON DELETE CASCADE,
    FOREIGN KEY (kode_barang) REFERENCES barang(kode_barang)
);

CREATE TABLE pembelian (
    no_po          VARCHAR(15) PRIMARY KEY,
    tanggal        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kode_supplier  VARCHAR(10) NOT NULL,
    id_user        INT NOT NULL,
    total          DECIMAL(14,2) NOT NULL DEFAULT 0,
    status         ENUM('Dipesan', 'Diterima') NOT NULL DEFAULT 'Dipesan',
    tanggal_terima DATETIME NULL,
    INDEX (tanggal),
    FOREIGN KEY (kode_supplier) REFERENCES supplier(kode_supplier),
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE detail_pembelian (
    id_detail   INT AUTO_INCREMENT PRIMARY KEY,
    no_po       VARCHAR(15) NOT NULL,
    kode_barang VARCHAR(10) NOT NULL,
    harga_beli  DECIMAL(12,2) NOT NULL,
    qty_pesan   INT NOT NULL CHECK (qty_pesan > 0),
    qty_terima  INT NOT NULL DEFAULT 0,
    subtotal    DECIMAL(14,2) NOT NULL,
    CHECK (qty_terima BETWEEN 0 AND qty_pesan),   -- diterima tidak boleh melebihi dipesan
    FOREIGN KEY (no_po) REFERENCES pembelian(no_po) ON DELETE CASCADE,
    FOREIGN KEY (kode_barang) REFERENCES barang(kode_barang)
);

CREATE TABLE kas (
    id_kas       INT AUTO_INCREMENT PRIMARY KEY,
    tanggal      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    jenis        ENUM('Masuk', 'Keluar') NOT NULL,
    keterangan   VARCHAR(255) NOT NULL,
    jumlah       DECIMAL(14,2) NOT NULL CHECK (jumlah >= 0),
    no_referensi VARCHAR(15),                  -- no_faktur / no_po asal transaksi
    INDEX (tanggal)
);
