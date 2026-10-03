package com.gme.trtc.hardwareearmonitor.daisy;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.IBinder;
import com.gme.liteav.base.util.LiteavLog;

public class DaisyAudioKaraokeFeatureKit extends DaisyAudioFeaturesKit {
    private static final String ENGINE_CLASS_NAME = "com.huawei.multimedia.audioengine.HwAudioKaraokeFeatureService";
    private static final String TAG = "DaisyAudioKit.DaisyAudioKaraokeFeatureKit";
    private Context mContext;
    private DaisyFeatureKitManager mFeatureKitManager;
    private IDaisyAudioKaraokeFeature mIHwAudioKaraokeFeatureAidl;
    private boolean mIsServiceConnected = false;
    private IBinder mService = null;
    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            DaisyAudioKaraokeFeatureKit.this.mIHwAudioKaraokeFeatureAidl = IDaisyAudioKaraokeFeature.Stub.asInterface(iBinder);
            if (DaisyAudioKaraokeFeatureKit.this.mIHwAudioKaraokeFeatureAidl != null) {
                DaisyAudioKaraokeFeatureKit.this.mIsServiceConnected = true;
                DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = DaisyAudioKaraokeFeatureKit.this;
                if (daisyAudioKaraokeFeatureKit.serviceInit(daisyAudioKaraokeFeatureKit.mContext.getPackageName())) {
                    DaisyAudioKaraokeFeatureKit.this.mFeatureKitManager.onCallBack(1000);
                    DaisyAudioKaraokeFeatureKit.this.serviceLinkToDeath(iBinder);
                } else {
                    DaisyAudioKaraokeFeatureKit.this.mFeatureKitManager.onCallBack(1002);
                }
            }
        }

        @Override
        public final void onServiceDisconnected(ComponentName componentName) {
            DaisyAudioKaraokeFeatureKit.this.mIsServiceConnected = false;
            if (DaisyAudioKaraokeFeatureKit.this.mFeatureKitManager != null) {
                DaisyAudioKaraokeFeatureKit.this.mFeatureKitManager.onCallBack(1001);
            }
        }
    };
    private IBinder.DeathRecipient mDeathRecipient = new IBinder.DeathRecipient() {
        @Override
        public final void binderDied() {
            LiteavLog.m994e(DaisyAudioKaraokeFeatureKit.TAG, "binderDied");
            DaisyAudioKaraokeFeatureKit.this.mService.unlinkToDeath(DaisyAudioKaraokeFeatureKit.this.mDeathRecipient, 0);
            DaisyAudioKaraokeFeatureKit.this.mFeatureKitManager.onCallBack(1003);
            DaisyAudioKaraokeFeatureKit.this.mService = null;
        }
    };

    public enum ParameName {
        CMD_SET_AUDIO_EFFECT_MODE_BASE("Karaoke_reverb_mode="),
        CMD_SET_VOCAL_VOLUME_BASE("Karaoke_volume="),
        CMD_SET_VOCAL_EQUALIZER_MODE("Karaoke_eq_mode=");

        private String mParameName;

        ParameName(String str) {
            this.mParameName = str;
        }

        public final String getParameName() {
            return this.mParameName;
        }
    }

    protected DaisyAudioKaraokeFeatureKit(Context context) {
        this.mFeatureKitManager = null;
        this.mFeatureKitManager = DaisyFeatureKitManager.getInstance();
        this.mContext = context;
    }

    public void serviceLinkToDeath(IBinder iBinder) {
        this.mService = iBinder;
        if (iBinder != null) {
            try {
                iBinder.linkToDeath(this.mDeathRecipient, 0);
            } catch (Throwable unused) {
                this.mFeatureKitManager.onCallBack(1002);
                LiteavLog.m994e(TAG, "serviceLinkToDeath, RemoteException");
            }
        }
    }

    protected void initialize(Context context) {
        if (context == null) {
            return;
        }
        if (!DaisyFeatureKitManager.isAudioKitSupport(context)) {
            this.mFeatureKitManager.onCallBack(2);
        } else {
            bindService(context);
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

    public boolean isKaraokeFeatureSupport() {
        try {
            IDaisyAudioKaraokeFeature iDaisyAudioKaraokeFeature = this.mIHwAudioKaraokeFeatureAidl;
            if (iDaisyAudioKaraokeFeature != null && this.mIsServiceConnected) {
                return iDaisyAudioKaraokeFeature.isKaraokeFeatureSupport();
            }
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "isFeatureSupported,RemoteException ex : %s", th.getMessage());
        }
        return false;
    }

    public int enableKaraokeFeature(boolean z) {
        try {
            IDaisyAudioKaraokeFeature iDaisyAudioKaraokeFeature = this.mIHwAudioKaraokeFeatureAidl;
            if (iDaisyAudioKaraokeFeature == null || !this.mIsServiceConnected) {
                return -2;
            }
            return iDaisyAudioKaraokeFeature.enableKaraokeFeature(z);
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "enableKaraokeFeature,RemoteException ex : %s", th.getMessage());
            return -2;
        }
    }

    public int getKaraokeLatency() {
        try {
            IDaisyAudioKaraokeFeature iDaisyAudioKaraokeFeature = this.mIHwAudioKaraokeFeatureAidl;
            if (iDaisyAudioKaraokeFeature == null || !this.mIsServiceConnected) {
                return -1;
            }
            return iDaisyAudioKaraokeFeature.getKaraokeLatency();
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "getKaraokeLatency,RemoteException ex : %s", th.getMessage());
            return -1;
        }
    }

    public int setParameter(ParameName parameName, int i) {
        if (parameName == null) {
            return 1807;
        }
        try {
            IDaisyAudioKaraokeFeature iDaisyAudioKaraokeFeature = this.mIHwAudioKaraokeFeatureAidl;
            if (iDaisyAudioKaraokeFeature == null || !this.mIsServiceConnected) {
                return -2;
            }
            return iDaisyAudioKaraokeFeature.setParameter(parameName.getParameName(), i);
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "setParameter,RemoteException ex : %s", th.getMessage());
            return -2;
        }
    }

    public boolean serviceInit(String str) {
        try {
            IDaisyAudioKaraokeFeature iDaisyAudioKaraokeFeature = this.mIHwAudioKaraokeFeatureAidl;
            if (iDaisyAudioKaraokeFeature == null || !this.mIsServiceConnected) {
                return true;
            }
            iDaisyAudioKaraokeFeature.init(str);
            return true;
        } catch (Throwable th) {
            LiteavLog.m996e(TAG, "isFeatureSupported,RemoteException ex : %s", th.getMessage());
            return false;
        }
    }
}
