package com.gamesafe.ano;

import android.os.Handler;
import android.os.Looper;

public class MainThreadDispatcher2 {

    static class RunnableC0974a implements Runnable {

        private String f532a;

        public RunnableC0974a(String str) {
            this.f532a = str;
        }

        @Override
        public void run() {
            MainThreadDispatcher2.m841c(this.f532a);
        }
    }

    public static void SendCmd(String str) {
        if (str.startsWith(C0975a.m846a("npw:"))) {
            m841c(str.substring(4));
        } else {
            new Handler(Looper.getMainLooper()).post(m840b(str));
        }
    }

    private static Runnable m840b(String str) {
        return new RunnableC0974a(str);
    }

    public static void m841c(String str) {
        AnoJavaMethod.sendCmd(str);
    }
}
