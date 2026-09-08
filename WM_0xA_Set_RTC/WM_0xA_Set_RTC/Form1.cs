using WinFormsApp1;

namespace WM_0xA_Set_RTC
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Btn_Read_Click(object sender, EventArgs e)
        {
            /*[17:01:06.706] Send: 2A 45 57 4D 30 32 06 00 01 7E 59 37 9B 52 33 96 9D 25 A5 AD 2C E3 35 CB 3E 23 42 B7
            [17:01:06.829] Recv: 2A 45 57 4D 30 32 08 00 06 F3 0F 00 8C 58 80 2B 2A 9B F6 0A B9 80 FC D1 92 23 65 88

            [17:01:06.830] Payload: 1A 09 08 11 01 05 00 00 00 00 00 00 00 00 00 00

            [17:01:16.049] Send: 2A 45 57 4D 30 32 05 00 07 E6 2E EB ED FB BD 42 1D B1 B4 08 1F B6 B6 E2 7E 23 66 4E
            [17:01:16.234] Recv: 2A 45 57 4D 30 32 07 00 01 7E 59 37 9B 52 33 96 9D 25 A5 AD 2C E3 35 CB 3E 23 7F 66

            [17:01:16.235] Payload: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00*/

            byte[] read_RTC = { 0x2A, 0x45, 0x57, 0x4D, 0x30, 0x32, 0x06, 0x00, 0x01, 0x7E, 0x59, 0x37, 0x9B, 0x52, 0x33, 0x96,
                                0x9D, 0x25, 0xA5, 0xAD, 0x2C, 0xE3, 0x35, 0xCB, 0x3E, 0x23, 0x42, 0xB7 }; //payload 01

            byte[] set_RTC = { 0x2A, 0x45, 0x57, 0x4D, 0x30, 0x32, 0x05, 0x00, 0x07, 0xE6, 0x2E, 0xEB, 0xED, 0xFB, 0xBD, 0x42,
                               0x1D, 0xB1, 0xB4, 0x08, 0x1F, 0xB6, 0xB6, 0xE2, 0x7E, 0x23, 0x66, 0x4E }; // payload 01 1A 09 08 11 01 10
            byte[] decryptedPayload = EwmFrameBuilder.ParseDecryptedPayload(set_RTC);
            string hexResult = BitConverter.ToString(decryptedPayload).Replace("-", " ");

            // Thêm dòng mới vào RichTextBox
            RTBox_Log.AppendText($"Decrypted Payload: {hexResult}\n");

            // Tự động cuộn xuống dòng mới nhất
            RTBox_Log.ScrollToCaret();

        }
    }
}
