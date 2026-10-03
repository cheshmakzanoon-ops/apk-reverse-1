package com.facebook.internal.instrument;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.GraphRequestBatch;
import com.facebook.GraphResponse;
import com.facebook.internal.FeatureManager;
import com.facebook.internal.Utility;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0002\b\u0005\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\b\u0010\u0005\u001a\u00020\u0006H\u0007J\u0012\u0010\u0007\u001a\u00020\u00062\b\u0010\b\u001a\u0004\u0018\u00010\tH\u0007J\r\u0010\n\u001a\u00020\u0004H\u0001¢\u0006\u0002\b\u000bJ\r\u0010\f\u001a\u00020\u0006H\u0001¢\u0006\u0002\b\rR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u000e"}, d2 = {"Lcom/facebook/internal/instrument/ExceptionAnalyzer;", "", "()V", "enabled", "", "enable", "", "execute", "e", "", "isDebug", "isDebug$facebook_core_release", "sendExceptionAnalysisReports", "sendExceptionAnalysisReports$facebook_core_release", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ExceptionAnalyzer {
    public static final ExceptionAnalyzer INSTANCE = new ExceptionAnalyzer();
    private static boolean enabled;

    @JvmStatic
    public static final boolean isDebug$facebook_core_release() {
        return false;
    }

    private ExceptionAnalyzer() {
    }

    @JvmStatic
    public static final void enable() {
        ExceptionAnalyzer exceptionAnalyzer = INSTANCE;
        enabled = true;
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (FacebookSdk.getAutoLogAppEventsEnabled()) {
            exceptionAnalyzer.sendExceptionAnalysisReports$facebook_core_release();
        }
    }

    @JvmStatic
    public static final void execute(Throwable e) {
        if (!enabled || isDebug$facebook_core_release() || e == null) {
            return;
        }
        HashSet hashSet = new HashSet();
        StackTraceElement[] stackTrace = e.getStackTrace();
        Intrinsics.checkNotNullExpressionValue(stackTrace, "e.stackTrace");
        for (StackTraceElement stackTraceElement : stackTrace) {
            FeatureManager featureManager = FeatureManager.INSTANCE;
            String className = stackTraceElement.getClassName();
            Intrinsics.checkNotNullExpressionValue(className, "it.className");
            FeatureManager.Feature feature = FeatureManager.getFeature(className);
            if (feature != FeatureManager.Feature.Unknown) {
                FeatureManager featureManager2 = FeatureManager.INSTANCE;
                FeatureManager.disableFeature(feature);
                hashSet.add(feature.toString());
            }
        }
        FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
        if (FacebookSdk.getAutoLogAppEventsEnabled()) {
            HashSet hashSet2 = hashSet;
            if (hashSet2.isEmpty()) {
                return;
            }
            InstrumentData.Builder builder = InstrumentData.Builder.INSTANCE;
            InstrumentData.Builder.build(new JSONArray((Collection) hashSet2)).save();
        }
    }

    public final void sendExceptionAnalysisReports$facebook_core_release() {
        Utility utility = Utility.INSTANCE;
        if (Utility.isDataProcessingRestricted()) {
            return;
        }
        InstrumentUtility instrumentUtility = InstrumentUtility.INSTANCE;
        File[] fileArrListExceptionAnalysisReportFiles = InstrumentUtility.listExceptionAnalysisReportFiles();
        ArrayList arrayList = new ArrayList();
        int length = fileArrListExceptionAnalysisReportFiles.length;
        int i = 0;
        while (i < length) {
            File file = fileArrListExceptionAnalysisReportFiles[i];
            i++;
            InstrumentData.Builder builder = InstrumentData.Builder.INSTANCE;
            final InstrumentData instrumentDataLoad = InstrumentData.Builder.load(file);
            if (instrumentDataLoad.isValid()) {
                JSONObject jSONObject = new JSONObject();
                try {
                    jSONObject.put("crash_shield", instrumentDataLoad.toString());
                    GraphRequest.Companion companion = GraphRequest.INSTANCE;
                    StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                    FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                    String str = String.format("%s/instruments", Arrays.copyOf(new Object[]{FacebookSdk.getApplicationId()}, 1));
                    Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(format, *args)");
                    arrayList.add(companion.newPostRequest(null, str, jSONObject, new GraphRequest.Callback() {
                        @Override
                        public final void onCompleted(GraphResponse graphResponse) {
                            ExceptionAnalyzer.m2521sendExceptionAnalysisReports$lambda1(instrumentDataLoad, graphResponse);
                        }
                    }));
                } catch (JSONException unused) {
                }
            }
        }
        if (arrayList.isEmpty()) {
            return;
        }
        new GraphRequestBatch(arrayList).executeAsync();
    }

    public static final void m2521sendExceptionAnalysisReports$lambda1(InstrumentData instrumentData, GraphResponse graphResponse) {
        Intrinsics.checkNotNullParameter(instrumentData, "$instrumentData");
        Intrinsics.checkNotNullParameter(graphResponse, "response");
        try {
            if (graphResponse.getError() == null) {
                JSONObject jsonObject = graphResponse.getJsonObject();
                if (Intrinsics.areEqual(jsonObject == null ? null : Boolean.valueOf(jsonObject.getBoolean(GraphResponse.SUCCESS_KEY)), true)) {
                    instrumentData.clear();
                }
            }
        } catch (JSONException unused) {
        }
    }
}
