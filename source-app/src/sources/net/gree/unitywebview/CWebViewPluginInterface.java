package net.gree.unitywebview;

import android.app.Activity;
import android.webkit.JavascriptInterface;
import com.unity3d.player.UnityPlayer;

class CWebViewPluginInterface {
    private String mGameObject;
    private CWebViewPlugin mPlugin;

    public CWebViewPluginInterface(CWebViewPlugin cWebViewPlugin, String str) {
        this.mPlugin = cWebViewPlugin;
        this.mGameObject = str;
    }

    @JavascriptInterface
    public void call(String str) {
        call("CallFromJS", str);
    }

    public void call(final String str, final String str2) {
        Activity activity = UnityPlayer.currentActivity;
        if (CWebViewPlugin.isDestroyed(activity)) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (CWebViewPluginInterface.this.mPlugin.IsInitialized()) {
                    CWebViewPluginInterface.this.mPlugin.MyUnitySendMessage(CWebViewPluginInterface.this.mGameObject, str, str2);
                }
            }
        });
    }
}
