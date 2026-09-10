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
            RTBox_Log.Location = new Point(444, 14);
            RTBox_Log.Name = "RTBox_Log";
            RTBox_Log.Size = new Size(356, 433);
            RTBox_Log.TabIndex = 1;
            RTBox_Log.Text = "";
            // 
            // Cbo_TypeMeter
            // 
            Cbo_TypeMeter.DropDownStyle = ComboBoxStyle.DropDownList;
            Cbo_TypeMeter.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Cbo_TypeMeter.FormattingEnabled = true;
            Cbo_TypeMeter.Items.AddRange(new object[] { "WM-01A", "WM-02A" });
            Cbo_TypeMeter.Location = new Point(12, 146);
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
            Btn_SearchCOM.Location = new Point(12, 96);
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
            label2.Location = new Point(181, 146);
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
            Cbo_ComControl.Location = new Point(171, 193);
            Cbo_ComControl.Name = "Cbo_ComControl";
            Cbo_ComControl.Size = new Size(121, 26);
            Cbo_ComControl.TabIndex = 8;
            // 
            // Cbo_ComWM
            // 
            Cbo_ComWM.DropDownStyle = ComboBoxStyle.DropDownList;
            Cbo_ComWM.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Cbo_ComWM.FormattingEnabled = true;
            Cbo_ComWM.Location = new Point(12, 193);
            Cbo_ComWM.Name = "Cbo_ComWM";
            Cbo_ComWM.Size = new Size(121, 26);
            Cbo_ComWM.TabIndex = 9;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(846, 486);
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
    }
}
