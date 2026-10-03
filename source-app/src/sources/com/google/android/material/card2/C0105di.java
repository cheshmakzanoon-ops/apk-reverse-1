package com.google.android.material.card2;

import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;

final class C0105di<T> extends AbstractC0022ah<T> {

    private final C0285k f181cw;

    private final AbstractC0022ah<T> f182cx;

    private final Type f183cy;

    C0105di(C0285k c0285k, AbstractC0022ah<T> abstractC0022ah, Type type) {
        this.f181cw = c0285k;
        this.f182cx = abstractC0022ah;
        this.f183cy = type;
    }

    private Type m386a(Type type, Object obj) {
        if (obj != null) {
            return (type == Object.class || (type instanceof TypeVariable) || (type instanceof Class)) ? gggy.m4399(obj) : type;
        }
        return type;
    }

    public static Type m3458(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8222() > 0) {
            return ((C0105di) obj).m386a((Type) obj2, obj3);
        }
        return null;
    }

    public static C0285k m3459(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m3467(obj);
        }
        return null;
    }

    public static C0285k m3460(Object obj) {
        if (C0448yd.m9079() < 0) {
            return ((C0105di) obj).f181cw;
        }
        return null;
    }

    public static AbstractC0022ah m3461(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0105di) obj).f182cx;
        }
        return null;
    }

    public static Type m3462(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m3468(obj);
        }
        return null;
    }

    public static Type m3463(Object obj, Object obj2, Object obj3) {
        if (C0458ze.m10932() >= 0) {
            return m3470(obj, obj2, obj3);
        }
        return null;
    }

    public static int m3464() {
        if (C0461zs.m11510() < 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static AbstractC0022ah m3465(Object obj) {
        if (C0449ye.m9220() < 0) {
            return m3469(obj);
        }
        return null;
    }

    public static Type m3466(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0105di) obj).f183cy;
        }
        return null;
    }

    public static C0285k m3467(Object obj) {
        if (gggy.m4365() >= 0) {
            return m3460((C0105di) obj);
        }
        return null;
    }

    public static Type m3468(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m3466((C0105di) obj);
        }
        return null;
    }

    public static AbstractC0022ah m3469(Object obj) {
        if (m3464() >= 0) {
            return m3461((C0105di) obj);
        }
        return null;
    }

    public static Type m3470(Object obj, Object obj2, Object obj3) {
        if (abd.m2021() >= 0) {
            return m3458((C0105di) obj, (Type) obj2, obj3);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, T t) {
        AbstractC0022ah abstractC0022ahM3465 = m3465(this);
        Type typeM3463 = m3463(this, m3462(this), t);
        if (typeM3463 != m3462(this)) {
            abstractC0022ahM3465 = abd.m2165(m3459(this), C0461zs.m11619(typeM3463));
            if ((abstractC0022ahM3465 instanceof C0095cz) && !(m3465(this) instanceof C0095cz)) {
                abstractC0022ahM3465 = m3465(this);
            }
        }
        C0457zc.m10586(abstractC0022ahM3465, c0155fe, t);
    }

    @Override
    public T mo227b(C0152fb c0152fb) {
        return (T) C0447yc.m8683(m3465(this), c0152fb);
    }
}
