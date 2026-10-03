package com.google.android.material.sidesheet;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import com.google.android.material.C0017R;

public class SideSheetDialog extends SheetDialog<SideSheetCallback> {
    private static final int SIDE_SHEET_DIALOG_THEME_ATTR = C0017R.attr.sideSheetDialogTheme;
    private static final int SIDE_SHEET_DIALOG_DEFAULT_THEME_RES = C0017R.style.Theme_Material3_Light_SideSheetDialog;

    @Override
    int getStateOnStart() {
        return 3;
    }

    @Override
    public void cancel() {
        super.cancel();
    }

    @Override
    public boolean isDismissWithSheetAnimationEnabled() {
        return super.isDismissWithSheetAnimationEnabled();
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
    }

    @Override
    public void setCancelable(boolean z) {
        super.setCancelable(z);
    }

    @Override
    public void setCanceledOnTouchOutside(boolean z) {
        super.setCanceledOnTouchOutside(z);
    }

    @Override
    public void setContentView(int i) {
        super.setContentView(i);
    }

    @Override
    public void setContentView(View view) {
        super.setContentView(view);
    }

    @Override
    public void setContentView(View view, ViewGroup.LayoutParams layoutParams) {
        super.setContentView(view, layoutParams);
    }

    @Override
    public void setDismissWithSheetAnimationEnabled(boolean z) {
        super.setDismissWithSheetAnimationEnabled(z);
    }

    @Override
    public void setSheetEdge(int i) {
        super.setSheetEdge(i);
    }

    public SideSheetDialog(Context context) {
        this(context, 0);
    }

    public SideSheetDialog(Context context, int i) {
        super(context, i, SIDE_SHEET_DIALOG_THEME_ATTR, SIDE_SHEET_DIALOG_DEFAULT_THEME_RES);
    }

    @Override
    void addSheetCancelOnHideCallback(Sheet<SideSheetCallback> sheet) {
        sheet.addCallback(new SideSheetCallback() {
            @Override
            public void onSlide(View view, float f) {
            }

            @Override
            public void onStateChanged(View view, int i) {
                if (i == 5) {
                    SideSheetDialog.this.cancel();
                }
            }
        });
    }

    @Override
    int getLayoutResId() {
        return C0017R.layout.m3_side_sheet_dialog;
    }

    @Override
    int getDialogId() {
        return C0017R.id.m3_side_sheet;
    }

    @Override
    Sheet<SideSheetCallback> getBehaviorFromSheet(FrameLayout frameLayout) {
        return SideSheetBehavior.from(frameLayout);
    }

    @Override
    public SideSheetBehavior<? extends View> getBehavior() {
        Sheet behavior = super.getBehavior();
        if (!(behavior instanceof SideSheetBehavior)) {
            throw new IllegalStateException("The view is not associated with SideSheetBehavior");
        }
        return (SideSheetBehavior) behavior;
    }
}
