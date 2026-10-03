package com.google.android.material.card2;

import java.io.File;
import java.io.IOException;

final class C0386ns implements InterfaceC0385nr {
    C0386ns() {
    }

    public static void m7418(Object obj, Object obj2) throws IOException {
        if (C0456zb.m10326() < 0) {
            m7420(obj, obj2);
        }
    }

    public static void m7419(Object obj, Object obj2) throws IOException {
        if (gggy.m4269() <= 0) {
            ((C0386ns) obj).mo1267a((File) obj2);
        }
    }

    public static void m7420(Object obj, Object obj2) throws IOException {
        if (C0445ya.m8330() >= 0) {
            m7419((C0386ns) obj, (File) obj2);
        }
    }

    @Override
    public void mo1267a(File file) throws IOException {
        if (!C0448yd.m8996(file) && C0449ye.m9283(file)) {
            throw new IOException(abc.m1925(abd.m2090(C0460zg.m11407(new StringBuilder(), C0450yf.m9461()), file)));
        }
    }

    @Override
    public void mo1268a(File file, File file2) throws IOException {
        m7418(this, file2);
        if (!C0459zf.m11025(file, file2)) {
            throw new IOException(abc.m1925(abd.m2090(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0461zs.m11625()), file), C0458ze.m10784()), file2)));
        }
    }

    @Override
    public boolean mo1269b(File file) {
        return C0449ye.m9283(file);
    }

    @Override
    public long mo1270c(File file) {
        return C0453yj.m9957(file);
    }
}
