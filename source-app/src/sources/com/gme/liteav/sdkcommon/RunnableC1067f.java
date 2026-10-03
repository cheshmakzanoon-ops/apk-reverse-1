package com.gme.liteav.sdkcommon;

final class RunnableC1067f implements Runnable {

    private final DashboardManager f795a;

    private final String f796b;

    private final String f797c;

    private RunnableC1067f(DashboardManager dashboardManager, String str, String str2) {
        this.f795a = dashboardManager;
        this.f796b = str;
        this.f797c = str2;
    }

    public static Runnable m1048a(DashboardManager dashboardManager, String str, String str2) {
        return new RunnableC1067f(dashboardManager, str, str2);
    }

    @Override
    public final void run() {
        this.f795a.appendLogInternal(this.f796b, this.f797c);
    }
}
