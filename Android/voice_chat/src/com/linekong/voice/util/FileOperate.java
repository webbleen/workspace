package com.linekong.voice.util;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;


import android.media.AmrInputStream;
import android.util.Log;

public class FileOperate {
    private static final String TAG = "FileOperate";
    
    public static byte[] fileDownload(String actionUrl, String fileName) throws IOException {
    	//URL url = new URL("http://img.linekong.com/acceptVoice/index.php?act=sendVoice&file="+fileName);
    	URL url = new URL(actionUrl + "?act=sendVoice&file=" + fileName);
        HttpURLConnection conn=(HttpURLConnection)url.openConnection();
        InputStream input=conn.getInputStream();

        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
        byte[] buffer = new byte[1024];
        int len = -1;
        while ((len = input.read(buffer)) > 0) {  
        	outStream.write(buffer, 0, len);  
        } 
        conn.disconnect();
		return outStream.toByteArray();
    }
    
    public static int doUpload(String actionUrl, Map<String,String>params,String filename, String file) throws IOException {
        String BOUNDARY = java.util.UUID.randomUUID().toString();
        String PREFIX = "--", LINEND = "\r\n";
        String MULTIPART_FROM_DATA = "multipart/form-data";
        String CHARSET = "UTF-8";
        
        //URL uri = new URL("http://img.linekong.com/acceptVoice/index.php");
        URL uri = new URL(actionUrl);
        HttpURLConnection conn = (HttpURLConnection) uri.openConnection();
        conn.setReadTimeout(5 * 1000);
        conn.setDoInput(true);
        conn.setDoOutput(true);
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("connection", "keep-alive");
        conn.setRequestProperty("Charsert", "UTF-8");
        conn.setRequestProperty("Content-Type", MULTIPART_FROM_DATA
                + ";boundary=" + BOUNDARY);
        conn.setRequestProperty("referer", "LK_Voice_Chat_SDK");
 
        StringBuilder sb = new StringBuilder();
        if (params != null){
            for (Map.Entry<String, String> entry : params.entrySet()) {
                sb.append(PREFIX);
                sb.append(BOUNDARY);
                sb.append(LINEND);
                sb.append("Content-Disposition: form-data; name=\""
                        + entry.getKey() + "\"" + LINEND);
                sb.append("Content-Type: text/plain; charset=" + CHARSET + LINEND);
                sb.append("Content-Transfer-Encoding: 8bit" + LINEND);
                sb.append(LINEND);
                sb.append(entry.getValue());
                sb.append(LINEND);
            }
        }
 
        DataOutputStream outStream = new DataOutputStream(
                conn.getOutputStream());
        outStream.write(sb.toString().getBytes());
        
        StringBuilder sb1 = new StringBuilder();
        sb1.append(PREFIX);
        sb1.append(BOUNDARY);
        sb1.append(LINEND);
        sb1.append("Content-Disposition: form-data; name=\"file\"; filename=\""
                + filename + "\"" + LINEND);
        sb1.append("Content-Type: application/octet-stream; charset="
                        + CHARSET + LINEND);
        sb1.append(LINEND);
        outStream.write(sb1.toString().getBytes());
 
        InputStream fis = new FileInputStream(file);
		AmrInputStream ais = new AmrInputStream(fis);

        byte[] buffer = new byte[1024];
        int len = 0;
        
        while((len = ais.read(buffer)) != -1)
        {
            outStream.write(buffer, 0, len);
        }

        fis.close();
        ais.close();
        buffer = null;
        outStream.write(LINEND.getBytes());
 
        byte[] end_data = (PREFIX + BOUNDARY + PREFIX + LINEND).getBytes();
        outStream.write(end_data);
        outStream.flush();
 
        int res = conn.getResponseCode();
        conn.disconnect();
        return res;
    }
}



