package com.gme.liteav.sdkcommon;

import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.SpinnerAdapter;
import android.widget.TextView;
import android.widget.Toast;
import androidx.core.internal.view.SupportMenu;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import com.gme.liteav.base.util.LiteavLog;
import com.gme.trtc.hardwareearmonitor.honor.HonorResultCode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@JNINamespace("liteav::dashboard")
public class DashboardManager {
    private static final int LOG_MAX_SIZE = 15000;
    private static final String TAG = "DashboardManager";
    private final Context mAppContext;
    private final C1068g mDashboardManagerView;
    private boolean mIsInit;
    private final C1068g.a mSelectedDashboardChangeListener;
    private String mSelectedDashboardId;
    private final Handler mUIHandler;
    private final ArrayList<String> mDashboards = new ArrayList<>();
    private final Map<String, String> mDashboardStatus = new HashMap();
    private final Map<String, StringBuilder> mDashboardLogs = new HashMap();

    public DashboardManager() {
        C1068g.a aVar = new C1068g.a() {
            @Override
            public final void mo1042a(int i) {
                if (DashboardManager.this.mDashboards.size() <= i) {
                    return;
                }
                DashboardManager dashboardManager = DashboardManager.this;
                dashboardManager.mSelectedDashboardId = (String) dashboardManager.mDashboards.get(i);
                if (DashboardManager.this.mDashboards.contains(DashboardManager.this.mSelectedDashboardId)) {
                    DashboardManager.this.mDashboardManagerView.m1054b((String) DashboardManager.this.mDashboardStatus.get(DashboardManager.this.mSelectedDashboardId));
                    StringBuilder sb = (StringBuilder) DashboardManager.this.mDashboardLogs.get(DashboardManager.this.mSelectedDashboardId);
                    if (sb != null) {
                        DashboardManager.this.mDashboardManagerView.m1051a(sb.toString());
                    } else {
                        DashboardManager.this.mDashboardManagerView.m1051a("");
                    }
                }
            }
        };
        this.mSelectedDashboardChangeListener = aVar;
        LiteavLog.m998i(TAG, "java DashBoardManager Construct");
        this.mIsInit = false;
        Context applicationContext = ContextUtils.getApplicationContext();
        this.mAppContext = applicationContext;
        this.mDashboardManagerView = new C1068g(applicationContext, aVar);
        this.mUIHandler = new Handler(Looper.getMainLooper());
    }

    public int showDashboard(boolean z) {
        LiteavLog.m998i(TAG, "showDashBoard isShow = ".concat(String.valueOf(z)));
        this.mUIHandler.post(RunnableC1062a.m1043a(this, z));
        return 0;
    }

    public int addDashboard(String str) {
        LiteavLog.m998i(TAG, "addDashboard dashboardId = ".concat(String.valueOf(str)));
        this.mUIHandler.post(RunnableC1063b.m1044a(this, str));
        return 0;
    }

    public int removeDashboard(String str) {
        LiteavLog.m998i(TAG, "removeDashboard dashboardId = ".concat(String.valueOf(str)));
        this.mUIHandler.post(RunnableC1064c.m1045a(this, str));
        return 0;
    }

    public int removeAllDashboard() {
        LiteavLog.m998i(TAG, "removeAllDashboard ");
        this.mUIHandler.post(RunnableC1065d.m1046a(this));
        return 0;
    }

    public int setStatus(String str, String str2) {
        this.mUIHandler.post(RunnableC1066e.m1047a(this, str, str2));
        return 0;
    }

    public int appendLog(String str, String str2) {
        this.mUIHandler.post(RunnableC1067f.m1048a(this, str, str2));
        return 0;
    }

    private boolean checkPermission() {
        if (LiteavSystemInfo.getSystemOSVersionInt() <= 23 || Settings.canDrawOverlays(this.mAppContext)) {
            return true;
        }
        Toast.makeText(this.mAppContext, "no system alert window permission, please authorize", 0).show();
        return false;
    }

    private boolean init() {
        if (this.mIsInit) {
            return true;
        }
        C1068g c1068g = this.mDashboardManagerView;
        if (c1068g.f800c == null) {
            Log.m948e("DashboardManagerView", "dashBoardManagerView context is null", new Object[0]);
        } else {
            c1068g.f803f = (WindowManager) c1068g.f800c.getSystemService("window");
            if (c1068g.f803f == null) {
                Log.m948e("DashboardManagerView", "get windowManager is fail", new Object[0]);
            } else {
                c1068g.f803f.getDefaultDisplay().getMetrics(c1068g.f798a);
                c1068g.f811n = c1068g.f798a.heightPixels - c1068g.m1049a(50);
                C1068g c1068g2 = this.mDashboardManagerView;
                if (Build.VERSION.SDK_INT >= 26) {
                    c1068g2.f799b.type = 2038;
                } else {
                    c1068g2.f799b.type = HonorResultCode.ADVANCED_RECORD_SERVICE_LINKFAIL;
                }
                c1068g2.f799b.format = 1;
                c1068g2.f799b.gravity = 8388659;
                c1068g2.f799b.width = c1068g2.f798a.widthPixels;
                c1068g2.f799b.height = c1068g2.f811n;
                c1068g2.f799b.x = 0;
                c1068g2.f799b.y = 0;
                c1068g2.f799b.flags = 32;
                LinearLayout linearLayout = new LinearLayout(c1068g2.f800c);
                linearLayout.setLayoutParams(new ViewGroup.LayoutParams(-1, -1));
                linearLayout.setOrientation(1);
                linearLayout.setOnTouchListener(new C1068g.b(c1068g2, (byte) 0));
                LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(c1068g2.m1049a(70), c1068g2.m1049a(40));
                Button button = new Button(c1068g2.f800c);
                button.setText("Resize");
                button.setLayoutParams(layoutParams);
                button.setOnClickListener(ViewOnClickListenerC1071j.m1057a(c1068g2, button));
                Button button2 = new Button(c1068g2.f800c);
                button2.setText("close");
                layoutParams.leftMargin = c1068g2.m1049a(10);
                button2.setLayoutParams(layoutParams);
                button2.setOnClickListener(ViewOnClickListenerC1072k.m1058a(c1068g2));
                LinearLayout linearLayout2 = new LinearLayout(c1068g2.f800c);
                linearLayout2.addView(button);
                linearLayout2.addView(button2);
                linearLayout2.setLayoutParams(new ViewGroup.LayoutParams(-1, -2));
                linearLayout2.setOrientation(0);
                linearLayout2.setBackgroundColor(-7829368);
                linearLayout2.setAlpha(0.5f);
                linearLayout.addView(linearLayout2);
                c1068g2.f807j = new Spinner(c1068g2.f800c);
                c1068g2.f807j.setAdapter((SpinnerAdapter) c1068g2.f802e);
                LinearLayout.LayoutParams layoutParams2 = new LinearLayout.LayoutParams(-1, c1068g2.m1049a(30));
                layoutParams2.topMargin = c1068g2.m1049a(2);
                c1068g2.f807j.setLayoutParams(layoutParams2);
                c1068g2.f807j.setOnItemSelectedListener(new C1068g.c(c1068g2, (byte) 0));
                c1068g2.f807j.setBackgroundColor(-7829368);
                c1068g2.f807j.setAlpha(0.5f);
                linearLayout.addView(c1068g2.f807j);
                c1068g2.f805h = new TextView(c1068g2.f800c);
                LinearLayout.LayoutParams layoutParams3 = new LinearLayout.LayoutParams(-1, c1068g2.m1049a(160));
                layoutParams3.topMargin = c1068g2.m1049a(10);
                layoutParams3.leftMargin = c1068g2.m1049a(10);
                layoutParams3.rightMargin = c1068g2.m1049a(3);
                c1068g2.f805h.setLayoutParams(layoutParams3);
                c1068g2.f805h.setTextColor(SupportMenu.CATEGORY_MASK);
                linearLayout.addView(c1068g2.f805h);
                c1068g2.f808k = new ScrollView(c1068g2.f800c);
                LinearLayout.LayoutParams layoutParams4 = new LinearLayout.LayoutParams(-1, c1068g2.m1053b());
                layoutParams4.leftMargin = c1068g2.m1049a(10);
                layoutParams4.rightMargin = c1068g2.m1049a(3);
                c1068g2.f808k.setLayoutParams(layoutParams4);
                c1068g2.f808k.setVerticalScrollBarEnabled(true);
                c1068g2.f806i = new TextView(c1068g2.f800c);
                c1068g2.f806i.setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
                c1068g2.f806i.setTextColor(SupportMenu.CATEGORY_MASK);
                c1068g2.f808k.addView(c1068g2.f806i);
                c1068g2.f808k.fullScroll(130);
                linearLayout.addView(c1068g2.f808k);
                c1068g2.f804g = linearLayout;
                c1068g2.f812o.mo1042a(0);
                this.mIsInit = true;
                return true;
            }
        }
        return false;
    }

    public void showDashboardInternal(boolean z) {
        if (z && (!checkPermission() || !init())) {
            LiteavLog.m998i(TAG, "init or check permission is fail");
        } else {
            this.mDashboardManagerView.m1052a(z);
        }
    }

    public void addDashboardInternal(String str) {
        if (this.mDashboards.contains(str)) {
            return;
        }
        this.mDashboards.add(str);
        C1068g c1068g = this.mDashboardManagerView;
        c1068g.f802e.add(str);
        if (c1068g.f809l == null) {
            c1068g.f809l = c1068g.f802e.getItem(0);
            c1068g.f812o.mo1042a(0);
        }
        c1068g.m1050a();
    }

    public void removeDashboardInternal(String str) {
        if (this.mDashboards.contains(str)) {
            this.mDashboards.remove(str);
            this.mDashboardStatus.remove(str);
            this.mDashboardLogs.remove(str);
            C1068g c1068g = this.mDashboardManagerView;
            if (str.equals(c1068g.f809l)) {
                int position = c1068g.f802e.getPosition(c1068g.f809l);
                if (position != c1068g.f802e.getCount() - 1) {
                    int i = position + 1;
                    c1068g.f809l = c1068g.f802e.getItem(i);
                    c1068g.f812o.mo1042a(position);
                    if (c1068g.f807j != null) {
                        c1068g.f807j.setSelection(i);
                    }
                } else if (position > 0) {
                    int i2 = position - 1;
                    c1068g.f809l = c1068g.f802e.getItem(i2);
                    c1068g.f812o.mo1042a(i2);
                    if (c1068g.f807j != null) {
                        c1068g.f807j.setSelection(i2);
                    }
                }
            }
            c1068g.f802e.remove(str);
            if (c1068g.f802e.getCount() == 0) {
                c1068g.f809l = null;
            }
            c1068g.m1050a();
        }
    }

    public void removeAllDashboardInternal() {
        this.mDashboards.clear();
        this.mDashboardStatus.clear();
        this.mDashboardLogs.clear();
        C1068g c1068g = this.mDashboardManagerView;
        c1068g.f802e.clear();
        c1068g.f809l = null;
        if (c1068g.f805h != null) {
            c1068g.f805h.setText("");
        }
        if (c1068g.f806i != null) {
            c1068g.f806i.setText("");
        }
    }

    public void setStatusInternal(String str, String str2) {
        if (this.mDashboards.contains(str)) {
            this.mDashboardStatus.put(str, str2);
            if (str.equals(this.mSelectedDashboardId)) {
                this.mDashboardManagerView.m1054b(str2);
            }
        }
    }

    public void appendLogInternal(String str, String str2) {
        if (this.mDashboards.contains(str)) {
            StringBuilder sb = this.mDashboardLogs.get(str);
            if (sb == null) {
                sb = new StringBuilder();
                this.mDashboardLogs.put(str, sb);
            }
            sb.append(str2);
            sb.append("\n");
            if (sb.length() > LOG_MAX_SIZE) {
                sb.delete(0, sb.length() / 2);
            }
            if (str.equals(this.mSelectedDashboardId)) {
                C1068g c1068g = this.mDashboardManagerView;
                if (c1068g.f806i != null) {
                    c1068g.f806i.append(str2 + "\n");
                    if (c1068g.f808k == null || c1068g.f808k.getScrollY() + c1068g.f808k.getHeight() + c1068g.m1049a(100) < c1068g.f806i.getMeasuredHeight()) {
                        return;
                    }
                    c1068g.f801d.post(RunnableC1070i.m1056a(c1068g));
                }
            }
        }
    }
}
