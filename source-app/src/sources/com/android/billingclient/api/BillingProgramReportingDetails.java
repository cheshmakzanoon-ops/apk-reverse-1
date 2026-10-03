package com.android.billingclient.api;

public final class BillingProgramReportingDetails {
    private final int billingProgram;
    private final String externalTransactionToken;

    BillingProgramReportingDetails(String str, int i) {
        this.externalTransactionToken = str;
        this.billingProgram = i;
    }

    public int getBillingProgram() {
        return this.billingProgram;
    }

    public String getExternalTransactionToken() {
        return this.externalTransactionToken;
    }
}
