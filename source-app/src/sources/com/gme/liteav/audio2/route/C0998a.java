package com.gme.liteav.audio2.route;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.usb.UsbDevice;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.system.LiteavSystemInfo;

public final class C0998a extends BroadcastReceiver {

    final Context f594a;

    private final a f595b;

    public interface a {
        void onBluetoothConnectionChanged(boolean z);

        void onBluetoothScoConnected(boolean z);

        void onSystemVolumeChanged();

        void onUsbConnectionChanged(String str, boolean z);

        void onWiredHeadsetConnectionChanged(boolean z);
    }

    public C0998a(Context context, a aVar) {
        this.f594a = context;
        this.f595b = aVar;
    }

    @Override
    public final void onReceive(Context context, Intent intent) {
        String productName;
        String str;
        if (intent == null || context == null) {
            Log.m948e("AudioEventBroadcastReceiver", "Receive intent or context is null", new Object[0]);
            return;
        }
        String action = intent.getAction();
        if (action == null) {
        }
        action.hashCode();
        switch (action) {
            case "android.hardware.usb.action.USB_DEVICE_ATTACHED":
            case "android.hardware.usb.action.USB_DEVICE_DETACHED":
                UsbDevice usbDevice = (UsbDevice) intent.getParcelableExtra(DeviceRequestsHelper.DEVICE_INFO_DEVICE);
                if (usbDevice != null) {
                    if (LiteavSystemInfo.getSystemOSVersionInt() < 21) {
                        productName = "";
                    } else {
                        productName = usbDevice.getProductName();
                        Log.m949i("AudioEventBroadcastReceiver", "Usb device attached " + productName + " manufacture " + usbDevice.getManufacturerName(), new Object[0]);
                    }
                    if (!AudioDeviceProperty.isUsbHeadsetDevice(usbDevice)) {
                        Log.m949i("AudioEventBroadcastReceiver", "The attached usb device doesn't seem to support audio, ignore it", new Object[0]);
                    } else if ("android.hardware.usb.action.USB_DEVICE_ATTACHED".equals(intent.getAction())) {
                        this.f595b.onUsbConnectionChanged(productName, true);
                    } else if (!"android.hardware.usb.action.USB_DEVICE_DETACHED".equals(intent.getAction())) {
                        Log.m949i("AudioEventBroadcastReceiver", "Unknown action, ignore it " + intent.getAction(), new Object[0]);
                    } else {
                        this.f595b.onUsbConnectionChanged(productName, false);
                    }
                    break;
                }
                break;
            case "android.media.VOLUME_CHANGED_ACTION":
                a aVar = this.f595b;
                if (aVar != null) {
                    aVar.onSystemVolumeChanged();
                    break;
                }
                break;
            case "android.intent.action.HEADSET_PLUG":
                int iM936a = m936a(intent, ServerProtocol.DIALOG_PARAM_STATE, -1);
                Log.m949i("AudioEventBroadcastReceiver", "Receive ACTION_HEADSET_PLUG, EXTRA_STATE:".concat(String.valueOf(iM936a)), new Object[0]);
                if (iM936a == -1) {
                    Log.m948e("AudioEventBroadcastReceiver", "Unknown headset state, ignore...", new Object[0]);
                    break;
                } else {
                    this.f595b.onWiredHeadsetConnectionChanged(iM936a != 0);
                    break;
                }
                break;
            case "android.bluetooth.adapter.action.STATE_CHANGED":
                int iM936a2 = m936a(intent, "android.bluetooth.adapter.extra.STATE", 0);
                Log.m949i("AudioEventBroadcastReceiver", "Receive ACTION_STATE_CHANGED, EXTRA_STATE:" + m937a(iM936a2) + " EXTRA_PREVIOUS_STATE: " + m937a(m936a(intent, "android.bluetooth.adapter.extra.PREVIOUS_STATE", 0)), new Object[0]);
                if (iM936a2 == 10) {
                    this.f595b.onBluetoothConnectionChanged(false);
                    break;
                }
                break;
            case "android.bluetooth.headset.profile.action.AUDIO_STATE_CHANGED":
                int iM936a3 = m936a(intent, "android.bluetooth.profile.extra.STATE", 10);
                if (iM936a3 == 12) {
                    Log.m949i("AudioEventBroadcastReceiver", "Receive bluetooth audio state changed to STATE_AUDIO_CONNECTED", new Object[0]);
                    this.f595b.onBluetoothScoConnected(true);
                    break;
                } else {
                    if (iM936a3 == 10) {
                        Log.m949i("AudioEventBroadcastReceiver", "Receive bluetooth audio state changed to STATE_AUDIO_DISCONNECTED", new Object[0]);
                        this.f595b.onBluetoothScoConnected(false);
                    }
                    break;
                }
                break;
            case "android.bluetooth.headset.profile.action.CONNECTION_STATE_CHANGED":
                int iM936a4 = m936a(intent, "android.bluetooth.profile.extra.STATE", -1);
                if (iM936a4 == 0) {
                    str = "STATE_DISCONNECTED";
                } else if (iM936a4 == 1) {
                    str = "STATE_CONNECTING";
                } else if (iM936a4 == 2) {
                    str = "STATE_CONNECTED";
                } else if (iM936a4 == 3) {
                    str = "STATE_DISCONNECTING";
                } else {
                    str = "unknown";
                }
                Log.m949i("AudioEventBroadcastReceiver", "Receive bluetooth headset connection state changed: %s", str);
                if (iM936a4 == 0) {
                    this.f595b.onBluetoothConnectionChanged(false);
                    break;
                } else if (iM936a4 == 2) {
                    this.f595b.onBluetoothConnectionChanged(true);
                    break;
                }
                break;
            default:
                Log.m951w("AudioEventBroadcastReceiver", "Ignore unknown Action:".concat(String.valueOf(action)), new Object[0]);
                break;
        }
    }

    private static String m937a(int i) {
        switch (i) {
            case 10:
                return "STATE_OFF";
            case 11:
                return "STATE_TURNING_ON";
            case 12:
                return "STATE_ON";
            case 13:
                return "STATE_TURNING_OFF";
            default:
                return "unknown";
        }
    }

    private static int m936a(Intent intent, String str, int i) {
        try {
            return intent.getIntExtra(str, i);
        } catch (Exception e) {
            Log.m948e("AudioEventBroadcastReceiver", "getIntentIntExtra ".concat(String.valueOf(e)), new Object[0]);
            return i;
        }
    }
}
