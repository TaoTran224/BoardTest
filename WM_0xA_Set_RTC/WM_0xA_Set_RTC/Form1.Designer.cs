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
            Btn_Read = new Button();
            RTBox_Log = new RichTextBox();
            Cbo_TypeMeter = new ComboBox();
            Tbox_TimeStart = new TextBox();
            SuspendLayout();
            // 
            // Btn_Read
            // 
            Btn_Read.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Btn_Read.Location = new Point(15, 14);
            Btn_Read.Name = "Btn_Read";
            Btn_Read.Size = new Size(97, 35);
            Btn_Read.TabIndex = 0;
            Btn_Read.Text = "Read";
            Btn_Read.UseVisualStyleBackColor = true;
            Btn_Read.Click += Btn_Read_Click;
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
            Cbo_TypeMeter.Location = new Point(297, 12);
            Cbo_TypeMeter.Name = "Cbo_TypeMeter";
            Cbo_TypeMeter.Size = new Size(121, 26);
            Cbo_TypeMeter.TabIndex = 2;
            // 
            // Tbox_TimeStart
            // 
            Tbox_TimeStart.Font = new Font("Arial", 12F, FontStyle.Regular, GraphicsUnit.Point, 0);
            Tbox_TimeStart.Location = new Point(15, 64);
            Tbox_TimeStart.Name = "Tbox_TimeStart";
            Tbox_TimeStart.Size = new Size(149, 26);
            Tbox_TimeStart.TabIndex = 3;
            Tbox_TimeStart.Text = "260908121314";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(Tbox_TimeStart);
            Controls.Add(Cbo_TypeMeter);
            Controls.Add(RTBox_Log);
            Controls.Add(Btn_Read);
            Name = "Form1";
            Text = "Form1";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button Btn_Read;
        private RichTextBox RTBox_Log;
        private ComboBox Cbo_TypeMeter;
        private TextBox Tbox_TimeStart;
    }
}
