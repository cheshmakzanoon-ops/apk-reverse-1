package com.sdkmanager.utils;

import java.util.Map;

public class HttpRequester {

    private enum HttpMethod {
        POST,
        DELETE,
        GET,
        PUT,
        HEAD
    }

    private static String invokeUrl(String str, Map map, Map<String, String> map2, int i, int i2, String str2, HttpMethod httpMethod) {
        String str3;
        StringBuilder sb;
        if (map != null) {
            StringBuilder sb2 = new StringBuilder();
            for (Map.Entry entry : map.entrySet()) {
                sb2.append(entry.getKey() + "=" + (entry.getValue() != null ? String.valueOf(entry.getValue()) : "") + "&");
            }
            if (httpMethod != HttpMethod.POST) {
                sb = sb2;
                str3 = str + "?" + sb2.toString();
            } else {
                str3 = str;
                sb = sb2;
            }
        } else {
            str3 = str;
            sb = null;
        }
        try {
            new HttpAsyncTask(str3, httpMethod.toString(), i, i2, str2, sb, map2).execute(new String[0]);
            return null;
        } catch (Exception e) {
            e.getStackTrace();
            return null;
        }
    }

    public static String post(String str, Map map, int i, int i2, String str2) {
        return invokeUrl(str, map, null, i, i2, str2, HttpMethod.POST);
    }

    public static String post(String str, Map map, Map<String, String> map2, int i, int i2, String str2) {
        return invokeUrl(str, map, map2, i, i2, str2, HttpMethod.POST);
    }

    public static String get(String str, Map map, int i, int i2, String str2) {
        return invokeUrl(str, map, null, i, i2, str2, HttpMethod.GET);
    }

    public static String get(String str, Map map, Map<String, String> map2, int i, int i2, String str2) {
        return invokeUrl(str, map, map2, i, i2, str2, HttpMethod.GET);
    }

    public static String put(String str, Map map, int i, int i2, String str2) {
        return invokeUrl(str, map, null, i, i2, str2, HttpMethod.PUT);
    }

    public static String put(String str, Map map, Map<String, String> map2, int i, int i2, String str2) {
        return invokeUrl(str, map, map2, i, i2, str2, HttpMethod.PUT);
    }

    public static String delete(String str, Map map, int i, int i2, String str2) {
        return invokeUrl(str, map, null, i, i2, str2, HttpMethod.DELETE);
    }

    public static String delete(String str, Map map, Map<String, String> map2, int i, int i2, String str2) {
        return invokeUrl(str, map, map2, i, i2, str2, HttpMethod.DELETE);
    }

    public static String head(String str, Map map, int i, int i2, String str2) {
        return invokeUrl(str, map, null, i, i2, str2, HttpMethod.HEAD);
    }

    public static String head(String str, Map map, Map<String, String> map2, int i, int i2, String str2) {
        return invokeUrl(str, map, map2, i, i2, str2, HttpMethod.HEAD);
    }
}
