package com.appsflyer.internal;

import j$.util.Map;
import java.util.HashMap;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;

public class AFa1nSDK extends HashMap<Integer, String> implements Map {
    private static AFa1nSDK AFKeystoreWrapper;
    private final Object valueOf = new Object();

    @Override
    public Object compute(Object obj, BiFunction biFunction) {
        return Map.-CC.$default$compute(this, obj, biFunction);
    }

    @Override
    public Object computeIfAbsent(Object obj, Function function) {
        return Map.-CC.$default$computeIfAbsent(this, obj, function);
    }

    @Override
    public Object computeIfPresent(Object obj, BiFunction biFunction) {
        return Map.-CC.$default$computeIfPresent(this, obj, biFunction);
    }

    @Override
    public void forEach(BiConsumer biConsumer) {
        Map.-CC.$default$forEach(this, biConsumer);
    }

    @Override
    public Object getOrDefault(Object obj, Object obj2) {
        return Map.-CC.$default$getOrDefault(this, obj, obj2);
    }

    @Override
    public Object merge(Object obj, Object obj2, BiFunction biFunction) {
        return Map.-CC.$default$merge(this, obj, obj2, biFunction);
    }

    @Override
    public Object putIfAbsent(Object obj, Object obj2) {
        return Map.-CC.$default$putIfAbsent(this, obj, obj2);
    }

    @Override
    public Object replace(Object obj, Object obj2) {
        return Map.-CC.$default$replace(this, obj, obj2);
    }

    @Override
    public boolean replace(Object obj, Object obj2, Object obj3) {
        return Map.-CC.$default$replace(this, obj, obj2, obj3);
    }

    @Override
    public void replaceAll(BiFunction biFunction) {
        Map.-CC.$default$replaceAll(this, biFunction);
    }

    private AFa1nSDK() {
    }

    public static synchronized AFa1nSDK afErrorLog() {
        if (AFKeystoreWrapper == null) {
            AFKeystoreWrapper = new AFa1nSDK();
        }
        return AFKeystoreWrapper;
    }

    @Override
    public String put(Integer num, String str) {
        String str2;
        synchronized (this.valueOf) {
            str2 = (String) super.put(num, str);
        }
        return str2;
    }

    @Override
    public boolean remove(Object obj, Object obj2) {
        boolean z$default$remove;
        synchronized (this.valueOf) {
            z$default$remove = Map.-CC.$default$remove(this, obj, obj2);
        }
        return z$default$remove;
    }

    @Override
    public String remove(Object obj) {
        String str;
        synchronized (this.valueOf) {
            str = (String) super.remove(obj);
        }
        return str;
    }
}
