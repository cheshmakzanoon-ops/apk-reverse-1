package com.google.android.material.card2;

import java.lang.ref.SoftReference;
import java.util.Hashtable;

public class C0170ft<K, V> {

    Hashtable<K, SoftReference<V>> f331fg = new Hashtable<>();

    public static Hashtable m4066(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0170ft) obj).f331fg;
        }
        return null;
    }

    public static Hashtable m4067(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m4066((C0170ft) obj);
        }
        return null;
    }

    public V get(K k) {
        SoftReference softReference = (SoftReference) C0449ye.m9236(C0457zc.m10731(this), k);
        if (softReference == null) {
            return null;
        }
        V v = (V) C0448yd.m8943(softReference);
        if (v != null) {
            return v;
        }
        C0455za.m10196(C0457zc.m10731(this), k);
        return v;
    }

    public V put(K k, V v) {
        SoftReference softReference = (SoftReference) abd.m2110(C0457zc.m10731(this), k, new SoftReference(v));
        if (softReference == null) {
            return null;
        }
        return (V) C0448yd.m8943(softReference);
    }

    public V remove(K k) {
        SoftReference softReference = (SoftReference) C0455za.m10196(C0457zc.m10731(this), k);
        if (softReference == null) {
            return null;
        }
        return (V) C0448yd.m8943(softReference);
    }
}
