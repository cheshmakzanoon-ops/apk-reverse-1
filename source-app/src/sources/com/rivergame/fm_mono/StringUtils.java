package com.rivergame.fm_mono;

public class StringUtils {
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.isEmpty();
    }

    public static int versionCompare(String str, String str2) {
        if (isNullOrEmpty(str)) {
            return isNullOrEmpty(str2) ? 0 : -1;
        }
        if (isNullOrEmpty(str2)) {
            return 1;
        }
        String[] strArrSplit = str.split("\\.");
        String[] strArrSplit2 = str2.split("\\.");
        int length = strArrSplit.length;
        int length2 = strArrSplit2.length;
        int iMax = Math.max(length, length2);
        int i = 0;
        while (i < iMax) {
            String str3 = i < length ? strArrSplit[i] : null;
            String str4 = i < length2 ? strArrSplit2[i] : null;
            int i2 = !isNullOrEmpty(str3) ? Integer.parseInt(str3) : 0;
            int i3 = !isNullOrEmpty(str4) ? Integer.parseInt(str4) : 0;
            if (i2 > i3) {
                return 1;
            }
            if (i2 < i3) {
                return -1;
            }
            i++;
        }
        return 0;
    }
}
