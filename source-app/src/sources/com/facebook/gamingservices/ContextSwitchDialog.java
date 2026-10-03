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
import com.facebook.gamingservices.model.ContextSwitchContent;
import com.facebook.internal.AppCall;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.DialogPresenter;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.internal.FragmentWrapper;
import com.facebook.internal.NativeProtocol;
import com.facebook.share.internal.ResultProcessor;
import com.facebook.share.internal.ShareInternalUtility;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0005\u0018\u0000 #2\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001:\u0004#$%&B\u000f\b\u0016\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006B\u000f\b\u0016\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tB\u000f\b\u0016\u0012\u0006\u0010\u0007\u001a\u00020\n¢\u0006\u0002\u0010\u000bB\u000f\b\u0012\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\u0010\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0002H\u0016J\b\u0010\u0019\u001a\u00020\u001aH\u0014J\u001e\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00030\u0010H\u0014J\u0010\u0010\u001f\u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u0002H\u0002J\u0018\u0010 \u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u00022\u0006\u0010!\u001a\u00020\"H\u0014R\u0016\u0010\u000f\u001a\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0010X\u0082\u000e¢\u0006\u0002\n\u0000R*\u0010\u0011\u001a\u0018\u0012\u0014\u0012\u00120\u0013R\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u00010\u00128TX\u0094\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0015¨\u0006'"}, d2 = {"Lcom/facebook/gamingservices/ContextSwitchDialog;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/model/ContextSwitchContent;", "Lcom/facebook/gamingservices/ContextSwitchDialog$Result;", "activity", "Landroid/app/Activity;", "(Landroid/app/Activity;)V", "fragment", "Landroidx/fragment/app/Fragment;", "(Landroidx/fragment/app/Fragment;)V", "Landroid/app/Fragment;", "(Landroid/app/Fragment;)V", "fragmentWrapper", "Lcom/facebook/internal/FragmentWrapper;", "(Lcom/facebook/internal/FragmentWrapper;)V", "callback", "Lcom/facebook/FacebookCallback;", "orderedModeHandlers", "", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "getOrderedModeHandlers", "()Ljava/util/List;", "canShow", "", "content", "createBaseAppCall", "Lcom/facebook/internal/AppCall;", "registerCallbackImpl", "", "callbackManager", "Lcom/facebook/internal/CallbackManagerImpl;", "showForCloud", "showImpl", "mode", "", "Companion", "FacebookAppHandler", "Result", "WebHandler", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ContextSwitchDialog extends FacebookDialogBase<ContextSwitchContent, Result> {
    private static final int DEFAULT_REQUEST_CODE = CallbackManagerImpl.RequestCodeOffset.GamingContextSwitch.toRequestCode();
    private FacebookCallback<Result> callback;

    public ContextSwitchDialog(Activity activity) {
        super(activity, DEFAULT_REQUEST_CODE);
        Intrinsics.checkNotNullParameter(activity, "activity");
    }

    public ContextSwitchDialog(Fragment fragment) {
        this(new FragmentWrapper(fragment));
        Intrinsics.checkNotNullParameter(fragment, "fragment");
    }

    public ContextSwitchDialog(android.app.Fragment fragment) {
        this(new FragmentWrapper(fragment));
        Intrinsics.checkNotNullParameter(fragment, "fragment");
    }

    private ContextSwitchDialog(FragmentWrapper fragmentWrapper) {
        super(fragmentWrapper, DEFAULT_REQUEST_CODE);
    }

    @Override
    public boolean canShow(ContextSwitchContent content) {
        Intrinsics.checkNotNullParameter(content, "content");
        return CloudGameLoginHandler.isRunningInCloud() || new FacebookAppHandler(this).canShow(content, true) || new WebHandler(this).canShow(content, true);
    }

    @Override
    public void showImpl(ContextSwitchContent content, Object mode) {
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(mode, "mode");
        if (CloudGameLoginHandler.isRunningInCloud()) {
            showForCloud(content);
        } else {
            super.showImpl(content, mode);
        }
    }

    private final void showForCloud(ContextSwitchContent content) {
        AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
        if (currentAccessToken == null || currentAccessToken.isExpired()) {
            throw new FacebookException("Attempted to open ContextSwitchContent with an invalid access token");
        }
        DaemonRequest.Callback callback = new DaemonRequest.Callback() {
            @Override
            public final void onCompleted(GraphResponse graphResponse) {
                ContextSwitchDialog.m2479showForCloud$lambda2(this.f$0, graphResponse);
            }
        };
        String contextID = content.getContextID();
        if (contextID == null) {
            FacebookCallback<Result> facebookCallback = this.callback;
            if (facebookCallback == null) {
                return;
            }
            facebookCallback.onError(new FacebookException("Required string contextID not provided."));
            return;
        }
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("id", contextID);
            DaemonRequest.executeAsync(getActivityContext(), jSONObject, callback, SDKMessageEnum.CONTEXT_SWITCH);
        } catch (JSONException unused) {
            FacebookCallback<Result> facebookCallback2 = this.callback;
            if (facebookCallback2 == null) {
                return;
            }
            facebookCallback2.onError(new FacebookException("Couldn't prepare Context Switch Dialog"));
        }
    }

    public static final void m2479showForCloud$lambda2(ContextSwitchDialog contextSwitchDialog, GraphResponse graphResponse) {
        Unit unit;
        Intrinsics.checkNotNullParameter(contextSwitchDialog, "this$0");
        FacebookCallback<Result> facebookCallback = contextSwitchDialog.callback;
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
        final ResultProcessor resultProcessor = new ResultProcessor(callback) {
            final FacebookCallback<ContextSwitchDialog.Result> $callback;

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
                    String string2 = results.getString(SDKConstants.PARAM_CONTEXT_CONTEXT_ID);
                    if (string != null) {
                        GamingContext.INSTANCE.setCurrentGamingContext(new GamingContext(string));
                        this.$callback.onSuccess(new ContextSwitchDialog.Result(string));
                    } else if (string2 != null) {
                        GamingContext.INSTANCE.setCurrentGamingContext(new GamingContext(string2));
                        this.$callback.onSuccess(new ContextSwitchDialog.Result(string2));
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
                return ContextSwitchDialog.m2478registerCallbackImpl$lambda3(this.f$0, resultProcessor, i, intent);
            }
        });
    }

    public static final boolean m2478registerCallbackImpl$lambda3(ContextSwitchDialog contextSwitchDialog, ResultProcessor resultProcessor, int i, Intent intent) {
        Intrinsics.checkNotNullParameter(contextSwitchDialog, "this$0");
        Intrinsics.checkNotNullParameter(resultProcessor, "$resultProcessor");
        ShareInternalUtility shareInternalUtility = ShareInternalUtility.INSTANCE;
        return ShareInternalUtility.handleActivityResult(contextSwitchDialog.getRequestCodeField(), i, intent, resultProcessor);
    }

    @Override
    protected List<FacebookDialogBase<ContextSwitchContent, Result>.ModeHandler> getOrderedModeHandlers() {
        return CollectionsKt.listOf(new FacebookDialogBase.ModeHandler[]{new FacebookAppHandler(this), new WebHandler(this)});
    }

    @Override
    protected AppCall createBaseAppCall() {
        return new AppCall(getRequestCodeField(), null, 2, null);
    }

    @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0010\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007R\u001c\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u0004¨\u0006\u000b"}, d2 = {"Lcom/facebook/gamingservices/ContextSwitchDialog$Result;", "", "contextID", "", "(Ljava/lang/String;)V", "response", "Lcom/facebook/GraphResponse;", "(Lcom/facebook/GraphResponse;)V", "getContextID", "()Ljava/lang/String;", "setContextID", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Result {
        private String contextID;

        public final String getContextID() {
            return this.contextID;
        }

        public final void setContextID(String str) {
            this.contextID = str;
        }

        public Result(String str) {
            Intrinsics.checkNotNullParameter(str, "contextID");
            this.contextID = str;
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

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00120\u0001R\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0002B\u0005¢\u0006\u0002\u0010\u0005J\u0018\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\u0007H\u0016J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\b\u001a\u00020\u0003H\u0016¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/ContextSwitchDialog$WebHandler;", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/model/ContextSwitchContent;", "Lcom/facebook/gamingservices/ContextSwitchDialog$Result;", "(Lcom/facebook/gamingservices/ContextSwitchDialog;)V", "canShow", "", "content", "isBestEffort", "createAppCall", "Lcom/facebook/internal/AppCall;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private final class WebHandler extends FacebookDialogBase<ContextSwitchContent, Result>.ModeHandler {
        final ContextSwitchDialog this$0;

        @Override
        public boolean canShow(ContextSwitchContent content, boolean isBestEffort) {
            Intrinsics.checkNotNullParameter(content, "content");
            return true;
        }

        public WebHandler(ContextSwitchDialog contextSwitchDialog) {
            super(contextSwitchDialog);
            Intrinsics.checkNotNullParameter(contextSwitchDialog, "this$0");
            this.this$0 = contextSwitchDialog;
        }

        @Override
        public AppCall createAppCall(ContextSwitchContent content) {
            Intrinsics.checkNotNullParameter(content, "content");
            AppCall appCallCreateBaseAppCall = this.this$0.createBaseAppCall();
            Bundle bundle = new Bundle();
            bundle.putString(SDKConstants.PARAM_CONTEXT_CONTEXT_ID, content.getContextID());
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            if (currentAccessToken != null) {
                bundle.putString("dialog_access_token", currentAccessToken.getToken());
            }
            DialogPresenter dialogPresenter = DialogPresenter.INSTANCE;
            DialogPresenter.setupAppCallForWebDialog(appCallCreateBaseAppCall, "context", bundle);
            return appCallCreateBaseAppCall;
        }
    }

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00120\u0001R\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00040\u0002B\u0005¢\u0006\u0002\u0010\u0005J\u0018\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\u0007H\u0016J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\b\u001a\u00020\u0003H\u0016¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/ContextSwitchDialog$FacebookAppHandler;", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/model/ContextSwitchContent;", "Lcom/facebook/gamingservices/ContextSwitchDialog$Result;", "(Lcom/facebook/gamingservices/ContextSwitchDialog;)V", "canShow", "", "content", "isBestEffort", "createAppCall", "Lcom/facebook/internal/AppCall;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private final class FacebookAppHandler extends FacebookDialogBase<ContextSwitchContent, Result>.ModeHandler {
        final ContextSwitchDialog this$0;

        public FacebookAppHandler(ContextSwitchDialog contextSwitchDialog) {
            super(contextSwitchDialog);
            Intrinsics.checkNotNullParameter(contextSwitchDialog, "this$0");
            this.this$0 = contextSwitchDialog;
        }

        @Override
        public boolean canShow(ContextSwitchContent content, boolean isBestEffort) {
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
        public AppCall createAppCall(ContextSwitchContent content) {
            Intrinsics.checkNotNullParameter(content, "content");
            AppCall appCallCreateBaseAppCall = this.this$0.createBaseAppCall();
            Intent intent = new Intent("com.facebook.games.gaming_services.DEEPLINK");
            intent.setType(AssetHelper.DEFAULT_MIME_TYPE);
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            Bundle bundle = new Bundle();
            bundle.putString(SDKConstants.PARAM_TOURNAMENTS_DEEPLINK, "CONTEXT_SWITCH");
            if (currentAccessToken != null) {
                bundle.putString("game_id", currentAccessToken.getApplicationId());
            } else {
                FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
                bundle.putString("game_id", FacebookSdk.getApplicationId());
            }
            if (content.getContextID() != null) {
                bundle.putString("context_token_id", content.getContextID());
            }
            NativeProtocol nativeProtocol = NativeProtocol.INSTANCE;
            String string = appCallCreateBaseAppCall.getCallId().toString();
            NativeProtocol nativeProtocol2 = NativeProtocol.INSTANCE;
            NativeProtocol.setupProtocolRequestIntent(intent, string, "", NativeProtocol.getLatestKnownVersion(), bundle);
            appCallCreateBaseAppCall.setRequestIntent(intent);
            return appCallCreateBaseAppCall;
        }
    }
}
