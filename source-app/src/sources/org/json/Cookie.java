package org.json;

import java.util.Locale;

public class Cookie {
    public static String escape(String str) {
        String strTrim = str.trim();
        int length = strTrim.length();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            char cCharAt = strTrim.charAt(i);
            if (cCharAt < ' ' || cCharAt == '+' || cCharAt == '%' || cCharAt == '=' || cCharAt == ';') {
                sb.append('%');
                sb.append(Character.forDigit((char) ((cCharAt >>> 4) & 15), 16));
                sb.append(Character.forDigit((char) (cCharAt & 15), 16));
            } else {
                sb.append(cCharAt);
            }
        }
        return sb.toString();
    }

    public static JSONObject toJSONObject(String str) {
        Object objTrim;
        JSONObject jSONObject = new JSONObject();
        JSONTokener jSONTokener = new JSONTokener(str);
        String strUnescape = unescape(jSONTokener.nextTo('=').trim());
        if ("".equals(strUnescape)) {
            throw new JSONException("Cookies must have a 'name'");
        }
        jSONObject.put("name", strUnescape);
        jSONTokener.next('=');
        jSONObject.put("value", unescape(jSONTokener.nextTo(';')).trim());
        jSONTokener.next();
        while (jSONTokener.more()) {
            String lowerCase = unescape(jSONTokener.nextTo("=;")).trim().toLowerCase(Locale.ROOT);
            if ("name".equalsIgnoreCase(lowerCase)) {
                throw new JSONException("Illegal attribute name: 'name'");
            }
            if ("value".equalsIgnoreCase(lowerCase)) {
                throw new JSONException("Illegal attribute name: 'value'");
            }
            if (jSONTokener.next() != '=') {
                objTrim = Boolean.TRUE;
            } else {
                objTrim = unescape(jSONTokener.nextTo(';')).trim();
                jSONTokener.next();
            }
            if (!"".equals(lowerCase) && !"".equals(objTrim)) {
                jSONObject.put(lowerCase, objTrim);
            }
        }
        return jSONObject;
    }

    public static String toString(JSONObject jSONObject) throws JSONException {
        StringBuilder sb = new StringBuilder();
        String strTrim = null;
        String strTrim2 = null;
        for (String str : jSONObject.keySet()) {
            if ("name".equalsIgnoreCase(str)) {
                strTrim = jSONObject.getString(str).trim();
            }
            if ("value".equalsIgnoreCase(str)) {
                strTrim2 = jSONObject.getString(str).trim();
            }
            if (strTrim != null && strTrim2 != null) {
                break;
            }
        }
        if (strTrim == null || "".equals(strTrim.trim())) {
            throw new JSONException("Cookie does not have a name");
        }
        if (strTrim2 == null) {
            strTrim2 = "";
        }
        sb.append(escape(strTrim));
        sb.append("=");
        sb.append(escape(strTrim2));
        for (String str2 : jSONObject.keySet()) {
            if (!"name".equalsIgnoreCase(str2) && !"value".equalsIgnoreCase(str2)) {
                Object objOpt = jSONObject.opt(str2);
                if (objOpt instanceof Boolean) {
                    if (Boolean.TRUE.equals(objOpt)) {
                        sb.append(';');
                        sb.append(escape(str2));
                    }
                } else {
                    sb.append(';');
                    sb.append(escape(str2));
                    sb.append('=');
                    sb.append(escape(objOpt.toString()));
                }
            }
        }
        return sb.toString();
    }

    public static String unescape(String str) {
        int i;
        int length = str.length();
        StringBuilder sb = new StringBuilder(length);
        int i2 = 0;
        while (i2 < length) {
            char cCharAt = str.charAt(i2);
            if (cCharAt == '+') {
                cCharAt = ' ';
            } else if (cCharAt == '%' && (i = i2 + 2) < length) {
                int iDehexchar = JSONTokener.dehexchar(str.charAt(i2 + 1));
                int iDehexchar2 = JSONTokener.dehexchar(str.charAt(i));
                if (iDehexchar >= 0 && iDehexchar2 >= 0) {
                    cCharAt = (char) ((iDehexchar * 16) + iDehexchar2);
                    i2 = i;
                }
            }
            sb.append(cCharAt);
            i2++;
        }
        return sb.toString();
    }
}
