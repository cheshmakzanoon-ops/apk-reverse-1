package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

import java.util.Arrays;

public class StringSupport {
    public static String indent(String str, int i) {
        if (str == null) {
            return null;
        }
        return str.replaceAll("(\\r?\\n)", "$1" + fillString(i, ' '));
    }

    public static String fillString(int i, char c) {
        char[] cArr = new char[i];
        Arrays.fill(cArr, c);
        return new String(cArr);
    }
}
