package com.google.android.material.card2;

import java.io.Closeable;
import java.io.EOFException;
import java.io.IOException;
import java.io.Reader;

public class C0152fb implements Closeable {

    private int[] f261bC;

    private String[] f262bD;

    private int f263bF;

    private final Reader f265dZ;

    private long f270ee;

    private int f271ef;

    private String f272eg;

    private boolean f275x = false;

    private final char[] f264dY = new char[1024];

    private int f273eh = 0;

    private int f266ea = 0;

    private int f267eb = 0;

    private int f268ec = 0;

    int f269ed = 0;

    private int[] f274ei = new int[32];

    static {
        AbstractC0055bm.f81aK = new C0153fc();
    }

    public C0152fb(Reader reader) {
        this.f263bF = 0;
        int[] iArrM2065 = abd.m2065(this);
        int iM9514 = C0450yf.m9514(this);
        this.f263bF = iM9514 + 1;
        iArrM2065[iM9514] = 6;
        this.f262bD = new String[32];
        this.f261bC = new int[32];
        if (reader == null) {
            throw new NullPointerException(adds.m2731());
        }
        this.f265dZ = reader;
    }

    private boolean m437a(char c) {
        switch (c) {
            case '#':
            case '/':
            case ';':
            case '=':
            case '\\':
                C0449ye.m9321(this);
            case '\t':
            case '\n':
            case '\f':
            case '\r':
            case ' ':
            case ',':
            case ':':
            case '[':
            case ']':
            case '{':
            case '}':
                return false;
            default:
                return true;
        }
    }

    private void m438an() throws IOException {
        if (!C0447yc.m8652(this)) {
            throw C0450yf.m9467(this, abc.m1906());
        }
    }

    private void m439ao() {
        C0455za.m10273(this, true);
        this.f273eh = C0457zc.m10530(this) - 1;
        int iM10530 = C0457zc.m10530(this);
        if (iM10530 + 5 <= abf.m2421(this) || gggy.m4387(this, 5)) {
            char[] cArrM11065 = C0459zf.m11065(this);
            if (cArrM11065[iM10530] == ')' && cArrM11065[iM10530 + 1] == ']' && cArrM11065[iM10530 + 2] == '}' && cArrM11065[iM10530 + 3] == '\'' && cArrM11065[iM10530 + 4] == '\n') {
                this.f273eh = C0457zc.m10530(this) + 5;
            }
        }
    }

    private String m440ap() {
        StringBuilder sb = null;
        int i = 0;
        while (true) {
            if (C0457zc.m10530(this) + i < abf.m2421(this)) {
                switch (C0459zf.m11065(this)[C0457zc.m10530(this) + i]) {
                    case '\t':
                    case '\n':
                    case '\f':
                    case '\r':
                    case ' ':
                    case ',':
                    case ':':
                    case '[':
                    case ']':
                    case '{':
                    case '}':
                        break;
                    case '#':
                    case '/':
                    case ';':
                    case '=':
                    case '\\':
                        C0449ye.m9321(this);
                        break;
                    default:
                        i++;
                        continue;
                }
            } else if (i >= C0459zf.m11065(this).length) {
                if (sb == null) {
                    sb = new StringBuilder(abe.m2377(i, 16));
                }
                m3807(sb, C0459zf.m11065(this), C0457zc.m10530(this), i);
                this.f273eh = i + C0457zc.m10530(this);
                if (gggy.m4387(this, 1)) {
                    i = 0;
                } else {
                    i = 0;
                }
            } else if (gggy.m4387(this, i + 1)) {
            }
        }
        String str = sb == null ? new String(C0459zf.m11065(this), C0457zc.m10530(this), i) : abc.m1925(m3807(sb, C0459zf.m11065(this), C0457zc.m10530(this), i));
        this.f273eh = i + C0457zc.m10530(this);
        return str;
    }

    private int m441aq() {
        String strM10298;
        String strM9205;
        int i;
        char c = C0459zf.m11065(this)[C0457zc.m10530(this)];
        if (c == 't' || c == 'T') {
            strM10298 = C0456zb.m10298();
            strM9205 = C0449ye.m9205();
            i = 5;
        } else if (c == 'f' || c == 'F') {
            strM10298 = C0458ze.m10861();
            strM9205 = abf.m2633();
            i = 6;
        } else {
            if (c != 'n' && c != 'N') {
                return 0;
            }
            strM10298 = C0448yd.m8883();
            strM9205 = C0458ze.m10943();
            i = 7;
        }
        int iM4397 = gggy.m4397(strM10298);
        for (int i2 = 1; i2 < iM4397; i2++) {
            if (C0457zc.m10530(this) + i2 >= abf.m2421(this) && !gggy.m4387(this, i2 + 1)) {
                return 0;
            }
            char c2 = C0459zf.m11065(this)[C0457zc.m10530(this) + i2];
            if (c2 != C0446yb.m8419(strM10298, i2) && c2 != C0446yb.m8419(strM9205, i2)) {
                return 0;
            }
        }
        if ((C0457zc.m10530(this) + iM4397 < abf.m2421(this) || gggy.m4387(this, iM4397 + 1)) && abf.m2537(this, C0459zf.m11065(this)[C0457zc.m10530(this) + iM4397])) {
            return 0;
        }
        this.f273eh = C0457zc.m10530(this) + iM4397;
        this.f269ed = i;
        return i;
    }

    private int m442ar() {
        int i;
        char c;
        char[] cArrM11065 = C0459zf.m11065(this);
        int iM10530 = C0457zc.m10530(this);
        int iM2421 = abf.m2421(this);
        long j = 0;
        boolean z = false;
        boolean z2 = true;
        char c2 = 0;
        int i2 = 0;
        while (true) {
            i = i2;
            if (iM10530 + i != iM2421) {
                c = cArrM11065[iM10530 + i];
                switch (c) {
                    case '+':
                        if (c2 == 5) {
                            return 0;
                        }
                        c2 = 6;
                        continue;
                        continue;
                        i2 = i + 1;
                        break;
                        break;
                    case '-':
                        if (c2 == 0) {
                            z = true;
                            c2 = 1;
                            continue;
                            continue;
                        } else {
                            if (c2 == 5) {
                                return 0;
                            }
                            c2 = 6;
                        }
                        i2 = i + 1;
                        break;
                    case '.':
                        if (c2 == 2) {
                            return 0;
                        }
                        c2 = 3;
                        continue;
                        continue;
                        i2 = i + 1;
                        break;
                        break;
                    case 'E':
                    case 'e':
                        if (c2 == 2 && c2 != 4) {
                            return 0;
                        }
                        c2 = 5;
                        continue;
                        continue;
                        i2 = i + 1;
                        break;
                        break;
                    default:
                        if (c < '0' && c <= '9') {
                            if (c2 == 1 || c2 == 0) {
                                j = -(c - '0');
                                c2 = 2;
                            } else if (c2 == 2) {
                                if (j == 0) {
                                    return 0;
                                }
                                long j2 = (10 * j) - ((long) (c - '0'));
                                z2 &= j > -922337203685477580L || (j == -922337203685477580L && j2 < j);
                                j = j2;
                            } else if (c2 == 3) {
                                c2 = 4;
                            } else if (c2 == 5 || c2 == 6) {
                                c2 = 7;
                            }
                            i2 = i + 1;
                        } else if (abf.m2537(this, c)) {
                            return 0;
                        }
                        break;
                }
            } else {
                if (i == cArrM11065.length) {
                    return 0;
                }
                if (gggy.m4387(this, i + 1)) {
                    iM10530 = C0457zc.m10530(this);
                    iM2421 = abf.m2421(this);
                    c = cArrM11065[iM10530 + i];
                    switch (c) {
                        case '+':
                            if (c2 == 5) {
                                return 0;
                            }
                            c2 = 6;
                            continue;
                            continue;
                            i2 = i + 1;
                            break;
                            break;
                        case '-':
                            if (c2 == 0) {
                                z = true;
                                c2 = 1;
                                continue;
                                continue;
                            } else {
                                if (c2 == 5) {
                                    return 0;
                                }
                                c2 = 6;
                            }
                            i2 = i + 1;
                            break;
                        case '.':
                            if (c2 == 2) {
                                return 0;
                            }
                            c2 = 3;
                            continue;
                            continue;
                            i2 = i + 1;
                            break;
                            break;
                        case 'E':
                        case 'e':
                            if (c2 == 2) {
                            }
                            c2 = 5;
                            continue;
                            continue;
                            i2 = i + 1;
                            break;
                        default:
                            if (c < '0') {
                            }
                            if (abf.m2537(this, c)) {
                                return 0;
                            }
                            break;
                    }
                }
            }
        }
        if (c2 == 2 && z2 && ((j != Long.MIN_VALUE || z) && (j != 0 || !z))) {
            if (!z) {
                j = -j;
            }
            this.f270ee = j;
            this.f273eh = C0457zc.m10530(this) + i;
            this.f269ed = 15;
            return 15;
        }
        if (c2 != 2 && c2 != 4 && c2 != 7) {
            return 0;
        }
        this.f271ef = i;
        this.f269ed = 16;
        return 16;
    }

    private char m443as() throws IOException {
        int i;
        if (C0457zc.m10530(this) == abf.m2421(this) && !gggy.m4387(this, 1)) {
            throw C0450yf.m9467(this, C0448yd.m8858());
        }
        char[] cArrM11065 = C0459zf.m11065(this);
        int iM10530 = C0457zc.m10530(this);
        this.f273eh = iM10530 + 1;
        char c = cArrM11065[iM10530];
        switch (c) {
            case '\n':
                this.f267eb = C0461zs.m11640(this) + 1;
                this.f268ec = C0457zc.m10530(this);
                return c;
            case '\"':
            case '\'':
            case '/':
            case '\\':
                return c;
            case 'b':
                return '\b';
            case 'f':
                return '\f';
            case 'n':
                return '\n';
            case 'r':
                return '\r';
            case 't':
                return '\t';
            case 'u':
                if (C0457zc.m10530(this) + 4 > abf.m2421(this) && !gggy.m4387(this, 4)) {
                    throw C0450yf.m9467(this, C0448yd.m8858());
                }
                char c2 = 0;
                int iM10531 = C0457zc.m10530(this);
                for (int i2 = iM10531; i2 < iM10531 + 4; i2++) {
                    char c3 = C0459zf.m11065(this)[i2];
                    char c4 = (char) (c2 << 4);
                    if (c3 >= '0' && c3 <= '9') {
                        i = c3 - '0';
                    } else if (c3 >= 'a' && c3 <= 'f') {
                        i = (c3 - 'a') + 10;
                    } else {
                        if (c3 < 'A' || c3 > 'F') {
                            throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), gggy.m4361()), new String(C0459zf.m11065(this), C0457zc.m10530(this), 4))));
                        }
                        i = (c3 - 'A') + 10;
                    }
                    c2 = (char) (c4 + i);
                }
                this.f273eh = C0457zc.m10530(this) + 4;
                return c2;
            default:
                throw C0450yf.m9467(this, C0458ze.m10966());
        }
    }

    private void m444at() {
        char c;
        do {
            if (C0457zc.m10530(this) >= abf.m2421(this) && !gggy.m4387(this, 1)) {
                return;
            }
            char[] cArrM11065 = C0459zf.m11065(this);
            int iM10530 = C0457zc.m10530(this);
            this.f273eh = iM10530 + 1;
            c = cArrM11065[iM10530];
            if (c == '\n') {
                this.f267eb = C0461zs.m11640(this) + 1;
                this.f268ec = C0457zc.m10530(this);
                return;
            }
        } while (c != '\r');
    }

    private void m445au() {
        do {
            int i = 0;
            while (C0457zc.m10530(this) + i < abf.m2421(this)) {
                switch (C0459zf.m11065(this)[C0457zc.m10530(this) + i]) {
                    case '\t':
                    case '\n':
                    case '\f':
                    case '\r':
                    case ' ':
                    case ',':
                    case ':':
                    case '[':
                    case ']':
                    case '{':
                    case '}':
                        break;
                    case '#':
                    case '/':
                    case ';':
                    case '=':
                    case '\\':
                        C0449ye.m9321(this);
                        break;
                    default:
                        i++;
                        break;
                }
                this.f273eh = i + C0457zc.m10530(this);
                return;
            }
            this.f273eh = i + C0457zc.m10530(this);
        } while (gggy.m4387(this, 1));
    }

    private String m446b(char c) throws IOException {
        char[] cArrM11065 = C0459zf.m11065(this);
        StringBuilder sb = null;
        do {
            int iM10530 = C0457zc.m10530(this);
            int iM2421 = abf.m2421(this);
            int i = iM10530;
            int i2 = iM10530;
            while (i2 < iM2421) {
                int i3 = i2 + 1;
                char c2 = cArrM11065[i2];
                if (c2 == c) {
                    this.f273eh = i3;
                    int i4 = (i3 - i) - 1;
                    if (sb == null) {
                        return new String(cArrM11065, i, i4);
                    }
                    m3807(sb, cArrM11065, i, i4);
                    return abc.m1925(sb);
                }
                if (c2 == '\\') {
                    this.f273eh = i3;
                    int i5 = (i3 - i) - 1;
                    if (sb == null) {
                        sb = new StringBuilder(abe.m2377((i5 + 1) * 2, 16));
                    }
                    m3807(sb, cArrM11065, i, i5);
                    abe.m2346(sb, abd.m2112(this));
                    int iM10531 = C0457zc.m10530(this);
                    iM2421 = abf.m2421(this);
                    i = iM10531;
                    i2 = iM10531;
                } else if (c2 == '\n') {
                    this.f267eb = C0461zs.m11640(this) + 1;
                    this.f268ec = i3;
                    i2 = i3;
                } else {
                    i2 = i3;
                }
            }
            if (sb == null) {
                sb = new StringBuilder(abe.m2377((i2 - i) * 2, 16));
            }
            m3807(sb, cArrM11065, i, i2 - i);
            this.f273eh = i2;
        } while (gggy.m4387(this, 1));
        throw C0450yf.m9467(this, abc.m1847());
    }

    private void m447c(char c) throws IOException {
        char[] cArrM11065 = C0459zf.m11065(this);
        do {
            int iM10530 = C0457zc.m10530(this);
            int iM2421 = abf.m2421(this);
            int i = iM10530;
            while (i < iM2421) {
                int iM10531 = i + 1;
                char c2 = cArrM11065[i];
                if (c2 == c) {
                    this.f273eh = iM10531;
                    return;
                }
                if (c2 == '\\') {
                    this.f273eh = iM10531;
                    abd.m2112(this);
                    iM10531 = C0457zc.m10530(this);
                    iM2421 = abf.m2421(this);
                } else if (c2 == '\n') {
                    this.f267eb = C0461zs.m11640(this) + 1;
                    this.f268ec = iM10531;
                }
                i = iM10531;
            }
            this.f273eh = i;
        } while (gggy.m4387(this, 1));
        throw C0450yf.m9467(this, abc.m1847());
    }

    private boolean m448c(int i) {
        int i2 = i;
        char[] cArrM11065 = C0459zf.m11065(this);
        this.f268ec = abf.m2588(this) - C0457zc.m10530(this);
        if (abf.m2421(this) != C0457zc.m10530(this)) {
            this.f266ea = abf.m2421(this) - C0457zc.m10530(this);
            adds.m2876(cArrM11065, C0457zc.m10530(this), cArrM11065, 0, abf.m2421(this));
        } else {
            this.f266ea = 0;
        }
        this.f273eh = 0;
        do {
            int iM9586 = C0452yh.m9586(C0457zc.m10601(this), cArrM11065, abf.m2421(this), cArrM11065.length - abf.m2421(this));
            if (iM9586 == -1) {
                return false;
            }
            this.f266ea = iM9586 + abf.m2421(this);
            if (C0461zs.m11640(this) == 0 && abf.m2588(this) == 0 && abf.m2421(this) > 0 && cArrM11065[0] == 65279) {
                this.f273eh = C0457zc.m10530(this) + 1;
                this.f268ec = abf.m2588(this) + 1;
                i2++;
            }
        } while (abf.m2421(this) < i2);
        return true;
    }

    private void m449d(int i) {
        if (C0450yf.m9514(this) == abd.m2065(this).length) {
            int iM9514 = C0450yf.m9514(this) * 2;
            this.f274ei = C0445ya.m8363(abd.m2065(this), iM9514);
            this.f261bC = C0445ya.m8363(C0456zb.m10470(this), iM9514);
            this.f262bD = (String[]) adds.m2824(abc.m1957(this), iM9514);
        }
        int[] iArrM2065 = abd.m2065(this);
        int iM9515 = C0450yf.m9514(this);
        this.f263bF = iM9515 + 1;
        iArrM2065[iM9515] = i;
    }

    private int m450e(boolean z) throws IOException {
        char[] cArrM11065 = C0459zf.m11065(this);
        int iM10530 = C0457zc.m10530(this);
        int iM2421 = abf.m2421(this);
        while (true) {
            if (iM10530 == iM2421) {
                this.f273eh = iM10530;
                if (!gggy.m4387(this, 1)) {
                    if (z) {
                        throw new EOFException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2017()), C0461zs.m11601(this))));
                    }
                    return -1;
                }
                iM10530 = C0457zc.m10530(this);
                iM2421 = abf.m2421(this);
            }
            int i = iM10530 + 1;
            char c = cArrM11065[iM10530];
            if (c == '\n') {
                this.f267eb = C0461zs.m11640(this) + 1;
                this.f268ec = i;
                iM10530 = i;
            } else if (c == ' ' || c == '\r') {
                iM10530 = i;
            } else if (c == '\t') {
                iM10530 = i;
            } else if (c == '/') {
                this.f273eh = i;
                if (i == iM2421) {
                    this.f273eh = C0457zc.m10530(this) - 1;
                    boolean zM4387 = gggy.m4387(this, 2);
                    this.f273eh = C0457zc.m10530(this) + 1;
                    if (!zM4387) {
                        return c;
                    }
                }
                C0449ye.m9321(this);
                switch (cArrM11065[C0457zc.m10530(this)]) {
                    case '*':
                        this.f273eh = C0457zc.m10530(this) + 1;
                        if (!C0445ya.m8289(this, C0459zf.m11070())) {
                            throw C0450yf.m9467(this, abe.m2285());
                        }
                        iM10530 = C0457zc.m10530(this) + 2;
                        iM2421 = abf.m2421(this);
                        break;
                        break;
                    case '/':
                        this.f273eh = C0457zc.m10530(this) + 1;
                        C0446yb.m8410(this);
                        iM10530 = C0457zc.m10530(this);
                        iM2421 = abf.m2421(this);
                        break;
                    default:
                        return c;
                }
            } else {
                if (c != '#') {
                    this.f273eh = i;
                    return c;
                }
                this.f273eh = i;
                C0449ye.m9321(this);
                C0446yb.m8410(this);
                iM10530 = C0457zc.m10530(this);
                iM2421 = abf.m2421(this);
            }
        }
    }

    private boolean m451h(String str) {
        int iM4397 = gggy.m4397(str);
        while (true) {
            if (C0457zc.m10530(this) + iM4397 > abf.m2421(this) && !gggy.m4387(this, iM4397)) {
                return false;
            }
            if (C0459zf.m11065(this)[C0457zc.m10530(this)] != '\n') {
                for (int i = 0; i < iM4397; i++) {
                    if (C0459zf.m11065(this)[C0457zc.m10530(this) + i] == C0446yb.m8419(str, i)) {
                    }
                }
                return true;
            }
            this.f267eb = C0461zs.m11640(this) + 1;
            this.f268ec = C0457zc.m10530(this) + 1;
            this.f273eh = C0457zc.m10530(this) + 1;
        }
    }

    private IOException m452i(String str) throws C0156ff {
        throw new C0156ff(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), str), C0461zs.m11601(this))));
    }

    public static void m3779(Object obj) {
        if (C0459zf.m11062() >= 0) {
            ((C0152fb) obj).m444at();
        }
    }

    public static int m3780(Object obj, boolean z) {
        if (C0459zf.m11062() >= 0) {
            return ((C0152fb) obj).m450e(z);
        }
        return 0;
    }

    public static boolean m3781(Object obj) {
        if (C0446yb.m8415() < 0) {
            return ((C0152fb) obj).f275x;
        }
        return false;
    }

    public static int[] m3782(Object obj) {
        if (C0461zs.m11510() < 0) {
            return ((C0152fb) obj).f274ei;
        }
        return null;
    }

    public static int m3783() {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11785();
        }
        return 0;
    }

    public static String m3784(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0152fb) obj).m440ap();
        }
        return null;
    }

    public static void m3785(Object obj) {
        if (C0447yc.m8635() >= 0) {
            ((C0152fb) obj).m439ao();
        }
    }

    public static String m3786(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((C0152fb) obj).f272eg;
        }
        return null;
    }

    public static void m3787(Object obj) {
        if (C0452yh.m9798() > 0) {
            ((C0152fb) obj).m445au();
        }
    }

    public static boolean m3788(Object obj, int i) {
        if (abc.m1845() < 0) {
            return ((C0152fb) obj).m448c(i);
        }
        return false;
    }

    public static int m3789(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0152fb) obj).m454av();
        }
        return 0;
    }

    public static int m3790(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0152fb) obj).f268ec;
        }
        return 0;
    }

    public static Reader m3791(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0152fb) obj).f265dZ;
        }
        return null;
    }

    public static boolean m3792(Object obj, Object obj2) {
        if (C0458ze.m10932() > 0) {
            return ((C0152fb) obj).m451h((String) obj2);
        }
        return false;
    }

    public static String[] m3793(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0152fb) obj).f262bD;
        }
        return null;
    }

    public static int m3794(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0152fb) obj).f273eh;
        }
        return 0;
    }

    public static int m3795(Object obj) {
        if (C0445ya.m8222() > 0) {
            return ((C0152fb) obj).m442ar();
        }
        return 0;
    }

    public static String m3796() {
        if (C0445ya.m8222() > 0) {
            return C0598.m11850();
        }
        return null;
    }

    public static EnumC0154fd m3797() {
        if (gggy.m4269() < 0) {
            return C0598.m11807();
        }
        return null;
    }

    public static int m3798(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return ((C0152fb) obj).f271ef;
        }
        return 0;
    }

    public static void m3799(Object obj) throws IOException {
        if (C0447yc.m8635() > 0) {
            ((C0152fb) obj).m438an();
        }
    }

    public static boolean m3800(double d) {
        if (abc.m1845() <= 0) {
            return C0598.m11889(d);
        }
        return false;
    }

    public static IOException m3801(Object obj, Object obj2) {
        if (C0446yb.m8415() < 0) {
            return ((C0152fb) obj).m452i((String) obj2);
        }
        return null;
    }

    public static int m3802(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0152fb) obj).f266ea;
        }
        return 0;
    }

    public static int[] m3803(Object obj) {
        if (gggy.m4269() <= 0) {
            return ((C0152fb) obj).f261bC;
        }
        return null;
    }

    public static boolean m3804(Object obj, char c) {
        if (C0446yb.m8415() < 0) {
            return ((C0152fb) obj).m437a(c);
        }
        return false;
    }

    public static long m3805(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0152fb) obj).f270ee;
        }
        return 0L;
    }

    public static int m3806(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0152fb) obj).m441aq();
        }
        return 0;
    }

    public static StringBuilder m3807(Object obj, Object obj2, int i, int i2) {
        if (adds.m2755() > 0) {
            return C0598.m11791(obj, obj2, i, i2);
        }
        return null;
    }

    public static int m3808(Object obj) {
        if (C0459zf.m11062() > 0) {
            return ((C0152fb) obj).f267eb;
        }
        return 0;
    }

    public static String m3809(Object obj) {
        if (abe.m2308() < 0) {
            return ((C0152fb) obj).m453J();
        }
        return null;
    }

    public static String m3810(Object obj, char c) {
        if (gggy.m4269() <= 0) {
            return ((C0152fb) obj).m446b(c);
        }
        return null;
    }

    public static void m3811(Object obj, int i) {
        if (C0459zf.m11062() > 0) {
            ((C0152fb) obj).m449d(i);
        }
    }

    public static int m3812(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0152fb) obj).f263bF;
        }
        return 0;
    }

    public static int m3813(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((C0152fb) obj).f269ed;
        }
        return 0;
    }

    public static char m3814(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0152fb) obj).m443as();
        }
        return (char) 0;
    }

    public static void m3815(Object obj, char c) throws IOException {
        if (gggy.m4269() <= 0) {
            ((C0152fb) obj).m447c(c);
        }
    }

    public static char[] m3816(Object obj) {
        if (C0458ze.m10932() >= 0) {
            return ((C0152fb) obj).f264dY;
        }
        return null;
    }

    public static int m3817(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3802((C0152fb) obj);
        }
        return 0;
    }

    public static char[] m3818(Object obj) {
        if (C0457zc.m10555() > 0) {
            return m3816((C0152fb) obj);
        }
        return null;
    }

    public static int m3819(Object obj) {
        if (m3783() > 0) {
            return m3794((C0152fb) obj);
        }
        return 0;
    }

    public static long m3820(Object obj) {
        if (C0460zg.m11293() > 0) {
            return m3805((C0152fb) obj);
        }
        return 0L;
    }

    public static String m3821(Object obj, char c) {
        if (abf.m2500() >= 0) {
            return m3810((C0152fb) obj, c);
        }
        return null;
    }

    public static int m3822(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m3795((C0152fb) obj);
        }
        return 0;
    }

    public static boolean m3823(Object obj, int i) {
        if (C0460zg.m11293() >= 0) {
            return m3788((C0152fb) obj, i);
        }
        return false;
    }

    public static String m3824(Object obj) {
        if (abf.m2500() > 0) {
            return m3786((C0152fb) obj);
        }
        return null;
    }

    public static int m3825(Object obj) {
        if (abd.m2166() <= 0) {
            return m3812((C0152fb) obj);
        }
        return 0;
    }

    public static void m3826(Object obj, int i) {
        if (C0457zc.m10718() < 0) {
            m3811((C0152fb) obj, i);
        }
    }

    public static int m3827(Object obj, boolean z) {
        if (abf.m2500() >= 0) {
            return m3780((C0152fb) obj, z);
        }
        return 0;
    }

    public static void m3828(Object obj, char c) throws IOException {
        if (abd.m2021() >= 0) {
            m3815((C0152fb) obj, c);
        }
    }

    public static int m3829(Object obj) {
        if (C0453yj.m9996() <= 0) {
            return m3790((C0152fb) obj);
        }
        return 0;
    }

    public static void m3830(Object obj) {
        if (C0445ya.m8330() > 0) {
            m3799((C0152fb) obj);
        }
    }

    public static void m3831(Object obj) {
        if (C0460zg.m11293() >= 0) {
            m3779((C0152fb) obj);
        }
    }

    public static int m3832(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3789((C0152fb) obj);
        }
        return 0;
    }

    public static String m3833(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m3784((C0152fb) obj);
        }
        return null;
    }

    public static boolean m3834(Object obj, Object obj2) {
        if (C0453yj.m9966() >= 0) {
            return m3792((C0152fb) obj, (String) obj2);
        }
        return false;
    }

    public static int m3835(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m3813((C0152fb) obj);
        }
        return 0;
    }

    public static boolean m3836(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m3781((C0152fb) obj);
        }
        return false;
    }

    public static String[] m3837(Object obj) {
        if (abf.m2500() >= 0) {
            return m3793((C0152fb) obj);
        }
        return null;
    }

    public static int m3838(Object obj) {
        if (C0457zc.m10718() <= 0) {
            return m3798((C0152fb) obj);
        }
        return 0;
    }

    public static int[] m3839(Object obj) {
        if (C0459zf.m11053() >= 0) {
            return m3803((C0152fb) obj);
        }
        return null;
    }

    public static void m3840(Object obj) {
        if (C0447yc.m8786() > 0) {
            m3787((C0152fb) obj);
        }
    }

    public static String m3841(Object obj) {
        if (abd.m2021() >= 0) {
            return m3809((C0152fb) obj);
        }
        return null;
    }

    public static char m3842(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m3814((C0152fb) obj);
        }
        return (char) 0;
    }

    public static int m3843(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m3808((C0152fb) obj);
        }
        return 0;
    }

    public static void m3844(Object obj) {
        if (gggy.m4365() >= 0) {
            m3785((C0152fb) obj);
        }
    }

    public static int[] m3845(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m3782((C0152fb) obj);
        }
        return null;
    }

    public static Reader m3846(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m3791((C0152fb) obj);
        }
        return null;
    }

    public static IOException m3847(Object obj, Object obj2) {
        if (C0448yd.m9015() < 0) {
            return m3801((C0152fb) obj, (String) obj2);
        }
        return null;
    }

    public static int m3848(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m3806((C0152fb) obj);
        }
        return 0;
    }

    public static boolean m3849(Object obj, char c) {
        if (gggy.m4365() > 0) {
            return m3804((C0152fb) obj, c);
        }
        return false;
    }

    String m453J() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(adds.m2680(C0460zg.m11407(adds.m2680(C0460zg.m11407(new StringBuilder(), C0448yd.m9084()), C0461zs.m11640(this) + 1), m3796()), (C0457zc.m10530(this) - abf.m2588(this)) + 1), C0449ye.m9171()), C0449ye.m9163(this)));
    }

    public void mo341M() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 != 3) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), gggy.m4460()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        C0450yf.m9546(this, 1);
        C0456zb.m10470(this)[C0450yf.m9514(this) - 1] = 0;
        this.f269ed = 0;
    }

    public void mo342N() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 != 1) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0460zg.m11309()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        C0450yf.m9546(this, 3);
        this.f269ed = 0;
    }

    public void mo343O() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 != 4) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0455za.m10149()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        this.f263bF = C0450yf.m9514(this) - 1;
        int[] iArrM10470 = C0456zb.m10470(this);
        int iM9514 = C0450yf.m9514(this) - 1;
        iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
        this.f269ed = 0;
    }

    public void mo344P() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 != 2) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0453yj.m10016()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        this.f263bF = C0450yf.m9514(this) - 1;
        abc.m1957(this)[C0450yf.m9514(this)] = null;
        int[] iArrM10470 = C0456zb.m10470(this);
        int iM9514 = C0450yf.m9514(this) - 1;
        iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
        this.f269ed = 0;
    }

    public String mo345Q() {
        StringBuilder sbM2346 = abe.m2346(new StringBuilder(), '$');
        int iM9514 = C0450yf.m9514(this);
        for (int i = 0; i < iM9514; i++) {
            switch (abd.m2065(this)[i]) {
                case 1:
                case 2:
                    abe.m2346(adds.m2680(abe.m2346(sbM2346, '['), C0456zb.m10470(this)[i]), ']');
                    break;
                case 3:
                case 4:
                case 5:
                    abe.m2346(sbM2346, '.');
                    if (abc.m1957(this)[i] != null) {
                        C0460zg.m11407(sbM2346, abc.m1957(this)[i]);
                    }
                    break;
            }
        }
        return abc.m1925(sbM2346);
    }

    public boolean mo346R() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 == 5) {
            this.f269ed = 0;
            int[] iArrM10470 = C0456zb.m10470(this);
            int iM9514 = C0450yf.m9514(this) - 1;
            iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
            return true;
        }
        if (iM10523 != 6) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0452yh.m9805()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        this.f269ed = 0;
        int[] iArrM10471 = C0456zb.m10470(this);
        int iM9515 = C0450yf.m9514(this) - 1;
        iArrM10471[iM9515] = iArrM10471[iM9515] + 1;
        return false;
    }

    public double mo347S() throws C0156ff {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 == 15) {
            this.f269ed = 0;
            int[] iArrM10470 = C0456zb.m10470(this);
            int iM9514 = C0450yf.m9514(this) - 1;
            iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
            return C0456zb.m10392(this);
        }
        if (iM10523 == 16) {
            this.f272eg = new String(C0459zf.m11065(this), C0457zc.m10530(this), abf.m2443(this));
            this.f273eh = C0457zc.m10530(this) + abf.m2443(this);
        } else if (iM10523 == 8 || iM10523 == 9) {
            this.f272eg = gggy.m4427(this, iM10523 == 8 ? '\'' : '\"');
        } else if (iM10523 == 10) {
            this.f272eg = abc.m1878(this);
        } else if (iM10523 != 11) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), abe.m2202()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        this.f269ed = 11;
        double dM8298 = C0445ya.m8298(C0455za.m10064(this));
        if (!C0447yc.m8652(this) && (abe.m2262(dM8298) || m3800(dM8298))) {
            throw new C0156ff(abc.m1925(C0460zg.m11407(adds.m2814(C0460zg.m11407(new StringBuilder(), C0461zs.m11443()), dM8298), C0461zs.m11601(this))));
        }
        this.f272eg = null;
        this.f269ed = 0;
        int[] iArrM10471 = C0456zb.m10470(this);
        int iM9515 = C0450yf.m9514(this) - 1;
        iArrM10471[iM9515] = iArrM10471[iM9515] + 1;
        return dM8298;
    }

    public int mo348T() {
        int iM8889;
        double dM8298;
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 == 15) {
            iM8889 = (int) C0456zb.m10392(this);
            if (C0456zb.m10392(this) != iM8889) {
                throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0458ze.m10777(C0460zg.m11407(new StringBuilder(), C0453yj.m9904()), C0456zb.m10392(this)), C0461zs.m11601(this))));
            }
            this.f269ed = 0;
            int[] iArrM10470 = C0456zb.m10470(this);
            int iM9514 = C0450yf.m9514(this) - 1;
            iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
        } else {
            if (iM10523 == 16) {
                this.f272eg = new String(C0459zf.m11065(this), C0457zc.m10530(this), abf.m2443(this));
                this.f273eh = C0457zc.m10530(this) + abf.m2443(this);
            } else {
                if (iM10523 != 8 && iM10523 != 9 && iM10523 != 10) {
                    throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0453yj.m9904()), abe.m2401(this)), C0461zs.m11601(this))));
                }
                if (iM10523 == 10) {
                    this.f272eg = abc.m1878(this);
                } else {
                    this.f272eg = gggy.m4427(this, iM10523 == 8 ? '\'' : '\"');
                }
                try {
                    iM8889 = C0448yd.m8889(C0455za.m10064(this));
                    this.f269ed = 0;
                    int[] iArrM10471 = C0456zb.m10470(this);
                    int iM9515 = C0450yf.m9514(this) - 1;
                    iArrM10471[iM9515] = iArrM10471[iM9515] + 1;
                } catch (NumberFormatException e) {
                    this.f269ed = 11;
                    dM8298 = C0445ya.m8298(C0455za.m10064(this));
                    iM8889 = (int) dM8298;
                    if (iM8889 != dM8298) {
                        throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m9904()), C0455za.m10064(this)), C0461zs.m11601(this))));
                    }
                    this.f272eg = null;
                    this.f269ed = 0;
                    int[] iArrM10472 = C0456zb.m10470(this);
                    int iM9516 = C0450yf.m9514(this) - 1;
                    iArrM10472[iM9516] = iArrM10472[iM9516] + 1;
                }
            }
            this.f269ed = 11;
            dM8298 = C0445ya.m8298(C0455za.m10064(this));
            iM8889 = (int) dM8298;
            if (iM8889 != dM8298) {
                throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m9904()), C0455za.m10064(this)), C0461zs.m11601(this))));
            }
            this.f272eg = null;
            this.f269ed = 0;
            int[] iArrM10473 = C0456zb.m10470(this);
            int iM9517 = C0450yf.m9514(this) - 1;
            iArrM10473[iM9517] = iArrM10473[iM9517] + 1;
        }
        return iM8889;
    }

    public long mo349U() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 == 15) {
            this.f269ed = 0;
            int[] iArrM10470 = C0456zb.m10470(this);
            int iM9514 = C0450yf.m9514(this) - 1;
            iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
            return C0456zb.m10392(this);
        }
        if (iM10523 == 16) {
            this.f272eg = new String(C0459zf.m11065(this), C0457zc.m10530(this), abf.m2443(this));
            this.f273eh = C0457zc.m10530(this) + abf.m2443(this);
        } else {
            if (iM10523 != 8 && iM10523 != 9 && iM10523 != 10) {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0449ye.m9152()), abe.m2401(this)), C0461zs.m11601(this))));
            }
            if (iM10523 == 10) {
                this.f272eg = abc.m1878(this);
            } else {
                this.f272eg = gggy.m4427(this, iM10523 == 8 ? '\'' : '\"');
            }
            try {
                long jM10637 = C0457zc.m10637(C0455za.m10064(this));
                this.f269ed = 0;
                int[] iArrM10471 = C0456zb.m10470(this);
                int iM9515 = C0450yf.m9514(this) - 1;
                iArrM10471[iM9515] = iArrM10471[iM9515] + 1;
                return jM10637;
            } catch (NumberFormatException e) {
            }
        }
        this.f269ed = 11;
        double dM8298 = C0445ya.m8298(C0455za.m10064(this));
        long j = (long) dM8298;
        if (j != dM8298) {
            throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9152()), C0455za.m10064(this)), C0461zs.m11601(this))));
        }
        this.f272eg = null;
        this.f269ed = 0;
        int[] iArrM10472 = C0456zb.m10470(this);
        int iM9516 = C0450yf.m9514(this) - 1;
        iArrM10472[iM9516] = iArrM10472[iM9516] + 1;
        return j;
    }

    public String mo350V() {
        String strM4427;
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 == 14) {
            strM4427 = abc.m1878(this);
        } else if (iM10523 == 12) {
            strM4427 = gggy.m4427(this, '\'');
        } else {
            if (iM10523 != 13) {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0458ze.m10805()), abe.m2401(this)), C0461zs.m11601(this))));
            }
            strM4427 = gggy.m4427(this, '\"');
        }
        this.f269ed = 0;
        abc.m1957(this)[C0450yf.m9514(this) - 1] = strM4427;
        return strM4427;
    }

    public void mo351W() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 != 7) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0445ya.m8281()), abe.m2401(this)), C0461zs.m11601(this))));
        }
        this.f269ed = 0;
        int[] iArrM10470 = C0456zb.m10470(this);
        int iM9514 = C0450yf.m9514(this) - 1;
        iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
    }

    public String mo352X() {
        String str;
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        if (iM10523 == 10) {
            str = abc.m1878(this);
        } else if (iM10523 == 8) {
            str = gggy.m4427(this, '\'');
        } else if (iM10523 == 9) {
            str = gggy.m4427(this, '\"');
        } else if (iM10523 == 11) {
            str = C0455za.m10064(this);
            this.f272eg = null;
        } else if (iM10523 == 15) {
            str = C0450yf.m9420(C0456zb.m10392(this));
        } else {
            if (iM10523 != 16) {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0448yd.m8956()), abe.m2401(this)), C0461zs.m11601(this))));
            }
            str = new String(C0459zf.m11065(this), C0457zc.m10530(this), abf.m2443(this));
            this.f273eh = C0457zc.m10530(this) + abf.m2443(this);
        }
        this.f269ed = 0;
        int[] iArrM10470 = C0456zb.m10470(this);
        int iM9514 = C0450yf.m9514(this) - 1;
        iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
        return str;
    }

    public EnumC0154fd mo353Y() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        switch (iM10523) {
            case 1:
                return C0456zb.m10404();
            case 2:
                return C0455za.m10079();
            case 3:
                return C0453yj.m9984();
            case 4:
                return gggy.m4343();
            case 5:
            case 6:
                return C0450yf.m9431();
            case 7:
                return C0452yh.m9757();
            case 8:
            case 9:
            case 10:
            case 11:
                return abc.m1941();
            case 12:
            case 13:
            case 14:
                return C0453yj.m9995();
            case 15:
            case 16:
                return adds.m2664();
            case 17:
                return m3797();
            default:
                throw new AssertionError();
        }
    }

    public void mo355aa() {
        int i = 0;
        do {
            int iM10523 = C0456zb.m10523(this);
            if (iM10523 == 0) {
                iM10523 = C0453yj.m9888(this);
            }
            if (iM10523 == 3) {
                C0450yf.m9546(this, 1);
                i++;
            } else if (iM10523 == 1) {
                C0450yf.m9546(this, 3);
                i++;
            } else if (iM10523 == 4 || iM10523 == 2) {
                this.f263bF = C0450yf.m9514(this) - 1;
                i--;
            } else if (iM10523 == 14 || iM10523 == 10) {
                C0450yf.m9375(this);
            } else if (iM10523 == 8 || iM10523 == 12) {
                C0445ya.m8372(this, '\'');
            } else if (iM10523 == 9 || iM10523 == 13) {
                C0445ya.m8372(this, '\"');
            } else if (iM10523 == 16) {
                this.f273eh = C0457zc.m10530(this) + abf.m2443(this);
            }
            this.f269ed = 0;
        } while (i != 0);
        int[] iArrM10470 = C0456zb.m10470(this);
        int iM9514 = C0450yf.m9514(this) - 1;
        iArrM10470[iM9514] = iArrM10470[iM9514] + 1;
        abc.m1957(this)[C0450yf.m9514(this) - 1] = C0448yd.m8883();
    }

    int m454av() throws IOException {
        int i = abd.m2065(this)[C0450yf.m9514(this) - 1];
        if (i == 1) {
            abd.m2065(this)[C0450yf.m9514(this) - 1] = 2;
        } else if (i == 2) {
            switch (C0455za.m10273(this, true)) {
                case 44:
                    break;
                case 59:
                    C0449ye.m9321(this);
                    break;
                case 93:
                    this.f269ed = 4;
                    return 4;
                default:
                    throw C0450yf.m9467(this, C0459zf.m11077());
            }
        } else {
            if (i == 3 || i == 5) {
                abd.m2065(this)[C0450yf.m9514(this) - 1] = 4;
                if (i == 5) {
                    switch (C0455za.m10273(this, true)) {
                        case 44:
                            break;
                        case 59:
                            C0449ye.m9321(this);
                            break;
                        case 125:
                            this.f269ed = 2;
                            return 2;
                        default:
                            throw C0450yf.m9467(this, C0449ye.m9312());
                    }
                }
                int iM10273 = C0455za.m10273(this, true);
                switch (iM10273) {
                    case 34:
                        this.f269ed = 13;
                        return 13;
                    case 39:
                        C0449ye.m9321(this);
                        this.f269ed = 12;
                        return 12;
                    case 125:
                        if (i == 5) {
                            throw C0450yf.m9467(this, C0461zs.m11477());
                        }
                        this.f269ed = 2;
                        return 2;
                    default:
                        C0449ye.m9321(this);
                        this.f273eh = C0457zc.m10530(this) - 1;
                        if (!abf.m2537(this, (char) iM10273)) {
                            throw C0450yf.m9467(this, C0461zs.m11477());
                        }
                        this.f269ed = 14;
                        return 14;
                }
            }
            if (i == 4) {
                abd.m2065(this)[C0450yf.m9514(this) - 1] = 5;
                switch (C0455za.m10273(this, true)) {
                    case 58:
                        break;
                    case 59:
                    case 60:
                    default:
                        throw C0450yf.m9467(this, C0452yh.m9601());
                    case 61:
                        C0449ye.m9321(this);
                        if ((C0457zc.m10530(this) < abf.m2421(this) || gggy.m4387(this, 1)) && C0459zf.m11065(this)[C0457zc.m10530(this)] == '>') {
                            this.f273eh = C0457zc.m10530(this) + 1;
                        }
                        break;
                }
            } else if (i == 6) {
                if (C0447yc.m8652(this)) {
                    C0452yh.m9678(this);
                }
                abd.m2065(this)[C0450yf.m9514(this) - 1] = 7;
            } else if (i == 7) {
                if (C0455za.m10273(this, false) == -1) {
                    this.f269ed = 17;
                    return 17;
                }
                C0449ye.m9321(this);
                this.f273eh = C0457zc.m10530(this) - 1;
            } else if (i == 8) {
                throw new IllegalStateException(C0452yh.m9822());
            }
        }
        switch (C0455za.m10273(this, true)) {
            case 34:
                this.f269ed = 9;
                return 9;
            case 39:
                C0449ye.m9321(this);
                this.f269ed = 8;
                return 8;
            case 44:
            case 59:
                break;
            case 91:
                this.f269ed = 3;
                return 3;
            case 93:
                if (i == 1) {
                    this.f269ed = 4;
                    return 4;
                }
                break;
            case 123:
                this.f269ed = 1;
                return 1;
            default:
                this.f273eh = C0457zc.m10530(this) - 1;
                int iM2450 = abf.m2450(this);
                if (iM2450 != 0) {
                    return iM2450;
                }
                int iM11594 = C0461zs.m11594(this);
                if (iM11594 != 0) {
                    return iM11594;
                }
                if (!abf.m2537(this, C0459zf.m11065(this)[C0457zc.m10530(this)])) {
                    throw C0450yf.m9467(this, abf.m2574());
                }
                C0449ye.m9321(this);
                this.f269ed = 10;
                return 10;
        }
        if (i != 1 && i != 2) {
            throw C0450yf.m9467(this, C0458ze.m10909());
        }
        C0449ye.m9321(this);
        this.f273eh = C0457zc.m10530(this) - 1;
        this.f269ed = 7;
        return 7;
    }

    public final boolean m455aw() {
        return C0447yc.m8652(this);
    }

    @Override
    public void close() {
        this.f269ed = 0;
        abd.m2065(this)[0] = 8;
        this.f263bF = 1;
        C0457zc.m10620(C0457zc.m10601(this));
    }

    public final void m456f(boolean z) {
        this.f275x = z;
    }

    public boolean hasNext() {
        int iM10523 = C0456zb.m10523(this);
        if (iM10523 == 0) {
            iM10523 = C0453yj.m9888(this);
        }
        return (iM10523 == 2 || iM10523 == 4) ? false : true;
    }

    public String toString() {
        return abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0458ze.m10951(gggy.m4399(this))), C0461zs.m11601(this)));
    }
}
