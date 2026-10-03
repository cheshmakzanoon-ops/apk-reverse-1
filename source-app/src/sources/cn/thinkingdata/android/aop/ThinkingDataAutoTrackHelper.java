package cn.thinkingdata.android.aop;

import android.content.DialogInterface;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ExpandableListView;
import android.widget.RadioGroup;
import cn.thinkingdata.android.ThinkingDataRuntimeBridge;

public class ThinkingDataAutoTrackHelper {
    public static final String TAG = "ThinkingAnalytics";

    public static void track(String str, String str2, String str3) {
        ThinkingDataRuntimeBridge.trackEvent(str, str2, str3);
    }

    public static void trackDialog(DialogInterface dialogInterface, int i) {
        ThinkingDataRuntimeBridge.onDialogClick(dialogInterface, i);
    }

    public static void trackExpandableListViewOnChildClick(ExpandableListView expandableListView, View view, int i, int i2) {
        ThinkingDataRuntimeBridge.onExpandableListViewOnChildClick(expandableListView, view, i, i2);
    }

    public static void trackExpandableListViewOnGroupClick(ExpandableListView expandableListView, View view, int i) {
        ThinkingDataRuntimeBridge.onExpandableListViewOnGroupClick(expandableListView, view, i);
    }

    public static void trackListView(AdapterView<?> adapterView, View view, int i) {
        ThinkingDataRuntimeBridge.onAdapterViewItemClick(adapterView, view, i);
    }

    public static void trackMenuItem(MenuItem menuItem) {
    }

    public static void trackMenuItem(Object obj, MenuItem menuItem) {
        ThinkingDataRuntimeBridge.onMenuItemSelected(obj, menuItem);
    }

    public static void trackRadioGroup(RadioGroup radioGroup, int i) {
        ThinkingDataRuntimeBridge.onViewOnClick(radioGroup, null);
    }

    public static void trackRadioGroup(RadioGroup radioGroup, int i, String str) {
        ThinkingDataRuntimeBridge.onViewOnClick(radioGroup, str);
    }

    public static void trackTabHost(String str) {
        ThinkingDataRuntimeBridge.onTabHostChanged(str);
    }

    public static void trackTabLayoutSelected(Object obj, Object obj2) {
        try {
            Object objInvoke = obj2.getClass().getDeclaredMethod("getText", null).invoke(obj2, null);
            if (objInvoke != null) {
                ThinkingDataRuntimeBridge.onTabHostChanged(objInvoke.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void trackViewOnClick(View view) {
        ThinkingDataRuntimeBridge.onViewOnClick(view, null);
    }

    public static void trackViewOnClick(View view, String str) {
        ThinkingDataRuntimeBridge.onViewOnClick(view, str);
    }
}
