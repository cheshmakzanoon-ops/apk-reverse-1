package com.google.android.material.card2;

import java.lang.reflect.GenericArrayType;
import java.lang.reflect.Type;

class C0078ci implements InterfaceC0024aj {
    C0078ci() {
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        Type typeM10432 = C0456zb.m10432(c0151fa);
        if (!(typeM10432 instanceof GenericArrayType) && (!(typeM10432 instanceof Class) || !C0459zf.m11119((Class) typeM10432))) {
            return null;
        }
        Type typeM2358 = abe.m2358(typeM10432);
        return new C0077ch(c0285k, abd.m2165(c0285k, C0461zs.m11619(typeM2358)), C0445ya.m8294(typeM2358));
    }
}
