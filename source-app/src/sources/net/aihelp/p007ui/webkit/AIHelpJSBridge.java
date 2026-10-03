package net.aihelp.p007ui.webkit;

import android.text.TextUtils;
import android.webkit.WebView;
import androidx.fragment.app.Fragment;
import org.json.JSONObject;

public class AIHelpJSBridge {
    private static final String CONFIG_ORIENTATION_AUTO = "1";
    private static final String CONFIG_ORIENTATION_LANDSCAPE = "3";
    private static final String CONFIG_ORIENTATION_PORTRAIT = "2";
    private static final String INTENT_TO_CALL_NATIVE_METHOD = "jsCallNative";
    private static final String INTENT_TO_FINISH_PAGE = "closeWebView";
    private static final String INTENT_TO_OPEN_NEW_LINK = "OpenUrlInINTLBrowser";
    private static final String INTENT_TO_SET_FULLSCREEN = "setFullScreen";
    private static final String INTENT_TO_UPDATE_ORIENTATION = "setScreenOrientation";
    private Fragment fragment;

    public void callJs(String str) {
    }

    public void handleJSMessages(Fragment fragment, WebView webView, String str) {
        byte b;
        this.fragment = fragment;
        try {
            JSONObject jSONObject = new JSONObject(str);
            String strOptString = jSONObject.optString("INTLMethod");
            switch (strOptString.hashCode()) {
                case -566715842:
                    if (!strOptString.equals(INTENT_TO_CALL_NATIVE_METHOD)) {
                        b = -1;
                    } else {
                        b = 4;
                    }
                    break;
                case -329683491:
                    if (!strOptString.equals(INTENT_TO_SET_FULLSCREEN)) {
                        b = -1;
                    } else {
                        b = 2;
                    }
                    break;
                case -121617663:
                    if (!strOptString.equals(INTENT_TO_FINISH_PAGE)) {
                        b = -1;
                    } else {
                        b = 0;
                    }
                    break;
                case -41194207:
                    if (!strOptString.equals(INTENT_TO_OPEN_NEW_LINK)) {
                        b = -1;
                    } else {
                        b = 1;
                    }
                    break;
                case 1012610434:
                    if (!strOptString.equals(INTENT_TO_UPDATE_ORIENTATION)) {
                        b = -1;
                    } else {
                        b = 3;
                    }
                    break;
                default:
                    b = -1;
                    break;
            }
            if (b == 0) {
                finishPage();
                return;
            }
            if (b == 1) {
                openNewLink(webView, jSONObject.optString("ParamKey"));
            } else if (b == 2) {
                updateFullScreen(jSONObject.optBoolean("isFullScreen"));
            } else {
                if (b != 3) {
                    return;
                }
                updateScreenOrientation(jSONObject.optString("screenOrientation"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void finishPage() {
        Fragment fragment = this.fragment;
        if (fragment == null || fragment.getActivity() == null) {
            return;
        }
        this.fragment.getActivity().finish();
    }

    private void openNewLink(WebView webView, String str) {
        try {
            JSONObject jSONObject = new JSONObject(str);
            if (TextUtils.isEmpty(jSONObject.optString("url"))) {
                return;
            }
            webView.loadUrl(jSONObject.optString("url"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateFullScreen(boolean z) {
        Fragment fragment = this.fragment;
        if (fragment == null || fragment.getActivity() == null) {
            return;
        }
        this.fragment.getActivity().getWindow().setFlags(z ? 1024 : 2048, 1024);
    }

    private void updateScreenOrientation(String str) {
        int i;
        if ("2".equals(str)) {
            i = 1;
        } else {
            i = "3".equals(str) ? 0 : 4;
        }
        Fragment fragment = this.fragment;
        if (fragment == null || fragment.getActivity() == null) {
            return;
        }
        this.fragment.getActivity().setRequestedOrientation(i);
    }

    public static AIHelpJSBridge getInstance() {
        return Holder.INSTANCE;
    }

    private static class Holder {
        private static final AIHelpJSBridge INSTANCE = new AIHelpJSBridge();

        private Holder() {
        }
    }
}
