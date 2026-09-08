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
            SuspendLayout();
            // 
            // Btn_Read
            // 
            Btn_Read.Location = new Point(15, 14);
            Btn_Read.Name = "Btn_Read";
            Btn_Read.Size = new Size(75, 23);
            Btn_Read.TabIndex = 0;
            Btn_Read.Text = "Read";
            Btn_Read.UseVisualStyleBackColor = true;
            Btn_Read.Click += Btn_Read_Click;
            // 
            // RTBox_Log
            // 
            RTBox_Log.Location = new Point(550, 88);
            RTBox_Log.Name = "RTBox_Log";
            RTBox_Log.Size = new Size(238, 350);
            RTBox_Log.TabIndex = 1;
            RTBox_Log.Text = "";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(RTBox_Log);
            Controls.Add(Btn_Read);
            Name = "Form1";
            Text = "Form1";
            ResumeLayout(false);
        }

        #endregion

        private Button Btn_Read;
        private RichTextBox RTBox_Log;
    }
}
