package com.ishumei.smantifraud;

import java.util.HashMap;
import java.util.Map;

public abstract class l1l11I11lll<T> extends l11l11l1lI1l<T> {
    public static final String l111l111llIl = "Connection";
    public static final String l11l111lI1l = "Close";
    public static final String l11l111llI1l = "application/octet-stream";
    public static final String l11l111lllIl = "Content-Type";

    public class l1111l111111Il implements l1l11lIl.l111l11111lIl<T> {
        @Override
        public void l1111l111111Il(T t) {
        }
    }

    public class l111l11111lIl implements l1l11lIl.l1111l111111Il {
        @Override
        public void l1111l111111Il(l1l11I11ll l1l11i11ll) {
        }
    }

    public l1l11I11lll(int i, String str, String str2, String str3, l1l11lIl.l111l11111lIl<T> l111l11111lil, l1l11lIl.l1111l111111Il l1111l111111il) {
        super(i, str, str2, str3, l111l11111lil, l1111l111111il);
    }

    public l1l11I11lll(String str, String str2, String str3) {
        this(1, str, str2, str3, new l1111l111111Il(), new l111l11111lIl());
    }

    @Override
    public Map<String, String> l111l1111llIl() {
        HashMap map = new HashMap();
        map.put("Content-Type", "application/octet-stream");
        map.put("Connection", l11l111lI1l);
        return map;
    }
}
