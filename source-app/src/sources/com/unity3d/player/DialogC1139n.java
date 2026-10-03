package com.unity3d.player;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.view.inputmethod.InputMethodSubtype;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.ishumei.smantifraud.l11l11lI1lll;

public final class DialogC1139n extends Dialog implements TextWatcher, View.OnClickListener {

    private static int f459d = 1627389952;

    private static int f460e = -1;

    boolean f461a;

    private Context f462b;

    private UnityPlayer f463c;

    private int f464f;

    public DialogC1139n(Context context, UnityPlayer unityPlayer, String str, int i, boolean z, boolean z2, boolean z3, String str2, int i2, boolean z4, boolean z5) {
        super(context);
        this.f462b = context;
        this.f463c = unityPlayer;
        Window window = getWindow();
        this.f461a = z5;
        window.requestFeature(1);
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.x = 0;
        attributes.y = 0;
        window.setAttributes(attributes);
        window.setBackgroundDrawable(new ColorDrawable(0));
        final View viewCreateSoftInputView = createSoftInputView();
        setContentView(viewCreateSoftInputView);
        window.setLayout(-1, -2);
        window.clearFlags(2);
        window.clearFlags(134217728);
        window.clearFlags(67108864);
        if (!this.f461a) {
            window.addFlags(32);
            window.addFlags(262144);
        }
        EditText editText = (EditText) findViewById(1057292289);
        Button button = (Button) findViewById(1057292290);
        m665a(editText, str, i, z, z2, z3, str2, i2);
        button.setOnClickListener(this);
        this.f464f = editText.getCurrentTextColor();
        m675a(z4);
        window.addFlags(524288);
        this.f463c.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public final void onGlobalLayout() {
                if (viewCreateSoftInputView.isShown()) {
                    Rect rect = new Rect();
                    DialogC1139n.this.f463c.getWindowVisibleDisplayFrame(rect);
                    int[] iArr = new int[2];
                    DialogC1139n.this.f463c.getLocationOnScreen(iArr);
                    Point point = new Point(rect.left - iArr[0], rect.height() - viewCreateSoftInputView.getHeight());
                    Point point2 = new Point();
                    DialogC1139n.this.getWindow().getWindowManager().getDefaultDisplay().getSize(point2);
                    int height = DialogC1139n.this.f463c.getHeight() - point2.y;
                    int height2 = DialogC1139n.this.f463c.getHeight() - point.y;
                    if (height2 != height + viewCreateSoftInputView.getHeight()) {
                        DialogC1139n.this.f463c.reportSoftInputIsVisible(true);
                    } else {
                        DialogC1139n.this.f463c.reportSoftInputIsVisible(false);
                    }
                    DialogC1139n.this.f463c.reportSoftInputArea(new Rect(point.x, point.y, viewCreateSoftInputView.getWidth(), height2));
                }
            }
        });
        editText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z6) {
                if (z6) {
                    DialogC1139n.this.getWindow().setSoftInputMode(5);
                }
            }
        });
        editText.requestFocus();
    }

    private static int m663a(int i, boolean z, boolean z2, boolean z3) {
        int i2 = (z ? 32768 : 524288) | (z2 ? 131072 : 0) | (z3 ? 128 : 0);
        if (i < 0 || i > 11) {
            return i2;
        }
        int i3 = new int[]{1, 16385, 12290, 17, 2, 3, 8289, 33, 1, 16417, 17, 8194}[i];
        return (i3 & 2) != 0 ? i3 : i3 | i2;
    }

    private void m665a(EditText editText, String str, int i, boolean z, boolean z2, boolean z3, String str2, int i2) {
        editText.setImeOptions(6);
        editText.setText(str);
        editText.setHint(str2);
        editText.setHintTextColor(f459d);
        editText.setInputType(m663a(i, z, z2, z3));
        editText.setImeOptions(33554432);
        if (i2 > 0) {
            editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(i2)});
        }
        editText.addTextChangedListener(this);
        editText.setSelection(editText.getText().length());
        editText.setClickable(true);
    }

    public void m667a(String str, boolean z) {
        ((EditText) findViewById(1057292289)).setSelection(0, 0);
        this.f463c.reportSoftInputStr(str, 1, z);
    }

    public String m668b() {
        EditText editText = (EditText) findViewById(1057292289);
        if (editText == null) {
            return null;
        }
        return editText.getText().toString();
    }

    public final String m671a() {
        InputMethodSubtype currentInputMethodSubtype = ((InputMethodManager) this.f462b.getSystemService("input_method")).getCurrentInputMethodSubtype();
        if (currentInputMethodSubtype == null) {
            return null;
        }
        String locale = currentInputMethodSubtype.getLocale();
        if (locale != null && !locale.equals("")) {
            return locale;
        }
        return currentInputMethodSubtype.getMode() + " " + currentInputMethodSubtype.getExtraValue();
    }

    public final void m672a(int i) {
        EditText editText = (EditText) findViewById(1057292289);
        if (editText != null) {
            if (i > 0) {
                editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(i)});
            } else {
                editText.setFilters(new InputFilter[0]);
            }
        }
    }

    public final void m673a(int i, int i2) {
        int i3;
        EditText editText = (EditText) findViewById(1057292289);
        if (editText == null || editText.getText().length() < (i3 = i2 + i)) {
            return;
        }
        editText.setSelection(i, i3);
    }

    public final void m674a(String str) {
        EditText editText = (EditText) findViewById(1057292289);
        if (editText != null) {
            editText.setText(str);
            editText.setSelection(str.length());
        }
    }

    public final void m675a(boolean z) {
        EditText editText = (EditText) findViewById(1057292289);
        Button button = (Button) findViewById(1057292290);
        View viewFindViewById = findViewById(1057292291);
        if (!z) {
            editText.setBackgroundColor(f460e);
            editText.setTextColor(this.f464f);
            editText.setCursorVisible(true);
            editText.setOnClickListener(null);
            editText.setLongClickable(true);
            editText.setTextIsSelectable(true);
            button.setClickable(true);
            button.setTextColor(this.f464f);
            viewFindViewById.setBackgroundColor(f460e);
            return;
        }
        editText.setBackgroundColor(0);
        editText.setTextColor(0);
        editText.setCursorVisible(false);
        editText.setOnClickListener(this);
        editText.setHighlightColor(0);
        editText.setLongClickable(false);
        editText.setTextIsSelectable(false);
        button.setTextColor(0);
        viewFindViewById.setBackgroundColor(0);
        viewFindViewById.setOnClickListener(this);
    }

    @Override
    public final void afterTextChanged(Editable editable) {
        this.f463c.reportSoftInputStr(editable.toString(), 0, false);
    }

    @Override
    public final void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
    }

    protected final View createSoftInputView() {
        RelativeLayout relativeLayout = new RelativeLayout(this.f462b);
        relativeLayout.setLayoutParams(new ViewGroup.LayoutParams(-1, -1));
        relativeLayout.setBackgroundColor(f460e);
        relativeLayout.setId(1057292291);
        EditText editText = new EditText(this.f462b) {
            @Override
            public final boolean onKeyPreIme(int i, KeyEvent keyEvent) {
                if (i == 4) {
                    DialogC1139n dialogC1139n = DialogC1139n.this;
                    dialogC1139n.m667a(dialogC1139n.m668b(), true);
                    return true;
                }
                if (i == 84) {
                    return true;
                }
                return super.onKeyPreIme(i, keyEvent);
            }

            @Override
            protected final void onSelectionChanged(int i, int i2) {
                DialogC1139n.this.f463c.reportSoftInputSelection(i, i2 - i);
            }

            @Override
            public final void onWindowFocusChanged(boolean z) {
                super.onWindowFocusChanged(z);
                if (z) {
                    ((InputMethodManager) DialogC1139n.this.f462b.getSystemService("input_method")).showSoftInput(this, 0);
                }
            }
        };
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(-1, -2);
        layoutParams.addRule(15);
        layoutParams.addRule(0, 1057292290);
        editText.setLayoutParams(layoutParams);
        editText.setId(1057292289);
        relativeLayout.addView(editText);
        Button button = new Button(this.f462b);
        button.setText(this.f462b.getResources().getIdentifier("ok", "string", l11l11lI1lll.l111l1111l1Il));
        RelativeLayout.LayoutParams layoutParams2 = new RelativeLayout.LayoutParams(-2, -2);
        layoutParams2.addRule(15);
        layoutParams2.addRule(11);
        button.setLayoutParams(layoutParams2);
        button.setId(1057292290);
        button.setBackgroundColor(0);
        relativeLayout.addView(button);
        ((EditText) relativeLayout.findViewById(1057292289)).setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public final boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                if (i == 6) {
                    DialogC1139n dialogC1139n = DialogC1139n.this;
                    dialogC1139n.m667a(dialogC1139n.m668b(), false);
                }
                return false;
            }
        });
        relativeLayout.setPadding(16, 16, 16, 16);
        return relativeLayout;
    }

    @Override
    public final boolean dispatchTouchEvent(MotionEvent motionEvent) {
        if (this.f461a || motionEvent.getAction() != 4) {
            return super.dispatchTouchEvent(motionEvent);
        }
        return true;
    }

    @Override
    public final void onBackPressed() {
        m667a(m668b(), true);
    }

    @Override
    public final void onClick(View view) {
        m667a(m668b(), false);
    }

    @Override
    public final void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
    }
}
