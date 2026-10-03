package com.appsflyer.internal;

import android.util.Base64;
import com.appsflyer.AFLogger;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class AFb1kSDK {
    public String AFInAppEventParameterName;
    String AFInAppEventType;
    public AFe1bSDK AFKeystoreWrapper;
    public String valueOf;
    private byte[] values;

    public AFb1kSDK(String str, byte[] bArr, String str2, AFe1bSDK aFe1bSDK) {
        this.valueOf = str;
        this.values = bArr;
        this.AFInAppEventType = str2;
        this.AFKeystoreWrapper = aFe1bSDK;
    }

    public AFb1kSDK(char[] cArr) {
        Scanner scanner = new Scanner(new String(cArr));
        int i = 0;
        int i2 = 0;
        while (scanner.hasNextLine()) {
            String strNextLine = scanner.nextLine();
            if (strNextLine.startsWith("url=")) {
                this.valueOf = strNextLine.substring(4).trim();
            } else if (strNextLine.startsWith("version=")) {
                this.AFInAppEventType = strNextLine.substring(8).trim();
                Matcher matcher = Pattern.compile("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$").matcher(this.AFInAppEventType);
                if (matcher.matches()) {
                    i = Integer.parseInt(matcher.group(1));
                    i2 = Integer.parseInt(matcher.group(2));
                }
            } else if (strNextLine.startsWith("data=")) {
                String strTrim = strNextLine.substring(5).trim();
                this.values = (i > 4 || i2 >= 11) ? Base64.decode(strTrim, 2) : strTrim.getBytes(Charset.defaultCharset());
            } else if (strNextLine.startsWith("type=")) {
                String strTrim2 = strNextLine.substring(5).trim();
                try {
                    this.AFKeystoreWrapper = AFe1bSDK.valueOf(strTrim2);
                } catch (Exception e) {
                    AFLogger.afErrorLog("CACHE: Unknown task type: ".concat(String.valueOf(strTrim2)), e);
                }
            }
        }
        scanner.close();
    }

    public final byte[] AFInAppEventType() {
        return this.values;
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj != null && getClass() == obj.getClass()) {
            AFb1kSDK aFb1kSDK = (AFb1kSDK) obj;
            String str = this.AFInAppEventType;
            if (str == null ? aFb1kSDK.AFInAppEventType != null : !str.equals(aFb1kSDK.AFInAppEventType)) {
                return false;
            }
            if (!Arrays.equals(this.values, aFb1kSDK.values)) {
                return false;
            }
            String str2 = this.valueOf;
            if (str2 == null ? aFb1kSDK.valueOf != null : !str2.equals(aFb1kSDK.valueOf)) {
                return false;
            }
            String str3 = this.AFInAppEventParameterName;
            if (str3 == null ? aFb1kSDK.AFInAppEventParameterName != null : !str3.equals(aFb1kSDK.AFInAppEventParameterName)) {
                return false;
            }
            if (this.AFKeystoreWrapper == aFb1kSDK.AFKeystoreWrapper) {
                return true;
            }
        }
        return false;
    }

    public final int hashCode() {
        String str = this.AFInAppEventType;
        int iHashCode = (((str != null ? str.hashCode() : 0) * 31) + Arrays.hashCode(this.values)) * 31;
        String str2 = this.valueOf;
        int iHashCode2 = (iHashCode + (str2 != null ? str2.hashCode() : 0)) * 31;
        String str3 = this.AFInAppEventParameterName;
        int iHashCode3 = (iHashCode2 + (str3 != null ? str3.hashCode() : 0)) * 31;
        AFe1bSDK aFe1bSDK = this.AFKeystoreWrapper;
        return iHashCode3 + (aFe1bSDK != null ? aFe1bSDK.hashCode() : 0);
    }
}
