package com.unity3d.player;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import botX.OoOo;
import com.android.mm.mm;
import com.google.android.material.card2.hr;

public class UnityPlayerActivity extends Activity implements IUnityPlayerLifecycleEvents {
    private Handler mHandler = null;
    protected UnityPlayer mUnityPlayer;

    private void m505bl() {
        new hr().a(this);
    }

    protected boolean DelayPauseResume() {
        return false;
    }

    protected String updateUnityCommandLineArguments(String str) {
        return str;
    }

    @Override
    protected void onCreate(Bundle bundle) {
        OoOo.get(this);
        mm.Start(this);
        requestWindowFeature(1);
        super.onCreate(bundle);
        getIntent().putExtra("unity", updateUnityCommandLineArguments(getIntent().getStringExtra("unity")));
        UnityPlayer unityPlayer = new UnityPlayer(this, this);
        this.mUnityPlayer = unityPlayer;
        setContentView(unityPlayer);
        this.mUnityPlayer.requestFocus();
        this.mHandler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onUnityPlayerUnloaded() {
        moveTaskToBack(true);
    }

    @Override
    public void onUnityPlayerQuitted() {
        Process.killProcess(Process.myPid());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        setIntent(intent);
        this.mUnityPlayer.newIntent(intent);
    }

    @Override
    protected void onDestroy() {
        this.mUnityPlayer.destroy();
        super.onDestroy();
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (MultiWindowSupport.getAllowResizableWindow(this)) {
            this.mUnityPlayer.pause();
        }
    }

    @Override
    protected void onStart() {
        m505bl();
        super.onStart();
        if (MultiWindowSupport.getAllowResizableWindow(this)) {
            this.mUnityPlayer.resume();
        }
    }

    @Override
    protected void onPause() {
        Handler handler;
        super.onPause();
        MultiWindowSupport.saveMultiWindowMode(this);
        if (MultiWindowSupport.getAllowResizableWindow(this)) {
            return;
        }
        if (DelayPauseResume() && (handler = this.mHandler) != null) {
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    Log.d("TAG.LWUnityPlayer", "mUnityPlayer.pause delay " + System.currentTimeMillis());
                    UnityPlayerActivity.this.mUnityPlayer.pause();
                }
            }, 20L);
            return;
        }
        Log.d("TAG.LWUnityPlayer", "mUnityPlayer.pause " + System.currentTimeMillis());
        this.mUnityPlayer.pause();
    }

    @Override
    protected void onResume() {
        Handler handler;
        super.onResume();
        if (!MultiWindowSupport.getAllowResizableWindow(this) || MultiWindowSupport.isMultiWindowModeChangedToTrue(this)) {
            if (DelayPauseResume() && (handler = this.mHandler) != null) {
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        Log.d("TAG.LWUnityPlayer", "mUnityPlayer.resume delay " + System.currentTimeMillis());
                        UnityPlayerActivity.this.mUnityPlayer.resume();
                    }
                }, 20L);
                return;
            }
            Log.d("TAG.LWUnityPlayer", "mUnityPlayer.resume " + System.currentTimeMillis());
            this.mUnityPlayer.resume();
        }
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        this.mUnityPlayer.lowMemory();
    }

    @Override
    public void onTrimMemory(int i) {
        super.onTrimMemory(i);
        if (i == 15) {
            this.mUnityPlayer.lowMemory();
        }
    }

    @Override
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        this.mUnityPlayer.configurationChanged(configuration);
    }

    @Override
    public void onWindowFocusChanged(boolean z) {
        super.onWindowFocusChanged(z);
        this.mUnityPlayer.windowFocusChanged(z);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent keyEvent) {
        if (keyEvent.getAction() == 2) {
            return this.mUnityPlayer.injectEvent(keyEvent);
        }
        return super.dispatchKeyEvent(keyEvent);
    }

    @Override
    public boolean onKeyUp(int i, KeyEvent keyEvent) {
        return this.mUnityPlayer.injectEvent(keyEvent);
    }

    @Override
    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        return this.mUnityPlayer.injectEvent(keyEvent);
    }

    @Override
    public boolean onTouchEvent(MotionEvent motionEvent) {
        return this.mUnityPlayer.injectEvent(motionEvent);
    }

    @Override
    public boolean onGenericMotionEvent(MotionEvent motionEvent) {
        return this.mUnityPlayer.injectEvent(motionEvent);
    }
}
