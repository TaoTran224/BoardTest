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
            Tbox_TimeStart = new TextBox();
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
            SuspendLayout();
            // 
            // Btn_SetRTC
            // 
            Btn_SetRTC.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_SetRTC.Location = new Point(15, 14);
            Btn_SetRTC.Name = "Btn_SetRTC";
            Btn_SetRTC.Size = new Size(97, 31);
            Btn_SetRTC.TabIndex = 0;
            Btn_SetRTC.Text = "Set RTC auto";
            Btn_SetRTC.UseVisualStyleBackColor = true;
            Btn_SetRTC.Click += Btn_Set_RTC_Click;
            // 
            // RTBox_Log
            // 
            RTBox_Log.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            RTBox_Log.Location = new Point(386, 14);
            RTBox_Log.Name = "RTBox_Log";
            RTBox_Log.Size = new Size(684, 561);
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
            Cbo_TypeMeter.Location = new Point(12, 272);
            Cbo_TypeMeter.Name = "Cbo_TypeMeter";
            Cbo_TypeMeter.Size = new Size(121, 26);
            Cbo_TypeMeter.TabIndex = 2;
            // 
            // Tbox_TimeStart
            // 
            Tbox_TimeStart.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Tbox_TimeStart.Location = new Point(181, 19);
            Tbox_TimeStart.Name = "Tbox_TimeStart";
            Tbox_TimeStart.Size = new Size(121, 26);
            Tbox_TimeStart.TabIndex = 3;
            Tbox_TimeStart.Text = "260908121314";
            // 
            // Btn_SearchCOM
            // 
            Btn_SearchCOM.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_SearchCOM.Location = new Point(12, 222);
            Btn_SearchCOM.Name = "Btn_SearchCOM";
            Btn_SearchCOM.Size = new Size(121, 35);
            Btn_SearchCOM.TabIndex = 4;
            Btn_SearchCOM.Text = "Search COM";
            Btn_SearchCOM.UseVisualStyleBackColor = true;
            Btn_SearchCOM.Click += Btn_SearchCOM_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(181, 272);
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
            Cbo_ComControl.Location = new Point(171, 319);
            Cbo_ComControl.Name = "Cbo_ComControl";
            Cbo_ComControl.Size = new Size(121, 26);
            Cbo_ComControl.TabIndex = 8;
            // 
            // Cbo_ComWM
            // 
            Cbo_ComWM.DropDownStyle = ComboBoxStyle.DropDownList;
            Cbo_ComWM.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Cbo_ComWM.FormattingEnabled = true;
            Cbo_ComWM.Location = new Point(12, 319);
            Cbo_ComWM.Name = "Cbo_ComWM";
            Cbo_ComWM.Size = new Size(121, 26);
            Cbo_ComWM.TabIndex = 9;
            // 
            // Btn_RunAuto
            // 
            Btn_RunAuto.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_RunAuto.Location = new Point(12, 394);
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
            Txt_RtcMinBefore.Location = new Point(54, 61);
            Txt_RtcMinBefore.Name = "Txt_RtcMinBefore";
            Txt_RtcMinBefore.Size = new Size(55, 26);
            Txt_RtcMinBefore.TabIndex = 11;
            Txt_RtcMinBefore.Text = "58";
            // 
            // Min
            // 
            Min.AutoSize = true;
            Min.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Min.Location = new Point(12, 64);
            Min.Name = "Min";
            Min.Size = new Size(33, 18);
            Min.TabIndex = 12;
            Min.Text = "Min";
            // 
            // Txt_RtcSecBefore
            // 
            Txt_RtcSecBefore.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_RtcSecBefore.Location = new Point(159, 61);
            Txt_RtcSecBefore.Name = "Txt_RtcSecBefore";
            Txt_RtcSecBefore.Size = new Size(55, 26);
            Txt_RtcSecBefore.TabIndex = 13;
            Txt_RtcSecBefore.Text = "45";
            // 
            // lable44
            // 
            lable44.AutoSize = true;
            lable44.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            lable44.Location = new Point(117, 64);
            lable44.Name = "lable44";
            lable44.Size = new Size(36, 18);
            lable44.TabIndex = 14;
            lable44.Text = "Sec";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label3.Location = new Point(220, 64);
            label3.Name = "label3";
            label3.Size = new Size(68, 18);
            label3.TabIndex = 15;
            label3.Text = "Wait sec";
            // 
            // Txt_RtcWaitSec
            // 
            Txt_RtcWaitSec.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_RtcWaitSec.Location = new Point(294, 61);
            Txt_RtcWaitSec.Name = "Txt_RtcWaitSec";
            Txt_RtcWaitSec.Size = new Size(55, 26);
            Txt_RtcWaitSec.TabIndex = 16;
            Txt_RtcWaitSec.Text = "120";
            // 
            // label111
            // 
            label111.AutoSize = true;
            label111.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label111.Location = new Point(12, 114);
            label111.Name = "label111";
            label111.Size = new Size(97, 18);
            label111.TabIndex = 18;
            label111.Text = "Num records";
            // 
            // Txt_NumRecords
            // 
            Txt_NumRecords.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Txt_NumRecords.Location = new Point(159, 114);
            Txt_NumRecords.Name = "Txt_NumRecords";
            Txt_NumRecords.Size = new Size(55, 26);
            Txt_NumRecords.TabIndex = 19;
            Txt_NumRecords.Text = "120";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1082, 600);
            Controls.Add(Txt_NumRecords);
            Controls.Add(label111);
            Controls.Add(Txt_RtcWaitSec);
            Controls.Add(label3);
            Controls.Add(lable44);
            Controls.Add(Txt_RtcSecBefore);
            Controls.Add(Min);
            Controls.Add(Txt_RtcMinBefore);
            Controls.Add(Btn_RunAuto);
            Controls.Add(Cbo_ComWM);
            Controls.Add(Cbo_ComControl);
            Controls.Add(label2);
            Controls.Add(Btn_SearchCOM);
            Controls.Add(Tbox_TimeStart);
            Controls.Add(Cbo_TypeMeter);
            Controls.Add(RTBox_Log);
            Controls.Add(Btn_SetRTC);
            Name = "Form1";
            Text = "Form1";
            Load += Form1_Load;
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button Btn_SetRTC;
        private RichTextBox RTBox_Log;
        private ComboBox Cbo_TypeMeter;
        private TextBox Tbox_TimeStart;
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
    }
}
