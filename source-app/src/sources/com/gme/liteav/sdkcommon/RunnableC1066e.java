package com.gme.liteav.sdkcommon;

final class RunnableC1066e implements Runnable {

    private final DashboardManager f792a;

    private final String f793b;

    private final String f794c;

    private RunnableC1066e(DashboardManager dashboardManager, String str, String str2) {
        this.f792a = dashboardManager;
        this.f793b = str;
        this.f794c = str2;
    }

    public static Runnable m1047a(DashboardManager dashboardManager, String str, String str2) {
        return new RunnableC1066e(dashboardManager, str, str2);
    }

    @Override
    public final void run() {
        this.f792a.setStatusInternal(this.f793b, this.f794c);
    }
}
