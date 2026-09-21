namespace WM_0xA_Set_RTC
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Btn_SetRTC = new Button();
            RTBox_Log = new RichTextBox();
            Cbo_TypeMeter = new ComboBox();
            Tbox_RtcManual = new TextBox();
            Btn_SearchCOM = new Button();
            label2 = new Label();
            Cbo_ComControl = new ComboBox();
            Cbo_ComWM = new ComboBox();
            folderBrowserDialog1 = new FolderBrowserDialog();
            Btn_RunAuto = new Button();
            Txt_RtcMinBefore = new TextBox();
            Min = new Label();
            Txt_RtcSecBefore = new TextBox();
            lable44 = new Label();
            label3 = new Label();
            Txt_RtcWaitSec = new TextBox();
            label111 = new Label();
            Txt_NumRecords = new TextBox();
            Btn_Magnet = new Button();
            Txt_MagnetTimeOff = new TextBox();
            Txt_MagnetTimeOn = new TextBox();
            label1 = new Label();
            label4 = new Label();
            Txt_MagnetTimes = new TextBox();
            label5 = new Label();
            panel1 = new Panel();
            groupBox1 = new GroupBox();
            Btn_WriteRtcManual = new Button();
            Mode = new GroupBox();
            rdo_RtcModeHex = new RadioButton();
            rdo_RtcModeStr = new RadioButton();
            Btn_ReadRtcManual = new Button();
            backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            Magnet = new GroupBox();
            comboBox1 = new ComboBox();
            button2 = new Button();
            Btn_MagnetOn = new Button();
            Btn_MagnetOff = new Button();
            backgroundWorker2 = new System.ComponentModel.BackgroundWorker();
            groupBox2 = new GroupBox();
            Btn_FanControl = new Button();
            textBox1 = new TextBox();
            tabControl1 = new TabControl();
            tabPage1 = new TabPage();
            tabPage2 = new TabPage();
            tabPage3 = new TabPage();
            groupBox3 = new GroupBox();
            Tbox_AutoResetSecond = new TextBox();
            label6 = new Label();
            Btn_AutoResetStart = new Button();
            panel1.SuspendLayout();
            groupBox1.SuspendLayout();
            Mode.SuspendLayout();
            Magnet.SuspendLayout();
            groupBox2.SuspendLayout();
            tabControl1.SuspendLayout();
            tabPage1.SuspendLayout();
            tabPage2.SuspendLayout();
            groupBox3.SuspendLayout();
            SuspendLayout();
            // 
            // Btn_SetRTC
            // 
            Btn_SetRTC.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_SetRTC.Location = new Point(0, 25);
            Btn_SetRTC.Name = "Btn_SetRTC";
            Btn_SetRTC.Size = new Size(110, 31);
            Btn_SetRTC.TabIndex = 0;
            Btn_SetRTC.Text = "       ";
            Btn_SetRTC.UseVisualStyleBackColor = true;
            Btn_SetRTC.Click += Btn_Set_RTC_Click;
            // 
            // RTBox_Log
            // 
            RTBox_Log.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            RTBox_Log.Location = new Point(1040, 21);
            RTBox_Log.Name = "RTBox_Log";
            RTBox_Log.Size = new Size(387, 613);
            RTBox_Log.TabIndex = 1;
            RTBox_Log.Text = "";
            RTBox_Log.TextChanged += RTBox_Log_TextChanged;
            // 
            // Cbo_TypeMeter
            // 
            Cbo_TypeMeter.DropDownStyle = ComboBoxStyle.DropDownList;
            Cbo_TypeMeter.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Cbo_TypeMeter.FormattingEnabled = true;
            Cbo_TypeMeter.Items.AddRange(new object[] { "WM-01A", "WM-02A" });
            Cbo_TypeMeter.Location = new Point(3, 71);
            Cbo_TypeMeter.Name = "Cbo_TypeMeter";
            Cbo_TypeMeter.Size = new Size(108, 26);
            Cbo_TypeMeter.TabIndex = 2;
            // 
            // Tbox_RtcManual
            // 
            Tbox_RtcManual.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Tbox_RtcManual.Location = new Point(6, 215);
            Tbox_RtcManual.Multiline = true;
            Tbox_RtcManual.Name = "Tbox_RtcManual";
            Tbox_RtcManual.Size = new Size(248, 50);
            Tbox_RtcManual.TabIndex = 3;
            Tbox_RtcManual.Text = "260908121314";
            // 
            // Btn_SearchCOM
            // 
            Btn_SearchCOM.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_SearchCOM.Location = new Point(3, 21);
            Btn_SearchCOM.Name = "Btn_SearchCOM";
            Btn_SearchCOM.Size = new Size(108, 35);
            Btn_SearchCOM.TabIndex = 4;
            Btn_SearchCOM.Text = "Search COM";
            Btn_SearchCOM.UseVisualStyleBackColor = true;
            Btn_SearchCOM.Click += Btn_SearchCOM_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(140, 87);
            label2.Name = "label2";
            label2.Size = new Size(99, 18);
            label2.TabIndex = 7;
            label2.Text = "COM Control";
            // 
            // Cbo_ComControl
            // 
            Cbo_ComControl.DropDownStyle = ComboBoxStyle.DropDownList;
            Cbo_ComControl.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Cbo_ComControl.FormattingEnabled = true;
            Cbo_ComControl.Location = new Point(140, 103);
            Cbo_ComControl.Name = "Cbo_ComControl";
            Cbo_ComControl.Size = new Size(99, 26);
            Cbo_ComControl.TabIndex = 8;
            // 
            // Cbo_ComWM
            // 
            Cbo_ComWM.DropDownStyle = ComboBoxStyle.DropDownList;
            Cbo_ComWM.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Cbo_ComWM.FormattingEnabled = true;
            Cbo_ComWM.Location = new Point(3, 103);
            Cbo_ComWM.Name = "Cbo_ComWM";
            Cbo_ComWM.Size = new Size(108, 26);
            Cbo_ComWM.TabIndex = 9;
            // 
            // Btn_RunAuto
            // 
            Btn_RunAuto.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_RunAuto.Location = new Point(6, 96);
            Btn_RunAuto.Name = "Btn_RunAuto";
            Btn_RunAuto.Size = new Size(121, 35);
            Btn_RunAuto.TabIndex = 10;
            Btn_RunAuto.Text = "Run Auto";
            Btn_RunAuto.UseVisualStyleBackColor = true;
            Btn_RunAuto.Click += Btn_RunAuto_Click;
            // 
            // Txt_RtcMinBefore
            // 
            Txt_RtcMinBefore.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_RtcMinBefore.Location = new Point(53, 62);
            Txt_RtcMinBefore.Name = "Txt_RtcMinBefore";
            Txt_RtcMinBefore.Size = new Size(57, 26);
            Txt_RtcMinBefore.TabIndex = 11;
            Txt_RtcMinBefore.Text = "59";
            // 
            // Min
            // 
            Min.AutoSize = true;
            Min.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Min.Location = new Point(6, 62);
            Min.Name = "Min";
            Min.Size = new Size(33, 18);
            Min.TabIndex = 12;
            Min.Text = "Min";
            // 
            // Txt_RtcSecBefore
            // 
            Txt_RtcSecBefore.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_RtcSecBefore.Location = new Point(182, 65);
            Txt_RtcSecBefore.Name = "Txt_RtcSecBefore";
            Txt_RtcSecBefore.Size = new Size(72, 26);
            Txt_RtcSecBefore.TabIndex = 13;
            Txt_RtcSecBefore.Text = "57";
            // 
            // lable44
            // 
            lable44.AutoSize = true;
            lable44.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            lable44.Location = new Point(116, 65);
            lable44.Name = "lable44";
            lable44.Size = new Size(36, 18);
            lable44.TabIndex = 14;
            lable44.Text = "Sec";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label3.Location = new Point(116, 31);
            label3.Name = "label3";
            label3.Size = new Size(68, 18);
            label3.TabIndex = 15;
            label3.Text = "Wait sec";
            // 
            // Txt_RtcWaitSec
            // 
            Txt_RtcWaitSec.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_RtcWaitSec.Location = new Point(196, 31);
            Txt_RtcWaitSec.Name = "Txt_RtcWaitSec";
            Txt_RtcWaitSec.Size = new Size(58, 26);
            Txt_RtcWaitSec.TabIndex = 16;
            Txt_RtcWaitSec.Text = "10";
            // 
            // label111
            // 
            label111.AutoSize = true;
            label111.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label111.Location = new Point(6, 100);
            label111.Name = "label111";
            label111.Size = new Size(97, 18);
            label111.TabIndex = 18;
            label111.Text = "Num records";
            // 
            // Txt_NumRecords
            // 
            Txt_NumRecords.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_NumRecords.Location = new Point(169, 97);
            Txt_NumRecords.Name = "Txt_NumRecords";
            Txt_NumRecords.Size = new Size(85, 26);
            Txt_NumRecords.TabIndex = 19;
            Txt_NumRecords.Text = "5";
            // 
            // Btn_Magnet
            // 
            Btn_Magnet.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_Magnet.Location = new Point(5, 25);
            Btn_Magnet.Name = "Btn_Magnet";
            Btn_Magnet.Size = new Size(92, 34);
            Btn_Magnet.TabIndex = 20;
            Btn_Magnet.Text = "Auto";
            Btn_Magnet.UseVisualStyleBackColor = true;
            Btn_Magnet.Click += Btn_Magnet_Click;
            // 
            // Txt_MagnetTimeOff
            // 
            Txt_MagnetTimeOff.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_MagnetTimeOff.Location = new Point(78, 95);
            Txt_MagnetTimeOff.Name = "Txt_MagnetTimeOff";
            Txt_MagnetTimeOff.Size = new Size(55, 26);
            Txt_MagnetTimeOff.TabIndex = 22;
            Txt_MagnetTimeOff.Text = "40";
            // 
            // Txt_MagnetTimeOn
            // 
            Txt_MagnetTimeOn.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_MagnetTimeOn.Location = new Point(6, 95);
            Txt_MagnetTimeOn.Name = "Txt_MagnetTimeOn";
            Txt_MagnetTimeOn.Size = new Size(55, 26);
            Txt_MagnetTimeOn.TabIndex = 23;
            Txt_MagnetTimeOn.Text = "35";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label1.Location = new Point(6, 65);
            label1.Name = "label1";
            label1.Size = new Size(31, 18);
            label1.TabIndex = 24;
            label1.Text = "ON";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label4.Location = new Point(88, 65);
            label4.Name = "label4";
            label4.Size = new Size(40, 18);
            label4.TabIndex = 25;
            label4.Text = "OFF";
            // 
            // Txt_MagnetTimes
            // 
            Txt_MagnetTimes.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_MagnetTimes.Location = new Point(154, 95);
            Txt_MagnetTimes.Name = "Txt_MagnetTimes";
            Txt_MagnetTimes.Size = new Size(55, 26);
            Txt_MagnetTimes.TabIndex = 26;
            Txt_MagnetTimes.Text = "17";
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label5.Location = new Point(154, 65);
            label5.Name = "label5";
            label5.Size = new Size(50, 18);
            label5.TabIndex = 27;
            label5.Text = "Times";
            // 
            // panel1
            // 
            panel1.BackColor = SystemColors.ActiveCaption;
            panel1.Controls.Add(Btn_SearchCOM);
            panel1.Controls.Add(Cbo_TypeMeter);
            panel1.Controls.Add(label2);
            panel1.Controls.Add(Cbo_ComControl);
            panel1.Controls.Add(Cbo_ComWM);
            panel1.Location = new Point(6, 6);
            panel1.Name = "panel1";
            panel1.Size = new Size(252, 147);
            panel1.TabIndex = 29;
            // 
            // groupBox1
            // 
            groupBox1.BackColor = SystemColors.ActiveCaption;
            groupBox1.Controls.Add(Btn_WriteRtcManual);
            groupBox1.Controls.Add(Mode);
            groupBox1.Controls.Add(Btn_ReadRtcManual);
            groupBox1.Controls.Add(Btn_SetRTC);
            groupBox1.Controls.Add(Txt_RtcMinBefore);
            groupBox1.Controls.Add(Min);
            groupBox1.Controls.Add(Txt_RtcSecBefore);
            groupBox1.Controls.Add(Tbox_RtcManual);
            groupBox1.Controls.Add(lable44);
            groupBox1.Controls.Add(label3);
            groupBox1.Controls.Add(Txt_RtcWaitSec);
            groupBox1.Controls.Add(label111);
            groupBox1.Controls.Add(Txt_NumRecords);
            groupBox1.Font = new Font("Arial Narrow", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            groupBox1.Location = new Point(264, 6);
            groupBox1.Name = "groupBox1";
            groupBox1.Size = new Size(260, 269);
            groupBox1.TabIndex = 30;
            groupBox1.TabStop = false;
            groupBox1.Text = "Auto setting RTC";
            // 
            // Btn_WriteRtcManual
            // 
            Btn_WriteRtcManual.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_WriteRtcManual.Location = new Point(89, 153);
            Btn_WriteRtcManual.Name = "Btn_WriteRtcManual";
            Btn_WriteRtcManual.Size = new Size(77, 54);
            Btn_WriteRtcManual.TabIndex = 35;
            Btn_WriteRtcManual.Text = "Write RTC";
            Btn_WriteRtcManual.UseVisualStyleBackColor = true;
            Btn_WriteRtcManual.Click += Btn_WriteRtcManual_Click;
            // 
            // Mode
            // 
            Mode.Controls.Add(rdo_RtcModeHex);
            Mode.Controls.Add(rdo_RtcModeStr);
            Mode.Font = new Font("Arial Narrow", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Mode.Location = new Point(182, 138);
            Mode.Name = "Mode";
            Mode.Size = new Size(61, 70);
            Mode.TabIndex = 34;
            Mode.TabStop = false;
            Mode.Text = "Type";
            // 
            // rdo_RtcModeHex
            // 
            rdo_RtcModeHex.AutoSize = true;
            rdo_RtcModeHex.Location = new Point(6, 47);
            rdo_RtcModeHex.Name = "rdo_RtcModeHex";
            rdo_RtcModeHex.Size = new Size(51, 24);
            rdo_RtcModeHex.TabIndex = 35;
            rdo_RtcModeHex.Text = "Hex";
            rdo_RtcModeHex.UseVisualStyleBackColor = true;
            // 
            // rdo_RtcModeStr
            // 
            rdo_RtcModeStr.AutoSize = true;
            rdo_RtcModeStr.Checked = true;
            rdo_RtcModeStr.Location = new Point(6, 22);
            rdo_RtcModeStr.Name = "rdo_RtcModeStr";
            rdo_RtcModeStr.Size = new Size(43, 24);
            rdo_RtcModeStr.TabIndex = 33;
            rdo_RtcModeStr.TabStop = true;
            rdo_RtcModeStr.Text = "Str";
            rdo_RtcModeStr.UseVisualStyleBackColor = true;
            // 
            // Btn_ReadRtcManual
            // 
            Btn_ReadRtcManual.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_ReadRtcManual.Location = new Point(6, 153);
            Btn_ReadRtcManual.Name = "Btn_ReadRtcManual";
            Btn_ReadRtcManual.Size = new Size(77, 54);
            Btn_ReadRtcManual.TabIndex = 33;
            Btn_ReadRtcManual.Text = "Read RTC";
            Btn_ReadRtcManual.UseVisualStyleBackColor = true;
            Btn_ReadRtcManual.Click += Btn_ReadRtcManual_Click;
            // 
            // Magnet
            // 
            Magnet.BackColor = SystemColors.ActiveCaption;
            Magnet.Controls.Add(comboBox1);
            Magnet.Controls.Add(button2);
            Magnet.Controls.Add(Btn_MagnetOn);
            Magnet.Controls.Add(Btn_MagnetOff);
            Magnet.Controls.Add(Btn_Magnet);
            Magnet.Controls.Add(Txt_MagnetTimeOn);
            Magnet.Controls.Add(Txt_MagnetTimeOff);
            Magnet.Controls.Add(label1);
            Magnet.Controls.Add(label5);
            Magnet.Controls.Add(label4);
            Magnet.Controls.Add(Txt_MagnetTimes);
            Magnet.Font = new Font("Arial Narrow", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Magnet.Location = new Point(527, 6);
            Magnet.Name = "Magnet";
            Magnet.Size = new Size(312, 189);
            Magnet.TabIndex = 31;
            Magnet.TabStop = false;
            Magnet.Text = "Magnet";
            // 
            // comboBox1
            // 
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox1.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            comboBox1.FormattingEnabled = true;
            comboBox1.Items.AddRange(new object[] { "STR", "HEX" });
            comboBox1.Location = new Point(78, 143);
            comboBox1.Name = "comboBox1";
            comboBox1.Size = new Size(62, 26);
            comboBox1.TabIndex = 33;
            // 
            // button2
            // 
            button2.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            button2.Location = new Point(6, 138);
            button2.Name = "button2";
            button2.Size = new Size(55, 34);
            button2.TabIndex = 33;
            button2.Text = "Auto";
            button2.UseVisualStyleBackColor = true;
            // 
            // Btn_MagnetOn
            // 
            Btn_MagnetOn.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_MagnetOn.Location = new Point(119, 27);
            Btn_MagnetOn.Name = "Btn_MagnetOn";
            Btn_MagnetOn.Size = new Size(72, 29);
            Btn_MagnetOn.TabIndex = 32;
            Btn_MagnetOn.Text = "ON";
            Btn_MagnetOn.UseVisualStyleBackColor = true;
            Btn_MagnetOn.Click += Btn_MagnetOn_Click;
            // 
            // Btn_MagnetOff
            // 
            Btn_MagnetOff.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_MagnetOff.Location = new Point(228, 28);
            Btn_MagnetOff.Name = "Btn_MagnetOff";
            Btn_MagnetOff.Size = new Size(72, 29);
            Btn_MagnetOff.TabIndex = 29;
            Btn_MagnetOff.Text = "OFF";
            Btn_MagnetOff.UseVisualStyleBackColor = true;
            Btn_MagnetOff.Click += Btn_MagnetOff_Click;
            // 
            // groupBox2
            // 
            groupBox2.BackColor = SystemColors.ActiveCaption;
            groupBox2.Controls.Add(Btn_FanControl);
            groupBox2.Controls.Add(textBox1);
            groupBox2.Font = new Font("Arial Narrow", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            groupBox2.Location = new Point(527, 205);
            groupBox2.Name = "groupBox2";
            groupBox2.Size = new Size(312, 70);
            groupBox2.TabIndex = 32;
            groupBox2.TabStop = false;
            groupBox2.Text = "Fan(0-100)(>100:random)";
            // 
            // Btn_FanControl
            // 
            Btn_FanControl.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_FanControl.Location = new Point(5, 25);
            Btn_FanControl.Name = "Btn_FanControl";
            Btn_FanControl.Size = new Size(92, 34);
            Btn_FanControl.TabIndex = 20;
            Btn_FanControl.Text = "Speed";
            Btn_FanControl.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            textBox1.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox1.Location = new Point(119, 30);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(55, 26);
            textBox1.TabIndex = 23;
            textBox1.Text = "35";
            // 
            // tabControl1
            // 
            tabControl1.Controls.Add(tabPage1);
            tabControl1.Controls.Add(tabPage2);
            tabControl1.Controls.Add(tabPage3);
            tabControl1.Font = new Font("Arial Narrow", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            tabControl1.Location = new Point(12, 12);
            tabControl1.Name = "tabControl1";
            tabControl1.SelectedIndex = 0;
            tabControl1.Size = new Size(1007, 552);
            tabControl1.TabIndex = 33;
            // 
            // tabPage1
            // 
            tabPage1.Controls.Add(groupBox3);
            tabPage1.Controls.Add(panel1);
            tabPage1.Controls.Add(groupBox2);
            tabPage1.Controls.Add(groupBox1);
            tabPage1.Controls.Add(Magnet);
            tabPage1.Location = new Point(4, 29);
            tabPage1.Name = "tabPage1";
            tabPage1.Padding = new Padding(3);
            tabPage1.Size = new Size(999, 519);
            tabPage1.TabIndex = 0;
            tabPage1.Text = "Read/Write";
            tabPage1.UseVisualStyleBackColor = true;
            // 
            // tabPage2
            // 
            tabPage2.Controls.Add(Btn_RunAuto);
            tabPage2.Location = new Point(4, 29);
            tabPage2.Name = "tabPage2";
            tabPage2.Padding = new Padding(3);
            tabPage2.Size = new Size(999, 367);
            tabPage2.TabIndex = 1;
            tabPage2.Text = "tabPage2";
            tabPage2.UseVisualStyleBackColor = true;
            // 
            // tabPage3
            // 
            tabPage3.Location = new Point(4, 29);
            tabPage3.Name = "tabPage3";
            tabPage3.Padding = new Padding(3);
            tabPage3.Size = new Size(999, 367);
            tabPage3.TabIndex = 2;
            tabPage3.Text = "tabPage3";
            tabPage3.UseVisualStyleBackColor = true;
            // 
            // groupBox3
            // 
            groupBox3.BackColor = SystemColors.ActiveCaption;
            groupBox3.Controls.Add(Btn_AutoResetStart);
            groupBox3.Controls.Add(label6);
            groupBox3.Controls.Add(Tbox_AutoResetSecond);
            groupBox3.Font = new Font("Arial Narrow", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            groupBox3.Location = new Point(6, 159);
            groupBox3.Name = "groupBox3";
            groupBox3.Size = new Size(252, 112);
            groupBox3.TabIndex = 33;
            groupBox3.TabStop = false;
            groupBox3.Text = "Auto write reset";
            // 
            // Tbox_AutoResetSecond
            // 
            Tbox_AutoResetSecond.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Tbox_AutoResetSecond.Location = new Point(98, 32);
            Tbox_AutoResetSecond.Name = "Tbox_AutoResetSecond";
            Tbox_AutoResetSecond.Size = new Size(88, 26);
            Tbox_AutoResetSecond.TabIndex = 24;
            Tbox_AutoResetSecond.Text = "35";
            // 
            // label6
            // 
            label6.AutoSize = true;
            label6.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label6.Location = new Point(21, 35);
            label6.Name = "label6";
            label6.Size = new Size(70, 18);
            label6.TabIndex = 25;
            label6.Text = "Seconds";
            // 
            // Btn_AutoResetStart
            // 
            Btn_AutoResetStart.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_AutoResetStart.Location = new Point(21, 71);
            Btn_AutoResetStart.Name = "Btn_AutoResetStart";
            Btn_AutoResetStart.Size = new Size(110, 31);
            Btn_AutoResetStart.TabIndex = 26;
            Btn_AutoResetStart.Text = "Auto Reset";
            Btn_AutoResetStart.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1448, 688);
            Controls.Add(tabControl1);
            Controls.Add(RTBox_Log);
            Name = "Form1";
            Text = "Water meter Auto Tool";
            Load += Form1_Load;
            panel1.ResumeLayout(false);
            panel1.PerformLayout();
            groupBox1.ResumeLayout(false);
            groupBox1.PerformLayout();
            Mode.ResumeLayout(false);
            Mode.PerformLayout();
            Magnet.ResumeLayout(false);
            Magnet.PerformLayout();
            groupBox2.ResumeLayout(false);
            groupBox2.PerformLayout();
            tabControl1.ResumeLayout(false);
            tabPage1.ResumeLayout(false);
            tabPage2.ResumeLayout(false);
            groupBox3.ResumeLayout(false);
            groupBox3.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Button Btn_SetRTC;
        private RichTextBox RTBox_Log;
        private ComboBox Cbo_TypeMeter;
        private TextBox Tbox_RtcManual;
        private Button Btn_SearchCOM;
        private ComboBox Tbox_COM_WM;
        private Label label2;
        private ComboBox Cbo_ComControl;
        private ComboBox Cbo_ComWM;
        private FolderBrowserDialog folderBrowserDialog1;
        private Button Btn_RunAuto;
        private TextBox Txt_RtcMinBefore;
        private Label Min;
        private TextBox Txt_RtcSecBefore;
        private Label lable44;
        private Label label3;
        private TextBox Txt_RtcWaitSec;
        private TextBox textBox1;
        private Label label111;
        private TextBox Txt_NumRecords;
        private Button Btn_Magnet;
        private TextBox Txt_MagnetTimeOff;
        private TextBox Txt_MagnetTimeOn;
        private Label label1;
        private Label label4;
        private TextBox Txt_MagnetTimes;
        private Label label5;
        private Button Btn_AutoResetStart;
        private Panel panel1;
        private GroupBox groupBox1;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private GroupBox Magnet;
        private Button Btn_MagnetOff;
        private System.ComponentModel.BackgroundWorker backgroundWorker2;
        private Button Btn_MagnetOn;
        private GroupBox groupBox2;
        private Button Btn_FanControl;
        private ComboBox comboBox1;
        private Button button2;
        private Button Btn_ReadRtcManual;
        private RadioButton rdo_RtcModeStr;
        private GroupBox Mode;
        private RadioButton rdo_RtcModeHex;
        private RadioButton radioButton1;
        private Button Btn_WriteRtcManual;
        private TabControl tabControl1;
        private TabPage tabPage2;
        private TabPage tabPage3;
        private TabPage tabPage1;
        private GroupBox groupBox3;
        private Label label6;
        private TextBox Tbox_AutoResetSecond;
    }
}
