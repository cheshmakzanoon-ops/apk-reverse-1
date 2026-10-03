package com.gme.liteav.base.system;

import android.os.SystemClock;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.storage.PersistStorage;
import java.security.MessageDigest;
import java.util.UUID;

final class C1041q {

    private static final char[] f732a = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

    public static String m987a(String str) {
        String string;
        String str2 = "";
        if (ContextUtils.getApplicationContext() == null) {
            return "";
        }
        PersistStorage persistStorage = new PersistStorage("com.gme.liteav.dev_uuid");
        String string2 = persistStorage.getString("com.gme.liteav.key_dev_uuid");
        String str3 = (string2 == null || string2.length() != 26) ? null : string2;
        if (str3 == null || str3.length() == 0) {
            string = str3;
            long jCurrentTimeMillis = System.currentTimeMillis();
            long jUptimeMillis = SystemClock.uptimeMillis();
            for (int i = 5; i >= 0; i--) {
                str2 = str2 + String.format("%02x", Byte.valueOf((byte) (255 & (jCurrentTimeMillis >> (i * 8)))));
            }
            for (int i2 = 3; i2 >= 0; i2--) {
                str2 = str2 + String.format("%02x", Byte.valueOf((byte) ((jUptimeMillis >> (i2 * 8)) & 255)));
            }
            StringBuilder sb = new StringBuilder();
            sb.append(str2);
            sb.append(m988b(str + UUID.randomUUID().toString()));
            string = sb.toString();
        }
        if (string2 == null || !string2.equals(string)) {
            persistStorage.put("com.gme.liteav.key_dev_uuid", string);
            persistStorage.commit();
        }
        return string;
    }

    private static String m988b(String str) {
        if (str == null) {
            return "";
        }
        try {
            byte[] bArrDigest = MessageDigest.getInstance("MD5").digest(str.getBytes("UTF-8"));
            char[] cArr = new char[bArrDigest.length << 1];
            int i = 0;
            for (byte b : bArrDigest) {
                int i2 = i + 1;
                char[] cArr2 = f732a;
                cArr[i] = cArr2[(b & 240) >>> 4];
                i += 2;
                cArr[i2] = cArr2[b & 15];
            }
            return new String(cArr);
        } catch (Exception e) {
            Log.m948e("UUID", "stringToMd5 failed.", e);
            return "";
        }
    }
}
