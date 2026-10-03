package com.gme.p007av.utils;

import android.content.Intent;
import android.os.Parcelable;
import android.util.Log;
import java.util.Iterator;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonParser {
    public static final String TAG = "JsonParser";

    public static Intent ParseJsonString(String str) {
        if (str != null && str.startsWith("\ufeff")) {
            str = str.substring(1);
        }
        Intent intent = new Intent();
        try {
            ParseJsonObject(intent, new JSONObject(str));
        } catch (JSONException unused) {
        }
        return intent;
    }

    public static void ParseJsonObject(Intent intent, JSONObject jSONObject) {
        if (intent == null || jSONObject == null) {
            return;
        }
        try {
            Iterator<String> itKeys = jSONObject.keys();
            while (itKeys.hasNext()) {
                String next = itKeys.next();
                Object obj = jSONObject.get(next);
                if (obj instanceof Integer) {
                    intent.putExtra(next, jSONObject.getInt(next));
                } else if (obj instanceof String) {
                    intent.putExtra(next, jSONObject.getString(next));
                } else if (obj instanceof Long) {
                    intent.putExtra(next, jSONObject.getLong(next));
                } else if (obj instanceof Boolean) {
                    intent.putExtra(next, jSONObject.getBoolean(next));
                } else if (obj instanceof Double) {
                    intent.putExtra(next, jSONObject.getDouble(next));
                } else if (obj instanceof JSONObject) {
                    Intent intent2 = new Intent();
                    intent.putExtra(next, intent2);
                    ParseJsonObject(intent2, jSONObject.getJSONObject(next));
                } else if (obj instanceof JSONArray) {
                    ParseJsonArray(intent, next, jSONObject.getJSONArray(next));
                }
            }
        } catch (JSONException e) {
            Log.w(TAG, "ParseJsonObject error  ", e);
        }
    }

    public static void ParseJsonArray(Intent intent, String str, JSONArray jSONArray) {
        int length = jSONArray.length();
        if (length <= 0) {
            return;
        }
        int i = 0;
        try {
            Object obj = jSONArray.get(0);
            if (obj instanceof Integer) {
                int[] iArr = new int[length];
                while (i < length) {
                    iArr[i] = jSONArray.getInt(i);
                    i++;
                }
                intent.putExtra(str, iArr);
                return;
            }
            if (obj instanceof String) {
                String[] strArr = new String[length];
                while (i < length) {
                    strArr[i] = jSONArray.getString(i);
                    i++;
                }
                intent.putExtra(str, strArr);
                return;
            }
            if (obj instanceof Long) {
                long[] jArr = new long[length];
                while (i < length) {
                    jArr[i] = jSONArray.getLong(i);
                    i++;
                }
                intent.putExtra(str, jArr);
                return;
            }
            if (obj instanceof Boolean) {
                boolean[] zArr = new boolean[length];
                while (i < length) {
                    zArr[i] = jSONArray.getBoolean(i);
                    i++;
                }
                intent.putExtra(str, zArr);
                return;
            }
            if (obj instanceof Double) {
                double[] dArr = new double[length];
                while (i < length) {
                    dArr[i] = jSONArray.getDouble(i);
                    i++;
                }
                intent.putExtra(str, dArr);
                return;
            }
            if (obj instanceof JSONObject) {
                Parcelable[] parcelableArr = new Intent[jSONArray.length()];
                while (i < length) {
                    Intent intent2 = new Intent();
                    parcelableArr[i] = intent2;
                    ParseJsonObject(intent2, jSONArray.getJSONObject(i));
                    i++;
                }
                intent.putExtra(str, parcelableArr);
            }
        } catch (JSONException e) {
            Log.w(TAG, "ParseJsonArray error  ", e);
        }
    }
}
