 package com.kioskworldline.com;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.hardware.usb.UsbConstants;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.hardware.usb.UsbInterface;
import android.hardware.usb.UsbManager;
import android.util.Log;

public class UsbDriver {
	public static final int MAX_DEVICE_NUM = 3;	//支持多台打印机数量
	private static final String TAG = "UsbDriver";
	public static final int WRITEBUF_SIZE = 4096;
	
	private UsbManager mManager;
	private PendingIntent  mPermissionIntent;
	private UsbDevice[] m_Device = new UsbDevice[MAX_DEVICE_NUM];
	private UsbInterface[] mInterface = new UsbInterface[MAX_DEVICE_NUM];
	private UsbDeviceConnection[] mDeviceConnection = new UsbDeviceConnection[MAX_DEVICE_NUM];
	private int m_UsbDevIdx = -1;	//UsbDevice 下标
	private UsbEndpoint[] mFTDIEndpointOUT = new UsbEndpoint[MAX_DEVICE_NUM];
	private UsbEndpoint[] mFTDIEndpointIN = new UsbEndpoint[MAX_DEVICE_NUM];
	private int m_iWaitTime = 3000;
	//增加日志记录
	private String m_strLog_Path = ""; // 日志文件在sdcard中的路径，空表示不记录日志
	@SuppressLint({ "SdCardPath", "SimpleDateFormat" })
	private static SimpleDateFormat LogSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 日志的输出格式
    private static SimpleDateFormat logfile = new SimpleDateFormat("yyyyMMdd"); // 日志文件格式
    private boolean syncLock;
	static int m_iSpecPID = 0x0;//0x0;0x7540;
    static int m_iSpecVID = 0x0;//0x0;0x483;

	public UsbDriver(UsbManager manager, Context context) {		
		syncLock = false;
		mManager = manager;
	}

	public synchronized void lock()
	{
		while(syncLock == true) {
			try {
				wait();
			}
			catch (Exception e) {
			//	Debug.warning(e);
			}
		}
		syncLock = true;
	}

	public synchronized void unlock()
	{
		syncLock = false;
		notifyAll();
	}

	//设置超时时间
	public void setFlowCtrl(int iFlowCtrlFlag) { 
		if(iFlowCtrlFlag==0)
		{ 
			m_iWaitTime = 2000;
		}
		else
		{
			m_iWaitTime = 0; 
		}		 		 
	}	
	
	public void setPermissionIntent(PendingIntent pi) { 
		 mPermissionIntent = pi;		 
	}	 
	
	// when insert the device USB plug into a USB port
	public boolean usbAttached(Intent intent) {
		UsbDevice usbDev = (UsbDevice) intent
				.getParcelableExtra(UsbManager.EXTRA_DEVICE);
		return usbAttached(usbDev);
	}	
	
	public boolean usbAttached(UsbDevice usbDev) {
		m_UsbDevIdx = getUsbDevIndex(usbDev); 
		m_Device[m_UsbDevIdx] = usbDev;
		if(m_UsbDevIdx<0)
		{
			Log.i(TAG, "Not support device : " + usbDev.toString());
			return false;
		}  
		
		//是否有权限
		if(mManager.hasPermission(m_Device[m_UsbDevIdx]))
		{
			return true; 
		}
		else
		{
			//请求权限
			mManager.requestPermission(m_Device[m_UsbDevIdx], mPermissionIntent);
			return false;
		} 
	}	

	public boolean openUsbDevice()
	{
		if(m_UsbDevIdx<0)
		{
			for (UsbDevice device : mManager.getDeviceList().values()) {
			//	Log.i(TAG, "Devices : " + device.toString());
				m_UsbDevIdx = getUsbDevIndex(device); 
				if(m_UsbDevIdx>=0)
				{
					m_Device[m_UsbDevIdx] = device;
					break;
				} 
			}
		}
		
		if(m_UsbDevIdx<0) 
			return false; 		
		return openUsbDevice(m_Device[m_UsbDevIdx]);
	}

	public boolean openUsbDevice(UsbDevice usbDev)
	{
		m_UsbDevIdx = getUsbDevIndex(usbDev); 
		if(m_UsbDevIdx<0) 
			return false; 
		
	    //获取设备接口
		int iIndex = 0;
		int iCount = m_Device[m_UsbDevIdx].getInterfaceCount();
		//Log.i(TAG, " m_Device[m_UsbDevIdx].getInterfaceCount():"+  iCount);
		
		//android5.X下面,当后接鼠标等USB设备时,getInterfaceCount会出现为0的情况,2017/05/19
		if(iCount==0)
			return false;
		
        for (iIndex = 0; iIndex < iCount;iIndex++ ) {
            // 一般来说一个设备都是一个接口，可以通过getInterfaceCount()查看接口的个数
            // 这个接口上有两个端点，分别对应OUT 和 IN 
            mInterface[m_UsbDevIdx] = m_Device[m_UsbDevIdx].getInterface(iIndex);
            break;
        } 
		
		//用UsbDeviceConnection 与 UsbInterface 进行端点设置和通讯
		//原用getEndpoint(1) getEndpoint(0)区分OUT、IN方向在1902芯片上有问题，修改2021-08-31
		iCount = mInterface[m_UsbDevIdx].getEndpointCount();
		for(iIndex =0;iIndex<iCount;iIndex++)
		{
			if(mInterface[m_UsbDevIdx].getEndpoint(iIndex).getType() == UsbConstants.USB_ENDPOINT_XFER_BULK)
			{
				if (mInterface[m_UsbDevIdx].getEndpoint(iIndex).getDirection() == UsbConstants.USB_DIR_OUT)
				{
					mFTDIEndpointOUT[m_UsbDevIdx] = mInterface[m_UsbDevIdx].getEndpoint(iIndex);
				} else if (mInterface[m_UsbDevIdx].getEndpoint(iIndex).getDirection() == UsbConstants.USB_DIR_IN)
				{
					mFTDIEndpointIN[m_UsbDevIdx] = mInterface[m_UsbDevIdx].getEndpoint(iIndex);
				}
			}
		}
        
		mDeviceConnection[m_UsbDevIdx] = mManager.openDevice(m_Device[m_UsbDevIdx]);
		if(mDeviceConnection[m_UsbDevIdx]==null)
			return false;
		
        if (mDeviceConnection[m_UsbDevIdx].claimInterface(mInterface[m_UsbDevIdx], true)) 
        {
        	return true;
        } 
        else 
        {
        	mDeviceConnection[m_UsbDevIdx].close();
        	return false;
        }
	}

	/**
	 * Gets an USB permission if no permission
	 * 
	 * @param device
	 * @see setPermissionIntent
	 */
	public void getPermission(UsbDevice device) {
		if (device != null && mPermissionIntent != null) {
			if (!mManager.hasPermission(device)) {
				mManager.requestPermission(device, mPermissionIntent);
			}
		}
	}

	// Close the device
	public void closeUsbDevice()
	{
		if(m_UsbDevIdx<0)
			return ;
		
		closeUsbDevice(m_Device[m_UsbDevIdx]);
	}
	// Close the device
	public boolean closeUsbDevice(UsbDevice usbDev)
	{
		try{
			m_UsbDevIdx = getUsbDevIndex(usbDev); 
			if(m_UsbDevIdx<0) 
				return false; 
			if(mDeviceConnection[m_UsbDevIdx]!=null)
			{
				if(mInterface[m_UsbDevIdx]!=null)
				{
					mDeviceConnection[m_UsbDevIdx].releaseInterface(mInterface[m_UsbDevIdx]);
					mInterface[m_UsbDevIdx] = null;
					mDeviceConnection[m_UsbDevIdx].close();
					mDeviceConnection[m_UsbDevIdx] = null;
					m_Device[m_UsbDevIdx] = null;
					mFTDIEndpointOUT[m_UsbDevIdx] = null;
					mFTDIEndpointIN[m_UsbDevIdx] = null;
				}
			}
		}catch(Exception e)
		{
			Log.i(TAG, "closeUsbDevice exception: " + e.getMessage().toString());
		}
		return true;  
	}
	
	// when remove the device USB plug from a USB port
	public boolean usbDetached(Intent intent) {
		UsbDevice device = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE); 
		return closeUsbDevice(device); 
	}
	
	public int write(byte[] buf) {
	 	return write(buf, buf.length);
	}
	
	public int write(byte[] buf, int length) {
		if(m_UsbDevIdx<0)
			return -1;
		
		return write(buf, buf.length, m_Device[m_UsbDevIdx]);
	}

	public int write(byte[] buf,int initial, int length) {
		if(m_UsbDevIdx<0)
			return -1;

		return write(buf, initial, buf.length,  m_Device[m_UsbDevIdx]);
	}
	
	// Read Binary Data
	public int read(byte[] bufRead,byte[] bufWrite) { 
		if(m_UsbDevIdx<0)
			return -1;
		
		return read(bufRead,bufWrite,m_Device[m_UsbDevIdx]);
	}
	
	public int write(byte[]  buf,UsbDevice usbDev) {
		return write(buf, buf.length, usbDev);
	}

	
	public int write(byte[] buf, int length,UsbDevice usbDev) {
		m_UsbDevIdx = getUsbDevIndex(usbDev); 
		if(m_UsbDevIdx<0) 
			return -1; 
		lock();
		int offset = 0;
		int actual_length;
		try
		{
		byte[] write_buf = new byte[WRITEBUF_SIZE];

		while (offset < length) {
			int write_size = WRITEBUF_SIZE;

			if (offset + write_size > length) {
				write_size = length - offset;
			}
			System.arraycopy(buf, offset, write_buf, 0, write_size);
			actual_length = mDeviceConnection[m_UsbDevIdx].bulkTransfer(
					mFTDIEndpointOUT[m_UsbDevIdx], write_buf, write_size, m_iWaitTime);
			//Log.i(TAG, "-----Length--------" + String.valueOf(actual_length));

			if (actual_length < 0) {
				unlock();
				return -1;
			}
			if(!m_strLog_Path.equals(""))
			{
				String str1="";
				String str2="";
				for(int i1=0;i1<actual_length;i1++)
				{
					str2 = String.format("%02X", write_buf[i1]);
					str1 = str1 + str2 + " ";
				}
				writeLogtoFile("write","Length="+String.valueOf(actual_length)+";Data=[" + str1 + "]");
			}

			offset += actual_length;
		}
		}catch(Exception e)
		{}
		
		unlock();
		return offset;
	}


	public int write(byte[] buf, int initial, int length,UsbDevice usbDev) {
		m_UsbDevIdx = getUsbDevIndex(usbDev);
		if(m_UsbDevIdx<0)
			return -1;
		lock();
		int offset = initial;
		int actual_length;
		try
		{
			byte[] write_buf = new byte[WRITEBUF_SIZE];

			while (offset < length) {
				int write_size = WRITEBUF_SIZE;

				if (offset + write_size > length) {
					write_size = length - offset;
				}
				System.arraycopy(buf, offset, write_buf, 0, write_size);
				actual_length = mDeviceConnection[m_UsbDevIdx].bulkTransfer(
						mFTDIEndpointOUT[m_UsbDevIdx], write_buf, write_size, m_iWaitTime);
				//Log.i(TAG, "-----Length--------" + String.valueOf(actual_length));

				if (actual_length < 0) {
					unlock();
					return -1;
				}
				if(!m_strLog_Path.equals(""))
				{
					String str1="";
					String str2="";
					for(int i1=0;i1<actual_length;i1++)
					{
						str2 = String.format("%02X", write_buf[i1]);
						str1 = str1 + str2 + " ";
					}
					writeLogtoFile("write","Length="+String.valueOf(actual_length)+";Data=[" + str1 + "]");
				}

				offset += actual_length;
			}
		}catch(Exception e)
		{}

		unlock();
		return offset;
	}

	public int read(byte[] bufRead,byte[] bufWrite, UsbDevice usbDev) {
		//先读空数据 2023/12/25
		byte[] bBuffer = new byte[256];
		mDeviceConnection[m_UsbDevIdx].bulkTransfer(mFTDIEndpointIN[m_UsbDevIdx],
				bBuffer, bBuffer.length, 50);
		if(write(bufWrite,bufWrite.length,usbDev)<0)
			return -1;  
		int len = 0;
		lock();
		try{
			try {
				Thread.sleep(50);
				if(bufRead.length>10)
					Thread.sleep(150);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				//Log.i(TAG, e);
			}
		 
			len = mDeviceConnection[m_UsbDevIdx].bulkTransfer(mFTDIEndpointIN[m_UsbDevIdx],
					bufRead, bufRead.length, 300); // RX
			if(len==0)
				len = mDeviceConnection[m_UsbDevIdx].bulkTransfer(mFTDIEndpointIN[m_UsbDevIdx],
						bufRead, bufRead.length, 300); // RX
			//Log.i(TAG,"mFTDIEndpointIN:"+len);
		}catch(Exception e)
		{}
		unlock();
		return len;
	}

	//读数据
	public int read(byte[] bufRead) {
		if(m_UsbDevIdx<0)
			return -1;

		int iLen = 0;
		int iResultData = 0;
		lock();
		try{
			byte[] bRead = new byte[32];
			iLen = mDeviceConnection[m_UsbDevIdx].bulkTransfer(mFTDIEndpointIN[m_UsbDevIdx],
					bRead, bRead.length, 300);
			while(iLen>0) {
				System.arraycopy(bRead,0,bufRead,iResultData,iLen);
				iResultData = iResultData + iLen;
				iLen = mDeviceConnection[m_UsbDevIdx].bulkTransfer(mFTDIEndpointIN[m_UsbDevIdx],
						bRead, bRead.length, 300);
			}
		}catch(Exception e)
		{}
		unlock();
		return iResultData;
	}

	// 获取设备返回的对应设备下标
	private int getUsbDevIndex(UsbDevice usbDev){
		try{
			if(usbDev == null)
				return -1;
			if((usbDev.getProductId() == 0x2013 && usbDev.getVendorId() == 0x519))
			{
				return 0;
			}else if((usbDev.getProductId() == 0x2015 && usbDev.getVendorId() == 0x519))
			{
				return 1;
			}else if((usbDev.getProductId() == m_iSpecPID && usbDev.getVendorId() == m_iSpecVID))
			{
				return 2;
			}
		}catch(Exception e)
		{ 
			Log.i(TAG, "getUsbDevIndex exception: " + e.getMessage().toString());
		}

		//Log.i(TAG, "Not support device : " + usbDev.toString());
		return -1;
	}	
	
	public boolean isUsbPermission()
	{
		boolean  blnRes = false;
		try{
			if(m_UsbDevIdx<0)
				return false;
			
			if(mManager!=null )
				blnRes =  mManager.hasPermission(m_Device[m_UsbDevIdx]);
		}catch(Exception e){}
		return blnRes;
	}
	
	public boolean isConnected() {
		if(m_UsbDevIdx<0)
			return false;
		
		if (m_Device[m_UsbDevIdx] != null && mFTDIEndpointOUT[m_UsbDevIdx] != null
				&& mFTDIEndpointIN[m_UsbDevIdx] != null) {
			return true;
		} else {
			return false;
		}
	}

	public void SetLogPath(String strValue)
	{
		m_strLog_Path = strValue;
	}
	
	private void writeLogtoFile(String tag, String text) {
		if(m_strLog_Path.equals(""))
			return;
		
        Date nowtime = new Date();
        String needWriteFiel = logfile.format(nowtime);
        String needWriteMessage = LogSdf.format(nowtime) + " " + tag + " " + text;
		try {
			File logdir = new File(m_strLog_Path);// 如果没有log文件夹则新建该文件夹
			if (!logdir.exists()) {
				logdir.mkdirs();
			}
			File file = new File(m_strLog_Path, "PrintSdk" + needWriteFiel + ".log");

            FileWriter filerWriter = new FileWriter(file, true);// 后面这个参数代表是不是要接上文件中原来的数据，不进行覆盖
            BufferedWriter bufWriter = new BufferedWriter(filerWriter);
            bufWriter.write(needWriteMessage);
            bufWriter.newLine();
            bufWriter.close();
            filerWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
