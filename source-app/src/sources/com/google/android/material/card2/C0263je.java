package com.google.android.material.card2;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;

final class C0263je implements InterfaceC0262jd {
    C0263je() {
    }

    @Override
    public List<InetAddress> mo685u(String str) throws UnknownHostException {
        if (str == null) {
            throw new UnknownHostException(C0445ya.m8313());
        }
        try {
            return abf.m2488(abc.m1833(str));
        } catch (NullPointerException e) {
            UnknownHostException unknownHostException = new UnknownHostException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0452yh.m9661()), str)));
            C0456zb.m10450(unknownHostException, e);
            throw unknownHostException;
        }
    }
}
