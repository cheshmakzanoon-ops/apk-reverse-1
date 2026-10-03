package com.facebook.gamingservices;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.net.Uri;
import com.facebook.AccessToken;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.GraphResponse;
import com.facebook.gamingservices.cloudgaming.CloudGameLoginHandler;
import com.facebook.gamingservices.cloudgaming.DaemonRequest;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKMessageEnum;
import com.facebook.internal.AppCall;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.internal.FragmentWrapper;
import java.util.List;
import org.json.JSONException;
import org.json.JSONObject;

public class FriendFinderDialog extends FacebookDialogBase<Void, Result> {
    private static final int DEFAULT_REQUEST_CODE = CallbackManagerImpl.RequestCodeOffset.GamingFriendFinder.toRequestCode();
    private FacebookCallback mCallback;

    public static class Result {
    }

    @Override
    protected AppCall createBaseAppCall() {
        return null;
    }

    @Override
    protected List<FacebookDialogBase<Void, Result>.ModeHandler> getOrderedModeHandlers() {
        return null;
    }

    public FriendFinderDialog(final Activity activity) {
        super(activity, DEFAULT_REQUEST_CODE);
    }

    public FriendFinderDialog(final Fragment fragment) {
        super(new FragmentWrapper(fragment), DEFAULT_REQUEST_CODE);
    }

    public FriendFinderDialog(final androidx.fragment.app.Fragment fragment) {
        super(new FragmentWrapper(fragment), DEFAULT_REQUEST_CODE);
    }

    public void show() {
        showImpl();
    }

    @Override
    public void show(final Void content) {
        showImpl();
    }

    protected void showImpl() {
        AccessToken currentAccessToken = AccessToken.getCurrentAccessToken();
        if (currentAccessToken == null || currentAccessToken.isExpired()) {
            throw new FacebookException("Attempted to open GamingServices FriendFinder with an invalid access token");
        }
        String applicationId = currentAccessToken.getApplicationId();
        if (CloudGameLoginHandler.isRunningInCloud()) {
            Activity activityContext = getActivityContext();
            DaemonRequest.Callback callback = new DaemonRequest.Callback() {
                @Override
                public void onCompleted(GraphResponse response) {
                    if (FriendFinderDialog.this.mCallback != null) {
                        if (response.getError() != null) {
                            FriendFinderDialog.this.mCallback.onError(new FacebookException(response.getError().getErrorMessage()));
                        } else {
                            FriendFinderDialog.this.mCallback.onSuccess(new Result());
                        }
                    }
                }
            };
            JSONObject jSONObject = new JSONObject();
            try {
                jSONObject.put("id", applicationId);
                jSONObject.put(SDKConstants.PARAM_DEEP_LINK, "FRIEND_FINDER");
                DaemonRequest.executeAsync(activityContext, jSONObject, callback, SDKMessageEnum.OPEN_GAMING_SERVICES_DEEP_LINK);
                return;
            } catch (JSONException unused) {
                FacebookCallback facebookCallback = this.mCallback;
                if (facebookCallback != null) {
                    facebookCallback.onError(new FacebookException("Couldn't prepare Friend Finder Dialog"));
                    return;
                }
                return;
            }
        }
        startActivityForResult(new Intent("android.intent.action.VIEW", Uri.parse("https://fb.gg/me/friendfinder/" + applicationId)), getRequestCodeField());
    }

    @Override
    protected void registerCallbackImpl(final CallbackManagerImpl callbackManager, final FacebookCallback<Result> callback) {
        this.mCallback = callback;
        callbackManager.registerCallback(getRequestCodeField(), new CallbackManagerImpl.Callback() {
            @Override
            public boolean onActivityResult(int resultCode, Intent data) {
                if (data != null && data.hasExtra("error")) {
                    callback.onError(((FacebookRequestError) data.getParcelableExtra("error")).getException());
                    return true;
                }
                callback.onSuccess(new Result());
                return true;
            }
        });
    }
}
