package com.sdkmanager.notify;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.content.Context;
import android.util.Log;

public class NotificationJobService extends JobService {
    @Override
    public boolean onStopJob(JobParameters jobParameters) {
        return false;
    }

    @Override
    public boolean onStartJob(JobParameters jobParameters) {
        try {
            Context applicationContext = getApplicationContext();
            new LocalNotificationManager(applicationContext).fireNotificationNew2(applicationContext, jobParameters);
            return false;
        } catch (Exception unused) {
            Log.e("IFJobService", "Exception in NotificationService onStartJob");
            return false;
        }
    }
}
