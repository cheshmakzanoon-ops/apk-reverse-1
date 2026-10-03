package com.facebook.share.widget;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import com.facebook.FacebookCallback;
import com.facebook.appevents.InternalAppEventsLogger;
import com.facebook.internal.AnalyticsEvents;
import com.facebook.internal.AppCall;
import com.facebook.internal.CallbackManagerImpl;
import com.facebook.internal.DialogFeature;
import com.facebook.internal.DialogPresenter;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.internal.FragmentWrapper;
import com.facebook.share.Sharer;
import com.facebook.share.internal.LegacyNativeDialogParameters;
import com.facebook.share.internal.MessageDialogFeature;
import com.facebook.share.internal.NativeDialogParameters;
import com.facebook.share.internal.ShareContentValidation;
import com.facebook.share.internal.ShareInternalUtility;
import com.facebook.share.model.ShareContent;
import com.facebook.share.model.ShareLinkContent;
import java.util.ArrayList;
import java.util.List;

public final class MessageDialog extends ShareDialog implements Sharer {
    private static final int DEFAULT_REQUEST_CODE = CallbackManagerImpl.RequestCodeOffset.Message.toRequestCode();
    private boolean shouldFailOnDataError;

    public static void show(final Activity activity, final ShareContent shareContent) {
        new MessageDialog(activity).show(shareContent);
    }

    public static void show(final Fragment fragment, final ShareContent shareContent) {
        show(new FragmentWrapper(fragment), shareContent);
    }

    public static void show(final android.app.Fragment fragment, final ShareContent shareContent) {
        show(new FragmentWrapper(fragment), shareContent);
    }

    private static void show(final FragmentWrapper fragmentWrapper, final ShareContent shareContent) {
        new MessageDialog(fragmentWrapper).show(shareContent);
    }

    public static boolean canShow(Class<? extends ShareContent<?, ?>> contentType) {
        DialogFeature feature = getFeature(contentType);
        return feature != null && DialogPresenter.canPresentNativeDialogWithFeature(feature);
    }

    public MessageDialog(Activity activity) {
        int i = DEFAULT_REQUEST_CODE;
        super(activity, i);
        this.shouldFailOnDataError = false;
        ShareInternalUtility.registerStaticShareCallback(i);
    }

    public MessageDialog(Fragment fragment) {
        this(new FragmentWrapper(fragment));
    }

    public MessageDialog(android.app.Fragment fragment) {
        this(new FragmentWrapper(fragment));
    }

    private MessageDialog(FragmentWrapper fragmentWrapper) {
        int i = DEFAULT_REQUEST_CODE;
        super(fragmentWrapper, i);
        this.shouldFailOnDataError = false;
        ShareInternalUtility.registerStaticShareCallback(i);
    }

    MessageDialog(Activity activity, int requestCode) {
        super(activity, requestCode);
        this.shouldFailOnDataError = false;
        ShareInternalUtility.registerStaticShareCallback(requestCode);
    }

    MessageDialog(Fragment fragment, int requestCode) {
        this(new FragmentWrapper(fragment), requestCode);
    }

    MessageDialog(android.app.Fragment fragment, int requestCode) {
        this(new FragmentWrapper(fragment), requestCode);
    }

    private MessageDialog(FragmentWrapper fragmentWrapper, int requestCode) {
        super(fragmentWrapper, requestCode);
        this.shouldFailOnDataError = false;
        ShareInternalUtility.registerStaticShareCallback(requestCode);
    }

    @Override
    protected void registerCallbackImpl(final CallbackManagerImpl callbackManager, final FacebookCallback<Sharer.Result> callback) {
        ShareInternalUtility.registerSharerCallback(getRequestCodeField(), callbackManager, callback);
    }

    @Override
    public boolean getShouldFailOnDataError() {
        return this.shouldFailOnDataError;
    }

    @Override
    public void setShouldFailOnDataError(boolean shouldFailOnDataError) {
        this.shouldFailOnDataError = shouldFailOnDataError;
    }

    @Override
    protected AppCall createBaseAppCall() {
        return new AppCall(getRequestCodeField());
    }

    @Override
    protected List<FacebookDialogBase<ShareContent<?, ?>, Sharer.Result>.ModeHandler> getOrderedModeHandlers() {
        ArrayList arrayList = new ArrayList();
        arrayList.add(new NativeHandler());
        return arrayList;
    }

    private class NativeHandler extends FacebookDialogBase<ShareContent<?, ?>, Sharer.Result>.ModeHandler {
        private NativeHandler() {
            super(MessageDialog.this);
        }

        @Override
        public boolean canShow(final ShareContent<?, ?> shareContent, boolean isBestEffort) {
            return canShow2((ShareContent) shareContent, isBestEffort);
        }

        @Override
        public AppCall createAppCall(final ShareContent<?, ?> content) {
            return createAppCall2((ShareContent) content);
        }

        public boolean canShow2(final ShareContent shareContent, boolean isBestEffort) {
            return shareContent != null && MessageDialog.canShow((Class<? extends ShareContent<?, ?>>) shareContent.getClass());
        }

        public AppCall createAppCall2(final ShareContent content) {
            ShareContentValidation.validateForMessage(content);
            final AppCall appCallCreateBaseAppCall = MessageDialog.this.createBaseAppCall();
            final boolean shouldFailOnDataError = MessageDialog.this.getShouldFailOnDataError();
            MessageDialog.logDialogShare(MessageDialog.this.getActivityContext(), content, appCallCreateBaseAppCall);
            DialogPresenter.setupAppCallForNativeDialog(appCallCreateBaseAppCall, new DialogPresenter.ParameterProvider() {
                @Override
                public Bundle getParameters() {
                    return NativeDialogParameters.create(appCallCreateBaseAppCall.getCallId(), (ShareContent<?, ?>) content, shouldFailOnDataError);
                }

                @Override
                public Bundle getLegacyParameters() {
                    return LegacyNativeDialogParameters.create(appCallCreateBaseAppCall.getCallId(), (ShareContent<?, ?>) content, shouldFailOnDataError);
                }
            }, MessageDialog.getFeature(content.getClass()));
            return appCallCreateBaseAppCall;
        }
    }

    public static DialogFeature getFeature(Class<? extends ShareContent> type) {
        if (ShareLinkContent.class.isAssignableFrom(type)) {
            return MessageDialogFeature.MESSAGE_DIALOG;
        }
        return null;
    }

    public static void logDialogShare(Context context, ShareContent content, AppCall appCall) {
        String str;
        DialogFeature feature = getFeature(content.getClass());
        if (feature == MessageDialogFeature.MESSAGE_DIALOG) {
            str = "status";
        } else if (feature == MessageDialogFeature.MESSENGER_GENERIC_TEMPLATE) {
            str = AnalyticsEvents.PARAMETER_SHARE_MESSENGER_GENERIC_TEMPLATE;
        } else if (feature == MessageDialogFeature.MESSENGER_MEDIA_TEMPLATE) {
            str = AnalyticsEvents.PARAMETER_SHARE_MESSENGER_MEDIA_TEMPLATE;
        } else {
            str = "unknown";
        }
        InternalAppEventsLogger internalAppEventsLogger = new InternalAppEventsLogger(context);
        Bundle bundle = new Bundle();
        bundle.putString(AnalyticsEvents.PARAMETER_SHARE_DIALOG_CONTENT_TYPE, str);
        bundle.putString(AnalyticsEvents.PARAMETER_SHARE_DIALOG_CONTENT_UUID, appCall.getCallId().toString());
        bundle.putString(AnalyticsEvents.PARAMETER_SHARE_DIALOG_CONTENT_PAGE_ID, content.getPageId());
        internalAppEventsLogger.logEventImplicitly(AnalyticsEvents.EVENT_SHARE_MESSENGER_DIALOG_SHOW, bundle);
    }
}
