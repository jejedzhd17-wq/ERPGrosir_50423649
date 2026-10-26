package erpgrosir;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Koneksi ke database MySQL (XAMPP).
 * Pemakaian: Connection conn = Koneksi.getKoneksi();
 * @author Jeremy Nathanael Sahertian - 50423649
 */
public class Koneksi {

    private static final String URL = "jdbc:mysql://localhost:3306/erp_grosir";
    private static final String USER = "root";
    private static final String PASSWORD = "";   // default XAMPP: root tanpa password

    private static Connection conn;

    public static Connection getKoneksi() throws SQLException {
        if (conn == null || conn.isClosed()) {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        }
        return conn;
    }

    // Tes koneksi: klik kanan file ini -> Run File
    public static void main(String[] args) {
        try {
            getKoneksi();
            System.out.println("Koneksi ke database erp_grosir BERHASIL");
        } catch (SQLException e) {
            System.out.println("Koneksi GAGAL: " + e.getMessage());
        }
    }
}
