package com.android.billingclient.api;

public final class BillingProgramAvailabilityDetails {
    private final int billingProgram;

    BillingProgramAvailabilityDetails(int i) {
        this.billingProgram = i;
    }

    public int getBillingProgram() {
        return this.billingProgram;
    }
}
