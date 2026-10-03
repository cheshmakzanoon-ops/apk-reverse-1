package com.gme.trtc.hardwareearmonitor.honor;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.IBinder;

public class HonorAudioPlayClient extends HonorAudioFeaturesKit {
    private static final String ENGINE_CLASS_NAME = "com.hihonor.android.magicx.media.audioengine.HnAudioPlayServiceImpl";
    private static final String TAG = "HnAudioEngine.HnAudioPlayClient";
    private Context mContext;
    private HonorFeatureKitManager mFeatureKitManager;
    private IHonorAudioPlayService mHnAudioPlayService;
    private boolean mIsServiceConnected = false;
    private IBinder mService = null;
    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            HonorLogUtils.info(HonorAudioPlayClient.TAG, "onServiceConnected");
            HonorAudioPlayClient.this.mHnAudioPlayService = IHonorAudioPlayService.Stub.asInterface(iBinder);
            if (HonorAudioPlayClient.this.mHnAudioPlayService != null) {
                HonorAudioPlayClient.this.mIsServiceConnected = true;
                HonorAudioPlayClient honorAudioPlayClient = HonorAudioPlayClient.this;
                honorAudioPlayClient.serviceInit(honorAudioPlayClient.mContext.getPackageName());
                HonorAudioPlayClient.this.serviceLinkToDeath(iBinder);
                HonorAudioPlayClient.this.mFeatureKitManager.onCallBack(3000);
            }
        }

        @Override
        public final void onServiceDisconnected(ComponentName componentName) {
            HonorLogUtils.info(HonorAudioPlayClient.TAG, "onServiceDisconnected");
            HonorAudioPlayClient.this.mIsServiceConnected = false;
            if (HonorAudioPlayClient.this.mFeatureKitManager != null) {
                HonorAudioPlayClient.this.mFeatureKitManager.onCallBack(HonorResultCode.AUDIO_PLAY_SERVICE_DISCONNECTED);
            }
        }
    };
    private IBinder.DeathRecipient mDeathRecipient = new IBinder.DeathRecipient() {
        @Override
        public final void binderDied() {
            HonorAudioPlayClient.this.mService.unlinkToDeath(HonorAudioPlayClient.this.mDeathRecipient, 0);
            HonorAudioPlayClient.this.mFeatureKitManager.onCallBack(HonorResultCode.AUDIO_PLAY_SERVICE_DIED);
            HonorLogUtils.error(HonorAudioPlayClient.TAG, "service binder died");
            HonorAudioPlayClient.this.mService = null;
        }
    };

    public HonorAudioPlayClient(Context context) {
        this.mFeatureKitManager = null;
        this.mFeatureKitManager = HonorFeatureKitManager.getInstance();
        this.mContext = context;
    }

    public void serviceInit(String str) {
        HonorLogUtils.info(TAG, "HnAudioPlayClient serviceInit");
        try {
            IHonorAudioPlayService iHonorAudioPlayService = this.mHnAudioPlayService;
            if (iHonorAudioPlayService == null || !this.mIsServiceConnected) {
                return;
            }
            iHonorAudioPlayService.init(str);
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "HnAudioPlayClient isSupported,RemoteException ex :" + th.getMessage());
        }
    }

    public void serviceLinkToDeath(IBinder iBinder) {
        this.mService = iBinder;
        if (iBinder != null) {
            try {
                iBinder.linkToDeath(this.mDeathRecipient, 0);
            } catch (Throwable unused) {
                this.mFeatureKitManager.onCallBack(HonorResultCode.AUDIO_PLAY_SERVICE_LINKFAILED);
                HonorLogUtils.error(TAG, "serviceLinkToDeath, RemoteException");
            }
        }
    }

    public void initialize(Context context) {
        if (context == null) {
            HonorLogUtils.info(TAG, "initialize, context is null");
        } else if (!HonorFeatureKitManager.isAudioKitSupport(context)) {
            this.mFeatureKitManager.onCallBack(2);
            HonorLogUtils.info(TAG, "initialize, not install AudioEngine");
        } else {
            bindService(context);
        }
    }

    private void bindService(Context context) {
        HonorLogUtils.info(TAG, "bindService");
        HonorFeatureKitManager honorFeatureKitManager = this.mFeatureKitManager;
        if (honorFeatureKitManager == null || this.mIsServiceConnected) {
            return;
        }
        honorFeatureKitManager.bindService(context, this.mConnection, ENGINE_CLASS_NAME);
    }

    public void enableHighSampleRatePlay(boolean z) {
        if (HonorFeatureKitManager.mMinVersion < 1000001) {
            HonorLogUtils.error(TAG, "not support high sample rate play service. The mix version is " + HonorFeatureKitManager.mMinVersion);
            this.mFeatureKitManager.onCallBack(HonorResultCode.HIGHSAMPLERATE_PLAY_SERVICE_UNSUPPORTED);
            return;
        }
        HonorLogUtils.info(TAG, "enableHighSampleRatePlay, enable = ".concat(String.valueOf(z)));
        try {
            IHonorAudioPlayService iHonorAudioPlayService = this.mHnAudioPlayService;
            if (iHonorAudioPlayService == null || !this.mIsServiceConnected) {
                return;
            }
            iHonorAudioPlayService.enableHighSampleRatePlay(z);
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "enableHighSampleRatePlay,RemoteException ex : " + th.getMessage());
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        HonorLogUtils.info(TAG, "destroy, mIsServiceConnected = " + this.mIsServiceConnected);
        if (this.mIsServiceConnected) {
            this.mIsServiceConnected = false;
            this.mFeatureKitManager.unbindService(this.mContext, this.mConnection);
        }
    }
}
