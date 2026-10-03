package com.gme.trtc.hardwareearmonitor.oplus;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import androidx.core.provider.FontsContractCompat;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.util.C1055g;
import com.gme.liteav.base.util.LiteavLog;
import com.unity3d.player.l$a$;

@JNINamespace("liteav::extensions")
public class HardwareEarMonitorOplus {
    private static final int AUTHENTICATE_FAIL = 1002;
    private static final String AUTH_URI = "content://com.oplus.ocs.out.OpenCapabilityThirdProvider/oplus";
    private static final int KARAOKE_MESSAGE_CODE = 3000;
    private static final int KARAOKE_SUCCESS = 1000;
    private static final int ON_BIND_EXCEPTION = 1012;
    private static final int OPEN_CAPABILITY_THIRD_PROVIDER_NOT_FOUND = 1013;
    private static final String TAG = "HardwareEarMonitorOplus";
    private OplusKaraokeServiceAidlInterface mKaraokeServiceInterface;
    private long mNativeHardwareEarMonitorHandle;
    private Intent mServiceIntent;
    private Object mLock = new Object();
    private AudioManager mAudioManager = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio");
    private Context mContext = ContextUtils.getApplicationContext();
    private KaraokeServiceConnection mConnection = new KaraokeServiceConnection();
    private C1055g mTaskRunner = new C1055g();

    public static native void nativeHandleResult(long j, int i);

    public static HardwareEarMonitorOplus create(long j) {
        return new HardwareEarMonitorOplus(j);
    }

    public void destroy() {
        synchronized (this.mLock) {
            this.mNativeHardwareEarMonitorHandle = 0L;
        }
        try {
            this.mContext.unbindService(this.mConnection);
        } catch (Throwable th) {
            LiteavLog.m998i(TAG, "destroy ex:" + th.getMessage());
        }
        this.mConnection = null;
        this.mKaraokeServiceInterface = null;
    }

    public boolean setAudioParams(String str) {
        try {
            this.mAudioManager.setParameters(str);
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    public int getUidFromPackage() {
        try {
            if (Build.VERSION.SDK_INT >= 24) {
                return l$a$.ExternalSyntheticApiModelOutline0.m(this.mContext.getPackageManager(), this.mContext.getPackageName(), 0);
            }
            return 0;
        } catch (Throwable unused) {
            return 0;
        }
    }

    public boolean systemFeatureSupported(String str) {
        try {
            if (Build.VERSION.SDK_INT >= 24) {
                return this.mContext.getPackageManager().hasSystemFeature(str);
            }
            return false;
        } catch (Throwable unused) {
            return false;
        }
    }

    public void notifyResult(final int i) {
        this.mTaskRunner.m1023a(new Runnable() {
            @Override
            public final void run() {
                synchronized (HardwareEarMonitorOplus.this.mLock) {
                    HardwareEarMonitorOplus.nativeHandleResult(HardwareEarMonitorOplus.this.mNativeHardwareEarMonitorHandle, i);
                }
            }
        });
    }

    public void authCheck(String str) {
        Bundle bundleCall;
        Uri uri = Uri.parse(AUTH_URI);
        Messenger messenger = new Messenger(new Handler(this.mContext.getMainLooper()) {
            @Override
            public final void handleMessage(Message message) {
                try {
                    super.handleMessage(message);
                    HardwareEarMonitorOplus.this.notifyResult(message.getData().getInt(FontsContractCompat.Columns.RESULT_CODE));
                } catch (Throwable th) {
                    LiteavLog.m998i(HardwareEarMonitorOplus.TAG, "authCheck ex:" + th.getMessage());
                    HardwareEarMonitorOplus.this.notifyResult(1002);
                }
            }
        });
        Bundle bundle = new Bundle();
        bundle.putBinder("callback", messenger.getBinder());
        try {
            bundleCall = this.mContext.getContentResolver().call(uri, "auth", str, bundle);
        } catch (Throwable th) {
            LiteavLog.m994e(TAG, "component is not exist or not visible ex:" + th.getMessage());
            notifyResult(1013);
            bundleCall = null;
        }
        if (bundleCall == null) {
            LiteavLog.m994e(TAG, "retBundle is null");
            notifyResult(1013);
        }
    }

    public int getOplusOSVersionInt() {
        try {
            Class<?> cls = Class.forName("com.oplus.os.OplusBuild");
            Integer num = (Integer) cls.getDeclaredMethod("getOplusOSVERSION", null).invoke(cls, null);
            return num.intValue();
        } catch (Throwable th) {
            LiteavLog.m998i(TAG, "getOplusOSVersionInt ex:" + th.getMessage());
            return 0;
        }
    }

    public void bindKaraokeService(String str, String str2, String str3) {
        this.mServiceIntent = new Intent();
        LiteavLog.m998i(TAG, "bindKaraokeService service package name:" + str + " service name:" + str2 + " android os:" + Build.VERSION.SDK_INT + " oplus os:" + getOplusOSVersionInt());
        this.mServiceIntent.setPackage(str);
        this.mServiceIntent.setAction(str2);
        this.mConnection.setDescName(str3);
        try {
            this.mContext.bindService(this.mServiceIntent, this.mConnection, 1);
        } catch (Throwable th) {
            LiteavLog.m998i(TAG, "bindKaraokeService ex:" + th.getMessage());
            notifyResult(1012);
        }
    }

    public String getManifestMeta(String str) {
        try {
            return this.mContext.getPackageManager().getApplicationInfo(this.mContext.getPackageName(), 128).metaData.getString(str);
        } catch (Throwable th) {
            LiteavLog.m998i(TAG, "getManifestMeta ex:" + th.getMessage());
            return "";
        }
    }

    public void setActiveClient(String str) {
        OplusKaraokeServiceAidlInterface oplusKaraokeServiceAidlInterface = this.mKaraokeServiceInterface;
        if (oplusKaraokeServiceAidlInterface != null) {
            try {
                oplusKaraokeServiceAidlInterface.setActiveClient(str);
            } catch (Throwable th) {
                LiteavLog.m998i(TAG, "setActiveClient ex:" + th.getMessage());
            }
        }
    }

    public class KaraokeServiceConnection implements ServiceConnection {
        private String mDescName;

        public KaraokeServiceConnection() {
        }

        void setDescName(String str) {
            this.mDescName = str;
        }

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            OplusKaraokeServiceAidlInterface.Stub.setDESCRIPTOR(this.mDescName);
            HardwareEarMonitorOplus.this.mKaraokeServiceInterface = OplusKaraokeServiceAidlInterface.Stub.asInterface(iBinder);
            if (HardwareEarMonitorOplus.this.mKaraokeServiceInterface != null) {
                LiteavLog.m998i(HardwareEarMonitorOplus.TAG, "mKaraokeServiceInterface Create Success");
                HardwareEarMonitorOplus.this.notifyResult(1000);
            } else {
                LiteavLog.m998i(HardwareEarMonitorOplus.TAG, "mKaraokeServiceInterface Create Failed");
                HardwareEarMonitorOplus.this.notifyResult(1012);
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            HardwareEarMonitorOplus.this.mKaraokeServiceInterface = null;
            LiteavLog.m998i(HardwareEarMonitorOplus.TAG, "onServiceDisconnected");
            HardwareEarMonitorOplus.this.notifyResult(1012);
        }
    }

    public HardwareEarMonitorOplus(long j) {
        this.mNativeHardwareEarMonitorHandle = 0L;
        this.mNativeHardwareEarMonitorHandle = j;
    }
}
