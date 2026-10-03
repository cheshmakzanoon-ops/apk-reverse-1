package p000j$.time;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import p000j$.util.Objects;

public abstract class ZoneId$$ExternalSyntheticBackport1 {
    public static Map m1678m(Map.Entry[] entryArr) {
        HashMap map = new HashMap(entryArr.length);
        for (Map.Entry entry : entryArr) {
            Object objRequireNonNull = Objects.requireNonNull(entry.getKey());
            if (map.put(objRequireNonNull, Objects.requireNonNull(entry.getValue())) != null) {
                throw new IllegalArgumentException("duplicate key: " + objRequireNonNull);
            }
        }
        return Collections.unmodifiableMap(map);
    }
}
