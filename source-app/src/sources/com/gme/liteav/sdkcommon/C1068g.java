package com.gme.liteav.sdkcommon;

import android.R;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import androidx.core.internal.view.SupportMenu;

final class C1068g {

    final Context f800c;

    final ArrayAdapter<String> f802e;

    WindowManager f803f;

    View f804g;

    TextView f805h;

    TextView f806i;

    Spinner f807j;

    ScrollView f808k;

    String f809l;

    final a f812o;

    final DisplayMetrics f798a = new DisplayMetrics();

    final WindowManager.LayoutParams f799b = new WindowManager.LayoutParams();

    private final int f813p = SupportMenu.CATEGORY_MASK;

    private boolean f814q = false;

    boolean f810m = false;

    int f811n = 1920;

    final Handler f801d = new Handler(Looper.getMainLooper());

    public interface a {
        void mo1042a(int i);
    }

    public C1068g(Context context, a aVar) {
        this.f800c = context;
        this.f812o = aVar;
        this.f802e = new ArrayAdapter<>(context, R.layout.simple_spinner_item);
    }

    public final void m1052a(boolean z) {
        if (z == this.f814q) {
            return;
        }
        if (z) {
            this.f803f.addView(this.f804g, this.f799b);
        } else {
            this.f803f.removeView(this.f804g);
        }
        this.f814q = z;
    }

    public final void m1051a(String str) {
        TextView textView = this.f806i;
        if (textView != null) {
            textView.setText(str);
        }
        this.f801d.post(RunnableC1069h.m1055a(this));
    }

    public final void m1054b(String str) {
        TextView textView = this.f805h;
        if (textView != null) {
            textView.setText(str);
        }
    }

    final void m1050a() {
        TextView textView;
        Spinner spinner = this.f807j;
        if (spinner == null || (textView = (TextView) spinner.getChildAt(spinner.getSelectedItemPosition())) == null) {
            return;
        }
        textView.setTextColor(SupportMenu.CATEGORY_MASK);
    }

    final int m1049a(int i) {
        return (int) ((i * this.f800c.getResources().getDisplayMetrics().density) + 0.5f);
    }

    final int m1053b() {
        return Math.max((this.f799b.height - m1049a(230)) - m1049a(20), 0);
    }

    class c implements AdapterView.OnItemSelectedListener {
        @Override
        public final void onNothingSelected(AdapterView<?> adapterView) {
        }

        private c() {
        }

        c(C1068g c1068g, byte b) {
            this();
        }

        @Override
        public final void onItemSelected(AdapterView<?> adapterView, View view, int i, long j) {
            if (view == null) {
                return;
            }
            ((TextView) view).setTextColor(SupportMenu.CATEGORY_MASK);
            C1068g c1068g = C1068g.this;
            c1068g.f809l = c1068g.f802e.getItem(i);
            C1068g.this.f812o.mo1042a(i);
        }
    }

    class b implements View.OnTouchListener {

        private int f816b;

        private int f817c;

        private b() {
        }

        b(C1068g c1068g, byte b) {
            this();
        }

        @Override
        public final boolean onTouch(View view, MotionEvent motionEvent) {
            int action = motionEvent.getAction();
            if (action == 0) {
                this.f816b = (int) motionEvent.getRawX();
                this.f817c = (int) motionEvent.getRawY();
            } else if (action == 2) {
                int rawX = (int) motionEvent.getRawX();
                int rawY = (int) motionEvent.getRawY();
                int i = rawX - this.f816b;
                int i2 = rawY - this.f817c;
                C1068g.this.f799b.x += i;
                C1068g.this.f799b.y += i2;
                this.f816b = rawX;
                this.f817c = rawY;
                C1068g.this.f799b.x = Math.max(C1068g.this.f799b.x, 0);
                C1068g.this.f799b.y = Math.max(C1068g.this.f799b.y, 0);
                if (C1068g.this.f799b.x + C1068g.this.f798a.widthPixels > C1068g.this.f798a.widthPixels) {
                    C1068g.this.f799b.width = C1068g.this.f798a.widthPixels - C1068g.this.f799b.x;
                } else {
                    C1068g.this.f799b.width = C1068g.this.f798a.widthPixels;
                }
                C1068g.this.f799b.height = C1068g.this.f811n;
                if (C1068g.this.f810m) {
                    C1068g.this.f799b.height = C1068g.this.f811n / 2;
                }
                if (C1068g.this.f799b.y + C1068g.this.f799b.height > C1068g.this.f798a.heightPixels) {
                    C1068g.this.f799b.height = C1068g.this.f798a.heightPixels - C1068g.this.f799b.y;
                }
                ViewGroup.LayoutParams layoutParams = C1068g.this.f808k.getLayoutParams();
                layoutParams.height = C1068g.this.m1053b();
                C1068g.this.f808k.setLayoutParams(layoutParams);
                C1068g.this.f803f.updateViewLayout(view, C1068g.this.f799b);
            }
            view.performClick();
            return false;
        }
    }
}
