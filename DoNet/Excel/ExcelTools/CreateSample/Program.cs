using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Excel = Microsoft.Office.Interop.Excel;


namespace CreateSample
{
    class Program
    {
        static void Main(string[] args)
        {
            object missing = Type.Missing;
            int sheetNum = 99;

            Excel.Application excel = null;
            Excel.Workbooks wbs = null;
            Excel.Workbook wb = null;
            Excel.Worksheet xlsws = null;

            excel = new Excel.Application();
            if (excel == null)
            {
                Console.WriteLine("ERROR: Excel couldn't be started!");
                return;
            }

            excel.UserControl = true;
            excel.Visible = true;
            excel.AlertBeforeOverwriting = false;

            wbs = excel.Workbooks;
            if (wbs == null)
            {
                Console.WriteLine("ERROR: wbs == null!");
                return;
            }

            wb = wbs.Add();
            if (wb == null)
            {
                Console.WriteLine("ERROR: wb == null!");
                return;
            }

            excel.Worksheets.Add(missing, missing, sheetNum);
            int index = 1;
            foreach (Excel.Worksheet sheet in wb.Sheets)
            {
                //sheet.Select();
                sheet.Name = "No." + index;
                index++;
            }

            xlsws = (Excel.Worksheet)wb.Sheets.get_Item(1);
            xlsws.Select();

            //save
            string path = "C:\\Users\\webbleen\\Desktop\\Sameple";
            wb.SaveAs(path);

            excel.Quit();
            System.Runtime.InteropServices.Marshal.ReleaseComObject(excel);
            excel = null;
        }
    }                                                            
}
