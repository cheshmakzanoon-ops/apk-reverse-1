package com.facebook.gamingservices;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.webkit.internal.AssetHelper;
import com.facebook.AccessToken;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.gamingservices.cloudgaming.CloudGameLoginHandler;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.internal.TournamentShareDialogURIBuilder;
import com.facebook.internal.AppCall;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.internal.FragmentWrapper;
import com.facebook.internal.NativeProtocol;
import com.facebook.share.internal.ResultProcessor;
import com.facebook.share.internal.ShareInternalUtility;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0004\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0000\n\u0002\b\u0005\b\u0007\u0018\u0000 /2\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u0002\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u0001:\u0004./01B\u000f\b\u0016\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006B\u000f\b\u0016\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tB\u000f\b\u0016\u0012\u0006\u0010\u0007\u001a\u00020\n¢\u0006\u0002\u0010\u000bB\u000f\b\u0012\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\b\u0010 \u001a\u00020!H\u0014J \u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020%2\u000e\u0010&\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030'H\u0014J\u0016\u0010(\u001a\u00020#2\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u001a\u001a\u00020\u001bJ\u0016\u0010(\u001a\u00020#2\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010)\u001a\u00020\u0002J\u001a\u0010*\u001a\u00020#2\b\u0010+\u001a\u0004\u0018\u00010\u00022\u0006\u0010,\u001a\u00020-H\u0014R.\u0010\u000f\u001a\u001c\u0012\u0018\u0012\u00160\u0011R\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u0002\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00010\u00108TX\u0094\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013R\u001c\u0010\u0014\u001a\u0004\u0018\u00010\u0015X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u001c\u0010\u001a\u001a\u0004\u0018\u00010\u001bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001f¨\u00062"}, d2 = {"Lcom/facebook/gamingservices/TournamentShareDialog;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/TournamentConfig;", "Lcom/facebook/gamingservices/TournamentShareDialog$Result;", "activity", "Landroid/app/Activity;", "(Landroid/app/Activity;)V", "fragment", "Landroidx/fragment/app/Fragment;", "(Landroidx/fragment/app/Fragment;)V", "Landroid/app/Fragment;", "(Landroid/app/Fragment;)V", "fragmentWrapper", "Lcom/facebook/internal/FragmentWrapper;", "(Lcom/facebook/internal/FragmentWrapper;)V", "orderedModeHandlers", "", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "getOrderedModeHandlers", "()Ljava/util/List;", "score", "", "getScore", "()Ljava/lang/Number;", "setScore", "(Ljava/lang/Number;)V", "tournament", "Lcom/facebook/gamingservices/Tournament;", "getTournament", "()Lcom/facebook/gamingservices/Tournament;", "setTournament", "(Lcom/facebook/gamingservices/Tournament;)V", "createBaseAppCall", "Lcom/facebook/internal/AppCall;", "registerCallbackImpl", "", "callbackManager", "Lcom/facebook/internal/CallbackManagerImpl;", "callback", "Lcom/facebook/FacebookCallback;", "show", "newTournamentConfig", "showImpl", "content", "mode", "", "AppSwitchHandler", "Companion", "FacebookAppHandler", "Result", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class TournamentShareDialog extends FacebookDialogBase<TournamentConfig, Result> {
    private static final int defaultRequestCode = CallbackManagerImpl.RequestCodeOffset.TournamentShareDialog.toRequestCode();
    private Number score;
    private Tournament tournament;

    public final Number getScore() {
        return this.score;
    }

    public final void setScore(Number number) {
        this.score = number;
    }

    public final Tournament getTournament() {
        return this.tournament;
    }

    public final void setTournament(Tournament tournament) {
        this.tournament = tournament;
    }

    public TournamentShareDialog(Activity activity) {
        super(activity, defaultRequestCode);
        Intrinsics.checkNotNullParameter(activity, "activity");
    }

    public TournamentShareDialog(Fragment fragment) {
        this(new FragmentWrapper(fragment));
        Intrinsics.checkNotNullParameter(fragment, "fragment");
    }

    public TournamentShareDialog(android.app.Fragment fragment) {
        this(new FragmentWrapper(fragment));
        Intrinsics.checkNotNullParameter(fragment, "fragment");
    }

    private TournamentShareDialog(FragmentWrapper fragmentWrapper) {
        super(fragmentWrapper, defaultRequestCode);
    }

    public final void show(Number score, TournamentConfig newTournamentConfig) {
        Intrinsics.checkNotNullParameter(score, "score");
        Intrinsics.checkNotNullParameter(newTournamentConfig, "newTournamentConfig");
        this.score = score;
        showImpl(newTournamentConfig, FacebookDialogBase.BASE_AUTOMATIC_MODE);
    }

    public final void show(Number score, Tournament tournament) {
        Intrinsics.checkNotNullParameter(score, "score");
        Intrinsics.checkNotNullParameter(tournament, "tournament");
        this.score = score;
        this.tournament = tournament;
        showImpl((TournamentConfig) null, FacebookDialogBase.BASE_AUTOMATIC_MODE);
    }

    @Override
    public void showImpl(TournamentConfig content, Object mode) {
        Intrinsics.checkNotNullParameter(mode, "mode");
        if (CloudGameLoginHandler.isRunningInCloud()) {
            return;
        }
        super.showImpl(content, mode);
    }

    @Override
    protected void registerCallbackImpl(CallbackManagerImpl callbackManager, final FacebookCallback<Result> callback) {
        Intrinsics.checkNotNullParameter(callbackManager, "callbackManager");
        Intrinsics.checkNotNullParameter(callback, "callback");
        final ResultProcessor resultProcessor = new ResultProcessor(callback) {
            final FacebookCallback<TournamentShareDialog.Result> $callback;

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
                    } else if (results.getString(SDKConstants.PARAM_TOURNAMENTS_ID) != null) {
                        this.$callback.onSuccess(new TournamentShareDialog.Result(results));
                        return;
                    }
                }
                onCancel(appCall);
            }
        };
        callbackManager.registerCallback(getRequestCodeField(), new CallbackManagerImpl.Callback() {
            @Override
            public final boolean onActivityResult(int i, Intent intent) {
                return TournamentShareDialog.m2482registerCallbackImpl$lambda0(this.f$0, resultProcessor, i, intent);
            }
        });
    }

    public static final boolean m2482registerCallbackImpl$lambda0(TournamentShareDialog tournamentShareDialog, ResultProcessor resultProcessor, int i, Intent intent) {
        Intrinsics.checkNotNullParameter(tournamentShareDialog, "this$0");
        ShareInternalUtility shareInternalUtility = ShareInternalUtility.INSTANCE;
        return ShareInternalUtility.handleActivityResult(tournamentShareDialog.getRequestCodeField(), i, intent, resultProcessor);
    }

    @Override
    protected List<FacebookDialogBase<TournamentConfig, Result>.ModeHandler> getOrderedModeHandlers() {
        ArrayList arrayList = new ArrayList();
        arrayList.add(new FacebookAppHandler(this));
        arrayList.add(new AppSwitchHandler(this));
        return arrayList;
    }

    @Override
    protected AppCall createBaseAppCall() {
        return new AppCall(getRequestCodeField(), null, 2, null);
    }

    @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\b\u0018\u00002\u00020\u0001B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u001c\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u001c\u0010\u000b\u001a\u0004\u0018\u00010\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\b\"\u0004\b\r\u0010\n¨\u0006\u000e"}, d2 = {"Lcom/facebook/gamingservices/TournamentShareDialog$Result;", "", "results", "Landroid/os/Bundle;", "(Landroid/os/Bundle;)V", SDKConstants.REQUEST_ID, "", "getRequestID", "()Ljava/lang/String;", "setRequestID", "(Ljava/lang/String;)V", "tournamentID", "getTournamentID", "setTournamentID", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Result {
        private String requestID;
        private String tournamentID;

        public final String getRequestID() {
            return this.requestID;
        }

        public final void setRequestID(String str) {
            this.requestID = str;
        }

        public final String getTournamentID() {
            return this.tournamentID;
        }

        public final void setTournamentID(String str) {
            this.tournamentID = str;
        }

        public Result(Bundle bundle) {
            Intrinsics.checkNotNullParameter(bundle, "results");
            if (bundle.getString("request") != null) {
                this.requestID = bundle.getString("request");
            }
            this.tournamentID = bundle.getString(SDKConstants.PARAM_TOURNAMENTS_ID);
        }
    }

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00160\u0001R\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0002B\u0005¢\u0006\u0002\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u00032\u0006\u0010\t\u001a\u00020\u0007H\u0016J\u0012\u0010\n\u001a\u00020\u000b2\b\u0010\b\u001a\u0004\u0018\u00010\u0003H\u0016¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/TournamentShareDialog$FacebookAppHandler;", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/TournamentConfig;", "Lcom/facebook/gamingservices/TournamentShareDialog$Result;", "(Lcom/facebook/gamingservices/TournamentShareDialog;)V", "canShow", "", "content", "isBestEffort", "createAppCall", "Lcom/facebook/internal/AppCall;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private final class FacebookAppHandler extends FacebookDialogBase<TournamentConfig, Result>.ModeHandler {
        final TournamentShareDialog this$0;

        public FacebookAppHandler(TournamentShareDialog tournamentShareDialog) {
            super(tournamentShareDialog);
            Intrinsics.checkNotNullParameter(tournamentShareDialog, "this$0");
            this.this$0 = tournamentShareDialog;
        }

        @Override
        public boolean canShow(TournamentConfig content, boolean isBestEffort) {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            PackageManager packageManager = FacebookSdk.getApplicationContext().getPackageManager();
            Intrinsics.checkNotNullExpressionValue(packageManager, "getApplicationContext().packageManager");
            Intent intent = new Intent("com.facebook.games.gaming_services.DEEPLINK");
            intent.setType(AssetHelper.DEFAULT_MIME_TYPE);
            return intent.resolveActivity(packageManager) != null;
        }

        @Override
        public AppCall createAppCall(TournamentConfig content) {
            Bundle bundleBundleForUpdating$facebook_gamingservices_release;
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            AppCall appCallCreateBaseAppCall = this.this$0.createBaseAppCall();
            Intent intent = new Intent("com.facebook.games.gaming_services.DEEPLINK");
            intent.setType(AssetHelper.DEFAULT_MIME_TYPE);
            if (currentAccessToken == null || currentAccessToken.isExpired()) {
                throw new FacebookException("Attempted to share tournament with an invalid access token");
            }
            if (currentAccessToken.getGraphDomain() != null && !Intrinsics.areEqual(FacebookSdk.GAMING, currentAccessToken.getGraphDomain())) {
                throw new FacebookException("Attempted to share tournament while user is not gaming logged in");
            }
            String applicationId = currentAccessToken.getApplicationId();
            Number score = this.this$0.getScore();
            if (score == null) {
                throw new FacebookException("Attempted to share tournament without a score");
            }
            if (content != null) {
                bundleBundleForUpdating$facebook_gamingservices_release = TournamentShareDialogURIBuilder.INSTANCE.bundleForCreating$facebook_gamingservices_release(content, score, applicationId);
            } else {
                Tournament tournament = this.this$0.getTournament();
                bundleBundleForUpdating$facebook_gamingservices_release = tournament == null ? null : TournamentShareDialogURIBuilder.INSTANCE.bundleForUpdating$facebook_gamingservices_release(tournament.identifier, score, applicationId);
            }
            NativeProtocol nativeProtocol = NativeProtocol.INSTANCE;
            NativeProtocol.setupProtocolRequestIntent(intent, appCallCreateBaseAppCall.getCallId().toString(), "", NativeProtocol.PROTOCOL_VERSION_20210906, bundleBundleForUpdating$facebook_gamingservices_release);
            appCallCreateBaseAppCall.setRequestIntent(intent);
            return appCallCreateBaseAppCall;
        }
    }

    @Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00160\u0001R\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u0003\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0002B\u0005¢\u0006\u0002\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u00032\u0006\u0010\t\u001a\u00020\u0007H\u0016J\u0012\u0010\n\u001a\u00020\u000b2\b\u0010\b\u001a\u0004\u0018\u00010\u0003H\u0016¨\u0006\f"}, d2 = {"Lcom/facebook/gamingservices/TournamentShareDialog$AppSwitchHandler;", "Lcom/facebook/internal/FacebookDialogBase$ModeHandler;", "Lcom/facebook/internal/FacebookDialogBase;", "Lcom/facebook/gamingservices/TournamentConfig;", "Lcom/facebook/gamingservices/TournamentShareDialog$Result;", "(Lcom/facebook/gamingservices/TournamentShareDialog;)V", "canShow", "", "content", "isBestEffort", "createAppCall", "Lcom/facebook/internal/AppCall;", "facebook-gamingservices_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private final class AppSwitchHandler extends FacebookDialogBase<TournamentConfig, Result>.ModeHandler {
        final TournamentShareDialog this$0;

        @Override
        public boolean canShow(TournamentConfig content, boolean isBestEffort) {
            return true;
        }

        public AppSwitchHandler(TournamentShareDialog tournamentShareDialog) {
            super(tournamentShareDialog);
            Intrinsics.checkNotNullParameter(tournamentShareDialog, "this$0");
            this.this$0 = tournamentShareDialog;
        }

        @Override
        public AppCall createAppCall(TournamentConfig content) {
            Uri uriUriForUpdating$facebook_gamingservices_release;
            AppCall appCallCreateBaseAppCall = this.this$0.createBaseAppCall();
            AccessToken currentAccessToken = AccessToken.INSTANCE.getCurrentAccessToken();
            if (currentAccessToken == null || currentAccessToken.isExpired()) {
                throw new FacebookException("Attempted to share tournament with an invalid access token");
            }
            if (currentAccessToken.getGraphDomain() != null && !Intrinsics.areEqual(FacebookSdk.GAMING, currentAccessToken.getGraphDomain())) {
                throw new FacebookException("Attempted to share tournament without without gaming login");
            }
            Number score = this.this$0.getScore();
            if (score == null) {
                throw new FacebookException("Attempted to share tournament without a score");
            }
            if (content != null) {
                uriUriForUpdating$facebook_gamingservices_release = TournamentShareDialogURIBuilder.INSTANCE.uriForCreating$facebook_gamingservices_release(content, score, currentAccessToken.getApplicationId());
            } else {
                Tournament tournament = this.this$0.getTournament();
                uriUriForUpdating$facebook_gamingservices_release = tournament == null ? null : TournamentShareDialogURIBuilder.INSTANCE.uriForUpdating$facebook_gamingservices_release(tournament.identifier, score, currentAccessToken.getApplicationId());
            }
            Intent intent = new Intent("android.intent.action.VIEW", uriUriForUpdating$facebook_gamingservices_release);
            TournamentShareDialog tournamentShareDialog = this.this$0;
            tournamentShareDialog.startActivityForResult(intent, tournamentShareDialog.getRequestCodeField());
            return appCallCreateBaseAppCall;
        }
    }
}
