package com.kioskworldline.com;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Pointer;

public interface JNAData1 extends Library {
    JNAData1 INSTANCE = (JNAData1) Native.load("msprintdata1", JNAData1.class);
    //public String Data1GetPrintDataA();
    public Pointer Data1GetPrintDataL();
    public int Data1PrintDataMatrix(String strData, int iSize);
    public int Data1PrintQrcode(String strData,int iLmargin,int iMside,int iRound);
    public int Data1PrintDiskbmpfile(String strPath);
    public int Data1SetNvbmp(int iNums, String strPath);
    public int Data1PrintPDF417Bmp(int module_width,int module_height,int data_rows,int data_columns,int err_correct_level,String data_buf);
    public int Data1PrintImage(Pointer pPixels, int iWidth, int iHeight,int iMode);
    public int Data1Release();
}
