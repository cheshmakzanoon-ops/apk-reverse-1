package com.appsflyer.internal;

public abstract class AFh1vSDK extends AFa1pSDK {
    private final boolean force;

    private boolean f397i;

    private final boolean f398w;

    AFh1vSDK() {
        this(null, null, null, null, null);
    }

    public AFh1vSDK(String str, String str2, Boolean bool, Boolean bool2, Boolean bool3) {
        super(str, str2, Boolean.valueOf(bool3 != null ? bool3.booleanValue() : false));
        this.f398w = bool != null ? bool.booleanValue() : true;
        this.force = bool2 != null ? bool2.booleanValue() : true;
    }

    public final boolean m818w() {
        return this.f397i;
    }

    public final boolean m816i() {
        return this.f398w;
    }

    public final boolean m817v() {
        return this.force;
    }
}
