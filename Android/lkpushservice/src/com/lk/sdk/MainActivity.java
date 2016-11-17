package com.lk.sdk;

import java.util.Calendar;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class MainActivity extends Activity {

	private LkNotificationManager mLkNotification;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        /*
        Calendar c = Calendar.getInstance();

        c.set(Calendar.YEAR, c.get(Calendar.YEAR));
        c.set(Calendar.MONTH, c.get(Calendar.MONTH));
        c.set(Calendar.DATE, c.get(Calendar.DATE));
        c.set(Calendar.HOUR_OF_DAY, c.get(Calendar.HOUR_OF_DAY));
        c.set(Calendar.MINUTE, c.get(Calendar.MINUTE) + 1);
        c.set(Calendar.SECOND, 0);

        Intent intent = new Intent(this, LKNotification.class);
        intent.putExtra("title", "this is my title");
        intent.putExtra("text", "this is my text,haha");
        PendingIntent pi = PendingIntent.getBroadcast(this, 0, intent, 0);

        AlarmManager am = (AlarmManager) getSystemService("alarm");

        am.set(0, c.getTimeInMillis(), pi);
 		*/
        
        Context context = this.getApplicationContext();
        mLkNotification = new LkNotificationManager();
        mLkNotification.notify(context, 1, "title", "text", 2016, 11, 0, 6, 12, 0, 0, 4);
        
    }

}