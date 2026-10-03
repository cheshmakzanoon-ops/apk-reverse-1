package net.aihelp.core.p004ui.loading.helper;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import java.lang.ref.WeakReference;

public class VaryViewHelper {
    private WeakReference<Activity> mActivityRef;
    private View mOriginView;
    private ViewGroup.LayoutParams mOriginViewParams;
    private ViewGroup mParentView;
    private int mTargetViewIndex = -1;

    VaryViewHelper(View view) {
        if (view.getContext() instanceof Activity) {
            this.mActivityRef = new WeakReference<>((Activity) view.getContext());
        }
        this.mOriginView = view;
        prepareOriginViewCache();
    }

    private void prepareOriginViewCache() {
        this.mOriginViewParams = this.mOriginView.getLayoutParams();
        ViewGroup viewGroup = (ViewGroup) this.mOriginView.getParent();
        this.mParentView = viewGroup;
        if (viewGroup != null) {
            for (int i = 0; i < this.mParentView.getChildCount(); i++) {
                if (this.mOriginView == this.mParentView.getChildAt(i)) {
                    this.mTargetViewIndex = i;
                    return;
                }
            }
        }
    }

    void showLayout(View view) {
        ViewGroup viewGroup;
        if (this.mActivityRef.get() == null || this.mActivityRef.get().isFinishing() || (viewGroup = this.mParentView) == null || viewGroup.getChildAt(this.mTargetViewIndex) == view) {
            return;
        }
        this.mParentView.removeViewAt(this.mTargetViewIndex);
        this.mParentView.addView(view, this.mTargetViewIndex, this.mOriginViewParams);
    }

    void restoreView() {
        if (this.mActivityRef.get() == null || this.mActivityRef.get().isFinishing()) {
            return;
        }
        showLayout(this.mOriginView);
    }

    public View inflate(int i) {
        return LayoutInflater.from(this.mOriginView.getContext()).inflate(i, (ViewGroup) null);
    }

    public Context getContext() {
        return this.mOriginView.getContext();
    }

    public View getTargetView() {
        return this.mOriginView;
    }
}
