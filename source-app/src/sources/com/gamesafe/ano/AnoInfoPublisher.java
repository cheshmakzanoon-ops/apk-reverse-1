package com.gamesafe.ano;

import java.util.ArrayList;
import java.util.Iterator;

public class AnoInfoPublisher implements Runnable {
    public static final int ANO_INFO_TYPE_DETECT_RESULT = 1;
    public static final int ANO_INFO_TYPE_HEARTBEAT = 2;

    private static volatile AnoInfoPublisher f528a = null;

    private static Thread f529b = null;

    private static volatile boolean f530c = false;

    private ArrayList f531d = new ArrayList();

    public interface AnoInfoReceiver {
        void onReceive(int i, String str);
    }

    private AnoInfoPublisher() {
    }

    private static int m833a() {
        try {
            return Integer.parseInt(C0976b.m849c(C0975a.m846a("dgx_jkzi_kdkz")));
        } catch (Exception unused) {
            return -1;
        }
    }

    private void m834a(int i, String str) {
        if (str == null) {
            return;
        }
        ArrayList arrayList = new ArrayList();
        synchronized (AnoInfoPublisher.class) {
            arrayList.addAll(this.f531d);
        }
        Iterator it = arrayList.iterator();
        while (it.hasNext()) {
            ((AnoInfoReceiver) it.next()).onReceive(i, str);
        }
    }

    private static void m835b() {
        try {
            C0976b.m849c(C0975a.m846a("dgx_xgjnz_kdkz"));
        } catch (Exception unused) {
        }
    }

    private static String m836c() {
        try {
            return C0976b.m849c(C0975a.m846a("dgx_mzxq_kdkz"));
        } catch (Exception unused) {
            return "-1";
        }
    }

    public static AnoInfoPublisher getInstance() {
        if (f528a == null) {
            synchronized (AnoInfoPublisher.class) {
                if (f528a == null) {
                    f528a = new AnoInfoPublisher();
                }
            }
        }
        return f528a;
    }

    public void registAnoInfoReceiver(AnoInfoReceiver anoInfoReceiver) {
        if (anoInfoReceiver == null) {
            return;
        }
        synchronized (AnoInfoPublisher.class) {
            this.f531d.add(anoInfoReceiver);
        }
        if (f530c) {
            return;
        }
        synchronized (AnoSdk.class) {
            if (!f530c) {
                f530c = true;
                Thread thread = new Thread(getInstance());
                f529b = thread;
                thread.start();
            }
        }
    }

    @Override
    public void run() {
        int iIndexOf;
        if (m833a() == -1) {
            f530c = false;
            return;
        }
        while (true) {
            try {
                try {
                    String strM836c = m836c();
                    if (strM836c == null || strM836c.equals("-1") || (iIndexOf = strM836c.indexOf(124)) == -1) {
                        break;
                        break;
                        break;
                    } else {
                        int i = Integer.parseInt(strM836c.substring(0, iIndexOf));
                        if (i > 0) {
                            m834a(i, strM836c.substring(iIndexOf + 1));
                        } else {
                            try {
                                Thread.sleep(1000L);
                            } catch (Exception unused) {
                            }
                        }
                    }
                } catch (Exception unused2) {
                }
            } catch (Throwable th) {
                m835b();
                f530c = false;
                throw th;
            }
        }
        m835b();
        f530c = false;
    }
}
