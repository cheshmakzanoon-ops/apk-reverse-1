package com.google.android.material.card2;

import java.io.IOException;

public abstract class AbstractC0022ah<T> {
    public abstract void mo225a(C0155fe c0155fe, T t);

    public final AbstractC0441v m226b(T t) {
        try {
            C0086cq c0086cq = new C0086cq();
            C0457zc.m10586(this, c0086cq, t);
            return abc.m1765(c0086cq);
        } catch (IOException e) {
            throw new C0442w(e);
        }
    }

    public abstract T mo227b(C0152fb c0152fb);

    public final AbstractC0022ah<T> m228q() {
        return new C0023ai(this);
    }
}
