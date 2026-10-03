package androidx.tracing;

import android.adservices.appsetid.AppSetIdManager;
import android.adservices.common.AdData;
import android.adservices.customaudience.CustomAudience;
import android.adservices.customaudience.CustomAudienceManager;
import android.adservices.customaudience.JoinCustomAudienceRequest;
import android.adservices.customaudience.LeaveCustomAudienceRequest;
import android.adservices.customaudience.TrustedBiddingData;
import android.adservices.measurement.DeletionRequest;
import android.adservices.measurement.MeasurementManager;
import android.adservices.measurement.WebSourceParams;
import android.adservices.measurement.WebSourceRegistrationRequest;
import android.adservices.measurement.WebTriggerParams;
import android.adservices.measurement.WebTriggerRegistrationRequest;
import android.adservices.topics.GetTopicsRequest;
import android.adservices.topics.GetTopicsResponse;
import android.adservices.topics.Topic;
import android.adservices.topics.TopicsManager;
import android.net.Uri;
import java.util.List;

public final class Trace$$ExternalSyntheticApiModelOutline0 {
    public static AppSetIdManager m349m(Object obj) {
        return (AppSetIdManager) obj;
    }

    public static AdData.Builder m350m() {
        return new AdData.Builder();
    }

    public static CustomAudience.Builder m354m() {
        return new CustomAudience.Builder();
    }

    public static CustomAudienceManager m362m(Object obj) {
        return (CustomAudienceManager) obj;
    }

    public static JoinCustomAudienceRequest.Builder m363m() {
        return new JoinCustomAudienceRequest.Builder();
    }

    public static LeaveCustomAudienceRequest.Builder m366m() {
        return new LeaveCustomAudienceRequest.Builder();
    }

    public static TrustedBiddingData.Builder m370m() {
        return new TrustedBiddingData.Builder();
    }

    public static DeletionRequest.Builder m374m() {
        return new DeletionRequest.Builder();
    }

    public static MeasurementManager m378m(Object obj) {
        return (MeasurementManager) obj;
    }

    public static WebSourceParams.Builder m380m(Uri uri) {
        return new WebSourceParams.Builder(uri);
    }

    public static WebSourceRegistrationRequest.Builder m384m(List list, Uri uri) {
        return new WebSourceRegistrationRequest.Builder(list, uri);
    }

    public static WebTriggerParams.Builder m387m(Uri uri) {
        return new WebTriggerParams.Builder(uri);
    }

    public static WebTriggerRegistrationRequest.Builder m389m(List list, Uri uri) {
        return new WebTriggerRegistrationRequest.Builder(list, uri);
    }

    public static GetTopicsRequest.Builder m391m() {
        return new GetTopicsRequest.Builder();
    }

    public static GetTopicsResponse m395m(Object obj) {
        return (GetTopicsResponse) obj;
    }

    public static Topic m396m(Object obj) {
        return (Topic) obj;
    }

    public static TopicsManager m397m(Object obj) {
        return (TopicsManager) obj;
    }

    public static Class m401m() {
        return AppSetIdManager.class;
    }

    public static void m404m() {
    }

    public static Class m$1() {
        return CustomAudienceManager.class;
    }

    public static void m2249m$1() {
    }

    public static Class m$2() {
        return MeasurementManager.class;
    }

    public static void m2250m$2() {
    }

    public static Class m$3() {
        return TopicsManager.class;
    }

    public static void m2251m$3() {
    }
}
