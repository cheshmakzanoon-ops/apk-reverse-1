package com.example.updateandinstall;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class ApkInstallReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals("android.intent.action.DOWNLOAD_COMPLETE") && intent.getLongExtra("extra_download_id", -1L) == SpUtils.getInstance(context).getLong("downloadId", -1L)) {
            UpdateManager.getInstance().downloadApk();
        }
    }
}
