package ru.mopsicus.mobileinput;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.WindowInsets;
import android.widget.EditText;
import android.widget.PopupWindow;
import com.sdkmanager.utils.Udid$;
import java.lang.reflect.Field;
import org.json.JSONException;
import org.json.JSONObject;

public class KeyboardProvider extends PopupWindow {
    private Activity activity;
    private int heightMax;
    private int keyboardLandscapeHeight;
    private int keyboardPortraitHeight;
    private EditText lastFocusedEditText;
    private int navBarHeight;
    private int navigationBarHeight;
    private KeyboardObserver observer;
    private View parentView;
    private View popupView;
    private int statusBarHeight;

    public KeyboardProvider(Activity activity, ViewGroup viewGroup, KeyboardObserver keyboardObserver) {
        super(activity);
        this.heightMax = 0;
        this.navigationBarHeight = 0;
        this.statusBarHeight = 0;
        this.observer = keyboardObserver;
        this.activity = activity;
        View viewInflate = ((LayoutInflater) activity.getSystemService("layout_inflater")).inflate(activity.getResources().getIdentifier("popup", "layout", this.activity.getPackageName()), (ViewGroup) null, false);
        this.popupView = viewInflate;
        setContentView(viewInflate);
        setSoftInputMode(21);
        setInputMethodMode(1);
        this.parentView = viewGroup;
        setWidth(0);
        setHeight(-1);
        setBackgroundDrawable(new ColorDrawable(0));
        showAtLocation(this.parentView, 0, 0, 0);
        this.navBarHeight = getNavigationBarHeight();
        this.popupView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                if (KeyboardProvider.this.popupView != null) {
                    KeyboardProvider.this.handleOnGlobalLayout();
                }
            }
        });
        this.navigationBarHeight = getNavigationBarHeight(this.activity);
        this.statusBarHeight = getStatusBarHeight(this.activity);
    }

    public void disable() {
        dismiss();
    }

    private int getScreenOrientation() {
        return this.activity.getResources().getConfiguration().orientation;
    }

    private void SetHeightMax(int i) {
        if (this.heightMax == 0) {
            this.heightMax = i;
        }
    }

    public static void GetDisplayMetricsAreaSize(Activity activity, int[] iArr) {
        GetDisplayMetricsAreaSize_Version17(activity, iArr);
    }

    public static void GetDisplayMetricsAreaSize_Version17(Activity activity, int[] iArr) {
        DisplayMetrics displayMetrics = new DisplayMetrics();
        Display defaultDisplay = activity.getWindowManager().getDefaultDisplay();
        defaultDisplay.getRealMetrics(displayMetrics);
        iArr[0] = 0;
        iArr[1] = 0;
        iArr[2] = displayMetrics.widthPixels;
        iArr[3] = displayMetrics.heightPixels;
        try {
            Field declaredField = Display.class.getDeclaredField("mDisplayInfo");
            declaredField.setAccessible(true);
            Object obj = declaredField.get(defaultDisplay);
            Field declaredField2 = obj.getClass().getDeclaredField("logicalWidth");
            Field declaredField3 = obj.getClass().getDeclaredField("logicalHeight");
            declaredField2.setAccessible(true);
            declaredField3.setAccessible(true);
            int i = declaredField2.getInt(obj);
            int i2 = declaredField3.getInt(obj);
            iArr[2] = i;
            iArr[3] = i2;
        } catch (Exception unused) {
            iArr[2] = displayMetrics.widthPixels;
            iArr[3] = displayMetrics.heightPixels;
        }
    }

    public static void GetDisplayMetricsAreaSize_Version14(Activity activity, int[] iArr) {
        int iIntValue;
        int iIntValue2;
        Display defaultDisplay = activity.getWindowManager().getDefaultDisplay();
        try {
            iIntValue = ((Integer) Display.class.getMethod("getRawWidth", null).invoke(defaultDisplay, null)).intValue();
            iIntValue2 = ((Integer) Display.class.getMethod("getRawHeight", null).invoke(defaultDisplay, null)).intValue();
        } catch (Exception unused) {
            DisplayMetrics displayMetrics = new DisplayMetrics();
            defaultDisplay.getMetrics(displayMetrics);
            int i = displayMetrics.widthPixels;
            int i2 = displayMetrics.heightPixels;
            iIntValue = i;
            iIntValue2 = i2;
        }
        iArr[0] = 0;
        iArr[1] = 0;
        iArr[2] = iIntValue;
        iArr[3] = iIntValue2;
    }

    public static void GetDisplayMetricsAreaSize_VersionCompatible(Activity activity, int[] iArr) {
        Display defaultDisplay = activity.getWindowManager().getDefaultDisplay();
        DisplayMetrics displayMetrics = new DisplayMetrics();
        defaultDisplay.getMetrics(displayMetrics);
        iArr[0] = 0;
        iArr[1] = 0;
        iArr[2] = displayMetrics.widthPixels;
        iArr[3] = displayMetrics.heightPixels;
    }

    public void handleOnGlobalLayout() {
        WindowInsets rootWindowInsets;
        Point point = new Point();
        this.activity.getWindowManager().getDefaultDisplay().getSize(point);
        int[] iArr = new int[4];
        GetDisplayMetricsAreaSize(this.activity, iArr);
        Rect rect = new Rect();
        this.popupView.getWindowVisibleDisplayFrame(rect);
        if (rect.bottom > this.heightMax) {
            SetHeightMax(rect.bottom);
        }
        int i = this.heightMax - rect.bottom;
        float f = (iArr[3] - rect.bottom) / iArr[3];
        int screenOrientation = getScreenOrientation();
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("SDK_INIT", Build.VERSION.SDK_INT);
            jSONObject.put("hSize2", iArr[2]);
            jSONObject.put("hSize3", iArr[3]);
            jSONObject.put("heightMax", this.heightMax);
            jSONObject.put("recttop", rect.top);
            jSONObject.put("rectbottom", rect.bottom);
            jSONObject.put("keyboardHeight", i);
            jSONObject.put("screenSizeX", point.x);
            jSONObject.put("screenSizeY", point.y);
            DisplayMetrics displayMetrics = this.activity.getResources().getDisplayMetrics();
            jSONObject.put("activitySizeX", displayMetrics.widthPixels);
            jSONObject.put("activitySizeY", displayMetrics.heightPixels);
            jSONObject.put("activityDensityDpi", displayMetrics.densityDpi);
            jSONObject.put("activityDensity", displayMetrics.density);
            View decorView = this.activity.getWindow().getDecorView();
            jSONObject.put("DecorViewSizeX", decorView.getWidth());
            jSONObject.put("DecorViewSizeY", decorView.getHeight());
            jSONObject.put("navHeight", this.navigationBarHeight);
            jSONObject.put("statHeight", this.statusBarHeight);
        } catch (JSONException unused) {
        }
        try {
            if (Build.VERSION.SDK_INT >= 30 && (rootWindowInsets = this.activity.getWindow().getDecorView().getRootWindowInsets()) != null) {
                boolean zM = Udid$.ExternalSyntheticApiModelOutline0.m(rootWindowInsets, Udid$.ExternalSyntheticApiModelOutline0.m());
                int iM = Udid$.ExternalSyntheticApiModelOutline0.m(Udid$.ExternalSyntheticApiModelOutline0.m(rootWindowInsets, Udid$.ExternalSyntheticApiModelOutline0.m()));
                jSONObject.put("imeVisible", zM);
                jSONObject.put("imeHeight", iM);
            }
        } catch (JSONException unused2) {
        }
        if (i == 0) {
            EditText editText = this.lastFocusedEditText;
            notifyKeyboardHeight(0.0f, 0, screenOrientation, 0.0f, 0.0f, jSONObject.toString(), editText != null ? String.valueOf(editText.getId()) : "none");
        } else if (screenOrientation == 1) {
            this.keyboardPortraitHeight = i;
            notifyKeyboardHeight(f, i, screenOrientation, 0.0f, 0.0f, jSONObject.toString(), getFocusedInputField());
        } else {
            this.keyboardLandscapeHeight = i;
            float f2 = rect.left / rect.right;
            notifyKeyboardHeight(f, this.keyboardLandscapeHeight, screenOrientation, f2, ((double) f2) > 0.001d ? getNavigationBarHeight() / rect.right : 0.0f, jSONObject.toString(), getFocusedInputField());
        }
    }

    private String getFocusedInputField() {
        View currentFocus = this.activity.getCurrentFocus();
        if (currentFocus instanceof EditText) {
            EditText editText = (EditText) currentFocus;
            this.lastFocusedEditText = editText;
            return String.valueOf(editText.getId());
        }
        return "none";
    }

    private int GetNavigationBarHeight() {
        if (this.navigationBarHeight != 0) {
            Resources resources = this.activity.getResources();
            this.navigationBarHeight = resources.getDimensionPixelSize(resources.getIdentifier("navigation_bar_height", "dimen", "android"));
        }
        return this.navigationBarHeight;
    }

    private int getNavigationBarHeight() {
        Resources resources;
        int identifier;
        if (hasSoftKeys() && (identifier = (resources = this.activity.getResources()).getIdentifier("navigation_bar_height", "dimen", "android")) > 0) {
            return resources.getDimensionPixelSize(identifier);
        }
        return 0;
    }

    public static int getStatusBarHeight(Context context) {
        int identifier = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (identifier > 0) {
            return context.getResources().getDimensionPixelSize(identifier);
        }
        return 0;
    }

    public static int getNavigationBarHeight(Context context) {
        int identifier = context.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
        if (identifier > 0) {
            return context.getResources().getDimensionPixelSize(identifier);
        }
        return 0;
    }

    public boolean hasSoftKeys() {
        Display defaultDisplay = this.activity.getWindowManager().getDefaultDisplay();
        DisplayMetrics displayMetrics = new DisplayMetrics();
        defaultDisplay.getRealMetrics(displayMetrics);
        int i = displayMetrics.heightPixels;
        int i2 = displayMetrics.widthPixels;
        DisplayMetrics displayMetrics2 = new DisplayMetrics();
        defaultDisplay.getMetrics(displayMetrics2);
        return i2 - displayMetrics2.widthPixels > 0 || i - displayMetrics2.heightPixels > 0;
    }

    private void notifyKeyboardHeight(float f, int i, int i2, float f2, float f3, String str, String str2) {
        KeyboardObserver keyboardObserver = this.observer;
        if (keyboardObserver != null) {
            keyboardObserver.onKeyboardHeight(f, i, i2, f2, f3, str, str2);
        }
    }
}
