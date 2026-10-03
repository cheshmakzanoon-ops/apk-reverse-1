package cn.thinkingdata.android;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.text.TextUtils;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CheckedTextView;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RatingBar;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.ToggleButton;
import cn.thinkingdata.android.utils.C0756g;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.TDLog;
import com.facebook.internal.security.CertificateUtil;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import org.json.JSONException;
import org.json.JSONObject;

public class ThinkingDataRuntimeBridge {
    private static final String TAG = "ThinkingAnalytics.ThinkingDataRuntimeBridge";

    class C0709a implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final Object f122a;

        C0709a(Object obj) {
            this.f122a = obj;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            Object obj;
            ThinkingDataAutoTrackAppViewScreenUrl thinkingDataAutoTrackAppViewScreenUrl;
            JSONObject trackProperties;
            if (thinkingAnalyticsSDK.isTrackFragmentAppViewScreenEnabled()) {
                ThinkingDataIgnoreTrackAppViewScreen thinkingDataIgnoreTrackAppViewScreen = (ThinkingDataIgnoreTrackAppViewScreen) this.f122a.getClass().getAnnotation(ThinkingDataIgnoreTrackAppViewScreen.class);
                if (thinkingDataIgnoreTrackAppViewScreen == null || !(TextUtils.isEmpty(thinkingDataIgnoreTrackAppViewScreen.appId()) || thinkingAnalyticsSDK.getToken().equals(thinkingDataIgnoreTrackAppViewScreen.appId()))) {
                    JSONObject jSONObject = new JSONObject();
                    String canonicalName = this.f122a.getClass().getCanonicalName();
                    Activity activity = null;
                    try {
                        activity = (Activity) this.f122a.getClass().getMethod("getActivity", null).invoke(this.f122a, null);
                    } catch (Exception unused) {
                    }
                    try {
                        String strM735a = C0766q.m735a(this.f122a, thinkingAnalyticsSDK.getToken());
                        if (TextUtils.isEmpty(strM735a) || TDPresetProperties.disableList.contains("#title")) {
                            if (activity != null) {
                                strM735a = C0766q.m732a(activity);
                                if (!TextUtils.isEmpty(strM735a) && !TDPresetProperties.disableList.contains("#title")) {
                                }
                            }
                            if (activity != null) {
                                if (!TDPresetProperties.disableList.contains("#screen_name")) {
                                    jSONObject.put("#screen_name", String.format(Locale.CHINA, "%s|%s", activity.getClass().getCanonicalName(), canonicalName));
                                }
                            } else if (!TDPresetProperties.disableList.contains("#screen_name")) {
                                jSONObject.put("#screen_name", canonicalName);
                            }
                            obj = this.f122a;
                            if (!(obj instanceof ScreenAutoTracker)) {
                                ScreenAutoTracker screenAutoTracker = (ScreenAutoTracker) obj;
                                canonicalName = screenAutoTracker.getScreenUrl();
                                trackProperties = screenAutoTracker.getTrackProperties();
                                if (trackProperties != null) {
                                    C0766q.m747a(trackProperties, jSONObject, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                                }
                            } else {
                                thinkingDataAutoTrackAppViewScreenUrl = (ThinkingDataAutoTrackAppViewScreenUrl) obj.getClass().getAnnotation(ThinkingDataAutoTrackAppViewScreenUrl.class);
                                if (thinkingDataAutoTrackAppViewScreenUrl != null || (!TextUtils.isEmpty(thinkingDataAutoTrackAppViewScreenUrl.appId()) && !thinkingAnalyticsSDK.getToken().equals(thinkingDataAutoTrackAppViewScreenUrl.appId()))) {
                                    thinkingAnalyticsSDK.autoTrack("ta_app_view", jSONObject);
                                    return;
                                } else {
                                    String strUrl = thinkingDataAutoTrackAppViewScreenUrl.url();
                                    if (!TextUtils.isEmpty(strUrl)) {
                                        canonicalName = strUrl;
                                    }
                                }
                            }
                            thinkingAnalyticsSDK.trackViewScreenInternal(canonicalName, jSONObject);
                        }
                        jSONObject.put("#title", strM735a);
                        if (activity != null) {
                            if (!TDPresetProperties.disableList.contains("#screen_name")) {
                                jSONObject.put("#screen_name", String.format(Locale.CHINA, "%s|%s", activity.getClass().getCanonicalName(), canonicalName));
                            }
                        } else if (!TDPresetProperties.disableList.contains("#screen_name")) {
                            jSONObject.put("#screen_name", canonicalName);
                        }
                        obj = this.f122a;
                        if (!(obj instanceof ScreenAutoTracker)) {
                            thinkingDataAutoTrackAppViewScreenUrl = (ThinkingDataAutoTrackAppViewScreenUrl) obj.getClass().getAnnotation(ThinkingDataAutoTrackAppViewScreenUrl.class);
                            if (thinkingDataAutoTrackAppViewScreenUrl != null) {
                            }
                            thinkingAnalyticsSDK.autoTrack("ta_app_view", jSONObject);
                            return;
                        } else {
                            ScreenAutoTracker screenAutoTracker2 = (ScreenAutoTracker) obj;
                            canonicalName = screenAutoTracker2.getScreenUrl();
                            trackProperties = screenAutoTracker2.getTrackProperties();
                            if (trackProperties != null) {
                                C0766q.m747a(trackProperties, jSONObject, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                            }
                        }
                        thinkingAnalyticsSDK.trackViewScreenInternal(canonicalName, jSONObject);
                    } catch (JSONException unused2) {
                        TDLog.m679d(ThinkingDataRuntimeBridge.TAG, "JSONException occurred when track fragment events");
                    }
                }
            }
        }
    }

    class C0710b implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final String f123a;

        final String f124b;

        final JSONObject f125c;

        C0710b(String str, String str2, JSONObject jSONObject) {
            this.f123a = str;
            this.f124b = str2;
            this.f125c = jSONObject;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            if (thinkingAnalyticsSDK.isAutoTrackEnabled()) {
                if (TextUtils.isEmpty(this.f123a) || thinkingAnalyticsSDK.getToken().equals(this.f123a)) {
                    thinkingAnalyticsSDK.track(this.f124b, this.f125c);
                }
            }
        }
    }

    class C0711c implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final String f126a;

        final String f127b;

        final JSONObject f128c;

        C0711c(String str, String str2, JSONObject jSONObject) {
            this.f126a = str;
            this.f127b = str2;
            this.f128c = jSONObject;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            if (thinkingAnalyticsSDK.isAutoTrackEnabled()) {
                if (TextUtils.isEmpty(this.f126a) || thinkingAnalyticsSDK.getToken().equals(this.f126a)) {
                    thinkingAnalyticsSDK.track(this.f127b, this.f128c);
                }
            }
        }
    }

    class C0712d implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final Object f129a;

        final View f130b;

        C0712d(Object obj, View view) {
            this.f129a = obj;
            this.f130b = view;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            Class<?> cls;
            Class<?> cls2;
            String strSubstring;
            StringBuilder sb;
            Object obj;
            CharSequence string;
            CharSequence contentDescription;
            Class<?> cls3;
            String str;
            JSONObject jSONObject;
            try {
                if (thinkingAnalyticsSDK.isAutoTrackEnabled() && !thinkingAnalyticsSDK.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK)) {
                    Object obj2 = this.f129a;
                    if (obj2 != null) {
                        if (obj2 instanceof ThinkingDataIgnoreTrackOnClick) {
                            ThinkingDataIgnoreTrackOnClick thinkingDataIgnoreTrackOnClick = (ThinkingDataIgnoreTrackOnClick) obj2;
                            if (TextUtils.isEmpty(thinkingDataIgnoreTrackOnClick.appId()) || thinkingAnalyticsSDK.getToken().equals(thinkingDataIgnoreTrackOnClick.appId())) {
                                return;
                            }
                        } else if (obj2 instanceof ThinkingDataTrackViewOnClick) {
                            ThinkingDataTrackViewOnClick thinkingDataTrackViewOnClick = (ThinkingDataTrackViewOnClick) obj2;
                            if (!TextUtils.isEmpty(thinkingDataTrackViewOnClick.appId()) && !thinkingAnalyticsSDK.getToken().equals(thinkingDataTrackViewOnClick.appId())) {
                                return;
                            }
                        } else if (obj2 instanceof String) {
                            String str2 = (String) obj2;
                            if (!TextUtils.isEmpty(str2) && str2.length() >= 2) {
                                String strSubstring2 = str2.substring(2);
                                if (str2.startsWith("1_")) {
                                    if (TextUtils.isEmpty(strSubstring2) || thinkingAnalyticsSDK.getToken().equals(strSubstring2)) {
                                        return;
                                    }
                                } else if (str2.startsWith("2_") && !TextUtils.isEmpty(strSubstring2) && !thinkingAnalyticsSDK.getToken().equals(strSubstring2)) {
                                    return;
                                }
                            }
                        }
                    }
                    long jCurrentTimeMillis = System.currentTimeMillis();
                    String str3 = (String) C0766q.m730a(thinkingAnalyticsSDK.getToken(), this.f130b, C0702R.id.thinking_analytics_tag_view_onclick_timestamp);
                    if (!TextUtils.isEmpty(str3)) {
                        try {
                            if (jCurrentTimeMillis - Long.parseLong(str3) < 500) {
                                TDLog.m682i(ThinkingDataRuntimeBridge.TAG, "This onClick maybe extends from super, IGNORE");
                                return;
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        TDLog.m680e(ThinkingDataRuntimeBridge.TAG, "onViewClickMethod error: " + e.toString());
                        e.printStackTrace();
                    }
                    C0766q.m745a(thinkingAnalyticsSDK.getToken(), this.f130b, C0702R.id.thinking_analytics_tag_view_onclick_timestamp, String.valueOf(jCurrentTimeMillis));
                    Activity activityM729a = C0766q.m729a(this.f130b.getContext());
                    if ((activityM729a == null || !thinkingAnalyticsSDK.isActivityAutoTrackAppClickIgnored(activityM729a.getClass())) && !ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, this.f130b)) {
                        JSONObject jSONObject2 = new JSONObject();
                        C0766q.m743a(activityM729a, this.f130b, jSONObject2);
                        String strM734a = C0766q.m734a(this.f130b, thinkingAnalyticsSDK.getToken());
                        if (!TextUtils.isEmpty(strM734a) && !TDPresetProperties.disableList.contains("#element_id")) {
                            jSONObject2.put("#element_id", strM734a);
                        }
                        if (activityM729a != null && !TDPresetProperties.disableList.contains("#screen_name")) {
                            jSONObject2.put("#screen_name", activityM729a.getClass().getCanonicalName());
                            String strM732a = C0766q.m732a(activityM729a);
                            if (!TextUtils.isEmpty(strM732a) && !TDPresetProperties.disableList.contains("#title")) {
                                jSONObject2.put("#title", strM732a);
                            }
                        }
                        CharSequence charSequenceM738a = null;
                        try {
                            cls = Class.forName("androidx.appcompat.widget.SwitchCompat");
                        } catch (Exception unused) {
                            cls = null;
                        }
                        if (cls == null) {
                            try {
                                cls = Class.forName("androidx.appcompat.widget.SwitchCompat");
                            } catch (Exception unused2) {
                            }
                        }
                        try {
                            cls2 = Class.forName("androidx.viewpager.widget.ViewPager");
                        } catch (Exception unused3) {
                            cls2 = null;
                        }
                        if (cls2 == null) {
                            try {
                                cls2 = Class.forName("androidx.viewpager.widget.ViewPager");
                            } catch (Exception unused4) {
                            }
                        }
                        Object canonicalName = this.f130b.getClass().getCanonicalName();
                        View view = this.f130b;
                        if (view instanceof CheckBox) {
                            string = ((CheckBox) view).getText();
                            obj = "CheckBox";
                        } else {
                            if (cls == null || !cls.isInstance(view)) {
                                if (cls2 == null || !cls2.isInstance(this.f130b)) {
                                    View view2 = this.f130b;
                                    if (view2 instanceof Switch) {
                                        Switch r9 = (Switch) view2;
                                        CharSequence textOn = r9.isChecked() ? r9.getTextOn() : r9.getTextOff();
                                        if (TextUtils.isEmpty(textOn)) {
                                            textOn = r9.getText();
                                        }
                                        charSequenceM738a = textOn;
                                        canonicalName = "SwitchButton";
                                    } else if (view2 instanceof RadioGroup) {
                                        int checkedRadioButtonId = ((RadioGroup) view2).getCheckedRadioButtonId();
                                        canonicalName = "RadioGroup";
                                        if (activityM729a != null) {
                                            try {
                                                RadioButton radioButton = (RadioButton) activityM729a.findViewById(checkedRadioButtonId);
                                                if (radioButton != null && !TextUtils.isEmpty(radioButton.getText())) {
                                                    strSubstring = radioButton.getText().toString();
                                                    charSequenceM738a = strSubstring;
                                                }
                                            } catch (Exception e2) {
                                                e = e2;
                                                e.printStackTrace();
                                            }
                                        }
                                    } else if (view2 instanceof RadioButton) {
                                        string = ((RadioButton) view2).getText();
                                        obj = "RadioButton";
                                    } else if (view2 instanceof ToggleButton) {
                                        ToggleButton toggleButton = (ToggleButton) view2;
                                        obj = "ToggleButton";
                                        string = toggleButton.isChecked() ? toggleButton.getTextOn() : toggleButton.getTextOff();
                                    } else if (view2 instanceof Button) {
                                        string = ((Button) view2).getText();
                                        obj = "Button";
                                    } else if (view2 instanceof CheckedTextView) {
                                        string = ((CheckedTextView) view2).getText();
                                        obj = "CheckedTextView";
                                    } else if (view2 instanceof TextView) {
                                        string = ((TextView) view2).getText();
                                        obj = "TextView";
                                    } else if (view2 instanceof ImageButton) {
                                        ImageButton imageButton = (ImageButton) view2;
                                        canonicalName = "ImageButton";
                                        if (!TextUtils.isEmpty(imageButton.getContentDescription())) {
                                            contentDescription = imageButton.getContentDescription();
                                            strSubstring = contentDescription.toString();
                                            charSequenceM738a = strSubstring;
                                        }
                                    } else if (view2 instanceof ImageView) {
                                        ImageView imageView = (ImageView) view2;
                                        canonicalName = "ImageView";
                                        if (!TextUtils.isEmpty(imageView.getContentDescription())) {
                                            contentDescription = imageView.getContentDescription();
                                            strSubstring = contentDescription.toString();
                                            charSequenceM738a = strSubstring;
                                        }
                                    } else if (view2 instanceof RatingBar) {
                                        string = String.valueOf(((RatingBar) view2).getRating());
                                        obj = "RatingBar";
                                    } else if (view2 instanceof SeekBar) {
                                        string = String.valueOf(((SeekBar) view2).getProgress());
                                        obj = "SeekBar";
                                    } else if (view2 instanceof Spinner) {
                                        canonicalName = "Spinner";
                                        try {
                                            charSequenceM738a = C0766q.m738a(new StringBuilder(), (ViewGroup) this.f130b);
                                            if (!TextUtils.isEmpty(charSequenceM738a)) {
                                                charSequenceM738a = charSequenceM738a.toString().substring(0, charSequenceM738a.length() - 1);
                                            }
                                            if (!TDPresetProperties.disableList.contains("#element_position")) {
                                                jSONObject2.put("#element_position", ((Spinner) this.f130b).getSelectedItemPosition());
                                            }
                                        } catch (Exception e3) {
                                            e = e3;
                                            e.printStackTrace();
                                        }
                                    } else {
                                        if (view2 instanceof TimePicker) {
                                            sb = new StringBuilder();
                                            sb.append(((TimePicker) this.f130b).getCurrentHour());
                                            sb.append(CertificateUtil.DELIMITER);
                                            sb.append(((TimePicker) this.f130b).getCurrentMinute());
                                            obj = "TimePicker";
                                        } else if (view2 instanceof DatePicker) {
                                            DatePicker datePicker = (DatePicker) view2;
                                            sb = new StringBuilder();
                                            sb.append(datePicker.getYear());
                                            sb.append("-");
                                            sb.append(datePicker.getMonth());
                                            sb.append("-");
                                            sb.append(datePicker.getDayOfMonth());
                                            obj = "DatePicker";
                                        } else if (view2 instanceof ViewGroup) {
                                            try {
                                                charSequenceM738a = C0766q.m738a(new StringBuilder(), (ViewGroup) this.f130b);
                                                if (!TextUtils.isEmpty(charSequenceM738a)) {
                                                    strSubstring = charSequenceM738a.toString().substring(0, charSequenceM738a.length() - 1);
                                                    charSequenceM738a = strSubstring;
                                                }
                                            } catch (Exception e4) {
                                                e = e4;
                                                e.printStackTrace();
                                            }
                                        }
                                        string = sb.toString();
                                    }
                                } else {
                                    canonicalName = "ViewPager";
                                    try {
                                        Object objInvoke = this.f130b.getClass().getMethod("getAdapter", null).invoke(this.f130b, null);
                                        Method method = this.f130b.getClass().getMethod("getCurrentItem", null);
                                        if (method != null) {
                                            Integer num = (Integer) method.invoke(this.f130b, null);
                                            num.intValue();
                                            if (!TDPresetProperties.disableList.contains("#element_position")) {
                                                jSONObject2.put("#element_position", String.format(Locale.CHINA, "%d", num));
                                            }
                                            Method method2 = objInvoke.getClass().getMethod("getPageTitle", Integer.TYPE);
                                            if (method2 != null) {
                                                strSubstring = (String) method2.invoke(objInvoke, num);
                                                charSequenceM738a = strSubstring;
                                            }
                                        }
                                    } catch (Exception e5) {
                                        e = e5;
                                        e.printStackTrace();
                                    }
                                }
                                if (!TextUtils.isEmpty(charSequenceM738a) && !TDPresetProperties.disableList.contains("#element_content")) {
                                    jSONObject2.put("#element_content", charSequenceM738a.toString());
                                }
                                if (!TDPresetProperties.disableList.contains("#element_type")) {
                                    jSONObject2.put("#element_type", canonicalName);
                                }
                                C0766q.m744a(this.f130b, jSONObject2);
                                jSONObject = (JSONObject) C0766q.m730a(thinkingAnalyticsSDK.getToken(), this.f130b, C0702R.id.thinking_analytics_tag_view_properties);
                                if (jSONObject != null) {
                                    C0766q.m747a(jSONObject, jSONObject2, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                                }
                                thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject2);
                            }
                            if (((CompoundButton) this.f130b).isChecked()) {
                                cls3 = this.f130b.getClass();
                                str = "getTextOn";
                            } else {
                                cls3 = this.f130b.getClass();
                                str = "getTextOff";
                            }
                            string = (String) cls3.getMethod(str, null).invoke(this.f130b, null);
                            obj = "SwitchCompat";
                        }
                        charSequenceM738a = string;
                        canonicalName = obj;
                        if (!TextUtils.isEmpty(charSequenceM738a)) {
                            jSONObject2.put("#element_content", charSequenceM738a.toString());
                        }
                        if (!TDPresetProperties.disableList.contains("#element_type")) {
                            jSONObject2.put("#element_type", canonicalName);
                        }
                        C0766q.m744a(this.f130b, jSONObject2);
                        jSONObject = (JSONObject) C0766q.m730a(thinkingAnalyticsSDK.getToken(), this.f130b, C0702R.id.thinking_analytics_tag_view_properties);
                        if (jSONObject != null) {
                            C0766q.m747a(jSONObject, jSONObject2, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                        }
                        thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject2);
                    }
                }
            } catch (Exception e6) {
                TDLog.m680e(ThinkingDataRuntimeBridge.TAG, "onViewClickMethod error: " + e6.toString());
                e6.printStackTrace();
            }
        }
    }

    class C0713e implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final Context f131a;

        final View f132b;

        final View f133c;

        final int f134d;

        final int f135e;

        C0713e(Context context, View view, View view2, int i, int i2) {
            this.f131a = context;
            this.f132b = view;
            this.f133c = view2;
            this.f134d = i;
            this.f135e = i2;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            Object obj;
            String strSubstring;
            try {
                if (thinkingAnalyticsSDK.isAutoTrackEnabled() && !thinkingAnalyticsSDK.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK)) {
                    Activity activityM729a = C0766q.m729a(this.f131a);
                    if ((activityM729a != null && thinkingAnalyticsSDK.isActivityAutoTrackAppClickIgnored(activityM729a.getClass())) || ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, ExpandableListView.class) || ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, this.f132b) || ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, this.f133c)) {
                        return;
                    }
                    JSONObject jSONObject = new JSONObject();
                    C0766q.m743a(activityM729a, this.f133c, jSONObject);
                    if (activityM729a != null && !TDPresetProperties.disableList.contains("#screen_name")) {
                        jSONObject.put("#screen_name", activityM729a.getClass().getCanonicalName());
                        String strM732a = C0766q.m732a(activityM729a);
                        if (!TextUtils.isEmpty(strM732a) && !TDPresetProperties.disableList.contains("#title")) {
                            jSONObject.put("#title", strM732a);
                        }
                    }
                    String strM733a = C0766q.m733a(this.f132b);
                    if (!TextUtils.isEmpty(strM733a) && !TDPresetProperties.disableList.contains("#element_id")) {
                        jSONObject.put("#element_id", strM733a);
                    }
                    if (this.f134d < 0) {
                        if (!TDPresetProperties.disableList.contains("#element_position")) {
                            obj = String.format(Locale.CHINA, "%d", Integer.valueOf(this.f135e));
                            jSONObject.put("#element_position", obj);
                        }
                        e.printStackTrace();
                        TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " ExpandableListView.OnChildClickListener.onGroupClick AOP ERROR: " + e.getMessage());
                    }
                    if (!TDPresetProperties.disableList.contains("#element_position")) {
                        obj = String.format(Locale.CHINA, "%d:%d", Integer.valueOf(this.f135e), Integer.valueOf(this.f134d));
                        jSONObject.put("#element_position", obj);
                    }
                    e.printStackTrace();
                    TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " ExpandableListView.OnChildClickListener.onGroupClick AOP ERROR: " + e.getMessage());
                    if (!TDPresetProperties.disableList.contains("#element_type")) {
                        jSONObject.put("#element_type", "ExpandableListView");
                    }
                    View view = this.f133c;
                    String strM738a = null;
                    if (!(view instanceof ViewGroup)) {
                        if (view instanceof TextView) {
                            strSubstring = (String) ((TextView) view).getText();
                            strM738a = strSubstring;
                        }
                        e.printStackTrace();
                        TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " ExpandableListView.OnChildClickListener.onGroupClick AOP ERROR: " + e.getMessage());
                    }
                    try {
                        strM738a = C0766q.m738a(new StringBuilder(), (ViewGroup) this.f133c);
                        if (!TextUtils.isEmpty(strM738a)) {
                            strSubstring = strM738a.substring(0, strM738a.length() - 1);
                            strM738a = strSubstring;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    e.printStackTrace();
                    TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " ExpandableListView.OnChildClickListener.onGroupClick AOP ERROR: " + e.getMessage());
                    if (!TextUtils.isEmpty(strM738a) && !TDPresetProperties.disableList.contains("#element_content")) {
                        jSONObject.put("#element_content", strM738a);
                    }
                    C0766q.m744a(this.f132b, jSONObject);
                    JSONObject jSONObject2 = (JSONObject) C0766q.m730a(thinkingAnalyticsSDK.getToken(), this.f133c, C0702R.id.thinking_analytics_tag_view_properties);
                    if (jSONObject2 != null) {
                        C0766q.m747a(jSONObject2, jSONObject, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                    }
                    ExpandableListAdapter expandableListAdapter = ((ExpandableListView) this.f132b).getExpandableListAdapter();
                    if (expandableListAdapter != null && (expandableListAdapter instanceof ThinkingExpandableListViewItemTrackProperties)) {
                        try {
                            ThinkingExpandableListViewItemTrackProperties thinkingExpandableListViewItemTrackProperties = (ThinkingExpandableListViewItemTrackProperties) expandableListAdapter;
                            int i = this.f134d;
                            JSONObject thinkingGroupItemTrackProperties = i < 0 ? thinkingExpandableListViewItemTrackProperties.getThinkingGroupItemTrackProperties(this.f135e) : thinkingExpandableListViewItemTrackProperties.getThinkingChildItemTrackProperties(this.f135e, i);
                            if (thinkingGroupItemTrackProperties != null && C0756g.m705a(thinkingGroupItemTrackProperties)) {
                                C0766q.m747a(thinkingGroupItemTrackProperties, jSONObject, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                            }
                        } catch (JSONException e2) {
                            e2.printStackTrace();
                        }
                    }
                    thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject);
                }
            } catch (Exception e3) {
                e3.printStackTrace();
                TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " ExpandableListView.OnChildClickListener.onGroupClick AOP ERROR: " + e3.getMessage());
            }
        }
    }

    class C0714f implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final Dialog f136a;

        final int f137b;

        C0714f(Dialog dialog, int i) {
            this.f136a = dialog;
            this.f137b = i;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            Class<?> cls;
            Button button;
            Object item;
            Object text;
            try {
                if (thinkingAnalyticsSDK.isAutoTrackEnabled() && !thinkingAnalyticsSDK.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK)) {
                    Activity activityM729a = C0766q.m729a(this.f136a.getContext());
                    if (activityM729a == null) {
                        activityM729a = this.f136a.getOwnerActivity();
                    }
                    if ((activityM729a == null || !thinkingAnalyticsSDK.isActivityAutoTrackAppClickIgnored(activityM729a.getClass())) && !ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, Dialog.class)) {
                        JSONObject jSONObject = new JSONObject();
                        try {
                            if (this.f136a.getWindow() != null) {
                                String str = (String) C0766q.m730a(thinkingAnalyticsSDK.getToken(), this.f136a.getWindow().getDecorView(), C0702R.id.thinking_analytics_tag_view_id);
                                if (!TextUtils.isEmpty(str) && !TDPresetProperties.disableList.contains("#element_id")) {
                                    jSONObject.put("#element_id", str);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        if (activityM729a != null && !TDPresetProperties.disableList.contains("#screen_name")) {
                            jSONObject.put("#screen_name", activityM729a.getClass().getCanonicalName());
                            String strM732a = C0766q.m732a(activityM729a);
                            if (!TextUtils.isEmpty(strM732a) && !TDPresetProperties.disableList.contains("#title")) {
                                jSONObject.put("#title", strM732a);
                            }
                        }
                        if (!TDPresetProperties.disableList.contains("#element_type")) {
                            jSONObject.put("#element_type", "Dialog");
                        }
                        try {
                            cls = Class.forName("androidx.appcompat.app.AlertDialog)");
                        } catch (Exception unused) {
                            cls = null;
                        }
                        if (cls == null) {
                            try {
                                cls = Class.forName("androidx.appcompat.app.AlertDialog");
                            } catch (Exception unused2) {
                            }
                        }
                        Dialog dialog = this.f136a;
                        if (dialog instanceof AlertDialog) {
                            AlertDialog alertDialog = (AlertDialog) dialog;
                            Button button2 = alertDialog.getButton(this.f137b);
                            if (button2 == null) {
                                ListView listView = alertDialog.getListView();
                                if (listView != null && (text = listView.getAdapter().getItem(this.f137b)) != null && (text instanceof String) && !TDPresetProperties.disableList.contains("#element_content")) {
                                    jSONObject.put("#element_content", text);
                                }
                            } else if (!TextUtils.isEmpty(button2.getText()) && !TDPresetProperties.disableList.contains("#element_content")) {
                                text = button2.getText();
                                jSONObject.put("#element_content", text);
                            }
                        } else if (cls != null && cls.isInstance(dialog)) {
                            try {
                                button = (Button) this.f136a.getClass().getMethod("getButton", Integer.TYPE).invoke(this.f136a, Integer.valueOf(this.f137b));
                            } catch (Exception unused3) {
                                button = null;
                            }
                            if (button == null) {
                                try {
                                    ListView listView2 = (ListView) this.f136a.getClass().getMethod("getListView", null).invoke(this.f136a, null);
                                    if (listView2 != null && (item = listView2.getAdapter().getItem(this.f137b)) != null && (item instanceof String) && !TDPresetProperties.disableList.contains("#element_content")) {
                                        jSONObject.put("#element_content", item);
                                    }
                                } catch (Exception unused4) {
                                }
                            } else if (!TextUtils.isEmpty(button.getText()) && !TDPresetProperties.disableList.contains("#element_content")) {
                                text = button.getText();
                                jSONObject.put("#element_content", text);
                            }
                        }
                        thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject);
                    }
                }
            } catch (Exception e2) {
                e2.printStackTrace();
                TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " DialogInterface.OnClickListener.onClick AOP ERROR: " + e2.getMessage());
            }
        }
    }

    class C0715g implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final View f138a;

        final View f139b;

        final int f140c;

        C0715g(View view, View view2, int i) {
            this.f138a = view;
            this.f139b = view2;
            this.f140c = i;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            Context context;
            String strSubstring;
            try {
                if (!thinkingAnalyticsSDK.isAutoTrackEnabled() || thinkingAnalyticsSDK.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK) || (context = this.f138a.getContext()) == null) {
                    return;
                }
                Activity activityM729a = C0766q.m729a(context);
                if ((activityM729a == null || !thinkingAnalyticsSDK.isActivityAutoTrackAppClickIgnored(activityM729a.getClass())) && !ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, this.f139b.getClass())) {
                    JSONObject jSONObject = new JSONObject();
                    if (thinkingAnalyticsSDK.getIgnoredViewTypeList() != null) {
                        if ((this.f139b instanceof ListView) && !TDPresetProperties.disableList.contains("#element_type")) {
                            jSONObject.put("#element_type", "ListView");
                            if (ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, ListView.class)) {
                                return;
                            }
                        } else if ((this.f139b instanceof GridView) && !TDPresetProperties.disableList.contains("#element_type")) {
                            jSONObject.put("#element_type", "GridView");
                            if (ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, GridView.class)) {
                                return;
                            }
                        } else if ((this.f139b instanceof Spinner) && !TDPresetProperties.disableList.contains("#element_type")) {
                            jSONObject.put("#element_type", "Spinner");
                            if (ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, Spinner.class)) {
                                return;
                            }
                        }
                    }
                    Adapter adapter = ((AdapterView) this.f139b).getAdapter();
                    if (adapter instanceof ThinkingAdapterViewItemTrackProperties) {
                        try {
                            JSONObject thinkingItemTrackProperties = ((ThinkingAdapterViewItemTrackProperties) adapter).getThinkingItemTrackProperties(this.f140c);
                            if (thinkingItemTrackProperties != null && C0756g.m705a(thinkingItemTrackProperties)) {
                                C0766q.m747a(thinkingItemTrackProperties, jSONObject, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                    C0766q.m743a(activityM729a, this.f138a, jSONObject);
                    String strM734a = C0766q.m734a(this.f139b, thinkingAnalyticsSDK.getToken());
                    if (!TextUtils.isEmpty(strM734a) && !TDPresetProperties.disableList.contains("#element_id")) {
                        jSONObject.put("#element_id", strM734a);
                    }
                    if (activityM729a != null && !TDPresetProperties.disableList.contains("#screen_name")) {
                        jSONObject.put("#screen_name", activityM729a.getClass().getCanonicalName());
                        String strM732a = C0766q.m732a(activityM729a);
                        if (!TextUtils.isEmpty(strM732a) && !TDPresetProperties.disableList.contains("#title")) {
                            jSONObject.put("#title", strM732a);
                        }
                    }
                    if (!TDPresetProperties.disableList.contains("#element_position")) {
                        jSONObject.put("#element_position", String.valueOf(this.f140c));
                    }
                    View view = this.f138a;
                    String strM738a = null;
                    if (view instanceof ViewGroup) {
                        try {
                            strM738a = C0766q.m738a(new StringBuilder(), (ViewGroup) this.f138a);
                            if (!TextUtils.isEmpty(strM738a)) {
                                strSubstring = strM738a.substring(0, strM738a.length() - 1);
                                strM738a = strSubstring;
                            }
                        } catch (Exception e2) {
                            e2.printStackTrace();
                        }
                        e.printStackTrace();
                        TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " AdapterView.OnItemClickListener.onItemClick AOP ERROR: " + e.getMessage());
                    }
                    if (view instanceof TextView) {
                        strSubstring = ((TextView) view).getText().toString();
                        strM738a = strSubstring;
                    }
                    if (!TextUtils.isEmpty(strM738a) && !TDPresetProperties.disableList.contains("#element_content")) {
                        jSONObject.put("#element_content", strM738a);
                    }
                    C0766q.m744a(this.f139b, jSONObject);
                    JSONObject jSONObject2 = (JSONObject) C0766q.m730a(thinkingAnalyticsSDK.getToken(), this.f138a, C0702R.id.thinking_analytics_tag_view_properties);
                    if (jSONObject2 != null) {
                        C0766q.m747a(jSONObject2, jSONObject, thinkingAnalyticsSDK.mConfig.getDefaultTimeZone());
                    }
                    thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject);
                }
            } catch (Exception e3) {
                e3.printStackTrace();
                TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " AdapterView.OnItemClickListener.onItemClick AOP ERROR: " + e3.getMessage());
            }
        }
    }

    class C0716h implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final Object f141a;

        final MenuItem f142b;

        C0716h(Object obj, MenuItem menuItem) {
            this.f141a = obj;
            this.f142b = menuItem;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            Object obj;
            try {
                if (!thinkingAnalyticsSDK.isAutoTrackEnabled() || thinkingAnalyticsSDK.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK) || ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, MenuItem.class) || (obj = this.f141a) == null) {
                    return;
                }
                String resourceEntryName = null;
                Context context = obj instanceof Context ? (Context) obj : null;
                if (context == null) {
                    return;
                }
                Activity activityM729a = C0766q.m729a(context);
                if (activityM729a == null || !thinkingAnalyticsSDK.isActivityAutoTrackAppClickIgnored(activityM729a.getClass())) {
                    try {
                        resourceEntryName = context.getResources().getResourceEntryName(this.f142b.getItemId());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    JSONObject jSONObject = new JSONObject();
                    if (activityM729a != null && !TDPresetProperties.disableList.contains("#screen_name")) {
                        jSONObject.put("#screen_name", activityM729a.getClass().getCanonicalName());
                        String strM732a = C0766q.m732a(activityM729a);
                        if (!TextUtils.isEmpty(strM732a) && !TDPresetProperties.disableList.contains("#title")) {
                            jSONObject.put("#title", strM732a);
                        }
                    }
                    if (!TextUtils.isEmpty(resourceEntryName) && !TDPresetProperties.disableList.contains("#element_id")) {
                        jSONObject.put("#element_id", resourceEntryName);
                    }
                    if (!TextUtils.isEmpty(this.f142b.getTitle()) && !TDPresetProperties.disableList.contains("#element_content")) {
                        jSONObject.put("#element_content", this.f142b.getTitle());
                    }
                    if (!TDPresetProperties.disableList.contains("#element_type")) {
                        jSONObject.put("#element_type", "MenuItem");
                    }
                    thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject);
                }
            } catch (Exception e2) {
                e2.printStackTrace();
                TDLog.m682i(ThinkingDataRuntimeBridge.TAG, "track MenuItem click error: " + e2.getMessage());
            }
        }
    }

    class C0717i implements ThinkingAnalyticsSDK.InterfaceC0708b {

        final String f143a;

        C0717i(String str) {
            this.f143a = str;
        }

        @Override
        public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
            try {
                if (!thinkingAnalyticsSDK.isAutoTrackEnabled() || thinkingAnalyticsSDK.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK) || ThinkingDataRuntimeBridge.isViewIgnored(thinkingAnalyticsSDK, TabHost.class)) {
                    return;
                }
                JSONObject jSONObject = new JSONObject();
                if (!TDPresetProperties.disableList.contains("#element_content")) {
                    jSONObject.put("#element_content", this.f143a);
                }
                if (!TDPresetProperties.disableList.contains("#element_type")) {
                    jSONObject.put("#element_type", "TabHost");
                }
                thinkingAnalyticsSDK.autoTrack("ta_app_click", jSONObject);
            } catch (Exception e) {
                e.printStackTrace();
                TDLog.m682i(ThinkingDataRuntimeBridge.TAG, " onTabChanged AOP ERROR: " + e.getMessage());
            }
        }
    }

    private static boolean fragmentGetUserVisibleHint(Object obj) {
        try {
            return ((Boolean) obj.getClass().getMethod("getUserVisibleHint", null).invoke(obj, null)).booleanValue();
        } catch (Exception unused) {
            return false;
        }
    }

    private static boolean fragmentIsNotHidden(Object obj) {
        try {
            return !((Boolean) obj.getClass().getMethod("isHidden", null).invoke(obj, null)).booleanValue();
        } catch (Exception unused) {
            return true;
        }
    }

    private static boolean fragmentIsResumed(Object obj) {
        try {
            return ((Boolean) obj.getClass().getMethod("isResumed", null).invoke(obj, null)).booleanValue();
        } catch (Exception unused) {
            return false;
        }
    }

    private static boolean isNotFragment(Object obj) {
        Class<?> cls;
        Class<?> cls2 = null;
        try {
            cls = Class.forName("androidx.fragment.app.Fragment");
        } catch (Exception unused) {
            cls = null;
        }
        try {
            cls2 = Class.forName("androidx.fragment.app.Fragment");
        } catch (Exception unused2) {
        }
        if (cls == null && cls2 == null) {
            return true;
        }
        if (cls != null) {
            try {
                if (cls.isInstance(obj)) {
                    return false;
                }
                if (cls2 == null && cls2.isInstance(obj)) {
                    return false;
                }
            } catch (Exception unused3) {
            }
        } else if (cls2 == null) {
        }
        return true;
    }

    public static boolean isViewIgnored(ThinkingAnalyticsSDK thinkingAnalyticsSDK, View view) {
        if (view == null) {
            return true;
        }
        try {
            List<Class> ignoredViewTypeList = thinkingAnalyticsSDK.getIgnoredViewTypeList();
            if (ignoredViewTypeList != null) {
                Iterator<Class> it = ignoredViewTypeList.iterator();
                while (it.hasNext()) {
                    if (it.next().isAssignableFrom(view.getClass())) {
                        return true;
                    }
                }
            }
            return "1".equals(C0766q.m730a(thinkingAnalyticsSDK.getToken(), view, C0702R.id.thinking_analytics_tag_view_ignored));
        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
    }

    public static boolean isViewIgnored(ThinkingAnalyticsSDK thinkingAnalyticsSDK, Class cls) {
        if (cls == null) {
            return true;
        }
        try {
            List<Class> ignoredViewTypeList = thinkingAnalyticsSDK.getIgnoredViewTypeList();
            if (ignoredViewTypeList == null) {
                return false;
            }
            Iterator<Class> it = ignoredViewTypeList.iterator();
            while (it.hasNext()) {
                if (it.next().isAssignableFrom(cls)) {
                    return true;
                }
            }
            return false;
        } catch (Exception unused) {
            return true;
        }
    }

    public static void onAdapterViewItemClick(View view, View view2, int i) {
        if (view == null || view2 == null || !(view instanceof AdapterView)) {
            return;
        }
        ThinkingAnalyticsSDK.allInstances(new C0715g(view2, view, i));
    }

    public static void onDialogClick(Object obj, int i) {
        if (obj instanceof Dialog) {
            ThinkingAnalyticsSDK.allInstances(new C0714f((Dialog) obj, i));
        }
    }

    public static void onExpandableListViewOnChildClick(View view, View view2, int i, int i2) {
        Context context;
        if (view == null || (context = view.getContext()) == null) {
            return;
        }
        ThinkingAnalyticsSDK.allInstances(new C0713e(context, view, view2, i2, i));
    }

    public static void onExpandableListViewOnGroupClick(View view, View view2, int i) {
        onExpandableListViewOnChildClick(view, view2, i, -1);
    }

    public static void onFragmentCreateView(Object obj, View view) {
        try {
            if (isNotFragment(obj)) {
                return;
            }
            String name = obj.getClass().getName();
            view.setTag(C0702R.id.thinking_analytics_tag_view_fragment_name, name);
            if (view instanceof ViewGroup) {
                traverseView(name, (ViewGroup) view);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void onFragmentHiddenChanged(Object obj, boolean z) {
        if (isNotFragment(obj)) {
            return;
        }
        Object objInvoke = null;
        try {
            objInvoke = obj.getClass().getMethod("getParentFragment", null).invoke(obj, null);
        } catch (Exception unused) {
        }
        if (z) {
            return;
        }
        if ((objInvoke == null && fragmentIsResumed(obj) && fragmentIsNotHidden(obj)) || (fragmentIsResumed(obj) && fragmentIsNotHidden(obj) && fragmentGetUserVisibleHint(obj))) {
            trackFragmentViewScreen(obj);
        }
    }

    public static void onFragmentOnResume(Object obj) {
        if (isNotFragment(obj)) {
            return;
        }
        Object objInvoke = null;
        try {
            objInvoke = obj.getClass().getMethod("getParentFragment", null).invoke(obj, null);
        } catch (Exception unused) {
        }
        if (objInvoke == null) {
            if (!fragmentIsNotHidden(obj) || !fragmentGetUserVisibleHint(obj)) {
                return;
            }
        } else if (!fragmentIsNotHidden(obj) || !fragmentGetUserVisibleHint(obj) || !fragmentIsNotHidden(objInvoke) || !fragmentGetUserVisibleHint(objInvoke)) {
            return;
        }
        trackFragmentViewScreen(obj);
    }

    public static void onFragmentSetUserVisibleHint(Object obj, boolean z) {
        if (isNotFragment(obj)) {
            return;
        }
        Object objInvoke = null;
        try {
            objInvoke = obj.getClass().getMethod("getParentFragment", null).invoke(obj, null);
        } catch (Exception unused) {
        }
        if (z) {
            if ((objInvoke == null && fragmentIsResumed(obj) && fragmentIsNotHidden(obj)) || (fragmentIsResumed(obj) && fragmentIsNotHidden(obj) && fragmentGetUserVisibleHint(obj))) {
                trackFragmentViewScreen(obj);
            }
        }
    }

    public static void onMenuItemSelected(Object obj, MenuItem menuItem) {
        if (menuItem == null) {
            return;
        }
        ThinkingAnalyticsSDK.allInstances(new C0716h(obj, menuItem));
    }

    public static void onTabHostChanged(String str) {
        ThinkingAnalyticsSDK.allInstances(new C0717i(str));
    }

    public static void onViewOnClick(View view, Object obj) {
        if (view == null) {
            return;
        }
        ThinkingAnalyticsSDK.allInstances(new C0712d(obj, view));
    }

    public static void trackEvent(Object obj) {
        if (obj instanceof ThinkingDataTrackEvent) {
            ThinkingDataTrackEvent thinkingDataTrackEvent = (ThinkingDataTrackEvent) obj;
            String strEventName = thinkingDataTrackEvent.eventName();
            String strProperties = thinkingDataTrackEvent.properties();
            String strAppId = thinkingDataTrackEvent.appId();
            if (TextUtils.isEmpty(strEventName)) {
                return;
            }
            JSONObject jSONObject = new JSONObject();
            if (!TextUtils.isEmpty(strProperties)) {
                try {
                    C0766q.m747a(new JSONObject(strProperties), jSONObject, (TimeZone) null);
                } catch (JSONException e) {
                    TDLog.m680e(TAG, "Exception occurred in trackEvent");
                    e.printStackTrace();
                }
            }
            ThinkingAnalyticsSDK.allInstances(new C0710b(strAppId, strEventName, jSONObject));
        }
    }

    public static void trackEvent(String str, String str2, String str3) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        JSONObject jSONObject = new JSONObject();
        if (!TextUtils.isEmpty(str2)) {
            try {
                C0766q.m747a(new JSONObject(str2), jSONObject, (TimeZone) null);
            } catch (JSONException e) {
                TDLog.m680e(TAG, "Exception occurred in trackEvent");
                e.printStackTrace();
            }
        }
        ThinkingAnalyticsSDK.allInstances(new C0711c(str3, str, jSONObject));
    }

    private static void trackFragmentViewScreen(Object obj) {
        ThinkingAnalyticsSDK.allInstances(new C0709a(obj));
    }

    private static void traverseView(String str, ViewGroup viewGroup) {
        try {
            if (TextUtils.isEmpty(str) || viewGroup == null) {
                return;
            }
            int childCount = viewGroup.getChildCount();
            for (int i = 0; i < childCount; i++) {
                View childAt = viewGroup.getChildAt(i);
                childAt.setTag(C0702R.id.thinking_analytics_tag_view_fragment_name, str);
                if (childAt instanceof ViewGroup) {
                    traverseView(str, (ViewGroup) childAt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
