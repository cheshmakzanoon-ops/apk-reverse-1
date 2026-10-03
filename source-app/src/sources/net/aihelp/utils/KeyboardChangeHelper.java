package net.aihelp.utils;

import android.app.Activity;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.EditText;

public class KeyboardChangeHelper implements ViewTreeObserver.OnGlobalLayoutListener {
    private View contentView;
    private OnKeyboardShowListener listener;
    private int offset;
    private int rootViewVisibleHeight = 0;
    private EditText targetView;

    public interface OnKeyboardShowListener {
        void onKeyboardHide();

        void onKeyboardShow();
    }

    public KeyboardChangeHelper(View view) {
        this.contentView = view;
        setTranslationOffset(0);
    }

    public static boolean isKeyboardShown(View view) {
        View rootView = view.getRootView();
        Rect rect = new Rect();
        rootView.getWindowVisibleDisplayFrame(rect);
        return ((float) (rootView.getBottom() - rect.bottom)) > rootView.getResources().getDisplayMetrics().density * 100.0f;
    }

    @Override
    public void onGlobalLayout() {
        if (initTargetView()) {
            Rect rect = new Rect();
            this.contentView.getWindowVisibleDisplayFrame(rect);
            int iHeight = rect.height();
            int i = this.rootViewVisibleHeight;
            if (i == 0) {
                this.rootViewVisibleHeight = iHeight;
                return;
            }
            if (i == iHeight) {
                return;
            }
            if (i - iHeight > 200) {
                this.rootViewVisibleHeight = iHeight;
                OnKeyboardShowListener onKeyboardShowListener = this.listener;
                if (onKeyboardShowListener != null) {
                    onKeyboardShowListener.onKeyboardShow();
                }
                layoutResize(true, rect.bottom);
                return;
            }
            if (iHeight - i > 200) {
                this.rootViewVisibleHeight = iHeight;
                OnKeyboardShowListener onKeyboardShowListener2 = this.listener;
                if (onKeyboardShowListener2 != null) {
                    onKeyboardShowListener2.onKeyboardHide();
                }
                layoutResize(false, 0);
            }
        }
    }

    private void layoutResize(boolean z, int i) {
        int i2;
        Rect rect = new Rect();
        EditText editText = this.targetView;
        if (editText != null) {
            editText.getGlobalVisibleRect(rect);
            i2 = (rect.bottom + this.offset) - i;
        } else {
            i2 = 0;
        }
        if (i2 < 0) {
            return;
        }
        if (z) {
            this.contentView.setTranslationY(-i2);
        } else {
            this.contentView.setTranslationY(0.0f);
        }
    }

    private boolean initTargetView() {
        Activity activity = (Activity) this.contentView.getContext();
        if (activity == null) {
            return false;
        }
        View currentFocus = activity.getCurrentFocus();
        if (!(currentFocus instanceof EditText)) {
            return true;
        }
        this.targetView = (EditText) currentFocus;
        return true;
    }

    public void addListener() {
        this.contentView.getViewTreeObserver().addOnGlobalLayoutListener(this);
    }

    public void removeListener() {
        this.contentView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
    }

    public void setTranslationOffset(int i) {
        this.offset = i;
    }

    public void addOnKeyboardShowListener(OnKeyboardShowListener onKeyboardShowListener) {
        this.listener = onKeyboardShowListener;
    }
}
