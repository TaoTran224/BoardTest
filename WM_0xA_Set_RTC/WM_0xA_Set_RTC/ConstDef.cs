using System;

namespace WinFormsApp1
{
    public static class typeCmd
    {
        public const byte NbPushInfo = 1;  // Nb Push info
        public const byte NbPushData = 2;  // Nb Push Data
        public const byte NbPushEvent = 3;  // Nb Push Event
        public const byte AckNackToHes = 4;  // Ack/Nack to hes
        public const byte OptHesSet = 5;  // Opt/Hes Set
        public const byte OptHesRead = 6;  // Opt/Hes Read
        public const byte AckNackOpHesSet = 7;  // Ack/Nack Op/Hes Set
        public const byte ResponseOptHesRead = 8;  // Response Opt/Hes Read
        public const byte HesRequestSetting = 9;  // Hes request setting
        public const byte QueryData = 10; // Query Data
        public const byte QueryEvent = 11; // Query Event
        public const byte QueryPushStatus = 12; // Query Push Status
    }

    public static class ParamID
    {
        public const byte Time = 1;               // Time
        public const byte ImpData = 2;            // Imp Data
        public const byte ExpData = 3;            // Exp Data
        public const byte Version = 4;            // Version
        public const byte MeterSerial = 5;        // Meter Serial
        public const byte ModuleSerial = 6;       // Module Serial
        public const byte Qccid = 7;              // Qccid
        public const byte Imsi = 8;               // IMSI
        public const byte Apn = 9;                // APN
        public const byte NetworkCarrier = 10;    // Nhà mạng
        public const byte ServerIpPort = 11;      // Ip Port Sever
        public const byte ModuleIp = 12;          // Ip Module
        public const byte TypeWm = 13;            // Type WM
        public const byte Q3 = 14;                // Q3
        public const byte LiterPerPulse = 15;     // L/vong
        public const byte LatchPeriod = 16;       // Latch Period
        public const byte PushMethod = 17;        // Push Method
        public const byte PushPeriod = 18;        // Push Period
        public const byte PushTimestamp1 = 19;    // Push Timestamp1
        public const byte PushTimestamp2 = 20;    // Push Timestamp2
        public const byte BatteryRemaining = 21;  // Số tháng còn lại của Pin
        public const byte Temperature = 22;       // Temp
        public const byte Voltage = 23;           // Voltage
        public const byte NumReset = 24;          // Num Reset
        public const byte Rssi = 25;              // Rssi
        public const byte EventConfig = 26;       // Cấu hình sự kiện
        public const byte ClearData = 27;         // ClearData
        public const byte ActivateDevice = 28;    // Kich hoat thiết bị
        public const byte PushData = 29;          // Push Data
        public const byte ResetModule = 30;       // Reset Module
        public const byte LatchDataIndex = 31;    // LatData Index
        public const byte PushDataIndex = 32;     // PushData Index
        public const byte LatchEventIndex = 33;   // LatchEvent Index
        public const byte PushEventIndex = 34;    // PushEvent Index
        public const byte NbInfo = 35;            // Nb_Info
        public const byte VoltageThreshold = 36;  // Voltage ThresHold
        public const byte TestSensor1 = 37;       // Test sensor 1
    }
}