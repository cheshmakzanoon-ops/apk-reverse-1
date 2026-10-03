package org.json;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class JSONPointer {
    private static final String ENCODING = "utf-8";
    private final List<String> refTokens;

    public static class Builder {
        private final List<String> refTokens = new ArrayList();

        public JSONPointer build() {
            return new JSONPointer(this.refTokens);
        }

        public Builder append(String str) {
            if (str == null) {
                throw new NullPointerException("token cannot be null");
            }
            this.refTokens.add(str);
            return this;
        }

        public Builder append(int i) {
            this.refTokens.add(String.valueOf(i));
            return this;
        }
    }

    public static Builder builder() {
        return new Builder();
    }

    public JSONPointer(String str) {
        String strSubstring;
        if (str == null) {
            throw new NullPointerException("pointer cannot be null");
        }
        if (str.isEmpty() || str.equals("#")) {
            this.refTokens = Collections.emptyList();
            return;
        }
        if (str.startsWith("#/")) {
            try {
                strSubstring = URLDecoder.decode(str.substring(2), ENCODING);
            } catch (UnsupportedEncodingException e) {
                throw new RuntimeException(e);
            }
        } else if (str.startsWith("/")) {
            strSubstring = str.substring(1);
        } else {
            throw new IllegalArgumentException("a JSON pointer should start with '/' or '#/'");
        }
        this.refTokens = new ArrayList();
        int i = -1;
        while (true) {
            int i2 = i + 1;
            int iIndexOf = strSubstring.indexOf(47, i2);
            if (i2 == iIndexOf || i2 == strSubstring.length()) {
                this.refTokens.add("");
            } else if (iIndexOf >= 0) {
                this.refTokens.add(unescape(strSubstring.substring(i2, iIndexOf)));
            } else {
                this.refTokens.add(unescape(strSubstring.substring(i2)));
            }
            if (iIndexOf < 0) {
                return;
            } else {
                i = iIndexOf;
            }
        }
    }

    public JSONPointer(List<String> list) {
        this.refTokens = new ArrayList(list);
    }

    private static String unescape(String str) {
        return str.replace("~1", "/").replace("~0", "~");
    }

    public Object queryFrom(Object obj) throws JSONPointerException {
        if (this.refTokens.isEmpty()) {
            return obj;
        }
        for (String str : this.refTokens) {
            if (obj instanceof JSONObject) {
                obj = ((JSONObject) obj).opt(unescape(str));
            } else if (obj instanceof JSONArray) {
                obj = readByIndexToken(obj, str);
            } else {
                throw new JSONPointerException(String.format("value [%s] is not an array or object therefore its key %s cannot be resolved", obj, str));
            }
        }
        return obj;
    }

    private static Object readByIndexToken(Object obj, String str) throws JSONPointerException {
        try {
            int i = Integer.parseInt(str);
            JSONArray jSONArray = (JSONArray) obj;
            if (i >= jSONArray.length()) {
                throw new JSONPointerException(String.format("index %s is out of bounds - the array has %d elements", str, Integer.valueOf(jSONArray.length())));
            }
            try {
                return jSONArray.get(i);
            } catch (JSONException e) {
                throw new JSONPointerException("Error reading value at index position " + i, e);
            }
        } catch (NumberFormatException e2) {
            throw new JSONPointerException(String.format("%s is not an array index", str), e2);
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("");
        for (String str : this.refTokens) {
            sb.append('/');
            sb.append(escape(str));
        }
        return sb.toString();
    }

    private static String escape(String str) {
        return str.replace("~", "~0").replace("/", "~1");
    }

    public String toURIFragment() {
        try {
            StringBuilder sb = new StringBuilder("#");
            for (String str : this.refTokens) {
                sb.append('/');
                sb.append(URLEncoder.encode(str, ENCODING));
            }
            return sb.toString();
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }
}
