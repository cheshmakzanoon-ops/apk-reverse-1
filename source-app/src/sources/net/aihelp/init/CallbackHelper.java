package net.aihelp.init;

import net.aihelp.common.IntentValues;
import net.aihelp.p007ui.listener.OnAIHelpInitializedCallback;
import net.aihelp.p007ui.listener.OnAIHelpSessionCloseCallback;
import net.aihelp.p007ui.listener.OnAIHelpSessionOpenCallback;
import net.aihelp.p007ui.listener.OnMessageCountArrivedCallback;
import net.aihelp.p007ui.listener.OnNetworkCheckResultCallback;
import net.aihelp.p007ui.listener.OnSpecificFormSubmittedCallback;
import net.aihelp.p007ui.listener.OnSpecificUrlClickedCallback;

public class CallbackHelper {
    public static native void handleCocos2dxCallback(int i, Object... objArr);

    public static void registerCocos2dxCallback(final int i, Object... objArr) {
        switch (i) {
            case 1001:
                AIHelpSupport.setOnAIHelpInitializedCallback(new OnAIHelpInitializedCallback() {
                    @Override
                    public void onAIHelpInitialized(boolean z, String str) {
                        CallbackHelper.handleCocos2dxCallback(i, Boolean.valueOf(z), str);
                    }
                });
                break;
            case 1002:
                if (objArr != null && objArr.length > 0) {
                    Object obj = objArr[0];
                    if (obj instanceof String) {
                        AIHelpSupport.setNetworkCheckHostAddress((String) obj, new OnNetworkCheckResultCallback() {
                            @Override
                            public void onNetworkCheckResult(String str) {
                                CallbackHelper.handleCocos2dxCallback(i, str);
                            }
                        });
                    }
                    break;
                }
                break;
            case 1003:
                AIHelpSupport.startUnreadMessageCountPolling(new OnMessageCountArrivedCallback() {
                    @Override
                    public void onMessageCountArrived(int i2) {
                        CallbackHelper.handleCocos2dxCallback(i, Integer.valueOf(i2));
                    }
                });
                break;
            case 1004:
                AIHelpSupport.setOnSpecificFormSubmittedCallback(new OnSpecificFormSubmittedCallback() {
                    @Override
                    public void onFormSubmitted() {
                        CallbackHelper.handleCocos2dxCallback(i, new Object[0]);
                    }
                });
                break;
            case 1005:
                AIHelpSupport.setOnAIHelpSessionOpenCallback(new OnAIHelpSessionOpenCallback() {
                    @Override
                    public void onAIHelpSessionOpened() {
                        CallbackHelper.handleCocos2dxCallback(i, new Object[0]);
                    }
                });
                break;
            case 1006:
                AIHelpSupport.setOnAIHelpSessionCloseCallback(new OnAIHelpSessionCloseCallback() {
                    @Override
                    public void onAIHelpSessionClosed() {
                        CallbackHelper.handleCocos2dxCallback(i, new Object[0]);
                    }
                });
                break;
            case IntentValues.PAGE_HOPPING_CONVERSATION:
                AIHelpSupport.setOnSpecificUrlClickedCallback(new OnSpecificUrlClickedCallback() {
                    @Override
                    public void onSpecificUrlClicked(String str) {
                        CallbackHelper.handleCocos2dxCallback(i, str);
                    }
                });
                break;
        }
    }
}
