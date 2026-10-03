package com.appsflyer;

import kotlin.jvm.functions.Function1;

public final class AFLogger$$ExternalSyntheticLambda1 implements Runnable {
    public final Function1 f$0;

    public AFLogger$$ExternalSyntheticLambda1(Function1 function1) {
        this.f$0 = function1;
    }

    @Override
    public final void run() {
        AFLogger.AFInAppEventType(this.f$0);
    }
}
