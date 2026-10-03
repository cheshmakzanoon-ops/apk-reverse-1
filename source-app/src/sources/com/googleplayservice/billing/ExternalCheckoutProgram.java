package com.googleplayservice.billing;

public enum ExternalCheckoutProgram {
    None,
    AndroidUsExternalContent,
    AndroidEeaAlternative,
    AndroidJapanExternalPayments,
    AndroidKrAlternative,
    IosUsExternalLink,
    IosEuExternalPurchase,
    IosJapanAlternative,
    IosKrExternalPurchase;

    public static ExternalCheckoutProgram fromValue(int i) {
        ExternalCheckoutProgram[] externalCheckoutProgramArrValues = values();
        if (i < 0 || i >= externalCheckoutProgramArrValues.length) {
            return None;
        }
        return externalCheckoutProgramArrValues[i];
    }

    public boolean requiresAndroidBillingApproval() {
        return this == AndroidUsExternalContent || this == AndroidJapanExternalPayments;
    }
}
