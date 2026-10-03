package com.gme.trtc.hardwareearmonitor.honor;

import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.IBinder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

public class HonorAudioClient {
    private static final List<Integer> DEFAULT_FEATURE_LIST = new ArrayList(0);
    private static final int DEFAULT_VALUE = 0;
    private static final String ENGINE_CLASS_NAME = "com.hihonor.android.magicx.media.audioengine.HnAudioServiceImpl";
    private static final String ENGINE_PACKAGE_NAME = "com.hihonor.android.magicx.media.audioengine";
    private static final String TAG = "HnAudioEngine.HnAudioClient";
    private Context mContext;
    private HonorFeatureKitManager mFeatureKitManager;
    private IHonorAudioService mIHnAudioService = null;
    private boolean mIsServiceConnected = false;
    private IBinder mService = null;
    private List<Integer> mSupportedServiceList = new ArrayList();
    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public final void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            HonorAudioClient.this.mIHnAudioService = IHonorAudioService.Stub.asInterface(iBinder);
            HonorLogUtils.info(HonorAudioClient.TAG, "onServiceConnected");
            if (HonorAudioClient.this.mIHnAudioService != null) {
                HonorAudioClient.this.mIsServiceConnected = true;
                HonorLogUtils.info(HonorAudioClient.TAG, "onServiceConnected, mIHnAudioService is not null");
                HonorAudioClient.this.mFeatureKitManager.onCallBack(0);
                HonorAudioClient honorAudioClient = HonorAudioClient.this;
                honorAudioClient.serviceInit(honorAudioClient.mContext.getPackageName(), HonorVersion.SDK_VERSION_NAME);
                HonorAudioClient.this.serviceLinkToDeath(iBinder);
            }
        }

        @Override
        public final void onServiceDisconnected(ComponentName componentName) {
            HonorLogUtils.info(HonorAudioClient.TAG, "onServiceDisconnected");
            HonorAudioClient.this.mIHnAudioService = null;
            HonorAudioClient.this.mIsServiceConnected = false;
            HonorAudioClient.this.mFeatureKitManager.onCallBack(4);
        }
    };
    private IBinder.DeathRecipient mDeathRecipient = new IBinder.DeathRecipient() {
        @Override
        public final void binderDied() {
            HonorAudioClient.this.mService.unlinkToDeath(HonorAudioClient.this.mDeathRecipient, 0);
            HonorAudioClient.this.mFeatureKitManager.onCallBack(6);
            HonorLogUtils.error(HonorAudioClient.TAG, "service binder died");
            HonorAudioClient.this.mService = null;
        }
    };

    public enum ServiceType {
        HNAUDIO_SERVICE_EARRETURN(1),
        HNAUDIO_SERVICE_ADVANCEDRECORD(2),
        HNAUDIO_SERVICE_HIGHSAMPLERATEPLAY(3),
        HNAUDIO_SERVICE_RECORDDENOISE(4);

        private int mServiceType;

        ServiceType(int i) {
            this.mServiceType = i;
        }

        public final int getServiceType() {
            return this.mServiceType;
        }
    }

    public HonorAudioClient(Context context, IHonorAudioServiceCallback iHonorAudioServiceCallback) {
        HonorFeatureKitManager honorFeatureKitManager = HonorFeatureKitManager.getInstance();
        this.mFeatureKitManager = honorFeatureKitManager;
        this.mContext = null;
        honorFeatureKitManager.setCallBack(iHonorAudioServiceCallback);
        this.mContext = context;
    }

    public void serviceLinkToDeath(IBinder iBinder) {
        this.mService = iBinder;
        if (iBinder != null) {
            try {
                iBinder.linkToDeath(this.mDeathRecipient, 0);
            } catch (Throwable unused) {
                this.mFeatureKitManager.onCallBack(5);
                HonorLogUtils.error(TAG, "serviceLinkToDeath, RemoteException");
            }
        }
    }

    public void initialize() {
        HonorLogUtils.info(TAG, "initialize");
        Context context = this.mContext;
        if (context == null) {
            HonorLogUtils.info(TAG, "mContext is null");
            this.mFeatureKitManager.onCallBack(7);
        } else if (!HonorFeatureKitManager.isAudioKitSupport(context)) {
            HonorLogUtils.info(TAG, "not install AudioKitEngine");
            this.mFeatureKitManager.onCallBack(2);
        } else {
            bindService(this.mContext);
        }
    }

    private void bindService(Context context) {
        HonorLogUtils.info(TAG, "bindService, mIsServiceConnected = " + this.mIsServiceConnected);
        try {
            HonorFeatureKitManager honorFeatureKitManager = this.mFeatureKitManager;
            if (honorFeatureKitManager == null || this.mIsServiceConnected) {
                return;
            }
            honorFeatureKitManager.bindService(context, this.mConnection, ENGINE_CLASS_NAME);
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "bindService,RemoteException ex : " + th.getMessage());
        }
    }

    public void destroy() {
        HonorLogUtils.info(TAG, "destroy, mIsServiceConnected = " + this.mIsServiceConnected);
        try {
            if (this.mIsServiceConnected) {
                this.mIsServiceConnected = false;
                this.mFeatureKitManager.unbindService(this.mContext, this.mConnection);
            }
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "unbindService,RemoteException ex : " + th.getMessage());
        }
    }

    public static boolean isDeviceSupported(Context context) {
        return HonorFeatureKitManager.isAudioKitSupport(context);
    }

    public List<Integer> getSupportedServices() {
        try {
            IHonorAudioService iHonorAudioService = this.mIHnAudioService;
            if (iHonorAudioService != null && this.mIsServiceConnected) {
                List supportedServices = iHonorAudioService.getSupportedServices();
                if (supportedServices == null) {
                    HonorLogUtils.error(TAG, "list is null");
                    return DEFAULT_FEATURE_LIST;
                }
                this.mSupportedServiceList.clear();
                Iterator it = supportedServices.iterator();
                while (it.hasNext()) {
                    filterUnsupportedService(((Integer) it.next()).intValue());
                }
                HonorLogUtils.info(TAG, "getSupportedServices " + Arrays.toString(supportedServices.toArray()));
                return this.mSupportedServiceList;
            }
        } catch (Throwable unused) {
            HonorLogUtils.error(TAG, "getSupportedServices, createFeature,wait bind service fail");
        }
        HonorLogUtils.info(TAG, "getSupportedServices, service not bind");
        return DEFAULT_FEATURE_LIST;
    }

    private void filterUnsupportedService(int i) {
        if (i == 1) {
            if (HonorFeatureKitManager.mMinVersion >= 1000000) {
                this.mSupportedServiceList.add(Integer.valueOf(i));
            }
        } else if (i == 2) {
            if (HonorFeatureKitManager.mMinVersion >= 1000000) {
                this.mSupportedServiceList.add(Integer.valueOf(i));
            }
        } else if (i == 3) {
            if (HonorFeatureKitManager.mMinVersion >= 1000001) {
                this.mSupportedServiceList.add(Integer.valueOf(i));
            }
        } else if (i == 4 && HonorFeatureKitManager.mMinVersion >= 1000001) {
            this.mSupportedServiceList.add(Integer.valueOf(i));
        }
    }

    public boolean isServiceSupported(ServiceType serviceType) {
        if (serviceType == null) {
            return false;
        }
        HonorLogUtils.info(TAG, "isServiceSupported, type = " + serviceType.getServiceType());
        try {
            if (this.mIHnAudioService != null && this.mIsServiceConnected && this.mSupportedServiceList.contains(Integer.valueOf(serviceType.getServiceType()))) {
                return this.mIHnAudioService.isServiceSupported(serviceType.getServiceType());
            }
            return false;
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "isServiceSupported,RemoteException ex : " + th.getMessage());
            return false;
        }
    }

    public <T extends HonorAudioFeaturesKit> T createService(ServiceType serviceType) {
        if (this.mFeatureKitManager != null && serviceType != null && this.mSupportedServiceList.contains(Integer.valueOf(serviceType.getServiceType()))) {
            return (T) this.mFeatureKitManager.createFeatureKit(serviceType.getServiceType(), this.mContext);
        }
        HonorLogUtils.error(TAG, "createService fail");
        return null;
    }

    public void serviceInit(String str, String str2) {
        HonorLogUtils.info(TAG, "serviceInit");
        try {
            IHonorAudioService iHonorAudioService = this.mIHnAudioService;
            if (iHonorAudioService == null || !this.mIsServiceConnected) {
                return;
            }
            iHonorAudioService.init(str, str2);
        } catch (Throwable th) {
            HonorLogUtils.error(TAG, "isFeatureSupported,RemoteException ex :" + th.getMessage());
        }
    }
}
