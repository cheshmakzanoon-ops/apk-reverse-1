package com.jakewharton.processphoenix;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.widget.FrameLayout;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class ProcessPhoenix extends Activity {
    private static final String KEY_MAIN_PROCESS_PID = "phoenix_main_process_pid";
    public static final String KEY_RESTART_DATA = "RESTART_DATA";
    private static final String KEY_RESTART_INTENTS = "phoenix_restart_intents";
    private final Handler m_handler = new Handler(Looper.getMainLooper());
    private Intent[] m_itLaunchs;

    public static void triggerRebirth(Context context, String str) {
        triggerRebirth(context, getRestartIntent(context, str));
    }

    public static void triggerRebirth(Context context, Intent... intentArr) {
        if (intentArr.length < 1) {
            throw new IllegalArgumentException("intents cannot be empty");
        }
        intentArr[0].addFlags(268468224);
        Intent intent = new Intent(context, (Class<?>) ProcessPhoenix.class);
        intent.addFlags(268435456);
        intent.putParcelableArrayListExtra(KEY_RESTART_INTENTS, new ArrayList<>(Arrays.asList(intentArr)));
        intent.putExtra(KEY_MAIN_PROCESS_PID, Process.myPid());
        context.startActivity(intent);
    }

    private static Intent getRestartIntent(Context context, String str) {
        String packageName = context.getPackageName();
        Intent launchIntentForPackage = context.getPackageManager().getLaunchIntentForPackage(packageName);
        if (launchIntentForPackage != null) {
            launchIntentForPackage.putExtra(KEY_RESTART_DATA, str);
            return launchIntentForPackage;
        }
        throw new IllegalStateException("Unable to determine default activity for " + packageName + ". Does an activity specify the DEFAULT category in its intent filter?");
    }

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Process.killProcess(getIntent().getIntExtra(KEY_MAIN_PROCESS_PID, -1));
        ArrayList parcelableArrayListExtra = getIntent().getParcelableArrayListExtra(KEY_RESTART_INTENTS);
        setContentView(new FrameLayout(this));
        this.m_itLaunchs = (Intent[]) parcelableArrayListExtra.toArray(new Intent[0]);
    }

    @Override
    protected void onPostCreate(Bundle bundle) {
        super.onPostCreate(bundle);
        this.m_handler.post(new Runnable() {
            @Override
            public void run() {
                ProcessPhoenix processPhoenix = ProcessPhoenix.this;
                processPhoenix.startActivities(processPhoenix.m_itLaunchs);
                ProcessPhoenix.this.finish();
            }
        });
    }

    @Override
    protected void onDestroy() {
        this.m_handler.removeCallbacks(null);
        Runtime.getRuntime().exit(0);
        super.onDestroy();
    }

    public static boolean isPhoenixProcess(Context context) {
        int iMyPid = Process.myPid();
        List<ActivityManager.RunningAppProcessInfo> runningAppProcesses = ((ActivityManager) context.getSystemService("activity")).getRunningAppProcesses();
        if (runningAppProcesses == null) {
            return false;
        }
        for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : runningAppProcesses) {
            if (runningAppProcessInfo.pid == iMyPid && runningAppProcessInfo.processName.endsWith(":phoenix")) {
                return true;
            }
        }
        return false;
    }
}
