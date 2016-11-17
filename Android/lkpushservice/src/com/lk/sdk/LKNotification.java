package com.lk.sdk;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

public class LKNotification extends BroadcastReceiver {
    private static final String TAG = "Notification";
    public static final String TITLE = "title";
    public static final String TEXT = "text";
    private int mId = -559038801;

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "收到通知");

        if (intent != null) {
            String title = intent.getStringExtra("title");
            String text = intent.getStringExtra("text");
            try {
                notification(context, title, text);
            } catch (Exception e) {
                Log.d(TAG, "notification:" + e.toString());
            }
        }
    }

    private int getIcon(Context context) {
        int id = 0;
        if (context != null) {
            id = context.getResources().getIdentifier("app_icon", "drawable", context.getPackageName());
        }

        if (id == 0) {
            id = 17301651;
        }

        return id;
    }

    private void notification(Context context, String title, String text) {
        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(context).setContentTitle(title)
                .setContentText(text);
        mBuilder.setAutoCancel(true);

        int icon = getIcon(context);
        if (icon > 0) {
            mBuilder.setSmallIcon(icon);
        }

        Intent resultIntent = null;
        try {
            resultIntent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
            resultIntent.putExtra("notification", true);
        } catch (Exception e) {
            Log.d(TAG, "getActivity:" + e.toString());
        }

        PendingIntent myPendingIntent = PendingIntent.getActivity(context, 0, resultIntent, 0);

        mBuilder.setContentIntent(myPendingIntent);
        NotificationManager mNotificationManager = (NotificationManager) context.getSystemService("notification");

        mNotificationManager.notify(this.mId, mBuilder.build());
    }
}