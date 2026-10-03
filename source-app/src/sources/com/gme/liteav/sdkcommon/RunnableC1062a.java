package com.gme.liteav.sdkcommon;

final class RunnableC1062a implements Runnable {

    private final DashboardManager f785a;

    private final boolean f786b;

    private RunnableC1062a(DashboardManager dashboardManager, boolean z) {
        this.f785a = dashboardManager;
        this.f786b = z;
    }

    public static Runnable m1043a(DashboardManager dashboardManager, boolean z) {
        return new RunnableC1062a(dashboardManager, z);
    }

    @Override
    public final void run() {
        this.f785a.showDashboardInternal(this.f786b);
    }
}
