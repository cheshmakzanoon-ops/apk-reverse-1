package com.facebook.share.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import com.facebook.CallbackManager;
import com.facebook.FacebookButtonBase;
import com.facebook.FacebookCallback;
import com.facebook.FacebookSdk;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import com.facebook.share.Sharer;
import com.facebook.share.internal.ShareInternalUtility;
import com.facebook.share.model.ShareContent;

public abstract class ShareButtonBase extends FacebookButtonBase {
    private CallbackManager callbackManager;
    private boolean enabledExplicitlySet;
    private int requestCode;
    private ShareContent shareContent;

    protected abstract ShareDialog getDialog();

    protected ShareButtonBase(final Context context, final AttributeSet attrs, final int defStyleAttr, final String analyticsButtonCreatedEventName, final String analyticsButtonTappedEventName) {
        super(context, attrs, defStyleAttr, 0, analyticsButtonCreatedEventName, analyticsButtonTappedEventName);
        this.requestCode = 0;
        this.enabledExplicitlySet = false;
        this.requestCode = isInEditMode() ? 0 : getDefaultRequestCode();
        internalSetEnabled(false);
    }

    public ShareContent getShareContent() {
        return this.shareContent;
    }

    public void setShareContent(final ShareContent shareContent) {
        this.shareContent = shareContent;
        if (this.enabledExplicitlySet) {
            return;
        }
        internalSetEnabled(canShare());
    }

    @Override
    public void setEnabled(boolean enabled) {
        super.setEnabled(enabled);
        this.enabledExplicitlySet = true;
    }

    @Override
    public int getRequestCode() {
        return this.requestCode;
    }

    protected void setRequestCode(final int requestCode) {
        if (FacebookSdk.isFacebookRequestCode(requestCode)) {
            throw new IllegalArgumentException("Request code " + requestCode + " cannot be within the range reserved by the Facebook SDK.");
        }
        this.requestCode = requestCode;
    }

    public void registerCallback(final CallbackManager callbackManager, final FacebookCallback<Sharer.Result> callback) {
        memorizeCallbackManager(callbackManager);
        ShareInternalUtility.registerSharerCallback(getRequestCode(), callbackManager, callback);
    }

    public void registerCallback(final CallbackManager callbackManager, final FacebookCallback<Sharer.Result> callback, final int requestCode) {
        setRequestCode(requestCode);
        registerCallback(callbackManager, callback);
    }

    @Override
    protected void configureButton(final Context context, final AttributeSet attrs, final int defStyleAttr, final int defStyleRes) {
        super.configureButton(context, attrs, defStyleAttr, defStyleRes);
        setInternalOnClickListener(getShareOnClickListener());
    }

    protected boolean canShare() {
        return getDialog().canShow(getShareContent());
    }

    protected View.OnClickListener getShareOnClickListener() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (CrashShieldHandler.isObjectCrashing(this)) {
                    return;
                }
                try {
                    ShareButtonBase.this.callExternalOnClickListener(v);
                    ShareButtonBase.this.getDialog().show(ShareButtonBase.this.getShareContent());
                } catch (Throwable th) {
                    CrashShieldHandler.handleThrowable(th, this);
                }
            }
        };
    }

    private void internalSetEnabled(boolean enabled) {
        setEnabled(enabled);
        this.enabledExplicitlySet = false;
    }

    private void memorizeCallbackManager(CallbackManager callbackManager) {
        CallbackManager callbackManager2 = this.callbackManager;
        if (callbackManager2 == null) {
            this.callbackManager = callbackManager;
        } else if (callbackManager2 != callbackManager) {
            Log.w(ShareButtonBase.class.toString(), "You're registering a callback on a Facebook Share Button with two different callback managers. It's almost wrong and may cause unexpected results. Only the first callback manager will be used for handling activity result with androidx.");
        }
    }

    protected CallbackManager getCallbackManager() {
        return this.callbackManager;
    }
}
