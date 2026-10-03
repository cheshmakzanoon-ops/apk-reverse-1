package com.gme.liteav.sdkcommon;

final class RunnableC1064c implements Runnable {

    private final DashboardManager f789a;

    private final String f790b;

    private RunnableC1064c(DashboardManager dashboardManager, String str) {
        this.f789a = dashboardManager;
        this.f790b = str;
    }

    public static Runnable m1045a(DashboardManager dashboardManager, String str) {
        return new RunnableC1064c(dashboardManager, str);
    }

    @Override
    public final void run() {
        this.f789a.removeDashboardInternal(this.f790b);
    }
}
