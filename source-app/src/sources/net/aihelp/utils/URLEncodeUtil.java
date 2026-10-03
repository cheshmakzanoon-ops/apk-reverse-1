package net.aihelp.utils;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class URLEncodeUtil {
    public static String encode(String str) {
        if (str != null && !str.equals("")) {
            try {
                return URLEncoder.encode(new String(str.getBytes(), StandardCharsets.UTF_8), "UTF-8");
            } catch (Exception unused) {
            }
        }
        return "";
    }

    public static String decode(String str) {
        if (str == null || str.equals("")) {
            return "";
        }
        try {
            return URLDecoder.decode(new String(str.getBytes(), StandardCharsets.UTF_8), "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
            return str;
        }
    }
}
