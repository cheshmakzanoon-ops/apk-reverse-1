package com.android.billingclient.api;

@Deprecated
public interface ExternalOfferReportingDetailsListener {
    void onExternalOfferReportingDetailsResponse(BillingResult billingResult, ExternalOfferReportingDetails externalOfferReportingDetails);
}
