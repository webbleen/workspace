package com.lk.sdk;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import android.R.integer;
import android.annotation.SuppressLint;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.util.Log;

@SuppressLint({ "UseSparseArrays", "SimpleDateFormat" })
public class LkNotificationManager {
    public static final String TAG = "Notification";
    private static HashMap<Integer, PendingIntent> mPendingIntents = new HashMap<Integer, PendingIntent>();

    public void notify_unity(int id, String title, String text, int year, int month, int day, int weekday, int hour, int minute,
            int second, int interval) {
        Log.d(TAG, "unity_check=" + id + text);
        try {
            Class<?> unityCls = Class.forName("com.unity3d.player.UnityPlayer");
            Log.d(TAG, "find unity class:" + unityCls);
            if (unityCls != null) {
                Field currentActivity = unityCls.getDeclaredField("currentActivity");
                if (currentActivity != null)
                    notify((Context) currentActivity.get(null), id, title, text, year, month, day, weekday, hour, minute,
                            second, interval);
            }
        } catch (Exception e) {
            Log.d(TAG, e.toString());
        }
    }

    public void notify(Context context, int id, String title, String text, int year, int month, int day, int weekday, int hour,
            int minute, int second, int interval) {
        if (context == null) {
            return;
        }
        PackageManager pm = context.getPackageManager();
        try {
            title = (String) pm.getApplicationLabel(pm.getApplicationInfo(title, 0));
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        AlarmManager am = (AlarmManager) context.getSystemService("alarm");
        if (mPendingIntents.containsKey(Integer.valueOf(id))) {
            PendingIntent pendingIntent = (PendingIntent) mPendingIntents.get(Integer.valueOf(id));
            if (pendingIntent != null) {
                am.cancel(pendingIntent);
            }

            mPendingIntents.remove(Integer.valueOf(id));
        }

        Calendar c = Calendar.getInstance();

        c.set(Calendar.YEAR, year);
        c.set(Calendar.MONTH, month - 1);
        if (day == 0) {
        	// 当天;
        	c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH));
		} else {
			// 指定某一天;
			c.set(Calendar.DAY_OF_MONTH, day);
		}
        if (weekday > 0 && weekday <= 7) {
        	c.set(Calendar.DAY_OF_WEEK, weekday%7 + 1);
		}
        c.set(Calendar.HOUR_OF_DAY, hour);
        c.set(Calendar.MINUTE, minute);
        c.set(Calendar.SECOND, second);
        Intent intent = new Intent(context, LKNotification.class);
        intent.putExtra("title", title);
        intent.putExtra("text", text);
        if (c.getTimeInMillis() < System.currentTimeMillis()) {
        	switch (Integer.valueOf(interval)) {
        	case 1:
                break; // 每分钟
            case 2:
            	break; // 每小时
            case 3:
            	c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH) + 1); // 每天
            	break;
            case 4:
                c.set(Calendar.WEEK_OF_YEAR, c.get(Calendar.WEEK_OF_YEAR) + 1); // 每周
                break;
            case 5:
            	break; // 每月
            default:
            	break;
        	}
        }
        
        SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
        Log.d(TAG, df.format(c.getTime()));  
        
        PendingIntent pi = PendingIntent.getBroadcast(context, id, intent, 0);

        if (interval > 0) {
            interval = getIntervalTime(Integer.valueOf(interval));
            if (interval > 0) {
                Log.d(TAG, "interval-----" + interval + "====title:" + text + "===id:" + id);
                Log.d(TAG, c.getTime().toString());
                am.setRepeating(0, c.getTimeInMillis(), interval * 1000, pi);
            }
        } else {
            long deltatime = c.getTimeInMillis() - System.currentTimeMillis();
            if (deltatime / 1000L < 61L) {
                return;
            }
            Log.d(TAG, "deltatime: " + deltatime + "===" + c.getTimeInMillis() + "---" + System.currentTimeMillis());
            am.set(0, c.getTimeInMillis(), pi);
        }

        mPendingIntents.put(Integer.valueOf(id), pi);
    }

    private int getIntervalTime(Integer interval) {
        Log.d(TAG, "interval======" + interval.toString());
        switch (interval.intValue()) {
        case 1:
            return 60; // 一分钟
        case 2:
            return 3600; // 一小时
        case 3:
            return 86400; // 一天
        case 4:
            return 604800;// 一周
        case 5:
            return 2592000;// 一个月
        }

        return 0;
    }

    public void clear(Context context) {
        AlarmManager am = (AlarmManager) context.getSystemService("alarm");
        for (Iterator<?> localIterator = mPendingIntents.keySet().iterator(); localIterator.hasNext();) {
            int key = ((Integer) localIterator.next()).intValue();
            PendingIntent pendingIntent = (PendingIntent) mPendingIntents.get(Integer.valueOf(key));
            if (pendingIntent != null) {
                am.cancel(pendingIntent);
            }
        }

        mPendingIntents.clear();
    }

    public void clearNotity() {
        try {
            Class<?> unityCls = Class.forName("com.unity3d.player.UnityPlayer");
            Log.d(TAG, "find unity class:" + unityCls);
            if (unityCls != null) {
                Field currentActivity = unityCls.getDeclaredField("currentActivity");
                if (currentActivity != null) {
                    Context context = (Context) currentActivity.get(null);
                    clear(context);
                }
            }
        } catch (Exception e) {
            Log.d(TAG, e.toString());
        }
    }
}