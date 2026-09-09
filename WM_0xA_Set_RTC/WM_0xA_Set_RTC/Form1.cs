using System.Reflection.Metadata;
using WinFormsApp1;
using static System.Net.Mime.MediaTypeNames;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.TaskbarClock;
using System.IO.Ports;
using System.Text;

namespace WM_0xA_Set_RTC
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        const int COM_MAX_LEN = 500;
        public enum FlagRecCOM
        {
            START_F = 0,
            TIMEOUT_F,
            TRUE_F,
            BREAK_F,
        }
        public class COM_t
        {
            public byte[] buf = new byte[COM_MAX_LEN];
            public byte len;
            public FlagRecCOM flagTimeout;
            public UInt16 timeout;
            public bool flagGetData;
            public void Clear()
            {
                if (buf != null)
                {
                    Array.Clear(buf, 0, buf.Length); // Reset toàn bộ mảng byte về 0x00
                }
                len = 0;
                timeout = 0;
                flagGetData = false;
                flagTimeout = default; // Đưa về giá trị mặc định của enum FlagRecCOM (hoặc 0/false)
            }
        }
        COM_t COM_RecWM = new COM_t();
        COM_t COM_RecCtrol = new COM_t();
        bool COM_WMIsOpen = false;
        bool COM_ControlIsOpen = false;

        bool Flag_RecComWM = false;

        private SerialPort COM_WM = new SerialPort();
        private SerialPort COM_Control = new SerialPort();

        // 3. Hàm khởi tạo và kết nối cổng COM
        void SearchCOM()
        {
            string[] ComList = SerialPort.GetPortNames();
            int[] ComNumberList = new int[ComList.Length];
            // Clear existing items
            Cbo_ComWM.Items.Clear();
            Cbo_ComWM.Text = ""; // Reset the text to avoid confusion"
            Tbox_ComControl.Items.Clear();
            Tbox_ComControl.Text = ""; // Reset the text to avoid confusion"
            if (ComList.Length == 0)
            {
                MessageBox.Show("Không tìm thấy cổng COM. Kiểm tra lại cổng COM.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                for (int i = 0; i < ComList.Length; i++)
                {
                    ComNumberList[i] = int.Parse(ComList[i].Substring(3));
                }
                Array.Sort(ComNumberList);
                foreach (int ComNumber in ComNumberList)
                {
                    Cbo_ComWM.Items.Add("COM" + ComNumber.ToString());
                    Cbo_ComWM.Text = "COM" + ComNumber.ToString();
                    Tbox_ComControl.Items.Add("COM" + ComNumber.ToString());
                    Tbox_ComControl.Text = "COM" + ComNumber.ToString();
                }
            }
        }

        bool Open_Com(SerialPort com, bool typeCOM, ComboBox cbox)
        {
            bool flagChooseCOM;
            if (cbox.Text == "")
            {
                MessageBox.Show("Không tìm thấy cổng COM. Kiểm tra lại cổng COM.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }
            else
            {
                flagChooseCOM = true;
            }
            if (true == com.IsOpen)
            {
                if (true == typeCOM)
                {
                    com.Close();
                    typeCOM = false;
                    return false;
                }
                else
                {
                    MessageBox.Show(com.PortName + "đã được mở từ phần mềm khác. Kiểm tra lại cổng COM.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
            }
            else
            {
                if (true == flagChooseCOM)
                {
                    com.PortName = cbox.Text;
                }
                try
                {
                    typeCOM = true;
                    com.PortName = cbox.Text;
                    com.BaudRate = 9600;                     // Tốc độ Baud: 9600
                    com.DataBits = 8;                        // 8 bit dữ liệu
                    com.Parity = Parity.None;                // None Parity
                    com.StopBits = StopBits.One;             // 1 Stop bit
                    com.Handshake = Handshake.None;          // Không dùng luồng điều khiển cứng/mềm
                    com.DataReceived += COM_Port_DataReceived;                // Kích hoạt sự kiện nhận dữ liệu
                    com.Open();
                    return true;
                }
                catch (Exception)
                {
                    typeCOM = false;
                    MessageBox.Show("Cannot open " + com.PortName, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
            }
        }


        void COM_Close(SerialPort com, bool typeCOM)
        {
            if (true == com.IsOpen)
            {
                com.Close();
                typeCOM = false;
            }
        }
        private void Btn_SearchCOM_Click(object sender, EventArgs e)
        {
            SearchCOM();
            // Optional: Log the action
            PrintLog(NULL, 0, "Search COM clicked", "SEND");
        }

        byte[] NULL = new byte[0];
        public struct RTC_DateTime
        {
            public byte Year;   // Năm (VD: 26 đại diện cho 2026, hoặc 2026 % 100)
            public byte Month;  // Tháng (1 - 12)
            public byte Day;    // Ngày (1 - 31)
            public byte Hour;   // Giờ (0 - 23)
            public byte Minute; // Phút (0 - 59)
            public byte Second; // Giây (0 - 59)

            // Constructor khởi tạo nhanh
            public RTC_DateTime(byte year, byte month, byte day, byte hour, byte minute, byte second)
            {
                Year = year;
                Month = month;
                Day = day;
                Hour = hour;
                Minute = minute;
                Second = second;
            }

            // Hàm chuyển đổi struct thành mảng 6 byte để làm Payload truyền UART
            public byte[] ToByteArray()
            {
                return new byte[] { Year, Month, Day, Hour, Minute, Second };
            }

            // Hàm đọc từ mảng 6 byte giải mã ra Struct
            public static RTC_DateTime FromByteArray(byte[] data, int startIndex = 0)
            {
                return new RTC_DateTime(
                    data[startIndex],     // Year
                    data[startIndex + 1], // Month
                    data[startIndex + 2], // Day
                    data[startIndex + 3], // Hour
                    data[startIndex + 4], // Minute
                    data[startIndex + 5]  // Second
                );
            }
            public static RTC_DateTime ParseRTCFromTextBox(string input)
            {
                // Kiểm tra chuỗi nhập vào phải đúng 12 ký tự số
                if (string.IsNullOrWhiteSpace(input) || input.Length != 12 || !long.TryParse(input, out _))
                {
                    throw new ArgumentException("Chuỗi thời gian phải đúng 12 ký tự số (YYMMDDHHMMSS)!");
                }

                // Tách từng phần 2 ký tự và chuyển sang byte
                byte year = byte.Parse(input.Substring(0, 2));  // "26" -> 26
                byte month = byte.Parse(input.Substring(2, 2));  // "01" -> 1
                byte day = byte.Parse(input.Substring(4, 2));  // "01" -> 1
                byte hour = byte.Parse(input.Substring(6, 2));  // "12" -> 12
                byte minute = byte.Parse(input.Substring(8, 2));  // "13" -> 13
                byte second = byte.Parse(input.Substring(10, 2)); // "14" -> 14

                return new RTC_DateTime(year, month, day, hour, minute, second);
            }
        }
        RTC_DateTime RTC_Read = new RTC_DateTime();
        RTC_DateTime RTC_Write = new RTC_DateTime();
        private void PrintLog(byte[] message, UInt16 len_message, string str, string mode)
        {
            string timestamp = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss.fff");
            if ("SEND" == mode)
            {
                RTBox_Log.SelectionColor = Color.Blue;
            }
            else if ("RECV" == mode)
            {
                RTBox_Log.SelectionColor = Color.Red;
            }
            string hexData = string.Empty;
            if (message != null && len_message > 0)
            {
                // Chặn lỗi tràn mảng nếu len_message lớn hơn độ dài thực tế của mảng message
                int printLength = Math.Min((int)len_message, message.Length);

                // BitConverter.ToString(mảng, vị_trí_bắt_đầu, số_lượng_byte)
                hexData = BitConverter.ToString(message, 0, printLength).Replace("-", " ");
            }

            // 3. Đưa con trỏ xuống cuối và Append text
            RTBox_Log.SelectionStart = RTBox_Log.TextLength;
            RTBox_Log.SelectionLength = 0;

            RTBox_Log.AppendText($"[{timestamp}] {mode}: {str} [{len_message} bytes]: {hexData}{Environment.NewLine}");
            RTBox_Log.ScrollToCaret();
        }

        private string Get_Header()
        {
            if ("WM-01A" == Cbo_TypeMeter.Text)
            {
                return "*EWM01";
            }
            if ("WM-02A" == Cbo_TypeMeter.Text)
            {
                return "*EWM02";
            }
            return "";
        }

        void COM_SendBuf(SerialPort com, byte[] buf, UInt16 len)
        {
            PrintLog(buf, (UInt16)buf.Length, buf.Length.ToString(), "SEND");
            com.Write(buf, 0, len);
        }

        void COM_MakeFrameWmReadRTC(ref COM_t ComSend)
        {
            List<byte> paramIds3 = new List<byte>
            {
                1
            };
            byte[] payload3 = EwmFrameBuilder.BuildOptReadPayload(paramIds3);
            EwmFrameBuilder builder3 = new EwmFrameBuilder
            {
                TypePack = 6,
                Payload = payload3
            };

            builder3.HEADER = Get_Header();
            byte[] frameReadRTC = builder3.BuildFrame(builder3.HEADER);
            ComSend.buf = frameReadRTC;
            ComSend.len = (byte)frameReadRTC.Length;

        }

        void COM_MakeFrameWmWriteRTC(ref COM_t ComSend, RTC_DateTime rtc)
        {
            List<ParameterData> parameters3 = new List<ParameterData>();
            byte[] timeData = new byte[]
            {
                        (byte)(rtc.Year % 100),
                        (byte)rtc.Month,
                        (byte)rtc.Day,
                        (byte)rtc.Hour,
                        (byte)rtc.Minute,
                        (byte)rtc.Second
            };
            parameters3.Add(new ParameterData
            {
                ParamId = 1,
                Data = timeData
            });
            byte[] payload3 = EwmFrameBuilder.BuildOptSetPayload(parameters3);
            EwmFrameBuilder builder3 = new EwmFrameBuilder
            {
                TypePack = 5,
                Payload = payload3
            };
            builder3.HEADER = Get_Header();
            byte[] frame3 = builder3.BuildFrame(builder3.HEADER);
            byte[] frameSeRTC = builder3.BuildFrame(builder3.HEADER);
            ComSend.buf = frameSeRTC;
            ComSend.len = (byte)frameSeRTC.Length;
        }

        private async Task<bool> WaitForResponseAsync(int timeoutMs = 5000)
        {
            int elapsed = 0;
            while (elapsed < timeoutMs)
            {
                // Chỉ xử lý khi ngắt đã nhận xong và đã qua khoảng chờ ổn định frame (timeout >= 3)
                if (COM_RecWM.flagGetData && COM_RecWM.timeout >= 3)
                {
                    return true; // Đã nhận đủ dữ liệu
                }

                COM_RecWM.timeout++;
                await Task.Delay(100);
                elapsed += 100;
            }

            return false; // Hết 5000ms Timeout
        }
        private async void Btn_Set_RTC_Click(object sender, EventArgs e)
        {
            Btn_SetRTC.Enabled = false;
            if (COM_WM == null || !COM_WM.IsOpen)
            {
                Open_Com(COM_WM, COM_WMIsOpen, Cbo_ComWM);
            }
            try
            {
                for (int j = 0; j < 3; j++)
                {
                    // 1. Kiểm tra mở cổng COM

                    COM_t ComSend = new COM_t();

                    // =========================================================================
                    // BƯỚC 1: ĐỌC RTC (Chờ hoàn thành 100% mới chuyển bước)
                    // =========================================================================
                    COM_RecWM.Clear(); // Xóa sạch bộ đệm trước khi gửi
                    PrintLog(null, 0, "1. Đọc RTC", "SEND");

                    COM_MakeFrameWmReadRTC(ref ComSend);
                    COM_SendBuf(COM_WM, ComSend.buf, ComSend.len);

                    // Chờ nhận dữ liệu hoàn toàn (AWAIT ép chương trình dừng lại chờ tại đây)
                    bool isReadSuccess = await WaitForResponseAsync(5000);

                    if (!isReadSuccess)
                    {
                        PrintLog(NULL, 0, "Không nhận được phản hồi sau khi Đọc RTC.", "RECV");
                        return; // DỪNG TIẾN TRÌNH: Không chạy xuống lệnh Ghi nếu Đọc thất bại
                    }

                    // Xử lý dữ liệu Đọc về
                    PrintLog(COM_RecWM.buf, COM_RecWM.len, "Dữ liệu đệm RTC", "RECV");
                    byte[] decryptedRead = EwmFrameBuilder.ParseDecryptedPayload(COM_RecWM.buf, Get_Header());

                    if (decryptedRead == null || decryptedRead.Length < 6)
                    {
                        PrintLog(NULL, 0, "Dữ liệu RTC đọc về bị lỗi hoặc sai cấu trúc!", "RECV");
                        return; // DỪNG TIẾN TRÌNH
                    }

                    PrintLog(decryptedRead, (UInt16)decryptedRead.Length, "DECRYPTED READ", "RECV");
                    RTC_Read = RTC_DateTime.FromByteArray(decryptedRead, 0);

                    // =========================================================================
                    // BƯỚC 2: GHI RTC MỚI (Chỉ chạy sau khi BƯỚC 1 đã hoàn tất)
                    // =========================================================================
                    RTC_Write = RTC_Read;
                    RTC_Write.Minute = 59;
                    RTC_Write.Second = 55;

                    // BẮT BUỘC: Reset hoàn toàn bộ đệm COM_RecWM và nghỉ 200ms để xả tuyến UART
                    COM_RecWM.Clear();
                    await Task.Delay(200);
                    ComSend.Clear();
                    PrintLog(NULL, 0, "2. Ghi RTC", "SEND");
                    COM_MakeFrameWmWriteRTC(ref ComSend, RTC_Write);
                    COM_SendBuf(COM_WM, ComSend.buf, ComSend.len);

                    // Chờ nhận dữ liệu phản hồi bước Ghi
                    bool isWriteSuccess = await WaitForResponseAsync(5000);

                    if (isWriteSuccess)
                    {
                        PrintLog(COM_RecWM.buf, COM_RecWM.len, "Phản hồi Ghi RTC", "RECV");
                        byte[] decryptedWrite = EwmFrameBuilder.ParseDecryptedPayload(COM_RecWM.buf, Get_Header());

                        if (decryptedWrite != null && decryptedWrite.Length >= 6)
                        {
                            PrintLog(decryptedWrite, (UInt16)decryptedWrite.Length, "DECRYPTED WRITE OK", "RECV");
                            PrintLog(NULL, 0, "Cài đặt RTC thành công!", "RECV");
                        }
                    }
                    else
                    {
                        PrintLog(NULL, 0, "Không nhận được phản hồi sau khi Ghi RTC.", "RECV");
                    }
                    Thread.Sleep(10000);
                }
            }
            catch (Exception ex)
            {
                PrintLog(NULL, 0, "Lỗi xử lý", "SEND");
            }
            finally
            {
                // Đóng COM và bật lại nút bấm
                COM_Close(COM_WM, COM_WMIsOpen);
                Btn_SetRTC.Enabled = true;
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Cbo_TypeMeter.Text = "WM-02A";
        }

        void Com_GetData(SerialPort com, COM_t COM_Rec)
        {
            byte countByte = (byte)com.BytesToRead;
            byte[] Rec = new byte[countByte];
            com.Read(Rec, 0, countByte);
            if (COM_MAX_LEN >= (COM_Rec.len + countByte))
            {
                for (int i = 0; i < countByte; i++)
                {
                    COM_Rec.buf[COM_Rec.len + i] = Rec[i];
                }
                COM_Rec.len += countByte;
            }
            else
            {
                Array.Clear(COM_Rec.buf, 0, COM_Rec.len);
                COM_Rec.len = 0;
            }
            COM_Rec.timeout = 0;
            COM_Rec.flagGetData = true;
        }

        private void COM_Port_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {

            Com_GetData(COM_WM, COM_RecWM);

        }
    }
}
