package com.google.android.material.card2;

import java.io.EOFException;
import java.io.IOException;
import java.io.Writer;

public final class C0068bz {
    public static Writer m323a(Appendable appendable) {
        return appendable instanceof Writer ? (Writer) appendable : new C0070ca(appendable);
    }

    public static void m324b(AbstractC0441v abstractC0441v, C0155fe c0155fe) {
        C0457zc.m10586(gggy.m4271(), c0155fe, abstractC0441v);
    }

    public static AbstractC0441v m325h(C0152fb c0152fb) {
        boolean z = true;
        try {
            abe.m2401(c0152fb);
            z = false;
            return (AbstractC0441v) C0447yc.m8683(gggy.m4271(), c0152fb);
        } catch (C0156ff e) {
            throw new C0018ad(e);
        } catch (EOFException e2) {
            if (z) {
                return C0458ze.m10823();
            }
            throw new C0018ad(e2);
        } catch (IOException e3) {
            throw new C0442w(e3);
        } catch (NumberFormatException e4) {
            throw new C0018ad(e4);
        }
    }
}
