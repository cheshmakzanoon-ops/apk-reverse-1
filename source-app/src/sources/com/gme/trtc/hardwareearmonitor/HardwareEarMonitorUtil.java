package com.gme.trtc.hardwareearmonitor;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import com.facebook.appevents.integrity.IntegrityManager;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav::extensions")
public class HardwareEarMonitorUtil extends BroadcastReceiver {
    private IntentFilter mFilter;
    private long mNativeHardwareEarMonitorHandle;
    private int mHeadsetState = -1;
    private int mHasMicrophone = -1;
    private String mDeviceName = "NotDefine";
    private String mPortName = "NotDefine";
    private String mDeviceAddress = "NotDefine";
    private Object mLock = new Object();
    private Context mContext = ContextUtils.getApplicationContext();

    private static native void nativeHeadsetDescChanged(long j, int i, int i2, String str, String str2, String str3);

    public static HardwareEarMonitorUtil create(long j) {
        return new HardwareEarMonitorUtil(j);
    }

    public void destroy() {
        Context context = this.mContext;
        if (context != null) {
            context.unregisterReceiver(this);
        }
        if (this.mFilter != null) {
            this.mFilter = null;
        }
        synchronized (this.mLock) {
            this.mNativeHardwareEarMonitorHandle = 0L;
        }
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent != null && "android.intent.action.HEADSET_PLUG".equals(intent.getAction())) {
            synchronized (this.mLock) {
                this.mHeadsetState = intent.getIntExtra(ServerProtocol.DIALOG_PARAM_STATE, -1);
                this.mHasMicrophone = intent.getIntExtra("microphone", -1);
                this.mDeviceName = intent.getStringExtra(DeviceRequestsHelper.DEVICE_INFO_DEVICE);
                this.mPortName = intent.getStringExtra("portName");
                String stringExtra = intent.getStringExtra(IntegrityManager.INTEGRITY_TYPE_ADDRESS);
                this.mDeviceAddress = stringExtra;
                long j = this.mNativeHardwareEarMonitorHandle;
                int i = this.mHeadsetState;
                int i2 = this.mHasMicrophone;
                String str = this.mDeviceName;
                if (str == null) {
                    str = "";
                }
                String str2 = this.mPortName;
                if (str2 == null) {
                    str2 = "";
                }
                if (stringExtra == null) {
                    stringExtra = "";
                }
                nativeHeadsetDescChanged(j, i, i2, str, str2, stringExtra);
            }
        }
    }

    public HardwareEarMonitorUtil(long j) {
        this.mNativeHardwareEarMonitorHandle = 0L;
        this.mNativeHardwareEarMonitorHandle = j;
        try {
            IntentFilter intentFilter = new IntentFilter("android.intent.action.HEADSET_PLUG");
            this.mFilter = intentFilter;
            this.mContext.registerReceiver(this, intentFilter);
        } catch (Throwable unused) {
        }
    }
}
