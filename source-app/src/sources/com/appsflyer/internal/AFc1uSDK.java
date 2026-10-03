package com.appsflyer.internal;

import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Locale;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.MatchGroup;
import kotlin.text.MatchResult;
import kotlin.text.Regex;
import kotlin.text.StringsKt;

public final class AFc1uSDK {
    public static final int AFInAppEventParameterName(String str) {
        String value;
        Integer intOrNull;
        String value2;
        Integer intOrNull2;
        String value3;
        Integer intOrNull3;
        Intrinsics.checkNotNullParameter(str, "");
        MatchResult matchResultMatchEntire = new Regex("(\\d+).(\\d+).(\\d+).*").matchEntire(str);
        if (matchResultMatchEntire == null) {
            return -1;
        }
        MatchGroup matchGroup = matchResultMatchEntire.getGroups().get(1);
        int iIntValue = 0;
        int iIntValue2 = ((matchGroup == null || (value3 = matchGroup.getValue()) == null || (intOrNull3 = StringsKt.toIntOrNull(value3)) == null) ? 0 : intOrNull3.intValue()) * 1000000;
        MatchGroup matchGroup2 = matchResultMatchEntire.getGroups().get(2);
        int iIntValue3 = iIntValue2 + (((matchGroup2 == null || (value2 = matchGroup2.getValue()) == null || (intOrNull2 = StringsKt.toIntOrNull(value2)) == null) ? 0 : intOrNull2.intValue()) * 1000);
        MatchGroup matchGroup3 = matchResultMatchEntire.getGroups().get(3);
        if (matchGroup3 != null && (value = matchGroup3.getValue()) != null && (intOrNull = StringsKt.toIntOrNull(value)) != null) {
            iIntValue = intOrNull.intValue();
        }
        return iIntValue3 + iIntValue;
    }

    public static final double values(String str) throws ParseException {
        Intrinsics.checkNotNullParameter(str, "");
        try {
            return Double.parseDouble(str);
        } catch (NumberFormatException unused) {
            Number number = NumberFormat.getInstance(Locale.getDefault()).parse(str);
            if (number != null) {
                return number.doubleValue();
            }
            throw new ParseException("Failed parse String into number", 0);
        }
    }
}
