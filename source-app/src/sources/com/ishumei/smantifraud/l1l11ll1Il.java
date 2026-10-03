package com.ishumei.smantifraud;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class l1l11ll1Il {
    public final int l1111l111111Il;
    public final Map<String, String> l111l11111I1l;
    public final List<l11l11l11lIl> l111l11111Il;
    public final byte[] l111l11111lIl;
    public final boolean l111l1111l1Il;
    public final long l111l1111llIl;

    public l1l11ll1Il(int i, byte[] bArr, Map<String, String> map, List<l11l11l11lIl> list, boolean z, long j) {
        this.l1111l111111Il = i;
        this.l111l11111lIl = bArr;
        this.l111l11111I1l = map;
        this.l111l11111Il = list == null ? null : Collections.unmodifiableList(list);
        this.l111l1111l1Il = z;
        this.l111l1111llIl = j;
    }

    @Deprecated
    public l1l11ll1Il(int i, byte[] bArr, Map<String, String> map, boolean z) {
        this(i, bArr, map, z, 0L);
    }

    @Deprecated
    public l1l11ll1Il(int i, byte[] bArr, Map<String, String> map, boolean z, long j) {
        this(i, bArr, map, l1111l111111Il(map), z, j);
    }

    public l1l11ll1Il(int i, byte[] bArr, boolean z, long j, List<l11l11l11lIl> list) {
        this(i, bArr, l1111l111111Il(list), list, z, j);
    }

    public l1l11ll1Il(byte[] bArr) {
        this(200, bArr, false, 0L, (List<l11l11l11lIl>) Collections.emptyList());
    }

    @Deprecated
    public l1l11ll1Il(byte[] bArr, Map<String, String> map) {
        this(200, bArr, map, false, 0L);
    }

    public static List<l11l11l11lIl> l1111l111111Il(Map<String, String> map) {
        if (map == null) {
            return null;
        }
        if (map.isEmpty()) {
            return Collections.emptyList();
        }
        ArrayList arrayList = new ArrayList(map.size());
        for (Map.Entry<String, String> entry : map.entrySet()) {
            arrayList.add(new l11l11l11lIl(entry.getKey(), entry.getValue()));
        }
        return arrayList;
    }

    public static Map<String, String> l1111l111111Il(List<l11l11l11lIl> list) {
        if (list == null) {
            return null;
        }
        if (list.isEmpty()) {
            return Collections.emptyMap();
        }
        TreeMap treeMap = new TreeMap(String.CASE_INSENSITIVE_ORDER);
        for (l11l11l11lIl l11l11l11lil : list) {
            treeMap.put(l11l11l11lil.l1111l111111Il, l11l11l11lil.l111l11111lIl);
        }
        return treeMap;
    }
}
