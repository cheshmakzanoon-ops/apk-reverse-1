package cn.thinkingdata.android.utils;

import java.util.HashMap;
import java.util.Map;

public enum EnumC0761l {
    TRACK("track"),
    TRACK_UPDATE("track_update"),
    TRACK_OVERWRITE("track_overwrite"),
    USER_ADD("user_add"),
    USER_SET("user_set"),
    USER_SET_ONCE("user_setOnce"),
    USER_UNSET("user_unset"),
    USER_APPEND("user_append"),
    USER_DEL("user_del"),
    USER_UNIQ_APPEND("user_uniq_append");


    private static final Map<String, EnumC0761l> f267l = new HashMap();

    private final String f269a;

    static {
        for (EnumC0761l enumC0761l : values()) {
            f267l.put(enumC0761l.m715a(), enumC0761l);
        }
    }

    EnumC0761l(String str) {
        this.f269a = str;
    }

    public static EnumC0761l m714a(String str) {
        return f267l.get(str);
    }

    public String m715a() {
        return this.f269a;
    }

    public boolean m716b() {
        return this == TRACK || this == TRACK_OVERWRITE || this == TRACK_UPDATE;
    }
}
