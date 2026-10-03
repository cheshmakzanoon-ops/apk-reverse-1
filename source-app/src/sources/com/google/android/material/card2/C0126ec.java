package com.google.android.material.card2;

import java.sql.Timestamp;
import java.util.Date;

class C0126ec implements InterfaceC0024aj {
    C0126ec() {
    }

    @Override
    public <T> AbstractC0022ah<T> mo229a(C0285k c0285k, C0151fa<T> c0151fa) {
        if (abc.m1970(c0151fa) != Timestamp.class) {
            return null;
        }
        return new C0127ed(this, abf.m2506(c0285k, Date.class));
    }
}
