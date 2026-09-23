using System;

using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WinFormsApp1
{
    public class Cal
    {
        public static UInt16 Crc16Cal(byte[] data, UInt16 offset, UInt16 len)
        {
            ushort crc = 0xFFFF;
            for (ushort i = offset; i < (offset + len); i++)
            {
                crc ^= data[i];
                for (byte j = 0; j < 8; j++)
                {
                    if ((crc & 0x0001) != 0)
                    {
                        crc >>= 1;
                        crc ^= 0xA001;
                    }
                    else
                    {
                        crc >>= 1;
                    }
                }
            }
            return crc;
        }
    }
}
