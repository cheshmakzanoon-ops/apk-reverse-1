package com.sdkmanager;

import android.app.Activity;
import android.util.Log;
import com.ishumei.smantifraud.SmAntiFraud;
import com.ishumei.smantifraud.l111l1111llIl;
import java.util.HashSet;

public class SmSdkManager {
    private static volatile SmSdkManager Instance;
    public static String sDeviceId;
    private Activity mActivity;

    public static SmSdkManager getInstance() {
        if (Instance == null) {
            synchronized (SmSdkManager.class) {
                if (Instance == null) {
                    Instance = new SmSdkManager();
                }
            }
        }
        return Instance;
    }

    public void init(Activity activity) {
        Log.d("SmSdkManager", "init");
        this.mActivity = activity;
    }

    public void callCreate() {
        try {
            SmAntiFraud.registerServerIdCallback(new SmAntiFraud.IServerSmidCallback() {
                @Override
                public void onSuccess(String str) {
                    Log.d("SmSdkManager init success deviceId:", str);
                    SdkManager.getInstance().getSdkListener().SendDataToGame("OnShumeiSdkInitSuccess", "");
                }

                @Override
                public void onError(int i) {
                    Log.e("SmSdkManager init error:", SmSdkManager.this.decodeErrorCode(i));
                    SdkManager.getInstance().getSdkListener().SendDataToGame("OnShumeiSdkInitError", "");
                }
            });
            SmAntiFraud.SmOption smOption = new SmAntiFraud.SmOption();
            smOption.setOrganization("9dNCYkjHeFMYZMOjxgX8");
            smOption.setAppId("default");
            smOption.setPublicKey("MIIDLzCCAhegAwIBAgIBMDANBgkqhkiG9w0BAQUFADAyMQswCQYDVQQGEwJDTjELMAkGA1UECwwCU00xFjAUBgNVBAMMDWUuaXNodW1laS5jb20wHhcNMjQwNzIyMDYzMDExWhcNNDQwNzE3MDYzMDExWjAyMQswCQYDVQQGEwJDTjELMAkGA1UECwwCU00xFjAUBgNVBAMMDWUuaXNodW1laS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCC1T6Zie3jw6rZAoo4oRGUHJxS8VPKdC/Og6u/XvY3EOypyj4h1+AU4H5Yas5DdFFF0H+Py/7NL/01m3iolqDPFnK2Nvs6FwnS8kAkuA8XhhzOJkkctJ6AGbfoPuIKNQ5Gxp9WjbMNFTlsdOsx0tEk3Z20Y4631vbcKU6bDVwgdQZj+47/dZfS4hQ2++cioa6bb54/NwSzpwgt4JBkMmR02U8pQzFXWT/H4sarLwfu1yNaARbmC0IEP6rHQ7FFnPNpqTF3NUGM0MxbA8NS3RA+bRA15qylOJsEOJz3ACEnHo89OirdiuQoGk+VAe3Cl3Kslq1+j8+hF3neUJU0LplvAgMBAAGjUDBOMB0GA1UdDgQWBBTClCThfjVC0jolP0BTrex3BEBxvTAfBgNVHSMEGDAWgBTClCThfjVC0jolP0BTrex3BEBxvTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQAPLGeWtW/mrMBUTZfKgZZK0mwdxddaRlEmP1naXzwUWHS6UMgH/HcxHgX7lN2QQUuzMokjtHhs1MZRC9vA7be+S6rvl0b4YavFJdsPTPQTFA1gYScp9j7nqCcD5NPTguPo7F2zpuhprzOkQkrNEzadoG9R1kiInWPOT08is1e6/mSWq7mULm5/dODMs1pQQHSscrv84nwEHEnmad2duO/h/xKOpAzEh0yTROEqEf7yISB2PlL6cazNVRXZxTX8X15wmDEpzPQTJb3p+D8xaRCq6mPP87bOCqbaYsyhvM3KYY043t/WhrWr/tdgAUDkPOZDcgRIdbWlTaGcACzWNJlx");
            smOption.setArea(SmAntiFraud.AREA_FJNY);
            smOption.setUrl("https://shumei-api.lastwargame.com:19091/deviceprofile/v4");
            smOption.setConfUrl("https://shumei-api.lastwargame.com:19091/v3/cloudconf");
            smOption.setUsingHttps(true);
            HashSet hashSet = new HashSet();
            hashSet.add(l111l1111llIl.l111l111llIl);
            hashSet.add("protect");
            smOption.setNotCollect(hashSet);
            if (SmAntiFraud.create(this.mActivity, smOption)) {
                Log.d("SmSdkManager", "create success");
            } else {
                Log.d("SmSdkManager", "create failed");
            }
        } catch (Exception e) {
            Log.e("SmSdkManager", "create Exception: " + e.toString());
        }
    }

    public String decodeErrorCode(int i) {
        if (i == -3) {
            return "ERROR_SERVER_RESPONSE";
        }
        if (i == -2) {
            return "ERROR_NO_RESPONSE";
        }
        if (i == -1) {
            return "ERROR_NO_NETWORK";
        }
        return "ERROR_UNKNOWN";
    }

    public String getDeviceId() {
        String deviceId;
        try {
            deviceId = SmAntiFraud.getDeviceId();
        } catch (Exception e) {
            Log.e("SmSdkManager", "getDeviceId Exception: " + e.toString());
            deviceId = "";
        }
        Log.d("SmSdkManager deviceId:", deviceId);
        return deviceId;
    }
}
