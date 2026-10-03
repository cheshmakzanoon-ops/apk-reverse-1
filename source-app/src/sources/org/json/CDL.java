package org.json;

import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

public class CDL {
    private static String getValue(JSONTokener jSONTokener) throws JSONException {
        char next;
        char next2;
        while (true) {
            next = jSONTokener.next();
            if (next != ' ' && next != '\t') {
                break;
            }
        }
        if (next == 0) {
            return null;
        }
        if (next != '\"' && next != '\'') {
            if (next == ',') {
                jSONTokener.back();
                return "";
            }
            jSONTokener.back();
            return jSONTokener.nextTo(AbstractJsonLexerKt.COMMA);
        }
        StringBuilder sb = new StringBuilder();
        while (true) {
            char next3 = jSONTokener.next();
            if (next3 == next && (next2 = jSONTokener.next()) != '\"') {
                if (next2 > 0) {
                    jSONTokener.back();
                }
                return sb.toString();
            }
            if (next3 == 0 || next3 == '\n' || next3 == '\r') {
                throw jSONTokener.syntaxError("Missing close quote '" + next + "'.");
            }
            sb.append(next3);
        }
    }

    public static JSONArray rowToJSONArray(JSONTokener jSONTokener) throws JSONException {
        JSONArray jSONArray = new JSONArray();
        while (true) {
            String value = getValue(jSONTokener);
            char next = jSONTokener.next();
            if (value == null) {
                return null;
            }
            if (jSONArray.length() == 0 && value.length() == 0 && next != ',') {
                return null;
            }
            jSONArray.put(value);
            while (next != ',') {
                if (next != ' ') {
                    if (next == '\n' || next == '\r' || next == 0) {
                        return jSONArray;
                    }
                    throw jSONTokener.syntaxError("Bad character '" + next + "' (" + ((int) next) + ").");
                }
                next = jSONTokener.next();
            }
        }
    }

    public static JSONObject rowToJSONObject(JSONArray jSONArray, JSONTokener jSONTokener) throws JSONException {
        JSONArray jSONArrayRowToJSONArray = rowToJSONArray(jSONTokener);
        if (jSONArrayRowToJSONArray != null) {
            return jSONArrayRowToJSONArray.toJSONObject(jSONArray);
        }
        return null;
    }

    public static String rowToString(JSONArray jSONArray) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < jSONArray.length(); i++) {
            if (i > 0) {
                sb.append(AbstractJsonLexerKt.COMMA);
            }
            Object objOpt = jSONArray.opt(i);
            if (objOpt != null) {
                String string = objOpt.toString();
                if (string.length() > 0 && (string.indexOf(44) >= 0 || string.indexOf(10) >= 0 || string.indexOf(13) >= 0 || string.indexOf(0) >= 0 || string.charAt(0) == '\"')) {
                    sb.append('\"');
                    int length = string.length();
                    for (int i2 = 0; i2 < length; i2++) {
                        char cCharAt = string.charAt(i2);
                        if (cCharAt >= ' ' && cCharAt != '\"') {
                            sb.append(cCharAt);
                        }
                    }
                    sb.append('\"');
                } else {
                    sb.append(string);
                }
            }
        }
        sb.append('\n');
        return sb.toString();
    }

    public static JSONArray toJSONArray(String str) throws JSONException {
        return toJSONArray(new JSONTokener(str));
    }

    public static JSONArray toJSONArray(JSONTokener jSONTokener) throws JSONException {
        return toJSONArray(rowToJSONArray(jSONTokener), jSONTokener);
    }

    public static JSONArray toJSONArray(JSONArray jSONArray, String str) throws JSONException {
        return toJSONArray(jSONArray, new JSONTokener(str));
    }

    public static JSONArray toJSONArray(JSONArray jSONArray, JSONTokener jSONTokener) throws JSONException {
        if (jSONArray == null || jSONArray.length() == 0) {
            return null;
        }
        JSONArray jSONArray2 = new JSONArray();
        while (true) {
            JSONObject jSONObjectRowToJSONObject = rowToJSONObject(jSONArray, jSONTokener);
            if (jSONObjectRowToJSONObject == null) {
                break;
            }
            jSONArray2.put(jSONObjectRowToJSONObject);
        }
        if (jSONArray2.length() == 0) {
            return null;
        }
        return jSONArray2;
    }

    public static String toString(JSONArray jSONArray) throws JSONException {
        JSONArray jSONArrayNames;
        JSONObject jSONObjectOptJSONObject = jSONArray.optJSONObject(0);
        if (jSONObjectOptJSONObject == null || (jSONArrayNames = jSONObjectOptJSONObject.names()) == null) {
            return null;
        }
        return rowToString(jSONArrayNames) + toString(jSONArrayNames, jSONArray);
    }

    public static String toString(JSONArray jSONArray, JSONArray jSONArray2) throws JSONException {
        if (jSONArray == null || jSONArray.length() == 0) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < jSONArray2.length(); i++) {
            JSONObject jSONObjectOptJSONObject = jSONArray2.optJSONObject(i);
            if (jSONObjectOptJSONObject != null) {
                sb.append(rowToString(jSONObjectOptJSONObject.toJSONArray(jSONArray)));
            }
        }
        return sb.toString();
    }
}
