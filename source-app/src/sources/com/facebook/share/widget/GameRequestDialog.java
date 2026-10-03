package com.facebook.share.widget;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import com.facebook.AccessToken;
import com.facebook.FacebookCallback;
import com.facebook.FacebookSdk;
import com.facebook.internal.AppCall;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.CustomTabUtils;
import com.facebook.internal.DialogPresenter;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.internal.FragmentWrapper;
import com.facebook.internal.ServerProtocol;
import com.facebook.internal.Validate;
import com.facebook.share.internal.GameRequestValidation;
import com.facebook.share.internal.ResultProcessor;
import com.facebook.share.internal.ShareConstants;
import com.facebook.share.internal.ShareInternalUtility;
import com.facebook.share.internal.WebDialogParameters;
import com.facebook.share.model.GameRequestContent;
import java.util.ArrayList;
import java.util.List;

@Deprecated
public class GameRequestDialog extends FacebookDialogBase<GameRequestContent, Result> {
    private static final int DEFAULT_REQUEST_CODE = CallbackManagerImpl.RequestCodeOffset.GameRequest.toRequestCode();
    private static final String GAME_REQUEST_DIALOG = "apprequests";

    public static boolean canShow() {
        return true;
    }

    public static final class Result {
        String requestId;

        List<String> f527to;

        private Result(Bundle results) {
            this.requestId = results.getString("request");
            this.f527to = new ArrayList();
            while (results.containsKey(String.format(ShareConstants.WEB_DIALOG_RESULT_PARAM_TO_ARRAY_MEMBER, Integer.valueOf(this.f527to.size())))) {
                List<String> list = this.f527to;
                list.add(results.getString(String.format(ShareConstants.WEB_DIALOG_RESULT_PARAM_TO_ARRAY_MEMBER, Integer.valueOf(list.size()))));
            }
        }

        public String getRequestId() {
            return this.requestId;
        }

        public List<String> getRequestRecipients() {
            return this.f527to;
        }
    }

    public static void show(final Activity activity, final GameRequestContent gameRequestContent) {
        new GameRequestDialog(activity).show(gameRequestContent);
    }

    public static void show(final Fragment fragment, final GameRequestContent gameRequestContent) {
        show(new FragmentWrapper(fragment), gameRequestContent);
    }

    public static void show(final android.app.Fragment fragment, final GameRequestContent gameRequestContent) {
        show(new FragmentWrapper(fragment), gameRequestContent);
    }

    private static void show(final FragmentWrapper fragmentWrapper, final GameRequestContent gameRequestContent) {
        new GameRequestDialog(fragmentWrapper).show(gameRequestContent);
    }

    public GameRequestDialog(Activity activity) {
        super(activity, DEFAULT_REQUEST_CODE);
    }

    public GameRequestDialog(Fragment fragment) {
        this(new FragmentWrapper(fragment));
    }

    public GameRequestDialog(android.app.Fragment fragment) {
        this(new FragmentWrapper(fragment));
    }

    private GameRequestDialog(FragmentWrapper fragmentWrapper) {
        super(fragmentWrapper, DEFAULT_REQUEST_CODE);
    }

    @Override
    protected void registerCallbackImpl(final CallbackManagerImpl callbackManager, final FacebookCallback<Result> callback) {
        final ResultProcessor resultProcessor = callback == null ? null : new ResultProcessor(callback) {
            @Override
            public void onSuccess(AppCall appCall, Bundle results) {
                if (results != null) {
                    callback.onSuccess(new Result(results));
                } else {
                    onCancel(appCall);
                }
            }
        };
        callbackManager.registerCallback(getRequestCodeField(), new CallbackManagerImpl.Callback() {
            @Override
            public boolean onActivityResult(int resultCode, Intent data) {
                return ShareInternalUtility.handleActivityResult(GameRequestDialog.this.getRequestCodeField(), resultCode, data, resultProcessor);
            }
        });
    }

    @Override
    protected AppCall createBaseAppCall() {
        return new AppCall(getRequestCodeField());
    }

    @Override
    protected List<FacebookDialogBase<GameRequestContent, Result>.ModeHandler> getOrderedModeHandlers() {
        ArrayList arrayList = new ArrayList();
        arrayList.add(new ChromeCustomTabHandler());
        arrayList.add(new WebHandler());
        return arrayList;
    }

    private class ChromeCustomTabHandler extends FacebookDialogBase<GameRequestContent, Result>.ModeHandler {
        private ChromeCustomTabHandler() {
            super(GameRequestDialog.this);
        }

        @Override
        public boolean canShow(final GameRequestContent content, boolean isBestEffort) {
            return CustomTabUtils.getChromePackage() != null && Validate.hasCustomTabRedirectActivity(GameRequestDialog.this.getActivityContext(), CustomTabUtils.getDefaultRedirectURI());
        }

        @Override
        public AppCall createAppCall(final GameRequestContent content) {
            GameRequestValidation.validate(content);
            AppCall appCallCreateBaseAppCall = GameRequestDialog.this.createBaseAppCall();
            Bundle bundleCreate = WebDialogParameters.create(content);
            AccessToken currentAccessToken = AccessToken.getCurrentAccessToken();
            if (currentAccessToken != null) {
                bundleCreate.putString("app_id", currentAccessToken.getApplicationId());
            } else {
                bundleCreate.putString("app_id", FacebookSdk.getApplicationId());
            }
            bundleCreate.putString(ServerProtocol.DIALOG_PARAM_REDIRECT_URI, CustomTabUtils.getDefaultRedirectURI());
            DialogPresenter.setupAppCallForCustomTabDialog(appCallCreateBaseAppCall, GameRequestDialog.GAME_REQUEST_DIALOG, bundleCreate);
            return appCallCreateBaseAppCall;
        }
    }

    private class WebHandler extends FacebookDialogBase<GameRequestContent, Result>.ModeHandler {
        @Override
        public boolean canShow(final GameRequestContent content, boolean isBestEffort) {
            return true;
        }

        private WebHandler() {
            super(GameRequestDialog.this);
        }

        @Override
        public AppCall createAppCall(final GameRequestContent content) {
            GameRequestValidation.validate(content);
            AppCall appCallCreateBaseAppCall = GameRequestDialog.this.createBaseAppCall();
            DialogPresenter.setupAppCallForWebDialog(appCallCreateBaseAppCall, GameRequestDialog.GAME_REQUEST_DIALOG, WebDialogParameters.create(content));
            return appCallCreateBaseAppCall;
        }
    }
}
