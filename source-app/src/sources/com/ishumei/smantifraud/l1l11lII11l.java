package com.ishumei.smantifraud;

import android.text.TextUtils;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class l1l11lII11l {
    public static String l1111l111111Il(String[] strArr) throws Exception {
        Process processExec = Runtime.getRuntime().exec(strArr);
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(processExec.getInputStream()));
        StringBuilder sb = new StringBuilder();
        while (true) {
            String line = bufferedReader.readLine();
            if (TextUtils.isEmpty(line)) {
                break;
            }
            sb.append(line);
            sb.append("\n");
        }
        BufferedReader bufferedReader2 = new BufferedReader(new InputStreamReader(processExec.getErrorStream()));
        while (true) {
            String line2 = bufferedReader2.readLine();
            if (TextUtils.isEmpty(line2)) {
                return sb.toString();
            }
            sb.append(line2);
            sb.append("\n");
        }
    }
}
