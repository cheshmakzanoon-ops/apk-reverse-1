package cn.thinkingdata.android.utils;

import android.text.TextUtils;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class C0756g {

    private static final Pattern f246a = Pattern.compile("^[a-zA-Z][a-zA-Z\\d_]{0,49}$", 2);

    private static final ArrayList<String> f247b = new a();

    class a extends ArrayList {
        a() {
            add("#bundle_id");
            add("#duration");
        }
    }

    public static boolean m704a(String str) {
        return str == null || !f246a.matcher(str).matches();
    }

    public static boolean m705a(JSONObject jSONObject) {
        if (jSONObject == null || !TDLog.mEnableLog) {
            return true;
        }
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            if (TextUtils.isEmpty(next)) {
                TDLog.m679d("ThinkingAnalytics.PropertyUtils", "Empty property name is not allowed.");
            }
            if (!f246a.matcher(next).matches() && !f247b.contains(next)) {
                TDLog.m679d("ThinkingAnalytics.PropertyUtils", "Property name[" + next + "] is not valid. The property KEY must be string that starts with English letter, and contains letter, number, and '_'. The max length of the property KEY is 50. ");
            }
            try {
                Object obj = jSONObject.get(next);
                if (!(obj instanceof String) && !(obj instanceof Number) && !(obj instanceof Boolean) && !(obj instanceof Date) && !(obj instanceof JSONArray) && !(obj instanceof JSONObject)) {
                    TDLog.m679d("ThinkingAnalytics.PropertyUtils", "Property value must be type String, Number, Boolean, Date, JSONObject or JSONArray");
                }
                if (obj instanceof Number) {
                    double dDoubleValue = ((Number) obj).doubleValue();
                    if (dDoubleValue > 9.999999999999998E12d || dDoubleValue < -9.999999999999998E12d) {
                        TDLog.m679d("ThinkingAnalytics.PropertyUtils", "The number value [" + obj + "] is invalid.");
                    }
                }
            } catch (JSONException e) {
                TDLog.m679d("ThinkingAnalytics.PropertyUtils", "Unexpected parameters." + e);
                return false;
            }
        }
        return true;
    }

    public static byte[] m706a(String str, int i) throws UnsupportedEncodingException {
        int i2;
        int i3;
        byte b;
        byte[] bytes = str.getBytes("UTF-8");
        if (bytes.length <= i) {
            return bytes;
        }
        if ((bytes[i] & 128) == 0) {
            return Arrays.copyOf(bytes, i);
        }
        int i4 = 0;
        while (true) {
            i2 = i - i4;
            i3 = i2 - 1;
            b = bytes[i3];
            if ((b & 128) <= 0 || (b & 64) != 0) {
                break;
            }
            i4++;
        }
        return (b & 128) > 0 ? Arrays.copyOf(bytes, i3) : Arrays.copyOf(bytes, i2);
    }
}
