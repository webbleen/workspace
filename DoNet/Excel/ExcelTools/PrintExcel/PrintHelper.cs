using System;
using System.Data;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using Excel = Microsoft.Office.Interop.Excel;

namespace PrintExcel
{
    class PrintHelper
    {
        public void PrintXls(string fileName)
        {
            FileInfo fileInfo = new FileInfo(fileName);
            Excel.Application excelApp = new Excel.Application();
            if (excelApp == null)
            {
                Console.WriteLine("ERROR: Excel couldn't be started!");
                return;
            }

            excelApp.Visible = false;
            excelApp.UserControl = true;

            object missing = Type.Missing;
            Excel.Workbook wb = excelApp.Application.Workbooks.Open(fileName);
            if (wb == null)
            {
                Console.WriteLine("ERROR: wb == null!");
                return;
            }

            for (int index = 1; index <= wb.Sheets.Count; index++)
            {
                Excel.Worksheet workSheet = (Excel.Worksheet)wb.Worksheets.Item[index];

                //------------------------打印页面相关设置--------------------------------//
                workSheet.PageSetup.PaperSize = Microsoft.Office.Interop.Excel.XlPaperSize.xlPaperA4;//纸张大小
                workSheet.PageSetup.Orientation = Microsoft.Office.Interop.Excel.XlPageOrientation.xlPortrait;//页面竖向
                /*
                workSheet.PageSetup.Zoom = 75; //打印时页面设置,缩放比例百分之几
                workSheet.PageSetup.Zoom = false; //打印时页面设置,必须设置为false,页高,页宽才有效
                workSheet.PageSetup.FitToPagesWide = 1; //设置页面缩放的页宽为1页宽
                workSheet.PageSetup.FitToPagesTall = false; //设置页面缩放的页高自动
                workSheet.PageSetup.CenterFooter = "第 &P 页，共 &N 页";//页面下标
                workSheet.PageSetup.FooterMargin = 5;
                workSheet.PageSetup.PrintGridlines = false; //打印单元格网线
                workSheet.PageSetup.TopMargin = 15; //上边距为2cm（转换为in）
                workSheet.PageSetup.BottomMargin = 20; //下边距为1.5cm
                workSheet.PageSetup.LeftMargin = 30; //左边距为2cm
                workSheet.PageSetup.RightMargin = 30; //右边距为2cm
                workSheet.PageSetup.CenterHorizontally = true; //文字水平居中
                */
                string leftHeader = fileInfo.Name + "_" + workSheet.Name;
                workSheet.PageSetup.LeftHeader = leftHeader;

                string pdfFile = fileInfo.Directory.FullName + "\\" + leftHeader + ".pdf";
                workSheet.PrintOut(Preview: false, PrintToFile: true, PrToFileName: pdfFile);
                //workSheet.PrintOutEx(Preview: false, PrintToFile: true, PrToFileName: pdfFile);
            }


            KillProcess(excelApp); //杀掉生成的进程
            GC.Collect(); //垃圾回收机制
        }

        /// <summary>
        /// 杀掉生成的进程
        /// </summary>
        /// <param name="AppObject">进程程对象</param>
        private static void KillProcess(Microsoft.Office.Interop.Excel.Application AppObject)
        {
            int Pid = 0;
            IntPtr Hwnd = new IntPtr(AppObject.Hwnd);
            System.Diagnostics.Process p = null;
            try
            {
                GetWindowThreadProcessId(Hwnd, out Pid);
                p = System.Diagnostics.Process.GetProcessById(Pid);
                if (p != null)
                {
                    p.Kill();
                    p.Dispose();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("进程关闭失败！异常信息：" + ex);
            }
        }

        /// <summary>
        /// 引用Windows句柄，获取程序PID
        /// </summary>
        /// <param name="Hwnd"></param>
        /// <param name="PID"></param>
        /// <returns></returns>
        [DllImport("User32.dll")]
        public static extern int GetWindowThreadProcessId(IntPtr Hwnd, out int PID);

        public void CreateExcel(string title, string fileName, string sheetNames)
        {
            //待生成的文件名称
            string FileName = fileName;
            string strCurrentPath = Directory.GetCurrentDirectory();
            string FilePath = strCurrentPath + FileName;

            FileInfo fi = new FileInfo(FilePath);
            if (fi.Exists)     //判断文件是否已经存在,如果存在就删除!
            {
                fi.Delete();
            }
            if (sheetNames != null && sheetNames != "")
            {
                Excel.Application m_Excel = new Excel.Application();//创建一个Excel对象(同时启动EXCEL.EXE进程) 
                m_Excel.SheetsInNewWorkbook = 1;//工作表的个数 
                Excel._Workbook m_Book = (Excel._Workbook)(m_Excel.Workbooks.Add(Missing.Value));//添加新工作簿 
                Excel._Worksheet m_Sheet = (Excel._Worksheet)m_Book.ActiveSheet;


                #region 处理

                //DataSet ds = ScData.ListData("exec Vote_2008.dbo.P_VoteResult_Update " + int.Parse(fdate));
                DataSet ds = new DataSet();
                ds.ReadXml("");
                if (ds.Tables.Count <= 0)
                {
                    Console.WriteLine("没有最新数据!");
                    return;
                }
                DataTableToSheet(title, ds.Tables[0], m_Sheet, m_Book, 0);
                #endregion



                #region 保存Excel,清除进程
                m_Book.SaveAs(FilePath, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Excel.XlSaveAsAccessMode.xlNoChange, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value);
                //m_Excel.ActiveWorkbook._SaveAs(FilePath, Excel.XlFileFormat.xlExcel9795, null, null, false, false, Excel.XlSaveAsAccessMode.xlNoChange, null, null, null, null, null);
                m_Book.Close(false, Missing.Value, Missing.Value);
                m_Excel.Quit();
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_Book);
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_Excel);

                m_Book = null;
                m_Sheet = null;
                m_Excel = null;
                GC.Collect();
                //this.Close();//关闭窗体

                #endregion
            }
        }

        #region 将DataTable中的数据写到Excel的指定Sheet中
        /// <summary>
        /// 将DataTable中的数据写到Excel的指定Sheet中
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="m_Sheet"></param>
        public void DataTableToSheet(string title, DataTable dt, Excel._Worksheet m_Sheet, Excel._Workbook m_Book, int startrow)
        {

            //以下是填写EXCEL中数据
            Excel.Range range = m_Sheet.get_Range(m_Sheet.Cells[1, 1], m_Sheet.Cells[1, 2]);
            range.MergeCells = true;  //合并单元格
            range.Font.Bold = true;   //加粗单元格内字符
            //写入题目
            m_Sheet.Cells[startrow, startrow] = title;
            int rownum = dt.Rows.Count;//行数
            int columnnum = dt.Columns.Count;//列数
            int num = rownum + 2;   //得到数据中的最大行数


            //写入列标题
            for (int j = 0; j < columnnum; j++)
            {
                int bt_startrow = startrow + 1;

                //将字段名写入文档
                m_Sheet.Cells[bt_startrow, 1 + j] = dt.Columns[j].ColumnName;

                //单元格内背景色
                m_Sheet.get_Range(m_Sheet.Cells[bt_startrow, 1 + j], m_Sheet.Cells[bt_startrow, 1 + j]).Interior.ColorIndex = 15;
            }


            //逐行写入数据 
            for (int i = 0; i < rownum; i++)
            {
                for (int j = 0; j < columnnum; j++)
                {
                    m_Sheet.Cells[startrow + 2 + i, 1 + j] = dt.Rows[i][j].ToString();
                }
            }
            m_Sheet.Columns.AutoFit();



            //在当前工作表中根据数据生成图表

            CreateChart(m_Book, m_Sheet, num);
        }

        #endregion

        private void CreateChart(Excel._Workbook m_Book, Excel._Worksheet m_Sheet, int num)
        {
            Excel.Range oResizeRange;
            Excel.Series oSeries;

            m_Book.Charts.Add(Missing.Value, Missing.Value, 1, Missing.Value);
            m_Book.ActiveChart.ChartType = Excel.XlChartType.xlLine;//设置图形

            //设置数据取值范围
            m_Book.ActiveChart.SetSourceData(m_Sheet.get_Range("A2", "C" + num.ToString()), Excel.XlRowCol.xlColumns);
            //m_Book.ActiveChart.Location(Excel.XlChartLocation.xlLocationAutomatic, title);
            //以下是给图表放在指定位置
            m_Book.ActiveChart.Location(Excel.XlChartLocation.xlLocationAsObject, m_Sheet.Name);
            oResizeRange = (Excel.Range)m_Sheet.Rows.get_Item(10, Missing.Value);
            m_Sheet.Shapes.Item("Chart 1").Top = (float)(double)oResizeRange.Top;  //调图表的位置上边距
            oResizeRange = (Excel.Range)m_Sheet.Columns.get_Item(6, Missing.Value);  //调图表的位置左边距
            // m_Sheet.Shapes.Item("Chart 1").Left = (float)(double)oResizeRange.Left;
            m_Sheet.Shapes.Item("Chart 1").Width = 400;   //调图表的宽度
            m_Sheet.Shapes.Item("Chart 1").Height = 250;  //调图表的高度

            m_Book.ActiveChart.PlotArea.Interior.ColorIndex = 19;  //设置绘图区的背景色 
            m_Book.ActiveChart.PlotArea.Border.LineStyle = Excel.XlLineStyle.xlLineStyleNone;//设置绘图区边框线条
            m_Book.ActiveChart.PlotArea.Width = 400;   //设置绘图区宽度
            //m_Book.ActiveChart.ChartArea.Interior.ColorIndex = 10; //设置整个图表的背影颜色
            //m_Book.ActiveChart.ChartArea.Border.ColorIndex = 8;// 设置整个图表的边框颜色
            m_Book.ActiveChart.ChartArea.Border.LineStyle = Excel.XlLineStyle.xlLineStyleNone;//设置边框线条
            m_Book.ActiveChart.HasDataTable = false;


            //设置Legend图例的位置和格式
            m_Book.ActiveChart.Legend.Top = 20.00; //具体设置图例的上边距
            m_Book.ActiveChart.Legend.Left = 60.00;//具体设置图例的左边距
            m_Book.ActiveChart.Legend.Interior.ColorIndex = Excel.XlColorIndex.xlColorIndexNone;
            m_Book.ActiveChart.Legend.Width = 150;
            m_Book.ActiveChart.Legend.Font.Size = 9.5;
            //m_Book.ActiveChart.Legend.Font.Bold = true;
            m_Book.ActiveChart.Legend.Font.Name = "宋体";
            //m_Book.ActiveChart.Legend.Position = Excel.XlLegendPosition.xlLegendPositionTop;//设置图例的位置
            m_Book.ActiveChart.Legend.Border.LineStyle = Excel.XlLineStyle.xlLineStyleNone;//设置图例边框线条



            //设置X轴的显示
            Excel.Axis xAxis = (Excel.Axis)m_Book.ActiveChart.Axes(Excel.XlAxisType.xlValue, Excel.XlAxisGroup.xlPrimary);
            xAxis.MajorGridlines.Border.LineStyle = Excel.XlLineStyle.xlDot;
            xAxis.MajorGridlines.Border.ColorIndex = 1;//gridLine横向线条的颜色
            xAxis.HasTitle = false;
            xAxis.MinimumScale = 1500;
            xAxis.MaximumScale = 6000;
            xAxis.TickLabels.Font.Name = "宋体";
            xAxis.TickLabels.Font.Size = 9;



            //设置Y轴的显示
            Excel.Axis yAxis = (Excel.Axis)m_Book.ActiveChart.Axes(Excel.XlAxisType.xlCategory, Excel.XlAxisGroup.xlPrimary);
            yAxis.TickLabelSpacing = 30;
            yAxis.TickLabels.NumberFormat = "M月D日";
            yAxis.TickLabels.Orientation = Excel.XlTickLabelOrientation.xlTickLabelOrientationHorizontal;//Y轴显示的方向,是水平还是垂直等
            yAxis.TickLabels.Font.Size = 8;
            yAxis.TickLabels.Font.Name = "宋体";

            //m_Book.ActiveChart.Floor.Interior.ColorIndex = 8;  
            /***以下是设置标题*****
            m_Book.ActiveChart.HasTitle=true;
            m_Book.ActiveChart.ChartTitle.Text = "净值指数";
            m_Book.ActiveChart.ChartTitle.Shadow = true;
            m_Book.ActiveChart.ChartTitle.Border.LineStyle = Excel.XlLineStyle.xlContinuous;
            */

            oSeries = (Excel.Series)m_Book.ActiveChart.SeriesCollection(1);
            oSeries.Border.ColorIndex = 45;
            oSeries.Border.Weight = Excel.XlBorderWeight.xlThick;
            oSeries = (Excel.Series)m_Book.ActiveChart.SeriesCollection(2);
            oSeries.Border.ColorIndex = 9;
            oSeries.Border.Weight = Excel.XlBorderWeight.xlThick;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="dt"></param>
        protected void ExportExcel(DataTable dt)
        {
            if (dt == null || dt.Rows.Count == 0) return;
            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

            if (xlApp == null)
            {
                return;
            }
            System.Globalization.CultureInfo CurrentCI = System.Threading.Thread.CurrentThread.CurrentCulture;
            System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo("en-US");
            Microsoft.Office.Interop.Excel.Workbooks workbooks = xlApp.Workbooks;
            Microsoft.Office.Interop.Excel.Workbook workbook = workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);
            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];
            Microsoft.Office.Interop.Excel.Range range;
            long totalCount = dt.Rows.Count;
            long rowRead = 0;
            float percent = 0;
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                worksheet.Cells[1, i + 1] = dt.Columns[i].ColumnName;
                range = (Microsoft.Office.Interop.Excel.Range)worksheet.Cells[1, i + 1];
                range.Interior.ColorIndex = 15;
                range.Font.Bold = true;
            }
            for (int r = 0; r < dt.Rows.Count; r++)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    worksheet.Cells[r + 2, i + 1] = dt.Rows[r][i].ToString();
                }
                rowRead++;
                percent = ((float)(100 * rowRead)) / totalCount;
            }
            xlApp.Visible = true;
        }
    }
}
