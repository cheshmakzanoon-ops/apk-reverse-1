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
import android.widget.TextView;
import com.facebook.internal.security.CertificateUtil;

public class C0985k implements InterfaceC0981g {

    private Context f560b;

    private String f561c;

    private String f562d;

    private String f563e;

    private InterfaceC0981g.a f564f;

    AlertDialog f559a = null;

    private DialogInterface.OnDismissListener f565g = new DialogInterfaceOnDismissListenerC0986l(this);

    public C0985k(Context context, String str, String str2, String str3, InterfaceC0981g.a aVar) {
        this.f560b = context;
        this.f562d = str;
        this.f561c = str2;
        this.f563e = str3;
        this.f564f = aVar;
    }

    private int m898a(Context context, int i) {
        return (int) ((i * context.getResources().getDisplayMetrics().density) + 0.5f);
    }

    private Drawable m899a(Context context, String str, boolean z) {
        PackageManager packageManager = context.getPackageManager();
        try {
            Drawable drawableLoadIcon = packageManager.getPackageInfo(str, 0).applicationInfo.loadIcon(packageManager);
            if (z) {
                m901a(context, drawableLoadIcon);
            }
            return drawableLoadIcon;
        } catch (PackageManager.NameNotFoundException unused) {
            return null;
        }
    }

    private void m901a(Context context, Drawable drawable) {
        if (drawable != null) {
            int iM898a = m898a(context, 36);
            drawable.setBounds(0, 0, iM898a, iM898a);
        }
    }

    private void m902a(TextView textView) {
        int iM898a = m898a(this.f560b, 10);
        int iM898a2 = m898a(this.f560b, 6);
        int iM898a3 = m898a(this.f560b, 10);
        textView.setTextColor(Color.parseColor("#FFFFFF"));
        textView.setTextSize(2, 18.0f);
        textView.setBackgroundColor(Color.parseColor("#000000"));
        textView.setPadding(iM898a, iM898a2, iM898a, iM898a3);
    }

    private View m903d() {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        int iM898a = m898a(this.f560b, 10);
        int i = iM898a / 2;
        layoutParams.setMargins(iM898a, i, iM898a, i);
        LinearLayout linearLayout = new LinearLayout(this.f560b);
        linearLayout.setLayoutParams(layoutParams);
        linearLayout.setOrientation(1);
        linearLayout.addView(m904e());
        linearLayout.addView(m905f());
        return linearLayout;
    }

    private TextView m904e() {
        String str;
        ViewGroup.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        TextView textView = new TextView(this.f560b);
        textView.setLayoutParams(layoutParams);
        textView.setText(this.f562d);
        textView.setGravity(17);
        m902a(textView);
        String[] strArrSplit = this.f562d.split(CertificateUtil.DELIMITER);
        if (strArrSplit != null && strArrSplit.length == 3) {
            Drawable drawableM899a = m899a(this.f560b, strArrSplit[1], true);
            if (drawableM899a != null) {
                textView.setCompoundDrawables(drawableM899a, null, null, null);
                str = "  " + strArrSplit[2];
            } else {
                str = strArrSplit[2];
            }
            textView.setText(str);
        }
        return textView;
    }

    private TextView m905f() {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        TextView textView = new TextView(this.f560b);
        textView.setLayoutParams(layoutParams);
        textView.setText(this.f561c);
        m902a(textView);
        return textView;
    }

    @Override
    public void mo871a() {
        View viewM903d;
        AlertDialog.Builder builder = new AlertDialog.Builder(this.f560b, 1);
        builder.setCancelable(false);
        String str = this.f562d;
        if (str == null || !str.startsWith("ICON:")) {
            TextView textView = new TextView(this.f560b);
            textView.setText(this.f561c);
            m902a(textView);
            viewM903d = textView;
        } else {
            viewM903d = m903d();
        }
        builder.setView(viewM903d);
        builder.setNeutralButton(this.f563e, (DialogInterface.OnClickListener) null);
        AlertDialog alertDialogCreate = builder.create();
        this.f559a = alertDialogCreate;
        alertDialogCreate.setOnDismissListener(this.f565g);
        this.f559a.setOnShowListener(new DialogInterfaceOnShowListenerC0987m(this));
        this.f559a.show();
        m906b();
    }

    protected void m906b() {
        AlertDialog alertDialog;
        float f;
        float f2;
        if (this.f560b == null || (alertDialog = this.f559a) == null) {
            return;
        }
        WindowManager.LayoutParams attributes = alertDialog.getWindow().getAttributes();
        Display defaultDisplay = ((WindowManager) this.f560b.getSystemService(C0975a.m846a("rdiyjr"))).getDefaultDisplay();
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
        this.f559a.getWindow().setAttributes(attributes);
        this.f559a.getWindow().setGravity(17);
        this.f559a.setCanceledOnTouchOutside(false);
    }

    @Override
    public void mo873c() {
        AlertDialog alertDialog = this.f559a;
        if (alertDialog != null) {
            alertDialog.dismiss();
            this.f559a = null;
        }
    }
}
