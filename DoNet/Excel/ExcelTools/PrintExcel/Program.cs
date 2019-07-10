using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Excel = Microsoft.Office.Interop.Excel;

namespace PrintExcel
{
    class Program
    {
        static void Main(string[] args)
        {
            string strCurrentPath = Directory.GetCurrentDirectory();
            PrintHelper helper = new PrintHelper();

            DirectoryInfo dirInfo = new DirectoryInfo(@"C:\Users\webbleen\Desktop\print");
            FileInfo[] fileInfo = dirInfo.GetFiles();

            foreach (FileInfo file in fileInfo)
            {
                if (file.Exists == false)
                {
                    continue;
                }

                if (file.Extension.Equals(".xls") || file.Extension.Equals(".xlsx"))
                {
                    helper.PrintXls(file.FullName);
                }
            }
        }
    }
}
