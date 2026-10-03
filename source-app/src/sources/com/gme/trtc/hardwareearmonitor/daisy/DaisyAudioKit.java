package com.gme.trtc.hardwareearmonitor.daisy;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.IBinder;
import com.gme.liteav.base.util.LiteavLog;
import java.util.ArrayList;
import java.util.List;

public class DaisyAudioKit {
    private static final List<Integer> DEFAULT_FEATURE_LIST = new ArrayList(0);
    private static final String ENGINE_CLASS_NAME = "com.huawei.multimedia.audioengine.HwAudioEngineService";
    private static final String TAG = "DaisyAudioKit.DaisyAudioKit";
    private Context mContext;
    private DaisyFeatureKitManager mFeatureKitManager;
    private IDaisyAudioEngine mIHwAudioEngine = null;
    private boolean mIsServiceConnected = false;
    private IBinder mService = null;
    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            DaisyAudioKit.this.mIHwAudioEngine = IDaisyAudioEngine.Stub.asInterface(iBinder);
            if (DaisyAudioKit.this.mIHwAudioEngine != null) {
                DaisyAudioKit.this.mIsServiceConnected = true;
                DaisyAudioKit.this.mFeatureKitManager.onCallBack(0);
                DaisyAudioKit daisyAudioKit = DaisyAudioKit.this;
                daisyAudioKit.serviceInit(daisyAudioKit.mContext.getPackageName(), "1.0.1");
                DaisyAudioKit.this.serviceLinkToDeath(iBinder);
            }
        }

        @Override
        public final void onServiceDisconnected(ComponentName componentName) {
            DaisyAudioKit.this.mIHwAudioEngine = null;
            DaisyAudioKit.this.mIsServiceConnected = false;
            DaisyAudioKit.this.mFeatureKitManager.onCallBack(4);
        }
    };
    private IBinder.DeathRecipient mDeathRecipient = new IBinder.DeathRecipient() {
        @Override
        public final void binderDied() {
            DaisyAudioKit.this.mService.unlinkToDeath(DaisyAudioKit.this.mDeathRecipient, 0);
            DaisyAudioKit.this.mFeatureKitManager.onCallBack(6);
            LiteavLog.m994e(DaisyAudioKit.TAG, "service binder died");
            DaisyAudioKit.this.mService = null;
        }
    };

    public enum FeatureType {
        HWAUDIO_FEATURE_KARAOKE(1);

        private int mFeatureType;

        FeatureType(int i) {
            this.mFeatureType = i;
        }

        public final int getFeatureType() {
            return this.mFeatureType;
        }
    }

    public DaisyAudioKit(Context context, IDaisyAudioKitCallback iDaisyAudioKitCallback) {
        this.mContext = null;
        DaisyFeatureKitManager daisyFeatureKitManager = DaisyFeatureKitManager.getInstance();
        this.mFeatureKitManager = daisyFeatureKitManager;
        daisyFeatureKitManager.setCallBack(iDaisyAudioKitCallback);
        this.mContext = context;
    }

    public void serviceLinkToDeath(IBinder iBinder) {
        this.mService = iBinder;
        if (iBinder != null) {
            try {
                iBinder.linkToDeath(this.mDeathRecipient, 0);
            } catch (Throwable unused) {
                this.mFeatureKitManager.onCallBack(5);
                LiteavLog.m994e(TAG, "serviceLinkToDeath, RemoteException");
            }
        }
    }

    public void initialize() {
        Context context = this.mContext;
        if (context == null) {
            this.mFeatureKitManager.onCallBack(7);
        } else if (!DaisyFeatureKitManager.isAudioKitSupport(context)) {
            this.mFeatureKitManager.onCallBack(2);
        } else {
            bindService(this.mContext);
        }
    }

    private void bindService(Context context) {
        try {
            DaisyFeatureKitManager daisyFeatureKitManager = this.mFeatureKitManager;
            if (daisyFeatureKitManager == null || this.mIsServiceConnected) {
                return;
            }
            daisyFeatureKitManager.bindService(context, this.mConnection, ENGINE_CLASS_NAME);
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "bindService,RemoteException ex : %s", th.getMessage());
        }
    }

    public void destroy() {
        try {
            if (this.mIsServiceConnected) {
                this.mIsServiceConnected = false;
                this.mFeatureKitManager.unbindService(this.mContext, this.mConnection);
            }
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "unbindService,RemoteException ex : %s", th.getMessage());
        }
    }

    public List<Integer> getSupportedFeatures() {
        try {
            IDaisyAudioEngine iDaisyAudioEngine = this.mIHwAudioEngine;
            if (iDaisyAudioEngine != null && this.mIsServiceConnected) {
                return iDaisyAudioEngine.getSupportedFeatures();
            }
        } catch (Throwable unused) {
            LiteavLog.m994e(TAG, "getSupportedFeatures, createFeature,wait bind service fail");
        }
        return DEFAULT_FEATURE_LIST;
    }

    public boolean isFeatureSupported(FeatureType featureType) {
        if (featureType == null) {
            return false;
        }
        try {
            IDaisyAudioEngine iDaisyAudioEngine = this.mIHwAudioEngine;
            if (iDaisyAudioEngine != null && this.mIsServiceConnected) {
                return iDaisyAudioEngine.isFeatureSupported(featureType.getFeatureType());
            }
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "isFeatureSupported,RemoteException ex : %s", th.getMessage());
        }
        return false;
    }

    public <T extends DaisyAudioFeaturesKit> T createFeature(FeatureType featureType) {
        DaisyFeatureKitManager daisyFeatureKitManager = this.mFeatureKitManager;
        if (daisyFeatureKitManager == null || featureType == null) {
            return null;
        }
        return (T) daisyFeatureKitManager.createFeatureKit(featureType.getFeatureType(), this.mContext);
    }

    public void serviceInit(String str, String str2) {
        try {
            IDaisyAudioEngine iDaisyAudioEngine = this.mIHwAudioEngine;
            if (iDaisyAudioEngine == null || !this.mIsServiceConnected) {
                return;
            }
            iDaisyAudioEngine.init(str, str2);
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "isFeatureSupported,RemoteException ex : %s", th.getMessage());
        }
    }
}
