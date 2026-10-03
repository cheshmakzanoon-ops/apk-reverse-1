package com.gme.trtc.hardwareearmonitor.honor;

import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;

public class HonorFeatureKitManager {
    private static final String ENGINE_PACKAGE_NAME = "com.hihonor.android.magicx.media.audioengine";
    private static final int PACKAGE_INFO_FLAG = 0;
    private static final int SUB_VERSION_MASK = 1000;
    private static final String TAG = "HnAudioEngine.FeatureKitManager";
    public static long mMinVersion;
    private static HonorFeatureKitManager sInstance;
    private IHonorAudioServiceCallback mCallBack = null;
    private static final Object SET_CALL_BACK_LOCK = new Object();
    private static final Object NEW_FEATUREMANAGER_LOCK = new Object();
    private static final Object BIND_SERVICE_LOCK = new Object();
    private static final Object UNBIND_SERVICE_LOCK = new Object();

    private HonorFeatureKitManager() {
    }

    public static HonorFeatureKitManager getInstance() {
        HonorFeatureKitManager honorFeatureKitManager;
        synchronized (NEW_FEATUREMANAGER_LOCK) {
            if (sInstance == null) {
                sInstance = new HonorFeatureKitManager();
            }
            honorFeatureKitManager = sInstance;
        }
        return honorFeatureKitManager;
    }

    public <T extends HonorAudioFeaturesKit> T createFeatureKit(int i, Context context) {
        HonorLogUtils.info(TAG, "createFeatureKit, type =".concat(String.valueOf(i)));
        if (context == null) {
            return null;
        }
        if (i == 1) {
            HonorEarReturnClient honorEarReturnClient = new HonorEarReturnClient(context);
            honorEarReturnClient.initialize(context);
            return honorEarReturnClient;
        }
        if (i != 2) {
            if (i == 3) {
                HonorAudioPlayClient honorAudioPlayClient = new HonorAudioPlayClient(context);
                honorAudioPlayClient.initialize(context);
                return honorAudioPlayClient;
            }
            if (i != 4) {
                HonorLogUtils.info(TAG, "createFeatureKit, type error");
                return null;
            }
        }
        HonorAdvancedRecordClient honorAdvancedRecordClient = new HonorAdvancedRecordClient(context);
        honorAdvancedRecordClient.initialize(context);
        return honorAdvancedRecordClient;
    }

    public void bindService(Context context, ServiceConnection serviceConnection, String str) {
        synchronized (BIND_SERVICE_LOCK) {
            if (context == null) {
                return;
            }
            Intent intent = new Intent();
            intent.setClassName(ENGINE_PACKAGE_NAME, str);
            try {
                HonorLogUtils.info(TAG, "bindService");
                context.bindService(intent, serviceConnection, 1);
            } catch (Throwable th) {
                HonorLogUtils.error(TAG, "bindService, SecurityException, " + th.getMessage());
            }
        }
    }

    public void unbindService(Context context, ServiceConnection serviceConnection) {
        HonorLogUtils.info(TAG, "unbindService");
        synchronized (UNBIND_SERVICE_LOCK) {
            if (context != null) {
                context.unbindService(serviceConnection);
            }
        }
    }

    public static boolean isAudioKitSupport(Context context) {
        if (context == null) {
            HonorLogUtils.error(TAG, "context is null");
            return false;
        }
        PackageManager packageManager = context.getPackageManager();
        try {
            if (packageManager == null) {
                HonorLogUtils.error(TAG, "packageManager is null");
                return false;
            }
            int i = packageManager.getPackageInfo(ENGINE_PACKAGE_NAME, 0).versionCode / 1000;
            long j = i;
            if (j > 1000001) {
                j = 1000001;
            }
            mMinVersion = j;
            HonorLogUtils.info(TAG, " isDeviceSupport is true, enginVersionCode=" + i + " audioKitVersionCode=1000001");
            return true;
        } catch (Throwable unused) {
            HonorLogUtils.error(TAG, "isAudioKitSupport ,NameNotFoundException");
            return false;
        }
    }

    public void onCallBack(int i) {
        HonorLogUtils.info(TAG, "onCallBack, result =".concat(String.valueOf(i)));
        synchronized (SET_CALL_BACK_LOCK) {
            if (getCallBack() != null) {
                getCallBack().onResult(i);
            }
        }
    }

    public void setCallBack(IHonorAudioServiceCallback iHonorAudioServiceCallback) {
        this.mCallBack = iHonorAudioServiceCallback;
    }

    protected IHonorAudioServiceCallback getCallBack() {
        return this.mCallBack;
    }
}
