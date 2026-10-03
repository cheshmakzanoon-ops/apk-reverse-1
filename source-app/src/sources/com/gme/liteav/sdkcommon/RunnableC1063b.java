package com.gme.liteav.sdkcommon;

final class RunnableC1063b implements Runnable {

    private final DashboardManager f787a;

    private final String f788b;

    private RunnableC1063b(DashboardManager dashboardManager, String str) {
        this.f787a = dashboardManager;
        this.f788b = str;
    }

    public static Runnable m1044a(DashboardManager dashboardManager, String str) {
        return new RunnableC1063b(dashboardManager, str);
    }

    @Override
    public final void run() {
        this.f787a.addDashboardInternal(this.f788b);
    }
}
