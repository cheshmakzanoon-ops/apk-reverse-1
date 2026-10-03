package com.sdkmanager;

import com.googleplayservice.GooglePlayManager;

public final class SdkManager$$ExternalSyntheticLambda5 implements GooglePlayManager.GooglePlaySignInDelegate {
    public final SdkManager f$0;

    public SdkManager$$ExternalSyntheticLambda5(SdkManager sdkManager) {
        this.f$0 = sdkManager;
    }

    @Override
    public final void invoke(int i) {
        this.f$0.OnSetAccountFuncCallback(i);
    }
}
