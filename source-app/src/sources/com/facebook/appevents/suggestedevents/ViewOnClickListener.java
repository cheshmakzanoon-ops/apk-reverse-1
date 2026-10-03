package com.facebook.appevents.suggestedevents;

import android.os.Bundle;
import android.view.View;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.GraphRequest;
import com.facebook.appevents.InternalAppEventsLogger;
import com.facebook.appevents.codeless.internal.ViewHierarchy;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import com.facebook.appevents.p005ml.ModelManager;
import com.facebook.internal.Utility;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import java.lang.ref.WeakReference;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.StringsKt;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u0000 \u00152\u00020\u0001:\u0001\u0015B\u001f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u0010\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u0003H\u0016J \u0010\u000f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u00062\u0006\u0010\u0011\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u0013H\u0002J\b\u0010\u0014\u001a\u00020\rH\u0002R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\b\u001a\u0004\u0018\u00010\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00030\nX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Lcom/facebook/appevents/suggestedevents/ViewOnClickListener;", "Landroid/view/View$OnClickListener;", "hostView", "Landroid/view/View;", "rootView", "activityName", "", "(Landroid/view/View;Landroid/view/View;Ljava/lang/String;)V", "baseListener", "hostViewWeakReference", "Ljava/lang/ref/WeakReference;", "rootViewWeakReference", "onClick", "", ViewHierarchyConstants.VIEW_KEY, "predictAndProcess", "pathID", "buttonText", "viewData", "Lorg/json/JSONObject;", "process", "Companion", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ViewOnClickListener implements View.OnClickListener {
    private static final String API_ENDPOINT = "%s/suggested_events";
    public static final String OTHER_EVENT = "other";
    private final String activityName;
    private final View.OnClickListener baseListener;
    private final WeakReference<View> hostViewWeakReference;
    private final WeakReference<View> rootViewWeakReference;

    public static final Companion INSTANCE = new Companion(null);
    private static final Set<Integer> viewsAttachedListener = new HashSet();

    public ViewOnClickListener(View view, View view2, String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(view, view2, str);
    }

    @JvmStatic
    public static final void attachListener$facebook_core_release(View view, View view2, String str) {
        if (CrashShieldHandler.isObjectCrashing(ViewOnClickListener.class)) {
            return;
        }
        try {
            INSTANCE.attachListener$facebook_core_release(view, view2, str);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ViewOnClickListener.class);
        }
    }

    private ViewOnClickListener(View view, View view2, String str) {
        ViewHierarchy viewHierarchy = ViewHierarchy.INSTANCE;
        this.baseListener = ViewHierarchy.getExistingOnClickListener(view);
        this.rootViewWeakReference = new WeakReference<>(view2);
        this.hostViewWeakReference = new WeakReference<>(view);
        if (str == null) {
            throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
        }
        String lowerCase = str.toLowerCase();
        Intrinsics.checkNotNullExpressionValue(lowerCase, "(this as java.lang.String).toLowerCase()");
        this.activityName = StringsKt.replace$default(lowerCase, "activity", "", false, 4, (Object) null);
    }

    public static final Set access$getViewsAttachedListener$cp() {
        if (CrashShieldHandler.isObjectCrashing(ViewOnClickListener.class)) {
            return null;
        }
        try {
            return viewsAttachedListener;
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ViewOnClickListener.class);
            return null;
        }
    }

    @Override
    public void onClick(View view) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(view, ViewHierarchyConstants.VIEW_KEY);
            View.OnClickListener onClickListener = this.baseListener;
            if (onClickListener != null) {
                onClickListener.onClick(view);
            }
            process();
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final void process() {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            View view = this.rootViewWeakReference.get();
            View view2 = this.hostViewWeakReference.get();
            if (view == null || view2 == null) {
                return;
            }
            try {
                SuggestedEventViewHierarchy suggestedEventViewHierarchy = SuggestedEventViewHierarchy.INSTANCE;
                String textOfViewRecursively = SuggestedEventViewHierarchy.getTextOfViewRecursively(view2);
                PredictionHistoryManager predictionHistoryManager = PredictionHistoryManager.INSTANCE;
                String pathID = PredictionHistoryManager.getPathID(view2, textOfViewRecursively);
                if (pathID == null || INSTANCE.queryHistoryAndProcess(pathID, textOfViewRecursively)) {
                    return;
                }
                JSONObject jSONObject = new JSONObject();
                SuggestedEventViewHierarchy suggestedEventViewHierarchy2 = SuggestedEventViewHierarchy.INSTANCE;
                jSONObject.put(ViewHierarchyConstants.VIEW_KEY, SuggestedEventViewHierarchy.getDictionaryOfView(view, view2));
                jSONObject.put(ViewHierarchyConstants.SCREEN_NAME_KEY, this.activityName);
                predictAndProcess(pathID, textOfViewRecursively, jSONObject);
            } catch (Exception unused) {
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    private final void predictAndProcess(final String pathID, final String buttonText, final JSONObject viewData) {
        if (CrashShieldHandler.isObjectCrashing(this)) {
            return;
        }
        try {
            Utility utility = Utility.INSTANCE;
            Utility.runOnNonUiThread(new Runnable() {
                @Override
                public final void run() {
                    ViewOnClickListener.m2452predictAndProcess$lambda0(viewData, buttonText, this, pathID);
                }
            });
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, this);
        }
    }

    public static final void m2452predictAndProcess$lambda0(JSONObject jSONObject, String str, ViewOnClickListener viewOnClickListener, String str2) {
        if (CrashShieldHandler.isObjectCrashing(ViewOnClickListener.class)) {
            return;
        }
        try {
            Intrinsics.checkNotNullParameter(jSONObject, "$viewData");
            Intrinsics.checkNotNullParameter(str, "$buttonText");
            Intrinsics.checkNotNullParameter(viewOnClickListener, "this$0");
            Intrinsics.checkNotNullParameter(str2, "$pathID");
            try {
                Utility utility = Utility.INSTANCE;
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                String appName = Utility.getAppName(FacebookSdk.getApplicationContext());
                if (appName == null) {
                    throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
                }
                String lowerCase = appName.toLowerCase();
                Intrinsics.checkNotNullExpressionValue(lowerCase, "(this as java.lang.String).toLowerCase()");
                FeatureExtractor featureExtractor = FeatureExtractor.INSTANCE;
                float[] denseFeatures = FeatureExtractor.getDenseFeatures(jSONObject, lowerCase);
                FeatureExtractor featureExtractor2 = FeatureExtractor.INSTANCE;
                String textFeature = FeatureExtractor.getTextFeature(str, viewOnClickListener.activityName, lowerCase);
                if (denseFeatures == null) {
                    return;
                }
                ModelManager modelManager = ModelManager.INSTANCE;
                String[] strArrPredict = ModelManager.predict(ModelManager.Task.MTML_APP_EVENT_PREDICTION, new float[][]{denseFeatures}, new String[]{textFeature});
                if (strArrPredict == null) {
                    return;
                }
                String str3 = strArrPredict[0];
                PredictionHistoryManager predictionHistoryManager = PredictionHistoryManager.INSTANCE;
                PredictionHistoryManager.addPrediction(str2, str3);
                if (Intrinsics.areEqual(str3, "other")) {
                    return;
                }
                INSTANCE.processPredictedResult(str3, str, denseFeatures);
            } catch (Exception unused) {
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ViewOnClickListener.class);
        }
    }

    @Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010#\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u0014\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J%\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u000e\u001a\u00020\u0004H\u0001¢\u0006\u0002\b\u000fJ \u0010\u0010\u001a\u00020\n2\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\u0012\u001a\u00020\u00042\u0006\u0010\u0013\u001a\u00020\u0014H\u0002J\u0018\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0012\u001a\u00020\u0004H\u0002J \u0010\u0018\u001a\u00020\n2\u0006\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u0012\u001a\u00020\u00042\u0006\u0010\u0013\u001a\u00020\u0014H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001a"}, d2 = {"Lcom/facebook/appevents/suggestedevents/ViewOnClickListener$Companion;", "", "()V", "API_ENDPOINT", "", "OTHER_EVENT", "viewsAttachedListener", "", "", "attachListener", "", "hostView", "Landroid/view/View;", "rootView", "activityName", "attachListener$facebook_core_release", "processPredictedResult", "predictedEvent", "buttonText", "dense", "", "queryHistoryAndProcess", "", "pathID", "sendPredictedResult", "eventToPost", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final void attachListener$facebook_core_release(View hostView, View rootView, String activityName) {
            Intrinsics.checkNotNullParameter(hostView, "hostView");
            Intrinsics.checkNotNullParameter(rootView, "rootView");
            Intrinsics.checkNotNullParameter(activityName, "activityName");
            int iHashCode = hostView.hashCode();
            if (ViewOnClickListener.access$getViewsAttachedListener$cp().contains(Integer.valueOf(iHashCode))) {
                return;
            }
            ViewHierarchy viewHierarchy = ViewHierarchy.INSTANCE;
            ViewHierarchy.setOnClickListener(hostView, new ViewOnClickListener(hostView, rootView, activityName, null));
            ViewOnClickListener.access$getViewsAttachedListener$cp().add(Integer.valueOf(iHashCode));
        }

        public final boolean queryHistoryAndProcess(String pathID, final String buttonText) {
            PredictionHistoryManager predictionHistoryManager = PredictionHistoryManager.INSTANCE;
            final String strQueryEvent = PredictionHistoryManager.queryEvent(pathID);
            if (strQueryEvent == null) {
                return false;
            }
            if (Intrinsics.areEqual(strQueryEvent, "other")) {
                return true;
            }
            Utility utility = Utility.INSTANCE;
            Utility.runOnNonUiThread(new Runnable() {
                @Override
                public final void run() {
                    ViewOnClickListener.Companion.m2453queryHistoryAndProcess$lambda0(strQueryEvent, buttonText);
                }
            });
            return true;
        }

        public static final void m2453queryHistoryAndProcess$lambda0(String str, String str2) {
            Intrinsics.checkNotNullParameter(str, "$queriedEvent");
            Intrinsics.checkNotNullParameter(str2, "$buttonText");
            ViewOnClickListener.INSTANCE.processPredictedResult(str, str2, new float[0]);
        }

        public final void processPredictedResult(String predictedEvent, String buttonText, float[] dense) {
            SuggestedEventsManager suggestedEventsManager = SuggestedEventsManager.INSTANCE;
            if (SuggestedEventsManager.isProductionEvents$facebook_core_release(predictedEvent)) {
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                new InternalAppEventsLogger(FacebookSdk.getApplicationContext()).logEventFromSE(predictedEvent, buttonText);
            } else {
                SuggestedEventsManager suggestedEventsManager2 = SuggestedEventsManager.INSTANCE;
                if (SuggestedEventsManager.isEligibleEvents$facebook_core_release(predictedEvent)) {
                    sendPredictedResult(predictedEvent, buttonText, dense);
                }
            }
        }

        private final void sendPredictedResult(String eventToPost, String buttonText, float[] dense) {
            Bundle bundle = new Bundle();
            try {
                bundle.putString("event_name", eventToPost);
                JSONObject jSONObject = new JSONObject();
                StringBuilder sb = new StringBuilder();
                int length = dense.length;
                int i = 0;
                while (i < length) {
                    float f = dense[i];
                    i++;
                    sb.append(f);
                    sb.append(",");
                }
                jSONObject.put("dense", sb.toString());
                jSONObject.put("button_text", buttonText);
                bundle.putString("metadata", jSONObject.toString());
                GraphRequest.Companion companion = GraphRequest.INSTANCE;
                StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
                Locale locale = Locale.US;
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                String str = String.format(locale, ViewOnClickListener.API_ENDPOINT, Arrays.copyOf(new Object[]{FacebookSdk.getApplicationId()}, 1));
                Intrinsics.checkNotNullExpressionValue(str, "java.lang.String.format(locale, format, *args)");
                GraphRequest graphRequestNewPostRequest = companion.newPostRequest(null, str, null, null);
                graphRequestNewPostRequest.setParameters(bundle);
                graphRequestNewPostRequest.executeAndWait();
            } catch (JSONException unused) {
            }
        }
    }
}
