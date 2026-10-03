package com.gme.trtc.hardwareearmonitor.honor;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.Binder;
import android.os.IBinder;

public class HonorAdvancedRecordClient extends HonorAudioFeaturesKit {
    private static final String ENGINE_CLASS_NAME = "com.hihonor.android.magicx.media.audioengine.HnAdvancedRecordServiceImpl";
    private static final String TAG = "HnAudioService.HnAdvancedRecordClient";
    private Context mContext;
    private HonorFeatureKitManager mFeatureKitManager;
    private boolean mIsServiceConnected = false;
    private IHonorAdvancedRecordService mHnAdvancedRecordService = null;
    private IBinder mService = null;
    private final IBinder mClientBinder = new Binder();
    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            HonorAdvancedRecordClient.this.mHnAdvancedRecordService = IHonorAdvancedRecordService.Stub.asInterface(iBinder);
            HonorLogUtils.info(HonorAdvancedRecordClient.TAG, "HnAdvancedRecordClient onServiceConnected");
            if (HonorAdvancedRecordClient.this.mHnAdvancedRecordService != null) {
                HonorAdvancedRecordClient.this.mIsServiceConnected = true;
                HonorLogUtils.info(HonorAdvancedRecordClient.TAG, "HnAdvancedRecordClient onServiceConnected, mIHnAdvancedRecordService is not null");
                HonorAdvancedRecordClient.this.mFeatureKitManager.onCallBack(HonorResultCode.ADVANCED_RECORD_SUCCESS);
                HonorAdvancedRecordClient honorAdvancedRecordClient = HonorAdvancedRecordClient.this;
                honorAdvancedRecordClient.serviceInit(honorAdvancedRecordClient.mContext.getPackageName());
                HonorAdvancedRecordClient.this.serviceLinkToDeath(iBinder);
            }
        }

        @Override
        public final void onServiceDisconnected(ComponentName componentName) {
            HonorLogUtils.info(HonorAdvancedRecordClient.TAG, "HnAdvancedRecordClient onServiceDisconnected");
            HonorAdvancedRecordClient.this.mHnAdvancedRecordService = null;
            HonorAdvancedRecordClient.this.mIsServiceConnected = false;
            HonorAdvancedRecordClient.this.mFeatureKitManager.onCallBack(HonorResultCode.ADVANCED_RECORD_DISCONNECTED);
        }
    };
    private IBinder.DeathRecipient mDeathRecipient = new IBinder.DeathRecipient() {
        @Override
        public final void binderDied() {
            HonorAdvancedRecordClient.this.mService.unlinkToDeath(HonorAdvancedRecordClient.this.mDeathRecipient, 0);
            HonorAdvancedRecordClient.this.mFeatureKitManager.onCallBack(6);
            HonorLogUtils.error(HonorAdvancedRecordClient.TAG, "service binder died");
            HonorAdvancedRecordClient.this.mService = null;
        }
    };

    public void serviceLinkToDeath(IBinder iBinder) {
        this.mService = iBinder;
        if (iBinder != null) {
            try {
                iBinder.linkToDeath(this.mDeathRecipient, 0);
            } catch (Throwable unused) {
                this.mFeatureKitManager.onCallBack(HonorResultCode.ADVANCED_RECORD_SERVICE_LINKFAIL);
                HonorLogUtils.error(TAG, "serviceLinkToDeath, RemoteException");
            }
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        HonorLogUtils.info(TAG, "destroy, HnAdvancedRecordClient mIsServiceConnected = " + this.mIsServiceConnected);
        if (this.mIsServiceConnected) {
            this.mIsServiceConnected = false;
            this.mFeatureKitManager.unbindService(this.mContext, this.mConnection);
        }
    }

    public void serviceInit(String str) {
        HonorLogUtils.info(TAG, "HnAdvancedRecordClient serviceInit");
        try {
            IHonorAdvancedRecordService iHonorAdvancedRecordService = this.mHnAdvancedRecordService;
            if (iHonorAdvancedRecordService == null || !this.mIsServiceConnected) {
                return;
            }
            iHonorAdvancedRecordService.init(str);
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "HnAdvancedRecordClient isSupported,RemoteException ex :" + th.getMessage());
        }
    }

    public HonorAdvancedRecordClient(Context context) {
        this.mFeatureKitManager = null;
        this.mFeatureKitManager = HonorFeatureKitManager.getInstance();
        this.mContext = context;
    }

    public void initialize(Context context) {
        HonorLogUtils.info(TAG, "HnAdvancedRecordClient initialize");
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
        HonorLogUtils.info(TAG, "HnAdvancedRecordClient bindService");
        HonorFeatureKitManager honorFeatureKitManager = this.mFeatureKitManager;
        if (honorFeatureKitManager == null || this.mIsServiceConnected) {
            return;
        }
        honorFeatureKitManager.bindService(context, this.mConnection, ENGINE_CLASS_NAME);
    }

    public boolean enableAdvancedRecord(Context context) {
        HonorLogUtils.info(TAG, "HnAdvancedRecordClient enableAdvancedRecord");
        try {
            IHonorAdvancedRecordService iHonorAdvancedRecordService = this.mHnAdvancedRecordService;
            if (iHonorAdvancedRecordService == null || !this.mIsServiceConnected) {
                return false;
            }
            return iHonorAdvancedRecordService.enableAdvancedRecord();
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "enableAdvancedRecord failed, RemoteException ex : " + th.getMessage());
            return false;
        }
    }

    public boolean disableAdvancedRecord(Context context) {
        HonorLogUtils.info(TAG, "HnAdvancedRecordClient disableAdvancedRecord mIsServiceConnected=" + this.mIsServiceConnected);
        try {
            IHonorAdvancedRecordService iHonorAdvancedRecordService = this.mHnAdvancedRecordService;
            if (iHonorAdvancedRecordService == null || !this.mIsServiceConnected) {
                return false;
            }
            return iHonorAdvancedRecordService.disableAdvancedRecord();
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "disableAdvancedRecord failed, RemoteException ex : " + th.getMessage());
            return false;
        }
    }

    @Override
    public boolean isServiceSupported() {
        HonorLogUtils.info(TAG, "HnAdvancedRecordClient isSupported, type = " + HonorAudioClient.ServiceType.HNAUDIO_SERVICE_ADVANCEDRECORD.getServiceType() + ",mIsServiceConnected=" + this.mIsServiceConnected);
        try {
            IHonorAdvancedRecordService iHonorAdvancedRecordService = this.mHnAdvancedRecordService;
            if (iHonorAdvancedRecordService != null && this.mIsServiceConnected) {
                return iHonorAdvancedRecordService.isSupported(HonorAudioClient.ServiceType.HNAUDIO_SERVICE_ADVANCEDRECORD.getServiceType());
            }
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "isSupported,RemoteException ex : " + th.getMessage());
        }
        return super.isServiceSupported();
    }

    public int enableRecordDenoise(boolean z, DenoiseMode denoiseMode, DenoiseScene denoiseScene, DenoiseLevel denoiseLevel) {
        if (HonorFeatureKitManager.mMinVersion < 1000001) {
            HonorLogUtils.error(TAG, "enable record denoise fail, mix version is " + HonorFeatureKitManager.mMinVersion);
            return HonorResultCode.RECORD_DENOISE_SERVICE_UNSUPPORTED;
        }
        try {
            IHonorAdvancedRecordService iHonorAdvancedRecordService = this.mHnAdvancedRecordService;
            if (iHonorAdvancedRecordService == null || !this.mIsServiceConnected) {
                return -2;
            }
            return iHonorAdvancedRecordService.enableRecordDenoise(z, denoiseMode.getMode(), denoiseScene.getScene(), denoiseLevel.getLevel(), this.mClientBinder);
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "enableRecordDenoise,RemoteException ex : " + th.getMessage());
            return -2;
        }
    }

    public enum DenoiseMode {
        DENOISE_NN_MODE(1);

        private final int mDenoiseMode;

        DenoiseMode(int i) {
            this.mDenoiseMode = i;
        }

        public final int getMode() {
            return this.mDenoiseMode;
        }
    }

    public enum DenoiseScene {
        DENOISE_SPEAK_SCENE(1);

        private final int mDenoiseScene;

        DenoiseScene(int i) {
            this.mDenoiseScene = i;
        }

        public final int getScene() {
            return this.mDenoiseScene;
        }
    }

    public enum DenoiseLevel {
        DENOISE_DEFAULT_LEVEL(1);

        private final int mDenoiseLevel;

        DenoiseLevel(int i) {
            this.mDenoiseLevel = i;
        }

        public final int getLevel() {
            return this.mDenoiseLevel;
        }
    }
}
