package com.ishumei.smantifraud;

import android.os.Build;
import java.util.HashMap;

public class l11l1111Il1l {
    public static HashMap<String, String> l1111l111111Il() {
        HashMap<String, String> map = new HashMap<>();
        try {
            map.put("board", Build.BOARD);
            map.put("model", Build.MODEL);
            map.put("brand", Build.BRAND);
            map.put("manufacturer", Build.MANUFACTURER);
            map.put("fingerprint", Build.FINGERPRINT);
            map.put("cpu_abi", Build.CPU_ABI);
            map.put("cpu_abi2", Build.CPU_ABI2);
            map.put("radioVersion", Build.getRadioVersion());
        } catch (Exception unused) {
        }
        return map;
    }
}
