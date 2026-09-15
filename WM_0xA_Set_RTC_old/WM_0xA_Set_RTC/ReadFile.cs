using System;
using System.Data;
using System.Collections.Generic;
using System.Data;
using System.IO;
using ExcelDataReader;
namespace WinFormsApp1
{
    public class ExcelTestCase
    {
        public int STT { get; set; }
        public string HangMuc { get; set; }
        public string TypePack { get; set; }
        public string ParamID { get; set; }

        // Đọc ban đầu
        public int ReadSendLen { get; set; }
        public string ReadSendParam { get; set; }
        public int ReadRecLen { get; set; }
        public string ReadRecParam { get; set; }
        public string ReadRecType { get; set; }

        // Ghi
        public int WriteSendLen { get; set; }
        public string WriteSendParam { get; set; }
        public string WriteSendType { get; set; }
        public int WriteRecLen { get; set; }
        public string WriteRecParam { get; set; } // ACK / NACK hoặc 1 / 2

        // Chờ & Đọc kiểm tra
        public int DelaySec { get; set; }
        public int VerifyRecLen { get; set; }
        public string VerifyRecParam { get; set; }
        public string VerifyRecType { get; set; }
    }

    public static class ExcelHelper
    {
        public static List<ExcelTestCase> LoadTestCasesFromExcel(string filePath)
        {
            var testCases = new List<ExcelTestCase>();

            // Đăng ký provider cho ExcelDataReader (bắt buộc đối với .NET Core/Form chuẩn)
            System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);

            using (var stream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                using (var reader = ExcelReaderFactory.CreateReader(stream))
                {
                    var result = reader.AsDataSet();
                    DataTable table = result.Tables[0]; // Lấy Sheet1

                    // Dữ liệu bắt đầu từ Dòng 4 (Index 3 trong DataTable)
                    for (int i = 3; i < table.Rows.Count; i++)
                    {
                        DataRow row = table.Rows[i];

                        // Bỏ qua dòng trống nếu không có STT hoặc Hạng mục
                        if (string.IsNullOrWhiteSpace(row[0]?.ToString()) && string.IsNullOrWhiteSpace(row[1]?.ToString()))
                            continue;

                        ExcelTestCase tc = new ExcelTestCase
                        {
                            STT = GetInt(row[0]),
                            HangMuc = GetString(row[1]),
                            TypePack = GetString(row[2]),
                            ParamID = GetString(row[3]),

                            // Đọc ban đầu
                            ReadSendLen = GetInt(row[4]),
                            ReadSendParam = GetString(row[5]),
                            ReadRecLen = GetInt(row[6]),
                            ReadRecParam = GetString(row[7]),
                            ReadRecType = GetString(row[8]),

                            // Ghi
                            WriteSendLen = GetInt(row[9]),
                            WriteSendParam = GetString(row[10]),
                            WriteSendType = GetString(row[11]),
                            WriteRecLen = GetInt(row[12]),
                            WriteRecParam = GetString(row[13]),

                            // Chờ
                            DelaySec = GetInt(row[14]),

                            // Đọc kiểm tra
                            VerifyRecLen = GetInt(row[15]),
                            VerifyRecParam = GetString(row[16]),
                            VerifyRecType = GetString(row[17])
                        };

                        testCases.Add(tc);
                    }
                }
            }

            return testCases;
        }

        // Hàm ép kiểu chuỗi an toàn tránh Null Exception
        private static string GetString(object cellValue)
        {
            return cellValue == null || cellValue == DBNull.Value ? "" : cellValue.ToString().Trim();
        }

        // Hàm ép kiểu số an toàn
        private static int GetInt(object cellValue)
        {
            if (cellValue == null || cellValue == DBNull.Value) return 0;
            return int.TryParse(cellValue.ToString().Trim(), out int val) ? val : 0;
        }
    }
}
