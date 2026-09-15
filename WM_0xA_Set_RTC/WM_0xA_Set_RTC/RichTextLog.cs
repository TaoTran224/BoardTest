using System;
using System.Drawing;
using System.Windows.Forms;

namespace WinFormsApp1
{
    // Token: 0x0200000C RID: 12
    public class TextAppender
    {
        // Token: 0x0600007F RID: 127 RVA: 0x0000A554 File Offset: 0x00008754
        public static void AppendText(RichTextBox richTextBox, string text, Color? color = null)
        {
            bool invokeRequired = richTextBox.InvokeRequired;
            if (invokeRequired)
            {
                richTextBox.BeginInvoke(new Action(delegate ()
                {
                    TextAppender.AppendText(richTextBox, text, color);
                }));
            }
            else
            {
                Color originalColor = SystemColors.WindowText;
                bool flag = color != null;
                if (flag)
                {
                    richTextBox.SelectionColor = color.Value;
                }
                string timestamp = DateTime.Now.ToString("HH:mm:ss.fff");
                richTextBox.AppendText(string.Concat(new string[]
                {
                    "[",
                    timestamp,
                    "] ",
                    text,
                    Environment.NewLine
                }));
                richTextBox.SelectionColor = originalColor;
                richTextBox.SelectionStart = richTextBox.Text.Length;
                richTextBox.ScrollToCaret();
            }
        }
    }
}
