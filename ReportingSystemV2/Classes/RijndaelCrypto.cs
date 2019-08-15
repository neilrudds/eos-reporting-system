using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.Configuration;
using System.Web.Configuration;

namespace ReportingSystemV2
{
    public class RijndaelCrypto
    {
  
        public byte[] myKey = { 0xF4, 0x98, 0xD8, 0x16, 0x22, 0x4F, 0x47, 0x3F, 0x91, 0x9F, 0x96, 0xB8, 0xDD, 0x57, 0x51, 0xBE }; // OLD KEY - NOT USED

        public byte[] GetKey()
        {
            try 
            {
                Configuration config = WebConfigurationManager.OpenWebConfiguration("/");
                return getBytesFromString(config.AppSettings.Settings["Key"].Value);
            }
            catch (Exception ex)
            {
                LogMe.LogSystemException(ex.Message);
                return null;
            }
        }

        public byte[] EncryptToBytes(byte[] encryptMe, byte[] Key)
        {
            // Check arguments.
            if (encryptMe == null || encryptMe.Length <= 0)
                throw new ArgumentNullException("plainText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");
            byte[] encrypted;
            // Create an Rijndael object
            // with the specified key and IV.
            using (Rijndael rijAlg = Rijndael.Create())
            {
                rijAlg.Key = Key;
                rijAlg.IV = Key;
                rijAlg.Mode = CipherMode.ECB;
                rijAlg.Padding = PaddingMode.Zeros;

                // Create a decrytor to perform the stream transform.
                ICryptoTransform encryptor = rijAlg.CreateEncryptor(rijAlg.Key, rijAlg.IV);

                // Create the streams used for encryption.
                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        csEncrypt.Write(encryptMe, 0, encryptMe.Length);                      

                        //using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        //{

                        //    //Write all data to the stream.
                        //    swEncrypt.Write(plainText);
                        //}
                       
                    }
                    encrypted = msEncrypt.ToArray();
                }
            }

            // Return the encrypted bytes from the memory stream.
            return encrypted;
        }

        public byte[] DecryptBytesFromBytes(byte[] cipherText, byte[] Key)
        {
            // Check arguments.
            if (cipherText == null || cipherText.Length <= 0)
                throw new ArgumentNullException("cipherText");
            if (Key == null || Key.Length <= 0)
                throw new ArgumentNullException("Key");

            // Declare the string used to hold
            // the decrypted text.
            //string plaintext = null;

            // Create an Rijndael object
            // with the specified key and IV.
            using (Rijndael rijAlg = Rijndael.Create())
            {
                rijAlg.Key = Key;
                rijAlg.IV = Key;
                rijAlg.Mode = CipherMode.ECB;
                rijAlg.Padding = PaddingMode.Zeros;

                // Create a decrytor to perform the stream transform.
                ICryptoTransform decryptor = rijAlg.CreateDecryptor(rijAlg.Key, rijAlg.IV);

                // Create the streams used for decryption.
                using (MemoryStream msDecrypt = new MemoryStream(cipherText))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Write))
                    {

                        csDecrypt.Write(cipherText, 0, cipherText.Length);
                        csDecrypt.FlushFinalBlock();
                        return msDecrypt.ToArray();

                        //using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                        //{

                        //    // Read the decrypted bytes from the decrypting stream
                        //    // and place them in a string.
                        //    plaintext = srDecrypt.ReadToEnd();


                        //}
                    }
                }

            }

            //decrypted = GetBytes(plaintext);
            //length = (int)decrypted[0];

            //char[] chars = new char[length];
            //System.Buffer.BlockCopy(decrypted, 1, chars, 0, length);

            //return new string(chars);

        }

        public string DecryptStringFromBytes(byte[] cipherText, byte[] Key)
        {
            // decrypted data array
            byte[] decryptedBytes = DecryptBytesFromBytes(cipherText, Key);

            // decrypredBytes[0] contains the true string length from the sender
            // Extract the string from decrypredBytes[1] to decrypredBytes[0]'s length
            int charCount = BitConverter.ToInt16(decryptedBytes, 0);

            return Encoding.UTF8.GetString(decryptedBytes, 2, charCount);
        }

        public byte[] EncryptStringToBytes(string plainText, byte[] Key, bool IncludeLength = false)
        {
            byte[] plainTextwithLength = new byte[plainText.Length + 2]; // Create the byte array to include length int

            byte[] intBytes = BitConverter.GetBytes(Convert.ToInt16(plainText.Length));  // Get the length of the string to Bytes 16bit Max.

            intBytes.CopyTo(plainTextwithLength, 0); // Copy the length in to the array

            byte[] plainTextBytes = getBytesFromString(plainText); // Get the plain text to a byte array

            plainTextBytes.CopyTo(plainTextwithLength, 2); // Add the string bytes

            if (IncludeLength)
            {
                return EncryptToBytes(plainTextwithLength, Key);
            }
            else
            {
                return EncryptToBytes(plainTextBytes, Key);
            }
        }

        public static byte[] getBytesFromString(String str)
        {
            return Encoding.ASCII.GetBytes(str);
        }

        static string GetString(byte[] bytes)
        {
            char[] chars = new char[bytes.Length / sizeof(char)];
            System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
            return new string(chars);
        }
    }
}