using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WinFormsApp1
{
    // ================================================================
    //  EwmFrameBuilder — xây dựng và giải mã frame giao thức EWM02
    //
    //  BuildFrame():            tạo frame hoàn chỉnh để gửi
    //  ParseDecryptedPayload(): giải mã payload từ frame response
    //  BuildOptSetPayload():    tạo payload cho lệnh ghi (OptSet)
    //  BuildOptReadPayload():   tạo payload cho lệnh đọc (OptRead)
    // ================================================================
    public class EwmFrameBuilder
    {
        public const string HEADER = "*EWM02";

        public byte   TypePack { get; set; }
        public byte[] Payload  { get; set; } = new byte[0];

        // ── Build frame hoàn chỉnh ──────────────────────────────────
        // Frame layout: HEADER(6) | TypePack(1) | LenSerial(1)=0 |
        //               LenPayload(1) | AES_Payload(m) | '#'(1) | CRC16(2)
        //
        // LenPayload = Payload.Length gốc (trước AES)
        // AES_Payload = aes_128_en(Payload)  [16 byte nếu Payload < 16]
        public byte[] BuildFrame()
        {
            List<byte> frame = new List<byte>();

            // 1. Header "*EWM02"
            frame.AddRange(Encoding.ASCII.GetBytes(HEADER));

            // 2. TypePack
            frame.Add(TypePack);

            // 3. LenSerial = 0 (cổng quang, không có trường Serial)
            frame.Add((byte)0);

            // 4. LenPayload = độ dài payload GỐC (trước mã hoá)
            byte lenPayload = (byte)Payload.Length;
            frame.Add(lenPayload);

            // 5. AES_Payload — mã hoá AES-128-ECB
            frame.AddRange(clsAES128.aes_128_en(Payload));

            // 6. END_MARK '#' (0x23)
            frame.Add((byte)'#');

            // 7. CRC16/Modbus (tính trên tất cả byte từ HEADER đến '#')
            byte[] crcInput = frame.ToArray();
            ushort crc = Crc16Modbus(crcInput);
            frame.AddRange(BitConverter.GetBytes(crc)); // Little-Endian

            return frame.ToArray();
        }

        // ── Giải mã payload từ frame response ──────────────────────
        // Trả về: decryptedPayload (đầy đủ block AES, có thể có zero-padding)
        // Caller tự cắt theo số byte cần (vd: Take(6) cho RTC)
        //
        // ⚠ encryptedLen = lenPayload < 16 ? 16 : lenPayload
        //   KHÔNG làm tròn lên bội số 16 — đây là công thức chuẩn.
        public static byte[] ParseDecryptedPayload(byte[] frame)
        {
            try
            {
                int index = 0;

                // 1. Kiểm tra header "*EWM02"
                string header = Encoding.ASCII.GetString(frame, 0, 6);
                if (header != HEADER)
                    throw new Exception("Invalid header");
                index += 6;

                // 2. Bỏ qua TypePack (1 byte)
                index += 1;

                // 3. Đọc LenSerial, bỏ qua trường Serial
                byte lenSerial = frame[index++];
                index += lenSerial;

                // 4. Đọc LenPayload = độ dài payload gốc (trước mã hoá)
                byte lenPayload = frame[index];

                // 5. Tính encryptedPayloadLen
                //    LenPayload < 16  →  16 (1 block AES tối thiểu)
                //    LenPayload >= 16 →  lenPayload (dùng trực tiếp)
                int encryptedPayloadLen = lenPayload < 16 ? 16 : lenPayload;

                // 6. Kiểm tra frame đủ dài
                if (index++ + encryptedPayloadLen > frame.Length)
                    throw new Exception("Frame quá ngắn hoặc sai định dạng");
                // Sau index++: index trỏ đến byte đầu của AES_Payload

                // 7. Lấy encryptedPayloadLen byte làm AES_Payload
                byte[] encryptedPayload = frame.Skip(index).Take(encryptedPayloadLen).ToArray();

                // 8. Giải mã AES-128-ECB
                byte[] decryptedPayload = clsAES128.aes_128_dec(encryptedPayload);

                return decryptedPayload;
            }
            catch (Exception ex)
            {
                throw new Exception("Lỗi khi phân tích frame: " + ex.Message);
            }
        }

        // ── CRC16/Modbus (Init=0xFFFF, Poly=0xA001) ────────────────
        private ushort Crc16Modbus(byte[] data)
        {
            ushort crc = 0xFFFF;
            foreach (byte b in data)
            {
                crc ^= b;
                for (int i = 0; i < 8; i++)
                {
                    if ((crc & 0x0001) != 0) { crc >>= 1; crc ^= 0xA001; }
                    else                       { crc >>= 1; }
                }
            }
            return crc;
        }

        // ── Build payload cho OptSet (ghi nhiều tham số) ───────────
        // payload = [ParamId1][Data1...][ParamId2][Data2...]...
        public static byte[] BuildOptSetPayload(List<ParameterData> parameters)
        {
            var payload = new List<byte>();
            foreach (var param in parameters)
            {
                payload.Add(param.ParamId);
                payload.AddRange(param.Data);
            }
            return payload.ToArray();
        }

        // ── Build payload cho OptRead (đọc nhiều tham số) ──────────
        // payload = [ParamId1, ParamId2, ...]
        public static byte[] BuildOptReadPayload(List<byte> paramIds)
        {
            return paramIds.ToArray();
        }
    }

    // ── Dữ liệu một tham số dùng trong OptSet ──────────────────────
    public class ParameterData
    {
        public byte   ParamId { get; set; }
        public byte[] Data    { get; set; }
    }
}
