package com.common;

import android.util.Log;

public class HttpsSocketAndroidLoggerImpl implements HttpsSocketClient.ILoggerImpl {
    @Override
    public void mo826d(String str, String str2) {
        Log.d(str, str2);
    }
}
