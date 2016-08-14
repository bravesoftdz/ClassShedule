unit UExcelConst;

{$mode objfpc}{$H+}

interface

uses Windows, Activex;

type
  XlFileFormat = TOleEnum;
const
  xlAddIn = $00000012; // Microsoft Office Excel Add-In.
  xlCSV = $00000006; // Comma separated value.
  xlCSVMac = $00000016; // Comma separated value.
  xlCSVMSDOS = $00000018; // Comma separated value.
  xlCSVWindows = $00000017; // Comma separated value.
  xlDBF2 = $00000007; // Dbase 2 format.
  xlDBF3 = $00000008; // Dbase 3 format.
  xlDBF4 = $0000000B; // Dbase 4 format.
  xlDIF = $00000009; // Data Interchange format.
  xlExcel2 = $00000010; // Excel version 2.0.
  xlExcel2FarEast = $0000001B; // Excel version 2.0 far east.
  xlExcel3 = $0000001D; // Excel version 3.0.
  xlExcel4 = $00000021; // Excel version 4.0.
  xlExcel4Workbook = $00000023; // Excel version 4.0. Workbook format.
  xlExcel5 = $00000027; // Excel version 5.0.
  xlExcel7 = $00000027; // Excel 95.
  xlExcel9795 = $0000002B; // Excel version 95 and 97.
  xlIntlAddIn = $0000001A; // Microsoft Office Excel Add-In international format.
  xlIntlMacro = $00000019; // Deprecated format.
  xlWorkbookNormal = $FFFFEFD1; // Excel workbook format.
  xlSYLK = $00000002; // Symbolic link format.
  xlTemplate = $00000011; // Excel template format.
  xlCurrentPlatformText = $FFFFEFC2; // Specifies a type of text format.
  xlTextMac = $00000013; // Specifies a type of text format.
  xlTextMSDOS = $00000015; // Specifies a type of text format.
  xlTextPrinter = $00000024; // Specifies a type of text format.
  xlTextWindows = $00000014; // Specifies a type of text format.
  xlWJ2WD1 = $0000000E; // Deprecated format.
  xlWK1 = $00000005; // Lotus 1-2-3 format.
  xlWK1ALL = $0000001F; // Lotus 1-2-3 format.
  xlWK1FMT = $0000001E; // Lotus 1-2-3 format.
  xlWK3 = $0000000F; // Lotus 1-2-3 format.
  xlWK4 = $00000026; // Lotus 1-2-3 format.
  xlWK3FM3 = $00000020; // Lotus 1-2-3 format.
  xlWKS = $00000004; // Lotus 1-2-3 format.
  xlWorks2FarEast = $0000001C; // Microsoft Works 2.0 format.
  xlWQ1 = $00000022; // Quattro Pro format.
  xlWJ3 = $00000028; // Deprecated format.
  xlWJ3FJ3 = $00000029; // Deprecated format.
  xlExcel12 = $00000032; // Excel 2007.
  xlExcel8 = $00000038; // Excel 2003.
  xlHtml = $0000002C; // Web page format.
  xlTemplate8 = $00000011; // Excel 2003 template format.
  xlUnicodeText = $0000002A; // Specifies a type of text format.
  xlWebArchive = $0000002D; // MHT format.
  xlWorkbookDefault = $00000033; // Excel workbook format.
  xlXMLSpreadsheet = $0000002E; // Excel Spreadsheet format.

implementation

end.

