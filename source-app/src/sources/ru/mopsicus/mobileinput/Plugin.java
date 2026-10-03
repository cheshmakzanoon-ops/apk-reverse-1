package ru.mopsicus.mobileinput;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.unity3d.player.UnityPlayer;
import ru.mopsicus.common.Common;

public class Plugin {
    public static String KEYBOARD_ACTION = "KEYBOARD_ACTION";
    public static Activity activity = null;
    public static Common common = null;
    private static ViewGroup group = null;
    private static KeyboardListener keyboardListener = null;
    private static KeyboardProvider keyboardProvider = null;
    public static RelativeLayout layout = null;
    public static String name = "mobileinput";

    public static View getLeafView(View view) {
        if (!(view instanceof ViewGroup)) {
            return view;
        }
        ViewGroup viewGroup = (ViewGroup) view;
        for (int i = 0; i < viewGroup.getChildCount(); i++) {
            View leafView = getLeafView(viewGroup.getChildAt(i));
            if (leafView != null) {
                return leafView;
            }
        }
        return null;
    }

    public static void init() {
        common = new Common();
        Activity activity2 = UnityPlayer.currentActivity;
        activity = activity2;
        activity2.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (Plugin.layout != null) {
                    Plugin.group.removeView(Plugin.layout);
                }
                ViewGroup unused = Plugin.group = (ViewGroup) Plugin.getLeafView((ViewGroup) Plugin.activity.findViewById(android.R.id.content)).getParent();
                Plugin.layout = new RelativeLayout(Plugin.activity);
                Plugin.group.addView(Plugin.layout, new RelativeLayout.LayoutParams(-1, -1));
                KeyboardListener unused2 = Plugin.keyboardListener = new KeyboardListener();
                KeyboardProvider unused3 = Plugin.keyboardProvider = new KeyboardProvider(Plugin.activity, Plugin.group, Plugin.keyboardListener);
            }
        });
    }

    public static void destroy() {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Plugin.keyboardProvider.disable();
                KeyboardProvider unused = Plugin.keyboardProvider = null;
                KeyboardListener unused2 = Plugin.keyboardListener = null;
                if (Plugin.layout != null) {
                    Plugin.group.removeView(Plugin.layout);
                }
            }
        });
    }

    public static void execute(final int i, final String str) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                MobileInput.processMessage(i, str);
            }
        });
    }
}
