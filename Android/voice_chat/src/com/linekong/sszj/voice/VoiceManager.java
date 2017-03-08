package com.linekong.sszj.voice;

import java.io.IOException;

import com.iflytek.cloud.InitListener;
import com.iflytek.cloud.RecognizerListener;
import com.iflytek.cloud.RecognizerResult;
import com.iflytek.cloud.SpeechConstant;
import com.iflytek.cloud.SpeechError;
import com.iflytek.cloud.SpeechRecognizer;
import com.iflytek.cloud.SpeechUtility;
import com.linekong.voice.util.FileOperate;
import com.unity3d.player.UnityPlayer;

import android.content.Context;
//import android.media.AudioRecord;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
//import android.media.MediaRecorder;
import android.os.Bundle;
import android.speech.RecognitionService;
import android.util.Log;



public class VoiceManager {
	private static final String TAG = "VoiceManager";

	private String mUploadUrl;
	private String mDownloadUrl;
	
    private SpeechRecognizer mspeech;
//    public RecognitionService.Callback RServiceCallback;

    private MediaPlayer mMediaPlayer = new MediaPlayer();
//    private MediaRecorder mRecorder;
//    private AudioRecord mRecord;
    Context mContext = null;

    private Boolean isInitOver = false;
    private Boolean isCanceled = false;

//    private long lastVolTime = 0;

    private String recordFilePath = "/sdcard/RecordFile/linekong.pcm";
    private String recordchangeFilePath = "/sdcard/RecordFile/linekongVoice.amr";

    private String objName;
    private String recordName;

	private String mPlayingAudioName;
	
	private String mVoiceStr = "";

    public void speexSdkInit(String _objName, String uploadUrl, String downloadUrl) {
//        Log.e("Unity", "speexSdkInit");
    	if (uploadUrl == null || uploadUrl.equals("")) {
    		mUploadUrl = "http://img.linekong.com/acceptVoice/index.php";
    	} else {
            mUploadUrl = uploadUrl;
    	}
    	if (downloadUrl == null || downloadUrl.equals("")) {
    		mDownloadUrl = "http://img.linekong.com/acceptVoice/index.php";
    	} else {
            mDownloadUrl = downloadUrl;
    	}
        SpeechUtility.createUtility(UnityPlayer.currentActivity, "appid=" + "564446db");
        objName = _objName;
        mspeech = SpeechRecognizer.createRecognizer(UnityPlayer.currentActivity, mInitListener);
    }

    public void startRecord(String _recordName) {
        if (!isInitOver) {
        	OnError("");
//            Log.d(TAG, "Init is not over can't start");
        }
        if (!mspeech.isListening()) 
        {
            isCanceled = false;
            mspeech.setParameter(SpeechConstant.DOMAIN, "iat");
            mspeech.setParameter(SpeechConstant.SAMPLE_RATE, "8000");
            mspeech.setParameter(SpeechConstant.LANGUAGE, "zh_cn");
            mspeech.setParameter(SpeechConstant.ACCENT, "mandarin");
            mspeech.setParameter(SpeechConstant.ASR_AUDIO_PATH, recordFilePath);
            int ret = mspeech.startListening(recognizerListener);
            recordName = _recordName;
//            Log.d(TAG, "_recordName:" + recordName + "      ret : " + ret);
            return;
        }
        return;
    }

    public void stopRecord() {
        if (!isInitOver) {
        	OnError("");

//            Log.d(TAG, "Init is not over can't stop");
            return;
        }
        if (mspeech.isListening()) {
            mspeech.stopListening();
            return;
        }
        return;
    }

    public void CancelListener() {
        if (!isInitOver) {
        	OnError("");

//            Log.d(TAG, "Init is not over can't stop");
            return;
        }
        if (mspeech.isListening()) {
            mspeech.cancel();
        }

        isCanceled = true;

    }

    private InitListener mInitListener = new InitListener() {

        @Override
        public void onInit(int code) {
            if (code == 0) {
//                Log.d(TAG, "login");
                isInitOver = true;
            } else {
//                Log.d(TAG, "login error" + code);
            	OnError("");
                isInitOver = true;
            }
        }
    };

    public RecognizerListener recognizerListener = new RecognizerListener() {
        @Override
        public void onBeginOfSpeech() {
            // TODO Auto-generated method stub
        }

        @Override
        public void onEndOfSpeech() {
            // TODO Auto-generated method stub
        }

        @Override
        public void onError(SpeechError arg0) {
            if (!isCanceled) {
            	OnRecordError(arg0.getErrorCode() + ":" + arg0.getErrorDescription());
//                Log.d(TAG, "error:" + arg0.getErrorCode());
            }
        }

        @Override
        public void onResult(RecognizerResult arg0, boolean arg1) {
            if (!isCanceled) {
                final String result = JsonParser.parseIatResult(arg0.getResultString());
                mVoiceStr += result;
//                Log.d(TAG, "result:" + result);
                if(arg1 == true)
                {
                	String paramString = recordName + ":" + mVoiceStr;
                	mVoiceStr = "";
                    UnityPlayer.UnitySendMessage(objName, "onRecordFinish", paramString);
                    
                    new Thread(new Runnable()
                    {
                    	@Override
                    	public void run()
                    	{
                            int responseCode = 0;
                            try
                            {
                                responseCode = FileOperate.doUpload(mUploadUrl, null, recordName, recordFilePath);
                            } 
                            catch (IOException e) 
                            {
//                            	Log.d(TAG, "IO Exception" );
                            	//OnError("");
                            	OnRecordError("upload failed");
                                e.printStackTrace();
                            }
                            if (responseCode == 200) {
                            	UnityPlayer.UnitySendMessage(objName, "onUploadFinish", recordName + ":0");
                            } else {
//                            	Log.e(TAG, "upload failed : " + responseCode);
                            	UnityPlayer.UnitySendMessage(objName, "onUploadFinish", recordName + ":-1");
                            }
                    	}
                    }).start();	
                }
            }
            else
            {
            	mVoiceStr = "";
            }
        }

//        public void onVolumeChanged(int arg0) {
//            long t = System.currentTimeMillis();
//            if (t - lastVolTime > 30) {
//                float f = arg0 / 30.00f;
//                // UnityPlayer.UnitySendMessage("Global",
//                // "OnVoiceVolumeChanged", String.valueOf(f));
//                lastVolTime = t;
//            }
//        }

        @Override
        public void onEvent(int arg0, int arg1, int arg2, Bundle arg3) {
        }

        @Override
        public void onVolumeChanged(int arg0, byte[] arg1) {
            // TODO Auto-generated method stub

        }
    };

    private OnCompletionListener mediaFinishListener = new OnCompletionListener(){

		@Override
		public void onCompletion(MediaPlayer arg0) {
//			Log.e(TAG, "media play finish");
			UnityPlayer.UnitySendMessage(objName, "onPlayerFinish", mPlayingAudioName);
		}
    	
    };
    
    public void startPlay(final String _recordName) throws IOException {
    	
        new Thread(new Runnable()
        {
        	@Override
        	public void run()
        	{
                if (mMediaPlayer == null) {
                    mMediaPlayer = new MediaPlayer();
                }

                if (mMediaPlayer.isPlaying()) {
                    mMediaPlayer.stop();
                }
                mMediaPlayer.reset();
                
                byte[] voice = null;
				try 
				{
					voice = FileOperate.fileDownload(mDownloadUrl, _recordName);
				} 
				catch (IOException e1) 
				{
		        	OnError("");
					e1.printStackTrace();
				}
				
				if (voice == null)
				{
					OnError("voice:startPlay voice == null.");
					return;
				}
				
                Pcm2Amr.amrByteToFile(voice, recordchangeFilePath);
				mMediaPlayer.setOnCompletionListener(mediaFinishListener);
                try {
                    mMediaPlayer.setDataSource(recordchangeFilePath);
                    mMediaPlayer.prepare();
                } catch (IllegalArgumentException e) {
                    // UnityPlayer.UnitySendMessage("Global",
                    // "OnVoiceException",ERROR_CODE_PLAYVOICE_FAIL);

//                    Log.e(TAG, "Play Failed 1 : " + e.getMessage());
                    e.printStackTrace();
                } catch (SecurityException e) {
                    // UnityPlayer.UnitySendMessage("Global",
                    // "OnVoiceException",ERROR_CODE_PLAYVOICE_FAIL);

//                    Log.e(TAG, "Play Failed 2 : " + e.getMessage());
                    e.printStackTrace();
                } catch (IllegalStateException e) {
                    // UnityPlayer.UnitySendMessage("Global",
                    // "OnVoiceException",ERROR_CODE_PLAYVOICE_FAIL);

//                    Log.e(TAG, "Play Failed 3 : " + e.getMessage());
                    e.printStackTrace();
                } catch (IOException e) {
                    // UnityPlayer.UnitySendMessage("Global",
                    // "OnVoiceException",ERROR_CODE_PLAYVOICE_FAIL);

//                    Log.e(TAG, "Play Failed 4 : " + e.getMessage());
                    e.printStackTrace();
                }
                
                UnityPlayer.UnitySendMessage(objName, "onPlayerStart", _recordName);
                
                mPlayingAudioName = _recordName;
                mMediaPlayer.setLooping(false);
                mMediaPlayer.start();

        	}
        }).start();
    }
    public void OnError(String paramString) {
    	Log.e(TAG, "On Error : " + paramString);
    	//UnityPlayer.UnitySendMessage(objName, "OnError", paramString);
    }
    
    public void OnRecordError(String err) {
//    	Log.e(TAG, "On Record Error : " + err);
    	UnityPlayer.UnitySendMessage(objName,  "onRecordError", err);
    }

}