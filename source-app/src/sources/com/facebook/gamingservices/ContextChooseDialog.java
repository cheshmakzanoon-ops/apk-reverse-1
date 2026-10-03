package com.facebook.gamingservices;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.webkit.internal.AssetHelper;
import com.facebook.AccessToken;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.FacebookSdk;
import com.facebook.GraphResponse;
import com.facebook.gamingservices.cloudgaming.CloudGameLoginHandler;
import com.facebook.gamingservices.cloudgaming.DaemonRequest;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import com.facebook.gamingservices.model.ContextChooseContent;
import com.facebook.internal.AppCall;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.CustomTabUtils;
import com.facebook.internal.DialogPresenter;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.internal.FragmentWrapper;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.ServerProtocol;
import com.facebook.share.internal.ResultProcessor;
import com.facebook.share.internal.ShareInternalUtility;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0005\u0018\u0000 $2\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001:\u0004#$%&B\u000f\b\u0016\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006B\u000f\b\u0016\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tB\u000f\b\u0016\u0012\u0006\u0010\u0007\u001a\u00020\n¢\u0006\u0002\u0010\u000bB\u000f\b\u0012\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\u0010\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0002H\u0016J\b\u0010\u0019\u001a\u00020\u001aH\u0014J\u001e\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00030\u0010H\u0014J\u0010\u0010\u001f\u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u0002H\u0002J\u0018\u0010 \u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u00022\u0006\u0010!\u001a\u00020\"H\u0014R\u0016\u0010\u000f\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R*\u0010\u0011\u001a\u0018\u0012\u0014\u0012\u00120\u0013R\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u00010\u00128TX\u0094\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0015¨\u0006'"}, d2 = {"Lcom/facebook/gamingservices/ContextChooseDialog;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/model/ContextChooseContent;", "Lcom/facebook/gamingservices/ContextChooseDialog$Result;", "activity", "Landroid/app/Activity;", "(Landroid/app/Activity;)V", "fragment", "Landroidx/fragment/app/Fragment;", "(Landroidx/fragment/app/Fragment;)V", "Landroid/app/Fragment;", "(Landroid/app/Fragment;)V", "fragmentWrapper", "Lcom/facebook/internal/FragmentWrapper;", "(Lcom/facebook/internal/FragmentWrapper;)V", "callback", "Lcom/facebook/FacebookCallback;", "orderedModeHandlers", "", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "getOrderedModeHandlers", "()Ljava/util/List;", "canShow", "", "content", "createBaseAppCall", "Lcom/facebook/internal/AppCall;", "registerCallbackImpl", "", "callbackManager", "Lcom/facebook/internal/CallbackManagerImpl;", "showForCloud", "showImpl", "mode", "", "ChromeCustomTabHandler", "Companion", "FacebookAppHandler", "Result", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ContextChooseDialog extends FacebookDialogBase<ContextChooseContent, Result> {
    private static final String CONTEXT_CHOOSE_DIALOG = "context_choose";
    private static final int DEFAULT_REQUEST_CODE = CallbackManagerImpl.RequestCodeOffset.GamingContextChoose.toRequestCode();
    private FacebookCallback<Result> callback;

    public ContextChooseDialog(Activity activity) {
        super(activity, DEFAULT_REQUEST_CODE);
        Intrinsics.checkNotNullParameter(activity, "activity");
    }

    public ContextChooseDialog(Fragment fragment) {
        this(new FragmentWrapper(fragment));
        Intrinsics.checkNotNullParameter(fragment, "fragment");
    }

    public ContextChooseDialog(android.app.Fragment fragment) {
        this(new FragmentWrapper(fragment));
        Intrinsics.checkNotNullParameter(fragment, "fragment");
    }

    private ContextChooseDialog(FragmentWrapper fragmentWrapper) {
        super(fragmentWrapper, DEFAULT_REQUEST_CODE);
    }

    @Override
    public boolean canShow(ContextChooseContent content) {
        Intrinsics.checkNotNullParameter(content, "content");
        return CloudGameLoginHandler.isRunningInCloud() || new FacebookAppHandler(this).canShow(content, true) || new ChromeCustomTabHandler(this).canShow(content, true);
    }

    @Override
    public void showImpl(ContextChooseContent content, Object mode) {
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(mode, "mode");
        if (CloudGameLoginHandler.isRunningInCloud()) {
            showForCloud(content);
        } else {
            super.showImpl(content, mode);
        }
    }

    private final void showForCloud(ContextChooseContent content) {
        AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
        if (currentAccessToken == null || currentAccessToken.isExpired()) {
            throw new FacebookException("Attempted to open ContextChooseContent with an invalid access token");
        }
        DaemonRequest.Callback callback = new DaemonRequest.Callback() {
            @Override
            public final void onCompleted(GraphResponse graphResponse) {
                ContextChooseDialog.m2473showForCloud$lambda2(this.f$0, graphResponse);
            }
        };
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("filters", content.getFilters());
            jSONObject.put(SDKConstants.PARAM_CONTEXT_MIN_SIZE, content.getMinSize());
            List<String> filters = content.getFilters();
            if (filters != null) {
                JSONArray jSONArray = new JSONArray();
                Iterator<String> it = filters.iterator();
                while (it.hasNext()) {
                    jSONArray.put(it.next());
                }
                jSONObject.put("filters", jSONArray);
            }
            DaemonRequest.executeAsync(getActivityContext(), jSONObject, callback, SDKMessageEnum.CONTEXT_CHOOSE);
        } catch (JSONException unused) {
            FacebookCallback<Result> facebookCallback = this.callback;
            if (facebookCallback == null) {
                return;
            }
            facebookCallback.onError(new FacebookException("Couldn't prepare Context Choose Dialog"));
        }
    }

    public static final void m2473showForCloud$lambda2(ContextChooseDialog contextChooseDialog, GraphResponse graphResponse) {
        Unit unit;
        Intrinsics.checkNotNullParameter(contextChooseDialog, "this$0");
        FacebookCallback<Result> facebookCallback = contextChooseDialog.callback;
        if (facebookCallback == null) {
            return;
        }
        FacebookRequestError error = graphResponse.getError();
        if (error == null) {
            unit = null;
        } else {
            facebookCallback.onError(new FacebookException(error.getErrorMessage()));
            unit = Unit.INSTANCE;
        }
        if (unit == null) {
            Intrinsics.checkNotNullExpressionValue(graphResponse, "response");
            facebookCallback.onSuccess(new Result(graphResponse));
        }
    }

    @Override
    protected void registerCallbackImpl(CallbackManagerImpl callbackManager, final FacebookCallback<Result> callback) {
        Intrinsics.checkNotNullParameter(callbackManager, "callbackManager");
        Intrinsics.checkNotNullParameter(callback, "callback");
        this.callback = callback;
        final ?? r0 = new ResultProcessor(callback) {
            final FacebookCallback<ContextChooseDialog.Result> $callback;

            {
                super(callback);
                this.$callback = callback;
            }

            @Override
            public void onSuccess(AppCall appCall, Bundle results) {
                Intrinsics.checkNotNullParameter(appCall, "appCall");
                if (results != null) {
                    if (results.getString("error_message") != null) {
                        this.$callback.onError(new FacebookException(results.getString("error_message")));
                        return;
                    }
                    String string = results.getString("id");
                    if (string != null) {
                        GamingContext.INSTANCE.setCurrentGamingContext(new GamingContext(string));
                        this.$callback.onSuccess(new ContextChooseDialog.Result(results));
                    }
                    this.$callback.onError(new FacebookException(results.getString("Invalid response received from server.")));
                    return;
                }
                onCancel(appCall);
            }
        };
        callbackManager.registerCallback(getRequestCodeField(), new CallbackManagerImpl.Callback() {
            @Override
            public final boolean onActivityResult(int i, Intent intent) {
                return ContextChooseDialog.m2472registerCallbackImpl$lambda4(this.f$0, r0, i, intent);
            }
        });
    }

    public static final boolean m2472registerCallbackImpl$lambda4(ContextChooseDialog contextChooseDialog, ContextChooseDialog$registerCallbackImpl$resultProcessor$1 contextChooseDialog$registerCallbackImpl$resultProcessor$1, int i, Intent intent) {
        Intrinsics.checkNotNullParameter(contextChooseDialog, "this$0");
        Intrinsics.checkNotNullParameter(contextChooseDialog$registerCallbackImpl$resultProcessor$1, "$resultProcessor");
        ShareInternalUtility shareInternalUtility = ShareInternalUtility.INSTANCE;
        return ShareInternalUtility.handleActivityResult(contextChooseDialog.getRequestCodeField(), i, intent, contextChooseDialog$registerCallbackImpl$resultProcessor$1);
    }

    @Override
    protected List<FacebookDialogBase<ContextChooseContent, Result>.ModeHandler> getOrderedModeHandlers() {
        return CollectionsKt.listOf(new FacebookDialogBase.ModeHandler[]{new FacebookAppHandler(this), new ChromeCustomTabHandler(this)});
    }

    @Override
    protected AppCall createBaseAppCall() {
        return new AppCall(getRequestCodeField(), null, 2, null);
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\u0018\u00002\u00020\u0001B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0016\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007R\u001c\u0010\b\u001a\u0004\u0018\u00010\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\r¨\u0006\u000e"}, d2 = {"Lcom/facebook/gamingservices/ContextChooseDialog$Result;", "", "results", "Landroid/os/Bundle;", "(Landroid/os/Bundle;)V", "response", "Lcom/facebook/GraphResponse;", "(Lcom/facebook/GraphResponse;)V", "contextID", "", "getContextID", "()Ljava/lang/String;", "setContextID", "(Ljava/lang/String;)V", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Result {
        private String contextID;

        public final String getContextID() {
            return this.contextID;
        }

        public final void setContextID(String str) {
            this.contextID = str;
        }

        public Result(Bundle bundle) {
            Intrinsics.checkNotNullParameter(bundle, "results");
            this.contextID = bundle.getString("id");
        }

        public Result(GraphResponse graphResponse) {
            JSONObject jSONObjectOptJSONObject;
            Intrinsics.checkNotNullParameter(graphResponse, "response");
            try {
                JSONObject graphObject = graphResponse.getGraphObject();
                if (graphObject != null && (jSONObjectOptJSONObject = graphObject.optJSONObject("data")) != null) {
                    setContextID(jSONObjectOptJSONObject.getString("id"));
                }
            } catch (JSONException unused) {
                this.contextID = null;
            }
        }
    }

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00120\u0001R\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0002B\u0005¢\u0006\u0002\u0010\u0005J\u0018\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\u0007H\u0016J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\b\u001a\u00020\u0003H\u0016¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/ContextChooseDialog$FacebookAppHandler;", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/model/ContextChooseContent;", "Lcom/facebook/gamingservices/ContextChooseDialog$Result;", "(Lcom/facebook/gamingservices/ContextChooseDialog;)V", "canShow", "", "content", "isBestEffort", "createAppCall", "Lcom/facebook/internal/AppCall;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private final class FacebookAppHandler extends FacebookDialogBase<ContextChooseContent, Result>.ModeHandler {
        final ContextChooseDialog this$0;

        public FacebookAppHandler(ContextChooseDialog contextChooseDialog) {
            super(contextChooseDialog);
            Intrinsics.checkNotNullParameter(contextChooseDialog, "this$0");
            this.this$0 = contextChooseDialog;
        }

        @Override
        public boolean canShow(ContextChooseContent content, boolean isBestEffort) {
            Intrinsics.checkNotNullParameter(content, "content");
            Activity activityContext = this.this$0.getActivityContext();
            PackageManager packageManager = activityContext == null ? null : activityContext.getPackageManager();
            Intent intent = new Intent("com.facebook.games.gaming_services.DEEPLINK");
            intent.setType(AssetHelper.DEFAULT_MIME_TYPE);
            boolean z = (packageManager == null ? null : intent.resolveActivity(packageManager)) != null;
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            return z && ((currentAccessToken != null ? currentAccessToken.getGraphDomain() : null) != null && Intrinsics.areEqual(FacebookSdk.GAMING, currentAccessToken.getGraphDomain()));
        }

        @Override
        public AppCall createAppCall(ContextChooseContent content) {
            Intrinsics.checkNotNullParameter(content, "content");
            AppCall appCallCreateBaseAppCall = this.this$0.createBaseAppCall();
            Intent intent = new Intent("com.facebook.games.gaming_services.DEEPLINK");
            intent.setType(AssetHelper.DEFAULT_MIME_TYPE);
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            Bundle bundle = new Bundle();
            bundle.putString(SDKConstants.PARAM_TOURNAMENTS_DEEPLINK, "CONTEXT_CHOOSE");
            if (currentAccessToken != null) {
                bundle.putString("game_id", currentAccessToken.getApplicationId());
            } else {
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                bundle.putString("game_id", FacebookSdk.getApplicationId());
            }
            if (content.getMinSize() != null) {
                bundle.putString("min_thread_size", content.getMinSize().toString());
            }
            if (content.getMaxSize() != null) {
                bundle.putString("max_thread_size", content.getMaxSize().toString());
            }
            if (content.getFilters() != null) {
                bundle.putString("filters", new JSONArray((Collection) content.getFilters()).toString());
            }
            NativeProtocol nativeProtocol = NativeProtocol.INSTANCE;
            String string = appCallCreateBaseAppCall.getCallId().toString();
            NativeProtocol nativeProtocol2 = NativeProtocol.INSTANCE;
            NativeProtocol.setupProtocolRequestIntent(intent, string, "", NativeProtocol.getLatestKnownVersion(), bundle);
            appCallCreateBaseAppCall.setRequestIntent(intent);
            return appCallCreateBaseAppCall;
        }
    }

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00120\u0001R\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0002B\u0005¢\u0006\u0002\u0010\u0005J\u0018\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\u0007H\u0016J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\b\u001a\u00020\u0003H\u0016¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/ContextChooseDialog$ChromeCustomTabHandler;", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/model/ContextChooseContent;", "Lcom/facebook/gamingservices/ContextChooseDialog$Result;", "(Lcom/facebook/gamingservices/ContextChooseDialog;)V", "canShow", "", "content", "isBestEffort", "createAppCall", "Lcom/facebook/internal/AppCall;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private final class ChromeCustomTabHandler extends FacebookDialogBase<ContextChooseContent, Result>.ModeHandler {
        final ContextChooseDialog this$0;

        public ChromeCustomTabHandler(ContextChooseDialog contextChooseDialog) {
            super(contextChooseDialog);
            Intrinsics.checkNotNullParameter(contextChooseDialog, "this$0");
            this.this$0 = contextChooseDialog;
        }

        @Override
        public boolean canShow(ContextChooseContent content, boolean isBestEffort) {
            Intrinsics.checkNotNullParameter(content, "content");
            CustomTabUtils customTabUtils = CustomTabUtils.INSTANCE;
            return CustomTabUtils.getChromePackage() != null;
        }

        @Override
        public AppCall createAppCall(ContextChooseContent content) {
            Intrinsics.checkNotNullParameter(content, "content");
            AppCall appCallCreateBaseAppCall = this.this$0.createBaseAppCall();
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            Bundle bundle = new Bundle();
            Bundle bundle2 = new Bundle();
            Bundle bundle3 = new Bundle();
            String applicationId = currentAccessToken == null ? null : currentAccessToken.getApplicationId();
            if (applicationId == null) {
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                applicationId = FacebookSdk.getApplicationId();
            }
            bundle.putString("app_id", applicationId);
            if (content.getMinSize() != null) {
                bundle3.putString("min_size", content.getMinSize().toString());
            }
            if (content.getMaxSize() != null) {
                bundle3.putString("max_size", content.getMaxSize().toString());
            }
            if (content.getFilters() != null) {
                bundle3.putString("filters", new JSONArray((Collection) content.getFilters()).toString());
            }
            bundle2.putString("filters", bundle3.toString());
            bundle.putString("payload", bundle2.toString());
            CustomTabUtils customTabUtils = CustomTabUtils.INSTANCE;
            bundle.putString(ServerProtocol.DIALOG_PARAM_REDIRECT_URI, CustomTabUtils.getDefaultRedirectURI());
            DialogPresenter dialogPresenter = DialogPresenter.INSTANCE;
            DialogPresenter.setupAppCallForCustomTabDialog(appCallCreateBaseAppCall, ContextChooseDialog.CONTEXT_CHOOSE_DIALOG, bundle);
            return appCallCreateBaseAppCall;
        }
    }
}
