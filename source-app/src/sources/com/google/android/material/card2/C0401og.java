package com.google.android.material.card2;

import javax.security.auth.x500.X500Principal;

final class C0401og {

    private char[] f1279bl;

    private int f1280eh;

    private int f1281uO;

    private int f1282uP;

    private final String f1283uQ;

    private int f1284uR;

    private final int f1285uS = gggy.m4397(m7635(this));

    C0401og(X500Principal x500Principal) {
        this.f1283uQ = C0449ye.m9244(x500Principal, C0459zf.m11205());
    }

    private int m1314B(int i) {
        int i2;
        int i3;
        if (i + 1 >= m7615(this)) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0460zg.m11367()), m7635(this))));
        }
        char c = m7621(this)[i];
        if (c >= '0' && c <= '9') {
            i2 = c - '0';
        } else if (c >= 'a' && c <= 'f') {
            i2 = c - 'W';
        } else {
            if (c < 'A' || c > 'F') {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0460zg.m11367()), m7635(this))));
            }
            i2 = c - '7';
        }
        char c2 = m7621(this)[i + 1];
        if (c2 >= '0' && c2 <= '9') {
            i3 = c2 - '0';
        } else if (c2 >= 'a' && c2 <= 'f') {
            i3 = c2 - 'W';
        } else {
            if (c2 < 'A' || c2 > 'F') {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0460zg.m11367()), m7635(this))));
            }
            i3 = c2 - '7';
        }
        return (i2 << 4) + i3;
    }

    private String m1315fl() {
        this.f1281uO = m7628(this);
        this.f1284uR = m7628(this);
        while (m7628(this) < m7615(this)) {
            switch (m7621(this)[m7628(this)]) {
                case ' ':
                    this.f1282uP = m7636(this);
                    this.f1280eh = m7628(this) + 1;
                    char[] cArrM7621 = m7621(this);
                    int iM7636 = m7636(this);
                    this.f1284uR = iM7636 + 1;
                    cArrM7621[iM7636] = ' ';
                    while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] == ' ') {
                        char[] cArrM7622 = m7621(this);
                        int iM7637 = m7636(this);
                        this.f1284uR = iM7637 + 1;
                        cArrM7622[iM7637] = ' ';
                        this.f1280eh = m7628(this) + 1;
                    }
                    if (m7628(this) == m7615(this) || m7621(this)[m7628(this)] == ',' || m7621(this)[m7628(this)] == '+' || m7621(this)[m7628(this)] == ';') {
                        return new String(m7621(this), m7633(this), m7632(this) - m7633(this));
                    }
                    break;
                case '+':
                case ',':
                case ';':
                    return new String(m7621(this), m7633(this), m7636(this) - m7633(this));
                case '\\':
                    char[] cArrM7623 = m7621(this);
                    int iM7638 = m7636(this);
                    this.f1284uR = iM7638 + 1;
                    cArrM7623[iM7638] = m7617(this);
                    this.f1280eh = m7628(this) + 1;
                    break;
                default:
                    char[] cArrM7624 = m7621(this);
                    int iM7639 = m7636(this);
                    this.f1284uR = iM7639 + 1;
                    cArrM7624[iM7639] = m7621(this)[m7628(this)];
                    this.f1280eh = m7628(this) + 1;
                    break;
            }
        }
        return new String(m7621(this), m7633(this), m7636(this) - m7633(this));
    }

    private char m1316fm() {
        this.f1280eh = m7628(this) + 1;
        if (m7628(this) == m7615(this)) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2495()), m7635(this))));
        }
        switch (m7621(this)[m7628(this)]) {
            case ' ':
            case '\"':
            case '#':
            case '%':
            case '*':
            case '+':
            case ',':
            case ';':
            case '<':
            case '=':
            case '>':
            case '\\':
            case '_':
                return m7621(this)[m7628(this)];
            default:
                return m7625(this);
        }
    }

    private char m1317fn() {
        int i;
        int i2;
        int iM7631 = m7631(this, m7628(this));
        this.f1280eh = m7628(this) + 1;
        if (iM7631 < 128) {
            return (char) iM7631;
        }
        if (iM7631 < 192 || iM7631 > 247) {
            return '?';
        }
        if (iM7631 <= 223) {
            i = 1;
            i2 = iM7631 & 31;
        } else if (iM7631 <= 239) {
            i = 2;
            i2 = iM7631 & 15;
        } else {
            i = 3;
            i2 = iM7631 & 7;
        }
        for (int i3 = 0; i3 < i; i3++) {
            this.f1280eh = m7628(this) + 1;
            if (m7628(this) == m7615(this) || m7621(this)[m7628(this)] != '\\') {
                return '?';
            }
            this.f1280eh = m7628(this) + 1;
            int iM7632 = m7631(this, m7628(this));
            this.f1280eh = m7628(this) + 1;
            if ((iM7632 & 192) != 128) {
                return '?';
            }
            i2 = (i2 << 6) + (iM7632 & 63);
        }
        return (char) i2;
    }

    private String m1318fo() {
        if (m7628(this) + 4 >= m7615(this)) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2495()), m7635(this))));
        }
        this.f1281uO = m7628(this);
        this.f1280eh = m7628(this) + 1;
        while (true) {
            if (m7628(this) == m7615(this) || m7621(this)[m7628(this)] == '+' || m7621(this)[m7628(this)] == ',' || m7621(this)[m7628(this)] == ';') {
                this.f1284uR = m7628(this);
                break;
            }
            if (m7621(this)[m7628(this)] == ' ') {
                this.f1284uR = m7628(this);
                this.f1280eh = m7628(this) + 1;
                while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] == ' ') {
                    this.f1280eh = m7628(this) + 1;
                }
                break;
            }
            if (m7621(this)[m7628(this)] >= 'A' && m7621(this)[m7628(this)] <= 'F') {
                char[] cArrM7621 = m7621(this);
                int iM7628 = m7628(this);
                cArrM7621[iM7628] = (char) (cArrM7621[iM7628] + ' ');
            }
            this.f1280eh = m7628(this) + 1;
        }
        int iM7636 = m7636(this) - m7633(this);
        if (iM7636 < 5 || (iM7636 & 1) == 0) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2495()), m7635(this))));
        }
        byte[] bArr = new byte[iM7636 / 2];
        int iM7633 = m7633(this) + 1;
        for (int i = 0; i < bArr.length; i++) {
            bArr[i] = (byte) m7631(this, iM7633);
            iM7633 += 2;
        }
        return new String(m7621(this), m7633(this), iM7636);
    }

    private String m1319fp() {
        while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] == ' ') {
            this.f1280eh = m7628(this) + 1;
        }
        if (m7628(this) == m7615(this)) {
            return null;
        }
        this.f1281uO = m7628(this);
        this.f1280eh = m7628(this) + 1;
        while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] != '=' && m7621(this)[m7628(this)] != ' ') {
            this.f1280eh = m7628(this) + 1;
        }
        if (m7628(this) >= m7615(this)) {
            throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2495()), m7635(this))));
        }
        this.f1284uR = m7628(this);
        if (m7621(this)[m7628(this)] == ' ') {
            while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] != '=' && m7621(this)[m7628(this)] == ' ') {
                this.f1280eh = m7628(this) + 1;
            }
            if (m7621(this)[m7628(this)] != '=' || m7628(this) == m7615(this)) {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2495()), m7635(this))));
            }
        }
        this.f1280eh = m7628(this) + 1;
        while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] == ' ') {
            this.f1280eh = m7628(this) + 1;
        }
        if (m7636(this) - m7633(this) > 4 && m7621(this)[m7633(this) + 3] == '.' && ((m7621(this)[m7633(this)] == 'O' || m7621(this)[m7633(this)] == 'o') && ((m7621(this)[m7633(this) + 1] == 'I' || m7621(this)[m7633(this) + 1] == 'i') && (m7621(this)[m7633(this) + 2] == 'D' || m7621(this)[m7633(this) + 2] == 'd')))) {
            this.f1281uO = m7633(this) + 4;
        }
        return new String(m7621(this), m7633(this), m7636(this) - m7633(this));
    }

    private String m1320fq() {
        this.f1280eh = m7628(this) + 1;
        this.f1281uO = m7628(this);
        this.f1284uR = m7633(this);
        while (m7628(this) != m7615(this)) {
            if (m7621(this)[m7628(this)] == '\"') {
                this.f1280eh = m7628(this) + 1;
                while (m7628(this) < m7615(this) && m7621(this)[m7628(this)] == ' ') {
                    this.f1280eh = m7628(this) + 1;
                }
                return new String(m7621(this), m7633(this), m7636(this) - m7633(this));
            }
            if (m7621(this)[m7628(this)] == '\\') {
                m7621(this)[m7636(this)] = m7617(this);
            } else {
                m7621(this)[m7636(this)] = m7621(this)[m7628(this)];
            }
            this.f1280eh = m7628(this) + 1;
            this.f1284uR = m7636(this) + 1;
        }
        throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abf.m2495()), m7635(this))));
    }

    public static String m7610(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m7650(obj);
        }
        return null;
    }

    public static int m7611(Object obj) {
        if (adds.m2755() >= 0) {
            return ((C0401og) obj).f1280eh;
        }
        return 0;
    }

    public static String m7612(Object obj) {
        if (C0457zc.m10735() < 0) {
            return ((C0401og) obj).m1319fp();
        }
        return null;
    }

    public static String m7613(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m7645(obj);
        }
        return null;
    }

    public static char m7614(Object obj) {
        if (C0457zc.m10735() <= 0) {
            return ((C0401og) obj).m1316fm();
        }
        return (char) 0;
    }

    public static int m7615(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m7641(obj);
        }
        return 0;
    }

    public static char[] m7616(Object obj) {
        if (C0452yh.m9798() > 0) {
            return ((C0401og) obj).f1279bl;
        }
        return null;
    }

    public static char m7617(Object obj) {
        if (C0445ya.m8222() > 0) {
            return m7643(obj);
        }
        return (char) 0;
    }

    public static int m7618(Object obj) {
        if (abc.m1845() <= 0) {
            return ((C0401og) obj).f1285uS;
        }
        return 0;
    }

    public static String m7619(Object obj) {
        if (C0458ze.m10932() > 0) {
            return ((C0401og) obj).m1318fo();
        }
        return null;
    }

    public static String m7620(Object obj) {
        if (gggy.m4269() <= 0) {
            return m7638(obj);
        }
        return null;
    }

    public static char[] m7621(Object obj) {
        if (C0451yg.m9580() >= 0) {
            return m7649(obj);
        }
        return null;
    }

    public static String m7622(Object obj) {
        if (gggy.m4269() < 0) {
            return ((C0401og) obj).f1283uQ;
        }
        return null;
    }

    public static String m7623(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((C0401og) obj).m1320fq();
        }
        return null;
    }

    public static int m7624(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0401og) obj).f1282uP;
        }
        return 0;
    }

    public static char m7625(Object obj) {
        if (abf.m2510() < 0) {
            return m7648(obj);
        }
        return (char) 0;
    }

    public static int m7626(Object obj) {
        if (C0460zg.m11287() > 0) {
            return ((C0401og) obj).f1281uO;
        }
        return 0;
    }

    public static char m7627(Object obj) {
        if (C0453yj.m10013() > 0) {
            return ((C0401og) obj).m1317fn();
        }
        return (char) 0;
    }

    public static int m7628(Object obj) {
        if (C0461zs.m11510() <= 0) {
            return m7640(obj);
        }
        return 0;
    }

    public static String m7629(Object obj) {
        if (abe.m2308() <= 0) {
            return m7651(obj);
        }
        return null;
    }

    public static String m7630(Object obj) {
        if (abf.m2510() <= 0) {
            return ((C0401og) obj).m1315fl();
        }
        return null;
    }

    public static int m7631(Object obj, int i) {
        if (abc.m1845() <= 0) {
            return m7644(obj, i);
        }
        return 0;
    }

    public static int m7632(Object obj) {
        if (C0460zg.m11287() > 0) {
            return m7646(obj);
        }
        return 0;
    }

    public static int m7633(Object obj) {
        if (C0449ye.m9220() <= 0) {
            return m7647(obj);
        }
        return 0;
    }

    public static int m7634(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0401og) obj).f1284uR;
        }
        return 0;
    }

    public static String m7635(Object obj) {
        if (C0446yb.m8415() < 0) {
            return m7639(obj);
        }
        return null;
    }

    public static int m7636(Object obj) {
        if (C0456zb.m10326() < 0) {
            return m7642(obj);
        }
        return 0;
    }

    public static int m7637(Object obj, int i) {
        if (abe.m2308() <= 0) {
            return ((C0401og) obj).m1314B(i);
        }
        return 0;
    }

    public static String m7638(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m7619((C0401og) obj);
        }
        return null;
    }

    public static String m7639(Object obj) {
        if (C0445ya.m8330() > 0) {
            return m7622((C0401og) obj);
        }
        return null;
    }

    public static int m7640(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m7611((C0401og) obj);
        }
        return 0;
    }

    public static int m7641(Object obj) {
        if (C0457zc.m10555() >= 0) {
            return m7618((C0401og) obj);
        }
        return 0;
    }

    public static int m7642(Object obj) {
        if (C0453yj.m10032() > 0) {
            return m7634((C0401og) obj);
        }
        return 0;
    }

    public static char m7643(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m7614((C0401og) obj);
        }
        return (char) 0;
    }

    public static int m7644(Object obj, int i) {
        if (C0456zb.m10484() < 0) {
            return m7637((C0401og) obj, i);
        }
        return 0;
    }

    public static String m7645(Object obj) {
        if (abd.m2166() < 0) {
            return m7630((C0401og) obj);
        }
        return null;
    }

    public static int m7646(Object obj) {
        if (C0457zc.m10718() < 0) {
            return m7624((C0401og) obj);
        }
        return 0;
    }

    public static int m7647(Object obj) {
        if (C0456zb.m10484() < 0) {
            return m7626((C0401og) obj);
        }
        return 0;
    }

    public static char m7648(Object obj) {
        if (C0453yj.m9996() < 0) {
            return m7627((C0401og) obj);
        }
        return (char) 0;
    }

    public static char[] m7649(Object obj) {
        if (abd.m2166() < 0) {
            return m7616((C0401og) obj);
        }
        return null;
    }

    public static String m7650(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m7612((C0401og) obj);
        }
        return null;
    }

    public static String m7651(Object obj) {
        if (C0458ze.m10926() <= 0) {
            return m7623((C0401og) obj);
        }
        return null;
    }

    public String m1321al(String str) {
        this.f1280eh = 0;
        this.f1281uO = 0;
        this.f1284uR = 0;
        this.f1282uP = 0;
        this.f1279bl = adds.m2883(m7635(this));
        String strM7610 = m7610(this);
        if (strM7610 == null) {
            return null;
        }
        do {
            String strM4277 = gggy.m4277();
            if (m7628(this) == m7615(this)) {
                return null;
            }
            switch (m7621(this)[m7628(this)]) {
                case '\"':
                    strM4277 = m7629(this);
                    break;
                case '#':
                    strM4277 = m7620(this);
                    break;
                case '+':
                case ',':
                case ';':
                    break;
                default:
                    strM4277 = m7613(this);
                    break;
            }
            if (C0457zc.m10547(str, strM7610)) {
                return strM4277;
            }
            if (m7628(this) >= m7615(this)) {
                return null;
            }
            if (m7621(this)[m7628(this)] != ',' && m7621(this)[m7628(this)] != ';' && m7621(this)[m7628(this)] != '+') {
                throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0460zg.m11367()), m7635(this))));
            }
            this.f1280eh = m7628(this) + 1;
            strM7610 = m7610(this);
        } while (strM7610 != null);
        throw new IllegalStateException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0460zg.m11367()), m7635(this))));
    }
}
