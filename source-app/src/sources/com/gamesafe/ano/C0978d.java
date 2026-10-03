package com.gamesafe.ano;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import com.facebook.internal.security.CertificateUtil;
import java.util.Locale;

public class C0978d implements InterfaceC0981g {

    private Context f542b;

    private String f543c;

    private String f544d;

    private String f545e;

    private int f546f;

    private int f547g;

    private int f548h;

    private InterfaceC0981g.a f549i;

    AlertDialog f541a = null;

    private DialogInterface.OnDismissListener f550j = new DialogInterfaceOnDismissListenerC0979e(this);

    public C0978d(Context context, String str, String str2, String str3, int i, int i2, InterfaceC0981g.a aVar) {
        this.f542b = context;
        this.f543c = str;
        this.f544d = str2;
        this.f545e = str3;
        this.f546f = i;
        this.f547g = i2;
        this.f549i = aVar;
    }

    private int m858a(Context context, int i) {
        return (int) ((i * context.getResources().getDisplayMetrics().density) + 0.5f);
    }

    private Drawable m860a(Context context, String str, boolean z) {
        PackageManager packageManager = context.getPackageManager();
        try {
            Drawable drawableLoadIcon = packageManager.getPackageInfo(str, 0).applicationInfo.loadIcon(packageManager);
            if (z) {
                m863a(context, drawableLoadIcon);
            }
            return drawableLoadIcon;
        } catch (PackageManager.NameNotFoundException unused) {
            return null;
        }
    }

    private TextView m861a(String str) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        TextView textView = new TextView(this.f542b);
        textView.setLayoutParams(layoutParams);
        textView.setText(str);
        m865a(textView);
        return textView;
    }

    private void m863a(Context context, Drawable drawable) {
        if (drawable != null) {
            int iM858a = m858a(context, 36);
            drawable.setBounds(0, 0, iM858a, iM858a);
        }
    }

    private void m864a(SeekBar seekBar) {
        int iM858a = m858a(this.f542b, 20);
        int iM858a2 = m858a(this.f542b, 1);
        int iM858a3 = m858a(this.f542b, 5);
        seekBar.setBackgroundColor(Color.parseColor("#000000"));
        seekBar.setPadding(iM858a, iM858a2, iM858a, iM858a3);
    }

    private void m865a(TextView textView) {
        int iM858a = m858a(this.f542b, 20);
        int iM858a2 = m858a(this.f542b, 6);
        int iM858a3 = m858a(this.f542b, 10);
        textView.setTextColor(Color.parseColor("#FFFFFF"));
        textView.setTextSize(2, 18.0f);
        textView.setBackgroundColor(Color.parseColor("#000000"));
        textView.setPadding(iM858a, iM858a2, iM858a, iM858a3);
    }

    private View m868d() {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        int iM858a = m858a(this.f542b, 10);
        int i = iM858a / 2;
        layoutParams.setMargins(iM858a, i, iM858a, i);
        LinearLayout linearLayout = new LinearLayout(this.f542b);
        linearLayout.setLayoutParams(layoutParams);
        linearLayout.setOrientation(1);
        linearLayout.addView(m869e());
        linearLayout.addView(m870f());
        return linearLayout;
    }

    private TextView m869e() {
        String str;
        ViewGroup.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        TextView textView = new TextView(this.f542b);
        textView.setLayoutParams(layoutParams);
        textView.setText(this.f543c);
        textView.setGravity(17);
        m865a(textView);
        String[] strArrSplit = this.f543c.split(CertificateUtil.DELIMITER);
        if (strArrSplit != null && strArrSplit.length == 3) {
            Drawable drawableM860a = m860a(this.f542b, strArrSplit[1], true);
            if (drawableM860a != null) {
                textView.setCompoundDrawables(drawableM860a, null, null, null);
                str = "  " + strArrSplit[2];
            } else {
                str = strArrSplit[2];
            }
            textView.setText(str);
        }
        return textView;
    }

    private View m870f() {
        LinearLayout linearLayout = new LinearLayout(this.f542b);
        linearLayout.setOrientation(1);
        linearLayout.addView(m861a(this.f544d));
        TextView textViewM861a = m861a(String.format(Locale.ENGLISH, "%s%d", this.f545e, 0));
        SeekBar seekBar = new SeekBar(this.f542b);
        seekBar.setMax(this.f546f);
        seekBar.setKeyProgressIncrement(1);
        m864a(seekBar);
        seekBar.setOnSeekBarChangeListener(new C0980f(this, textViewM861a));
        linearLayout.addView(seekBar);
        linearLayout.addView(textViewM861a);
        return linearLayout;
    }

    @Override
    public void mo871a() {
        if (this.f544d == null || this.f545e == null || this.f546f < this.f547g) {
            return;
        }
        AlertDialog.Builder builder = new AlertDialog.Builder(this.f542b, 1);
        builder.setCancelable(false);
        builder.setView(m868d());
        AlertDialog alertDialogCreate = builder.create();
        this.f541a = alertDialogCreate;
        alertDialogCreate.setOnDismissListener(this.f550j);
        this.f541a.show();
        m872b();
    }

    protected void m872b() {
        AlertDialog alertDialog;
        float f;
        float f2;
        if (this.f542b == null || (alertDialog = this.f541a) == null) {
            return;
        }
        WindowManager.LayoutParams attributes = alertDialog.getWindow().getAttributes();
        Display defaultDisplay = ((WindowManager) this.f542b.getSystemService(C0975a.m846a("rdiyjr"))).getDefaultDisplay();
        Point point = new Point();
        defaultDisplay.getSize(point);
        if (point.y > point.x) {
            f = point.x;
            f2 = 0.9f;
        } else {
            f = point.x;
            f2 = 0.6f;
        }
        attributes.width = (int) (f * f2);
        this.f541a.getWindow().setAttributes(attributes);
        this.f541a.getWindow().setGravity(17);
        this.f541a.setCanceledOnTouchOutside(false);
    }

    @Override
    public void mo873c() {
        AlertDialog alertDialog = this.f541a;
        if (alertDialog != null) {
            alertDialog.dismiss();
            this.f541a = null;
        }
    }
}
