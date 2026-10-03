package p000j$.util;

import java.util.TimeZone;
import p000j$.time.ZoneId;

public class DesugarTimeZone {
    public static TimeZone getTimeZone(String str) {
        return TimeZone.getTimeZone(str);
    }

    public static ZoneId toZoneId(TimeZone timeZone) {
        return ZoneId.m1675of(timeZone.getID(), ZoneId.SHORT_IDS);
    }
}
