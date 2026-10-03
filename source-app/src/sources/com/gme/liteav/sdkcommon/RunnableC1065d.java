package com.gme.liteav.sdkcommon;

final class RunnableC1065d implements Runnable {

    private final DashboardManager f791a;

    private RunnableC1065d(DashboardManager dashboardManager) {
        this.f791a = dashboardManager;
    }

    public static Runnable m1046a(DashboardManager dashboardManager) {
        return new RunnableC1065d(dashboardManager);
    }

    @Override
    public final void run() {
        this.f791a.removeAllDashboardInternal();
    }
}
