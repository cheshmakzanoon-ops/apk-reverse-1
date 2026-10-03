package com.unity3d.player;

final class C1142q {

    private static boolean f480a;

    private boolean f481b = false;

    private boolean f482c = false;

    private boolean f483d = true;

    private boolean f484e = false;

    C1142q() {
    }

    static void m678a() {
        f480a = true;
    }

    static void m679b() {
        f480a = false;
    }

    static boolean m680c() {
        return f480a;
    }

    final void m681a(boolean z) {
        this.f481b = z;
    }

    final void m682b(boolean z) {
        this.f483d = z;
    }

    final void m683c(boolean z) {
        this.f484e = z;
    }

    final void m684d(boolean z) {
        this.f482c = z;
    }

    final boolean m685d() {
        return this.f483d;
    }

    final boolean m686e() {
        return this.f484e;
    }

    final boolean m687e(boolean z) {
        if (f480a) {
            return ((!z && !this.f481b) || this.f483d || this.f482c) ? false : true;
        }
        return false;
    }

    final boolean m688f() {
        return this.f482c;
    }

    public final String toString() {
        return super.toString();
    }
}
