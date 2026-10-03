package net.aihelp.core.p004ui.dialog;

import android.content.Context;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.lang.ref.WeakReference;

class DialogViewHelper {
    private View mContentView;
    private SparseArray<WeakReference<View>> mViews;

    public DialogViewHelper(Context context, int i) {
        this();
        this.mContentView = LayoutInflater.from(context).inflate(i, (ViewGroup) null);
    }

    public DialogViewHelper() {
        this.mContentView = null;
        this.mViews = new SparseArray<>();
    }

    public void setContentView(View view) {
        this.mContentView = view;
    }

    public void setText(int i, CharSequence charSequence) {
        TextView textView = (TextView) getView(i);
        if (textView != null) {
            textView.setText(charSequence);
        }
    }

    public void setBottomText(int i, CharSequence charSequence) {
        TextView textView = (TextView) getView(i);
        if (textView != null) {
            textView.setText(charSequence);
        }
    }

    public void setOnClickListener(int i, View.OnClickListener onClickListener) {
        View view = getView(i);
        if (view != null) {
            view.setOnClickListener(onClickListener);
        }
    }

    public void setBackground(int i, int i2) {
        View view = getView(i);
        if (view != null) {
            view.setBackgroundResource(i2);
        }
    }

    public View getContentView() {
        return this.mContentView;
    }

    public <V extends View> V getView(int i) {
        WeakReference<View> weakReference = this.mViews.get(i);
        V v = weakReference != null ? (V) weakReference.get() : null;
        if (v != null) {
            return v;
        }
        V v2 = (V) this.mContentView.findViewById(i);
        this.mViews.put(i, new WeakReference<>(v2));
        return v2;
    }
}
