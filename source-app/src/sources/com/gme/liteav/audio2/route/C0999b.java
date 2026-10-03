package com.gme.liteav.audio2.route;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.media.AudioDeviceInfo;
import android.media.AudioManager;
import android.os.Process;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.util.List;

public final class C0999b implements BluetoothProfile.ServiceListener {

    final BluetoothAdapter f596a;

    BluetoothProfile f597b = null;

    final Object f598c = new Object();

    private final Context f599d;

    private AudioManager f600e;

    public C0999b(Context context) {
        this.f599d = context;
        BluetoothAdapter bluetoothAdapterM939c = m939c();
        this.f596a = bluetoothAdapterM939c;
        if (bluetoothAdapterM939c == null) {
            Log.m949i("BluetoothHeadsetListener", "Bluetooth adapter is null", new Object[0]);
        } else {
            try {
                bluetoothAdapterM939c.getProfileProxy(context, this, 1);
            } catch (Throwable th) {
                Log.m951w("BluetoothHeadsetListener", "Get profile proxy exception " + th.getMessage(), new Object[0]);
            }
        }
        this.f600e = (AudioManager) this.f599d.getSystemService("audio");
    }

    public final boolean m943a() {
        boolean z;
        List<BluetoothDevice> listM940d;
        AudioDeviceInfo[] devices;
        int length;
        int i;
        AudioDeviceInfo audioDeviceInfo;
        if (this.f596a == null || !m941e()) {
            return false;
        }
        synchronized (this.f598c) {
            if (this.f597b == null) {
                try {
                    Log.m949i("BluetoothHeadsetListener", "mBluetoothHeadsetProfile is null ,wait for 1000ms", new Object[0]);
                    this.f598c.wait(1000L);
                } catch (Throwable th) {
                    Log.m951w("BluetoothHeadsetListener", "Wait exception " + th.getMessage(), new Object[0]);
                }
                if (this.f597b == null) {
                    Log.m949i("BluetoothHeadsetListener", "mBluetoothHeadsetProfile is still null", new Object[0]);
                } else {
                    Log.m949i("BluetoothHeadsetListener", "mBluetoothHeadsetProfile service is connected now", new Object[0]);
                }
                try {
                    z = true;
                    if (LiteavSystemInfo.getSystemOSVersionInt() >= 23) {
                        devices = this.f600e.getDevices(2);
                        length = devices.length;
                        i = 0;
                        while (true) {
                            if (i < length) {
                                z = false;
                                break;
                            }
                            audioDeviceInfo = devices[i];
                            if (audioDeviceInfo.getType() != 8 || audioDeviceInfo.getType() == 7 || audioDeviceInfo.getType() == 26) {
                                break;
                                break;
                                break;
                            }
                            i++;
                        }
                    } else if (!m938a(this.f599d) || (listM940d = m940d()) == null || listM940d.size() <= 0) {
                        z = false;
                        break;
                    }
                } catch (Throwable th2) {
                    Log.m948e("BluetoothHeadsetListener", "get connected bluetooth devices failed." + th2.getMessage(), new Object[0]);
                }
            } else {
                z = true;
                if (LiteavSystemInfo.getSystemOSVersionInt() >= 23) {
                    devices = this.f600e.getDevices(2);
                    length = devices.length;
                    i = 0;
                    while (true) {
                        if (i < length) {
                            z = false;
                            break;
                        }
                        audioDeviceInfo = devices[i];
                        if (audioDeviceInfo.getType() != 8) {
                            break;
                        }
                        i++;
                    }
                } else {
                    if (!m938a(this.f599d)) {
                        z = false;
                        break;
                    }
                    z = false;
                    break;
                }
            }
            throw th;
        }
        Log.m949i("BluetoothHeadsetListener", "find bluetooth device " + z + ", le audio supported is " + m942f(), new Object[0]);
        return z;
    }

    @Override
    public final void onServiceConnected(int i, BluetoothProfile bluetoothProfile) {
        BluetoothProfile bluetoothProfile2;
        if (i != 1) {
            return;
        }
        synchronized (this.f598c) {
            if (this.f596a != null && (bluetoothProfile2 = this.f597b) != null) {
                Log.m949i("BluetoothHeadsetListener", "Bluetooth Headset proxy changed from %s to %s", bluetoothProfile2, bluetoothProfile);
                m944b();
            }
            this.f597b = bluetoothProfile;
            this.f598c.notifyAll();
        }
    }

    @Override
    public final void onServiceDisconnected(int i) {
        if (i != 1) {
            return;
        }
        synchronized (this.f598c) {
            if (this.f596a != null && this.f597b != null) {
                m944b();
                this.f597b = null;
            }
        }
    }

    private static BluetoothAdapter m939c() {
        try {
            return BluetoothAdapter.getDefaultAdapter();
        } catch (Throwable th) {
            Log.m951w("BluetoothHeadsetListener", "Get default adapter exception " + th.getMessage(), new Object[0]);
            return null;
        }
    }

    final void m944b() {
        try {
            this.f596a.closeProfileProxy(1, this.f597b);
        } catch (Throwable th) {
            Log.m951w("BluetoothHeadsetListener", "Close profile proxy exception " + th.getMessage(), new Object[0]);
        }
    }

    private List<BluetoothDevice> m940d() {
        try {
            return this.f597b.getConnectedDevices();
        } catch (Throwable th) {
            Log.m951w("BluetoothHeadsetListener", "Get connected devices exception " + th.getMessage(), new Object[0]);
            return null;
        }
    }

    public static boolean m938a(Context context) {
        if (context == null || LiteavSystemInfo.getSystemOSVersionInt() < 31) {
            return true;
        }
        try {
            return context.checkPermission("android.permission.BLUETOOTH_CONNECT", Process.myPid(), Process.myUid()) == 0;
        } catch (Throwable th) {
            Log.m951w("BluetoothHeadsetListener", "checkPermission exception " + th.getMessage(), new Object[0]);
            return true;
        }
    }

    private boolean m941e() {
        try {
            return this.f596a.isEnabled();
        } catch (Throwable th) {
            Log.m951w("BluetoothHeadsetListener", "Get bluetooth adapter status exception " + th.getMessage(), new Object[0]);
            return false;
        }
    }

    private boolean m942f() {
        try {
            return ((Integer) BluetoothAdapter.class.getMethod("isLeAudioSupported", null).invoke(this.f596a, null)).intValue() == 10;
        } catch (Throwable th) {
            Log.m951w("BluetoothHeadsetListener", "get le audio supported failed. ".concat(String.valueOf(th)), new Object[0]);
            return false;
        }
    }
}
