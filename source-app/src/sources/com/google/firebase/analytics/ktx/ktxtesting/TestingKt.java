package com.google.firebase.analytics.ktx.ktxtesting;

import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.analytics.ktx.AnalyticsKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u001c\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00010\u0005¨\u0006\u0006"}, d2 = {"withAnalyticsForTest", "", "analytics", "Lcom/google/firebase/analytics/FirebaseAnalytics;", "block", "Lkotlin/Function0;", "java.com.google.android.gmscore.integ.client.measurement_api_measurement_api"}, k = 2, mv = {1, 9, 0}, xi = 48)
public final class TestingKt {
    public static final void withAnalyticsForTest(FirebaseAnalytics firebaseAnalytics, Function0<Unit> function0) {
        Intrinsics.checkNotNullParameter(firebaseAnalytics, "analytics");
        Intrinsics.checkNotNullParameter(function0, "block");
        synchronized (AnalyticsKt.getLOCK()) {
            FirebaseAnalytics analytics = AnalyticsKt.getANALYTICS();
            AnalyticsKt.setANALYTICS(firebaseAnalytics);
            try {
                function0.invoke();
                AnalyticsKt.setANALYTICS(analytics);
            } catch (Throwable th) {
                AnalyticsKt.setANALYTICS(analytics);
                throw th;
            }
        }
    }
}
