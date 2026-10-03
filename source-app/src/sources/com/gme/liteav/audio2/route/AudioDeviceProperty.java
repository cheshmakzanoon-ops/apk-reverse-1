package com.gme.liteav.audio2.route;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.media.AudioDeviceCallback;
import android.media.AudioDeviceInfo;
import android.media.AudioManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@JNINamespace("liteav::audio")
public class AudioDeviceProperty implements C0998a.a {
    private static final String TAG = "AudioDeviceProperty";
    private AudioDeviceCallback mAudioDeviceCallback;
    private C0998a mAudioEventBroadcastReceiver;
    private final AudioManager mAudioManager;
    private C0999b mBluetoothHeadsetListener;
    private final Context mContext;
    private long mNativeAudioDeviceProperty;
    private boolean mAudioDeviceCallbackAvailable = false;
    private boolean mUseBluetoothSco = false;

    public static native void nativeNotifyBluetoothConnectionChangedFromJava(long j, boolean z);

    private static native void nativeNotifyBluetoothScoConnectedFromJava(long j, boolean z);

    private static native void nativeNotifySystemVolumeChangedFromJava(long j);

    public static native void nativeNotifyUsbConnectionChangedFromJava(long j, String str, boolean z);

    public static native void nativeNotifyWiredHeadsetConnectionChangedFromJava(long j, boolean z);

    public AudioDeviceProperty(long j) {
        this.mNativeAudioDeviceProperty = j;
        Context applicationContext = ContextUtils.getApplicationContext();
        this.mContext = applicationContext;
        this.mAudioManager = (AudioManager) applicationContext.getSystemService("audio");
    }

    public void start() {
        registerAudioDeviceCallback();
        C0998a c0998a = new C0998a(this.mContext, this);
        this.mAudioEventBroadcastReceiver = c0998a;
        try {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction("android.intent.action.HEADSET_PLUG");
            intentFilter.addAction("android.bluetooth.adapter.action.STATE_CHANGED");
            intentFilter.addAction("android.bluetooth.headset.profile.action.AUDIO_STATE_CHANGED");
            intentFilter.addAction("android.bluetooth.headset.profile.action.CONNECTION_STATE_CHANGED");
            intentFilter.addAction("android.hardware.usb.action.USB_DEVICE_ATTACHED");
            intentFilter.addAction("android.hardware.usb.action.USB_DEVICE_DETACHED");
            intentFilter.addAction("android.media.VOLUME_CHANGED_ACTION");
            c0998a.f594a.registerReceiver(c0998a, intentFilter);
        } catch (Throwable unused) {
            Log.m948e("AudioEventBroadcastReceiver", "register broadcast exception", new Object[0]);
        }
        this.mBluetoothHeadsetListener = new C0999b(this.mContext);
    }

    public void stop() {
        C0998a c0998a = this.mAudioEventBroadcastReceiver;
        if (c0998a != null && c0998a.f594a != null) {
            try {
                c0998a.f594a.unregisterReceiver(c0998a);
            } catch (Exception unused) {
            }
        }
        this.mAudioEventBroadcastReceiver = null;
        C0999b c0999b = this.mBluetoothHeadsetListener;
        if (c0999b != null) {
            synchronized (c0999b.f598c) {
                if (c0999b.f596a != null && c0999b.f597b != null) {
                    c0999b.m944b();
                    c0999b.f597b = null;
                }
            }
        }
        this.mBluetoothHeadsetListener = null;
        unregisterAudioDeviceCallback();
    }

    public void setVoip(boolean z) {
        int i = z ? 3 : 0;
        try {
            this.mAudioManager.setMode(i);
            Log.m949i(TAG, "setMode ".concat(String.valueOf(i)), new Object[0]);
        } catch (Throwable th) {
            Log.m949i(TAG, "Set mode exception " + th.getMessage(), new Object[0]);
        }
    }

    public int getMode() {
        try {
            return this.mAudioManager.getMode();
        } catch (Throwable th) {
            Log.m949i(TAG, "Get mode exception " + th.getMessage(), new Object[0]);
            return 0;
        }
    }

    public boolean isSpeakerphoneOn() {
        try {
            return this.mAudioManager.isSpeakerphoneOn();
        } catch (Throwable th) {
            Log.m949i(TAG, "isSpeakerphoneOn exception " + th.getMessage(), new Object[0]);
            return false;
        }
    }

    public void setSpeakerphoneOn(boolean z) {
        try {
            this.mAudioManager.setSpeakerphoneOn(z);
            Log.m949i(TAG, "setSpeakerphoneOn ".concat(String.valueOf(z)), new Object[0]);
        } catch (Throwable th) {
            Log.m949i(TAG, "setSpeakerphoneOn exception " + th.getMessage(), new Object[0]);
        }
    }

    public boolean isWiredHeadsetOn() {
        try {
            return this.mAudioManager.isWiredHeadsetOn();
        } catch (Throwable th) {
            Log.m949i(TAG, "isWiredHeadsetOn exception " + th.getMessage(), new Object[0]);
            return false;
        }
    }

    public void setWiredHeadsetOn(boolean z) {
        try {
            this.mAudioManager.setWiredHeadsetOn(z);
            Log.m949i(TAG, "setWiredHeadsetOn ".concat(String.valueOf(z)), new Object[0]);
        } catch (Throwable th) {
            Log.m949i(TAG, "setWiredHeadsetOn exception " + th.getMessage(), new Object[0]);
        }
    }

    public void setBluetoothOn(boolean z) {
        try {
            if (LiteavSystemInfo.getSystemOSVersionInt() < 35) {
                this.mAudioManager.setBluetoothScoOn(z);
                Log.m949i(TAG, "setBluetoothScoOn ".concat(String.valueOf(z)), new Object[0]);
            }
        } catch (Throwable th) {
            Log.m949i(TAG, "setBluetoothOn exception " + th.getMessage(), new Object[0]);
        }
    }

    public boolean isBluetoothOn() {
        try {
            if (LiteavSystemInfo.getSystemOSVersionInt() < 35) {
                return this.mAudioManager.isBluetoothScoOn();
            }
            return isCommunicationDeviceConnected(7) || isCommunicationDeviceConnected(26);
        } catch (Throwable th) {
            Log.m949i(TAG, "isBluetoothOn exception " + th.getMessage(), new Object[0]);
            return false;
        }
    }

    public boolean isBluetoothScoAvailable() {
        if (LiteavSystemInfo.getSystemOSVersionInt() < 23) {
            return true;
        }
        ArrayList arrayList = new ArrayList();
        try {
            for (AudioDeviceInfo audioDeviceInfo : this.mAudioManager.getDevices(2)) {
                arrayList.add(Integer.valueOf(audioDeviceInfo.getType()));
            }
        } catch (Throwable th) {
            Log.m949i(TAG, "isBluetoothScoAvailable exception " + th.getMessage(), new Object[0]);
        }
        return arrayList.isEmpty() || !arrayList.contains(8) || arrayList.contains(7);
    }

    public boolean isBluetoothConnected() {
        try {
            if (LiteavSystemInfo.getSystemOSVersionInt() >= 35) {
                return isCommunicationDeviceConnected(7) || isCommunicationDeviceConnected(26);
            }
            Intent intentRegisterReceiver = ContextUtils.getApplicationContext().registerReceiver(null, new IntentFilter("android.media.ACTION_SCO_AUDIO_STATE_UPDATED"));
            return intentRegisterReceiver != null && intentRegisterReceiver.getIntExtra("android.media.extra.SCO_AUDIO_STATE", 0) == 1;
        } catch (Throwable th) {
            Log.m949i(TAG, "isBluetoothConnected exception " + th.getMessage(), new Object[0]);
            return false;
        }
    }

    public boolean checkBluetoothPermission() {
        return C0999b.m938a(this.mContext);
    }

    public void connectBluetooth() {
        try {
            if (LiteavSystemInfo.getSystemOSVersionInt() < 35) {
                this.mUseBluetoothSco = true;
                this.mAudioManager.startBluetoothSco();
                Log.m949i(TAG, "startBluetoothSco", new Object[0]);
                return;
            }
            List<AudioDeviceInfo> list = (List) AudioManager.class.getMethod("getAvailableCommunicationDevices", null).invoke(this.mAudioManager, null);
            if (list != null && !list.isEmpty()) {
                for (AudioDeviceInfo audioDeviceInfo : list) {
                    if (audioDeviceInfo.getType() == 7 || audioDeviceInfo.getType() == 26) {
                        setCommunicationDevice(audioDeviceInfo);
                        return;
                    }
                }
                Log.m951w(TAG, "not found available communication devices, try to startBluetoothSco", new Object[0]);
                this.mUseBluetoothSco = true;
                this.mAudioManager.startBluetoothSco();
            }
        } catch (Throwable th) {
            Log.m949i(TAG, "startBluetooth exception " + th.getMessage(), new Object[0]);
        }
    }

    public void disconnectBluetooth() {
        try {
            if (LiteavSystemInfo.getSystemOSVersionInt() >= 35 && !this.mUseBluetoothSco) {
                AudioManager.class.getMethod("clearCommunicationDevice", null).invoke(this.mAudioManager, null);
                Log.m949i(TAG, "clearCommunicationDevice", new Object[0]);
                return;
            }
            this.mUseBluetoothSco = false;
            this.mAudioManager.stopBluetoothSco();
            Log.m949i(TAG, "stopBluetoothSco", new Object[0]);
        } catch (Throwable th) {
            Log.m949i(TAG, "stopBluetooth exception " + th.getMessage(), new Object[0]);
        }
    }

    public boolean isBluetoothHeadsetConnected() {
        C0999b c0999b = this.mBluetoothHeadsetListener;
        if (c0999b == null) {
            Log.m948e(TAG, "mBluetoothHeadsetListener is null", new Object[0]);
            return false;
        }
        return c0999b.m943a();
    }

    public boolean isUsbHeadsetAvailable() {
        try {
            UsbManager usbManager = (UsbManager) this.mContext.getSystemService("usb");
            if (usbManager == null) {
                return false;
            }
            Iterator<UsbDevice> it = usbManager.getDeviceList().values().iterator();
            while (it.hasNext()) {
                if (isUsbHeadsetDevice(it.next())) {
                    return true;
                }
            }
        } catch (Throwable th) {
            Log.m949i(TAG, "getDeviceList exception " + th.getMessage(), new Object[0]);
        }
        return false;
    }

    public UsbAudioDeviceInfo GetUsbAudioDeviceInfo(String str) {
        UsbAudioDeviceInfo usbAudioDeviceInfo = new UsbAudioDeviceInfo();
        try {
            UsbManager usbManager = (UsbManager) this.mContext.getSystemService("usb");
            if (usbManager != null && LiteavSystemInfo.getSystemOSVersionInt() >= 21) {
                for (UsbDevice usbDevice : usbManager.getDeviceList().values()) {
                    if (str.contains(usbDevice.getProductName()) || isUsbHeadsetDevice(usbDevice)) {
                        usbAudioDeviceInfo.f592a = usbDevice.getProductName();
                        usbAudioDeviceInfo.f593b = String.valueOf(usbDevice.getVendorId()) + usbDevice.getProductId();
                    }
                }
                return usbAudioDeviceInfo;
            }
            return usbAudioDeviceInfo;
        } catch (Throwable th) {
            Log.m949i(TAG, "getDeviceList exception " + th.getMessage(), new Object[0]);
        }
    }

    @Override
    public void onWiredHeadsetConnectionChanged(boolean z) {
        if (this.mAudioDeviceCallbackAvailable) {
            return;
        }
        nativeNotifyWiredHeadsetConnectionChangedFromJava(this.mNativeAudioDeviceProperty, z);
    }

    @Override
    public void onBluetoothConnectionChanged(boolean z) {
        if (z || !isBluetoothHeadsetConnected()) {
            nativeNotifyBluetoothConnectionChangedFromJava(this.mNativeAudioDeviceProperty, z);
        }
    }

    public static boolean isUsbHeadsetDevice(UsbDevice usbDevice) {
        if (usbDevice == null) {
            return false;
        }
        for (int i = 0; i < usbDevice.getInterfaceCount(); i++) {
            try {
                if (usbDevice.getInterface(i).getInterfaceClass() == 1) {
                    return true;
                }
            } catch (Throwable th) {
                Log.m948e(TAG, "Get interface exception " + th.getMessage(), new Object[0]);
            }
        }
        return false;
    }

    private boolean isCommunicationDeviceConnected(int i) {
        try {
            AudioDeviceInfo audioDeviceInfo = (AudioDeviceInfo) AudioManager.class.getMethod("getCommunicationDevice", null).invoke(this.mAudioManager, null);
            return audioDeviceInfo != null && audioDeviceInfo.getType() == i;
        } catch (Throwable th) {
            Log.m949i(TAG, "get communication device failed. ".concat(String.valueOf(th)), new Object[0]);
            return false;
        }
    }

    private void setCommunicationDevice(AudioDeviceInfo audioDeviceInfo) {
        try {
            boolean zBooleanValue = ((Boolean) AudioManager.class.getMethod("setCommunicationDevice", AudioDeviceInfo.class).invoke(this.mAudioManager, audioDeviceInfo)).booleanValue();
            if (!zBooleanValue) {
                AudioManager.class.getMethod("clearCommunicationDevice", null).invoke(this.mAudioManager, null);
            }
            Log.m949i(TAG, "setCommunicationDevice: " + zBooleanValue + ", type: " + audioDeviceInfo.getType() + ", product name: " + ((Object) audioDeviceInfo.getProductName()), new Object[0]);
        } catch (Throwable th) {
            Log.m949i(TAG, "set communication device failed. ".concat(String.valueOf(th)), new Object[0]);
        }
    }

    private void registerAudioDeviceCallback() {
        if (LiteavSystemInfo.getSystemOSVersionInt() < 23) {
            return;
        }
        if (this.mAudioDeviceCallback == null) {
            buildAudioDeviceCallback();
        }
        AudioDeviceCallback audioDeviceCallback = this.mAudioDeviceCallback;
        if (audioDeviceCallback == null) {
            return;
        }
        try {
            this.mAudioManager.registerAudioDeviceCallback(audioDeviceCallback, null);
            Log.m949i(TAG, "register audio device callback", new Object[0]);
        } catch (Throwable th) {
            Log.m948e(TAG, "registerAudioDeviceCallback exception " + th.getMessage(), new Object[0]);
        }
    }

    private void unregisterAudioDeviceCallback() {
        AudioDeviceCallback audioDeviceCallback;
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 23 && (audioDeviceCallback = this.mAudioDeviceCallback) != null) {
            try {
                this.mAudioManager.unregisterAudioDeviceCallback(audioDeviceCallback);
                Log.m949i(TAG, "unregister audio device callback", new Object[0]);
            } catch (Throwable th) {
                Log.m948e(TAG, "unregisterAudioDeviceCallback exception " + th.getMessage(), new Object[0]);
            }
        }
    }

    private void buildAudioDeviceCallback() {
        if (this.mAudioDeviceCallback != null) {
            return;
        }
        this.mAudioDeviceCallback = new AudioDeviceCallback() {
            @Override
            public final void onAudioDevicesAdded(AudioDeviceInfo[] audioDeviceInfoArr) {
                if (audioDeviceInfoArr.length == 0) {
                    return;
                }
                Log.m949i(AudioDeviceProperty.TAG, "add device size " + audioDeviceInfoArr.length, new Object[0]);
                AudioDeviceProperty.this.mAudioDeviceCallbackAvailable = true;
                for (AudioDeviceInfo audioDeviceInfo : audioDeviceInfoArr) {
                    Log.m949i(AudioDeviceProperty.TAG, "added device type is " + audioDeviceInfo.getType() + " sink: " + audioDeviceInfo.isSink() + " product name: " + ((Object) audioDeviceInfo.getProductName()), new Object[0]);
                    if (audioDeviceInfo.getType() == 8 || audioDeviceInfo.getType() == 26) {
                        AudioDeviceProperty.nativeNotifyBluetoothConnectionChangedFromJava(AudioDeviceProperty.this.mNativeAudioDeviceProperty, true);
                    } else if (audioDeviceInfo.getType() == 11 || audioDeviceInfo.getType() == 12 || audioDeviceInfo.getType() == 22) {
                        AudioDeviceProperty.nativeNotifyUsbConnectionChangedFromJava(AudioDeviceProperty.this.mNativeAudioDeviceProperty, audioDeviceInfo.getProductName().toString(), AudioDeviceProperty.this.isUsbHeadsetAvailable());
                    } else if (audioDeviceInfo.getType() == 3 || audioDeviceInfo.getType() == 4) {
                        AudioDeviceProperty.nativeNotifyWiredHeadsetConnectionChangedFromJava(AudioDeviceProperty.this.mNativeAudioDeviceProperty, true);
                    }
                }
            }

            @Override
            public final void onAudioDevicesRemoved(AudioDeviceInfo[] audioDeviceInfoArr) {
                if (audioDeviceInfoArr.length == 0) {
                    return;
                }
                Log.m949i(AudioDeviceProperty.TAG, "remove device size " + audioDeviceInfoArr.length, new Object[0]);
                int length = audioDeviceInfoArr.length;
                for (int i = 0; i < length; i++) {
                    AudioDeviceInfo audioDeviceInfo = audioDeviceInfoArr[i];
                    Log.m949i(AudioDeviceProperty.TAG, "removed device type is " + audioDeviceInfo.getType() + " sink: " + audioDeviceInfo.isSink() + " product name: " + ((Object) audioDeviceInfo.getProductName()), new Object[0]);
                    if ((audioDeviceInfo.getType() == 8 || audioDeviceInfo.getType() == 7 || audioDeviceInfo.getType() == 26) && !AudioDeviceProperty.this.isBluetoothHeadsetConnected()) {
                        AudioDeviceProperty.nativeNotifyBluetoothConnectionChangedFromJava(AudioDeviceProperty.this.mNativeAudioDeviceProperty, false);
                    } else if (audioDeviceInfo.getType() == 11 || audioDeviceInfo.getType() == 12 || audioDeviceInfo.getType() == 22) {
                        AudioDeviceProperty.nativeNotifyUsbConnectionChangedFromJava(AudioDeviceProperty.this.mNativeAudioDeviceProperty, audioDeviceInfo.getProductName().toString(), AudioDeviceProperty.this.isUsbHeadsetAvailable());
                    } else if (audioDeviceInfo.getType() == 3 || audioDeviceInfo.getType() == 4) {
                        AudioDeviceProperty.nativeNotifyWiredHeadsetConnectionChangedFromJava(AudioDeviceProperty.this.mNativeAudioDeviceProperty, false);
                    }
                }
            }
        };
    }

    @Override
    public void onBluetoothScoConnected(boolean z) {
        nativeNotifyBluetoothScoConnectedFromJava(this.mNativeAudioDeviceProperty, z);
    }

    public int getSystemVolume() {
        try {
            int i = this.mAudioManager.getMode() == 0 ? 3 : 0;
            int streamMaxVolume = this.mAudioManager.getStreamMaxVolume(i);
            if (streamMaxVolume <= 0) {
                return -1;
            }
            return (int) ((this.mAudioManager.getStreamVolume(i) / streamMaxVolume) * 100.0f);
        } catch (Throwable th) {
            Log.m948e(TAG, "getStreamVolume exception " + th.getMessage(), new Object[0]);
            return -1;
        }
    }

    @Override
    public void onSystemVolumeChanged() {
        nativeNotifySystemVolumeChangedFromJava(this.mNativeAudioDeviceProperty);
    }

    @Override
    public void onUsbConnectionChanged(String str, boolean z) {
        if (this.mAudioDeviceCallbackAvailable) {
            return;
        }
        nativeNotifyUsbConnectionChangedFromJava(this.mNativeAudioDeviceProperty, str, z);
    }

    public static class UsbAudioDeviceInfo {

        public String f592a = "";

        public String f593b = "";

        public String getName() {
            return this.f592a;
        }

        public String getVidPid() {
            return this.f593b;
        }
    }
}
