package com.gme.p007av.sig;

import com.gme.p007av.jni.GMESDKJni;
import com.gme.p007av.utils.GMELibLoader;

public class AuthBuffer {
    private static boolean mIsSoLoaded = false;
    private static AuthBuffer sAuthBuffer;

    private static void loadSo() {
        mIsSoLoaded = GMELibLoader.loadSdkLibrary() == 0;
    }

    private AuthBuffer() {
    }

    public static AuthBuffer getInstance() {
        AuthBuffer authBuffer;
        synchronized (AuthBuffer.class) {
            if (sAuthBuffer == null) {
                loadSo();
                if (mIsSoLoaded) {
                    sAuthBuffer = new AuthBuffer();
                }
            }
            authBuffer = sAuthBuffer;
        }
        return authBuffer;
    }

    public byte[] genAuthBuffer(int i, String str, String str2, String str3) {
        return GMESDKJni.genAuthBuffer(i, str, str2, str3);
    }
}
