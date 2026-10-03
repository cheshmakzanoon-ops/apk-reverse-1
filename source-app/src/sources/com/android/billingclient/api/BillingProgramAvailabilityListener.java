package com.android.billingclient.api;

public interface BillingProgramAvailabilityListener {
    void onBillingProgramAvailabilityResponse(BillingResult billingResult, BillingProgramAvailabilityDetails billingProgramAvailabilityDetails);
}
