package p000j$.time;

import java.io.DataOutput;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.Map;
import java.util.TimeZone;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalQueries;
import p000j$.time.zone.ZoneRules;
import p000j$.time.zone.ZoneRulesException;
import p000j$.util.DesugarTimeZone;
import p000j$.util.Objects;

public abstract class ZoneId implements Serializable {
    public static final Map SHORT_IDS = ZoneId$$ExternalSyntheticBackport1.m1678m(new Map.Entry[]{ZoneId$$ExternalSyntheticBackport0.m1677m("ACT", "Australia/Darwin"), ZoneId$$ExternalSyntheticBackport0.m1677m("AET", "Australia/Sydney"), ZoneId$$ExternalSyntheticBackport0.m1677m("AGT", "America/Argentina/Buenos_Aires"), ZoneId$$ExternalSyntheticBackport0.m1677m("ART", "Africa/Cairo"), ZoneId$$ExternalSyntheticBackport0.m1677m("AST", "America/Anchorage"), ZoneId$$ExternalSyntheticBackport0.m1677m("BET", "America/Sao_Paulo"), ZoneId$$ExternalSyntheticBackport0.m1677m("BST", "Asia/Dhaka"), ZoneId$$ExternalSyntheticBackport0.m1677m("CAT", "Africa/Harare"), ZoneId$$ExternalSyntheticBackport0.m1677m("CNT", "America/St_Johns"), ZoneId$$ExternalSyntheticBackport0.m1677m("CST", "America/Chicago"), ZoneId$$ExternalSyntheticBackport0.m1677m("CTT", "Asia/Shanghai"), ZoneId$$ExternalSyntheticBackport0.m1677m("EAT", "Africa/Addis_Ababa"), ZoneId$$ExternalSyntheticBackport0.m1677m("ECT", "Europe/Paris"), ZoneId$$ExternalSyntheticBackport0.m1677m("IET", "America/Indiana/Indianapolis"), ZoneId$$ExternalSyntheticBackport0.m1677m("IST", "Asia/Kolkata"), ZoneId$$ExternalSyntheticBackport0.m1677m("JST", "Asia/Tokyo"), ZoneId$$ExternalSyntheticBackport0.m1677m("MIT", "Pacific/Apia"), ZoneId$$ExternalSyntheticBackport0.m1677m("NET", "Asia/Yerevan"), ZoneId$$ExternalSyntheticBackport0.m1677m("NST", "Pacific/Auckland"), ZoneId$$ExternalSyntheticBackport0.m1677m("PLT", "Asia/Karachi"), ZoneId$$ExternalSyntheticBackport0.m1677m("PNT", "America/Phoenix"), ZoneId$$ExternalSyntheticBackport0.m1677m("PRT", "America/Puerto_Rico"), ZoneId$$ExternalSyntheticBackport0.m1677m("PST", "America/Los_Angeles"), ZoneId$$ExternalSyntheticBackport0.m1677m("SST", "Pacific/Guadalcanal"), ZoneId$$ExternalSyntheticBackport0.m1677m("VST", "Asia/Ho_Chi_Minh"), ZoneId$$ExternalSyntheticBackport0.m1677m("EST", "-05:00"), ZoneId$$ExternalSyntheticBackport0.m1677m("MST", "-07:00"), ZoneId$$ExternalSyntheticBackport0.m1677m("HST", "-10:00")});
    private static final long serialVersionUID = 8352817235686L;

    public abstract String getId();

    public abstract ZoneRules getRules();

    abstract void write(DataOutput dataOutput);

    public static ZoneId systemDefault() {
        return DesugarTimeZone.toZoneId(TimeZone.getDefault());
    }

    public static ZoneId m1675of(String str, Map map) {
        Objects.requireNonNull(str, "zoneId");
        Objects.requireNonNull(map, "aliasMap");
        return m1674of((String) Objects.requireNonNullElse((String) map.get(str), str));
    }

    public static ZoneId m1674of(String str) {
        return m1676of(str, true);
    }

    public static ZoneId ofOffset(String str, ZoneOffset zoneOffset) {
        Objects.requireNonNull(str, "prefix");
        Objects.requireNonNull(zoneOffset, "offset");
        if (str.isEmpty()) {
            return zoneOffset;
        }
        if (!str.equals("GMT") && !str.equals("UTC") && !str.equals("UT")) {
            throw new IllegalArgumentException("prefix should be GMT, UTC or UT, is: " + str);
        }
        if (zoneOffset.getTotalSeconds() != 0) {
            str = str.concat(zoneOffset.getId());
        }
        return new ZoneRegion(str, zoneOffset.getRules());
    }

    static ZoneId m1676of(String str, boolean z) {
        Objects.requireNonNull(str, "zoneId");
        if (str.length() <= 1 || str.startsWith("+") || str.startsWith("-")) {
            return ZoneOffset.m1679of(str);
        }
        if (str.startsWith("UTC") || str.startsWith("GMT")) {
            return ofWithPrefix(str, 3, z);
        }
        if (str.startsWith("UT")) {
            return ofWithPrefix(str, 2, z);
        }
        return ZoneRegion.ofId(str, z);
    }

    private static ZoneId ofWithPrefix(String str, int i, boolean z) {
        String strSubstring = str.substring(0, i);
        if (str.length() == i) {
            return ofOffset(strSubstring, ZoneOffset.UTC);
        }
        if (str.charAt(i) != '+' && str.charAt(i) != '-') {
            return ZoneRegion.ofId(str, z);
        }
        try {
            ZoneOffset zoneOffsetM1679of = ZoneOffset.m1679of(str.substring(i));
            if (zoneOffsetM1679of == ZoneOffset.UTC) {
                return ofOffset(strSubstring, zoneOffsetM1679of);
            }
            return ofOffset(strSubstring, zoneOffsetM1679of);
        } catch (DateTimeException e) {
            throw new DateTimeException("Invalid ID for offset-based ZoneId: " + str, e);
        }
    }

    public static ZoneId from(TemporalAccessor temporalAccessor) {
        ZoneId zoneId = (ZoneId) temporalAccessor.query(TemporalQueries.zone());
        if (zoneId != null) {
            return zoneId;
        }
        throw new DateTimeException("Unable to obtain ZoneId from TemporalAccessor: " + temporalAccessor + " of type " + temporalAccessor.getClass().getName());
    }

    ZoneId() {
        if (getClass() != ZoneOffset.class && getClass() != ZoneRegion.class) {
            throw new AssertionError("Invalid subclass");
        }
    }

    public ZoneId normalized() {
        try {
            ZoneRules rules = getRules();
            if (rules.isFixedOffset()) {
                return rules.getOffset(Instant.EPOCH);
            }
        } catch (ZoneRulesException unused) {
        }
        return this;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof ZoneId) {
            return getId().equals(((ZoneId) obj).getId());
        }
        return false;
    }

    public int hashCode() {
        return getId().hashCode();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }

    public String toString() {
        return getId();
    }

    private Object writeReplace() {
        return new Ser((byte) 7, this);
    }
}
