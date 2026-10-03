package com.android.billingclient.api;

public interface BillingProgramReportingDetailsListener {
    void onCreateBillingProgramReportingDetailsResponse(BillingResult billingResult, BillingProgramReportingDetails billingProgramReportingDetails);
}
