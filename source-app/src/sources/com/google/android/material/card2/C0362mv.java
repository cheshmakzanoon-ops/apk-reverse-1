package com.google.android.material.card2;

import java.net.Socket;

public class C0362mv {

    InterfaceC0410op f1166pv;

    Socket f1167pw;

    InterfaceC0411oq f1168px;

    boolean f1169sa;

    String f1170sc;

    AbstractC0363mw f1171se = C0458ze.m10897();

    InterfaceC0381nn f1172sl = C0458ze.m10968();

    public C0362mv(boolean z) {
        this.f1169sa = z;
    }

    public C0362mv m1172a(AbstractC0363mw abstractC0363mw) {
        this.f1171se = abstractC0363mw;
        return this;
    }

    public C0362mv m1173a(Socket socket, String str, InterfaceC0411oq interfaceC0411oq, InterfaceC0410op interfaceC0410op) {
        this.f1167pw = socket;
        this.f1170sc = str;
        this.f1168px = interfaceC0411oq;
        this.f1166pv = interfaceC0410op;
        return this;
    }

    public C0354mn m1174eC() {
        return new C0354mn(this);
    }
}
