package com.google.android.material.card2;

import java.lang.reflect.AccessibleObject;

public abstract class AbstractC0148ey {

    private static final AbstractC0148ey f254dR;

    static {
        f254dR = C0455za.m10194() < 9 ? new C0147ex() : new C0149ez();
    }

    public static AbstractC0148ey m428ai() {
        return C0453yj.m10034();
    }

    public static AbstractC0148ey m3750() {
        if (C0451yg.m9580() >= 0) {
            return f254dR;
        }
        return null;
    }

    public static AbstractC0148ey m3751() {
        if (C0457zc.m10555() >= 0) {
            return m3750();
        }
        return null;
    }

    public abstract void mo427a(AccessibleObject accessibleObject);
}
