package com.appsflyer.internal;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFa1oSDK {
    public static JSONObject values(Map<String, ?> map) {
        JSONObject jSONObject = new JSONObject();
        for (Map.Entry<String, ?> entry : map.entrySet()) {
            try {
                jSONObject.put(entry.getKey(), values(entry.getValue()));
            } catch (JSONException unused) {
            }
        }
        return jSONObject;
    }

    public static JSONObject values(String str) {
        if (str == null) {
            return null;
        }
        try {
            return new JSONObject(str);
        } catch (JSONException unused) {
            return null;
        }
    }

    private static Object values(Object obj) {
        if (obj == null) {
            return JSONObject.NULL;
        }
        if ((obj instanceof JSONArray) || (obj instanceof JSONObject) || obj.equals(JSONObject.NULL)) {
            return obj;
        }
        try {
            if (obj instanceof Collection) {
                JSONArray jSONArray = new JSONArray();
                Iterator it = ((Collection) obj).iterator();
                while (it.hasNext()) {
                    jSONArray.put(values(it.next()));
                }
                return jSONArray;
            }
            if (obj.getClass().isArray()) {
                int length = Array.getLength(obj);
                JSONArray jSONArray2 = new JSONArray();
                for (int i = 0; i < length; i++) {
                    jSONArray2.put(values(Array.get(obj, i)));
                }
                return jSONArray2;
            }
            if (obj instanceof Map) {
                return values((Map<String, ?>) obj);
            }
            return ((obj instanceof Boolean) || (obj instanceof Byte) || (obj instanceof Character) || (obj instanceof Double) || (obj instanceof Float) || (obj instanceof Integer) || (obj instanceof Long) || (obj instanceof Short) || (obj instanceof String)) ? obj : obj.toString();
        } catch (Exception unused) {
            return JSONObject.NULL;
        }
    }

    public static Map<String, Object> AFInAppEventType(JSONObject jSONObject) throws JSONException {
        HashMap map = new HashMap();
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            Object objAFInAppEventType = jSONObject.get(next);
            if (objAFInAppEventType instanceof JSONArray) {
                objAFInAppEventType = AFKeystoreWrapper((JSONArray) objAFInAppEventType);
            } else if (objAFInAppEventType instanceof JSONObject) {
                objAFInAppEventType = AFInAppEventType((JSONObject) objAFInAppEventType);
            }
            map.put(next, objAFInAppEventType);
        }
        return map;
    }

    private static List<Object> AFKeystoreWrapper(JSONArray jSONArray) throws JSONException {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < jSONArray.length(); i++) {
            Object objAFInAppEventType = jSONArray.get(i);
            if (objAFInAppEventType instanceof JSONArray) {
                objAFInAppEventType = AFKeystoreWrapper((JSONArray) objAFInAppEventType);
            } else if (objAFInAppEventType instanceof JSONObject) {
                objAFInAppEventType = AFInAppEventType((JSONObject) objAFInAppEventType);
            }
            arrayList.add(objAFInAppEventType);
        }
        return arrayList;
    }

    static AFg1fSDK AFKeystoreWrapper(Context context) {
        if (context instanceof Activity) {
            return AFg1fSDK.activity;
        }
        if (context instanceof Application) {
            return AFg1fSDK.application;
        }
        return AFg1fSDK.other;
    }
}
