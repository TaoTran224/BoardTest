using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace WinFormsApp1
{
    // ================================================================
    //  clsEncrypt — mã hoá bản quyền AES-256-CBC
    //  ⚠ KHÔNG dùng cho giao thức frame EWM02.
    //    Chỉ dùng nội bộ bởi HardwareLicenseChecker để mã/giải mã
    //    chuỗi bản quyền (file lic.txt, pcinfo.txt).
    // ================================================================
    public class clsEncrypt
    {
        private static string initVector  = "123emicgmail9876";  // IV 16 bytes UTF-8
        private static int    keysize     = 256;
        private static string passPhrase  = "DaiDongHoanSonTienDu";

        // ── Mã hoá: plainText → Base64 cipherText ──────────────────
        public static string EncryptString(string plainText)
        {
            byte[] initVectorBytes = Encoding.UTF8.GetBytes(initVector);
            byte[] plainTextBytes  = Encoding.UTF8.GetBytes(plainText);

#pragma warning disable SYSLIB0041
            PasswordDeriveBytes password = new PasswordDeriveBytes(passPhrase, null);
            byte[] keyBytes = password.GetBytes(keysize / 8);
#pragma warning restore SYSLIB0041

            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;

            ICryptoTransform encryptor    = symmetricKey.CreateEncryptor(keyBytes, initVectorBytes);
            MemoryStream     memoryStream = new MemoryStream();
            CryptoStream     cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write);

            cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
            cryptoStream.FlushFinalBlock();

            byte[] cipherTextBytes = memoryStream.ToArray();
            memoryStream.Close();
            cryptoStream.Close();

            return Convert.ToBase64String(cipherTextBytes);
        }

        // ── Giải mã: Base64 cipherText → plainText ─────────────────
        public static string DecryptString(string cipherText)
        {
            byte[] initVectorBytes = Encoding.UTF8.GetBytes(initVector);
            byte[] cipherTextBytes = Convert.FromBase64String(cipherText);

#pragma warning disable SYSLIB0041
            PasswordDeriveBytes password = new PasswordDeriveBytes(passPhrase, null);
            byte[] keyBytes = password.GetBytes(keysize / 8);
#pragma warning restore SYSLIB0041

            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;

            ICryptoTransform decryptor    = symmetricKey.CreateDecryptor(keyBytes, initVectorBytes);
            MemoryStream     memoryStream = new MemoryStream(cipherTextBytes);
            CryptoStream     cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read);

            byte[] plainTextBytes       = new byte[cipherTextBytes.Length];
            int    decryptedByteCount   = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);

            memoryStream.Close();
            cryptoStream.Close();

            return Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount);
        }
    }
}
