package com.linekong.sszj.voice;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import android.media.AmrInputStream;

import com.linekong.sszj.voice.*;;

public class Pcm2Amr {
	
	public static byte[] pcm2AmrByte(String pcmPath)
	{
		try {
			FileInputStream fis = new FileInputStream(pcmPath);
			AmrInputStream ais = new AmrInputStream(fis);
			
	        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
	        byte[] data = new byte[3200000];  
	        int count = -1;  
	        while((count = ais.read(data,0,3200000)) != -1)  
	            outStream.write(data, 0, count);  
	          
	        data = null;  
			ais.close();
	        return outStream.toByteArray(); 
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}		

	}
	
//	public static void pcm2Amr(String pcmPath , String amrPath) {
//		try {
//			FileInputStream fis = new FileInputStream(pcmPath);
//			AmrInputStream ais = new AmrInputStream(fis);
//			OutputStream out = new FileOutputStream(amrPath);
//			byte[] buf = new byte[3200000];
//			int len = -1;
//			/*
//			 * �����?amr���ļ�ͷ
//			 * ȱ���⼸���ֽ��ǲ��е�
//			 */
//	        out.write(0x23);
//	        out.write(0x21);
//	        out.write(0x41);
//	        out.write(0x4D);
//	        out.write(0x52);
//	        out.write(0x0A);   
//			while((len = ais.read(buf)) >0){
//				out.write(buf,0,len);
//			}
//			out.close();
//			ais.close();
//		} catch (FileNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}		
//	}
	
	public static void amrByteToFile(byte[] data,String amrPath) {
		try {
			
			OutputStream out = new FileOutputStream(amrPath);
	        out.write(0x23);
	        out.write(0x21);
	        out.write(0x41);
	        out.write(0x4D);
	        out.write(0x52);
	        out.write(0x0A);   
	        out.write(data);
	        //out.flush();
	        out.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

	}
}