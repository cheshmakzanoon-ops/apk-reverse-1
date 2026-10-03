package com.joke.assistanttool;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.joke.assistanttool.utils.BmParentToolConstant;
import com.joke.assistanttool.utils.BmParentUILoad;
import com.joke.assistanttool.utils.DpiConvert;
import com.joke.plugin.bmJiasu.BmFloatSpeedLayout;
import com.joke.plugin.bmJiasu.BmFloatSpeedView;

public class BmFloatMenuLayout extends FrameLayout {
    private boolean floatMenuOpen;
    private TextView logoBackTextView;
    private ImageView logoBackView;
    private final LinearLayout logoContainerView;
    private ImageView logoView;
    private final BmFloatSpeedLayout speedView;
    private final BmFloatSpeedView speedViewController;
    private View.OnTouchListener touchListener;

    public BmFloatMenuLayout(Context context) {
        super(context);
        LinearLayout root = new LinearLayout(context);
        root.setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
        root.setOrientation(0);
        this.logoContainerView = initLogoView(context);
        root.addView(this.logoContainerView);
        this.speedViewController = new BmFloatSpeedView();
        this.speedView = this.speedViewController.initView(context);
        this.speedView.setBackground(getBgShapeHalfRightDrawable(context));
        this.speedView.setVisibility(8);
        root.addView(this.speedView);
        addView(root);
        setListener(context);
    }

    private LinearLayout initLogoView(Context context) {
        int dp48 = DpiConvert.dp2px(context, 48);
        int dp40 = DpiConvert.dp2px(context, 40);
        int dp14 = DpiConvert.dp2px(context, 14);
        int dp8 = DpiConvert.dp2px(context, 8);
        LinearLayout container = new LinearLayout(context);
        container.setLayoutParams(new LinearLayout.LayoutParams(dp48, DpiConvert.dp2px(context, 50)));
        container.setOrientation(1);
        container.setGravity(17);
        this.logoView = new ImageView(context);
        this.logoView.setLayoutParams(new LinearLayout.LayoutParams(dp40, dp40));
        this.logoView.setImageDrawable(BmParentUILoad.getDrawable(BmParentToolConstant.bm_plugin_menu_icon));
        container.addView(this.logoView);
        this.logoBackView = new ImageView(context);
        this.logoBackView.setLayoutParams(new LinearLayout.LayoutParams(dp14, dp14));
        this.logoBackView.setVisibility(8);
        this.logoBackView.setImageDrawable(BmParentUILoad.getDrawable(BmParentToolConstant.bm_plugin_float_menu_back));
        container.addView(this.logoBackView);
        this.logoBackTextView = new TextView(context);
        LinearLayout.LayoutParams textParams = new LinearLayout.LayoutParams(-2, -2);
        textParams.topMargin = dp8;
        this.logoBackTextView.setLayoutParams(textParams);
        this.logoBackTextView.setVisibility(8);
        this.logoBackTextView.setText("Back");
        this.logoBackTextView.setTextColor(-1);
        this.logoBackTextView.setTextSize(9.0f);
        container.addView(this.logoBackTextView);
        return container;
    }

    private void setListener(final Context context) {
        this.logoContainerView.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.lambda$setListener$0(context, view);
            }
        });
    }

    public void lambda$setListener$0(Context context, View v) {
        this.floatMenuOpen = !this.floatMenuOpen;
        setFloatSpeedOpen(context, this.floatMenuOpen);
    }

    private void setFloatSpeedOpen(Context context, boolean isOpen) {
        int contentVisible = isOpen ? 0 : 8;
        int logoVisible = isOpen ? 8 : 0;
        if (isOpen) {
            this.logoContainerView.setBackground(getBgShapeHalfLeftDrawable(context));
            this.speedViewController.initSpeed(context);
        } else {
            this.logoContainerView.setBackground(null);
        }
        this.logoView.setVisibility(logoVisible);
        this.logoBackView.setVisibility(contentVisible);
        this.logoBackTextView.setVisibility(contentVisible);
        this.speedView.setVisibility(contentVisible);
    }

    public boolean isFloatMenuOpen() {
        return this.floatMenuOpen;
    }

    public LinearLayout getLogoView() {
        return this.logoContainerView;
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (this.touchListener != null && this.touchListener.onTouch(this, ev)) {
            return true;
        }
        return super.dispatchTouchEvent(ev);
    }

    @Override
    public void setOnTouchListener(View.OnTouchListener l) {
        this.touchListener = l;
    }

    public static GradientDrawable getBgShapeDrawable(Context context) {
        return buildRoundedDrawable(context, 8, 8, 8, 8);
    }

    public static GradientDrawable getBgShapeHalfLeftDrawable(Context context) {
        return buildRoundedDrawable(context, 8, 0, 8, 0);
    }

    public static GradientDrawable getBgShapeHalfRightDrawable(Context context) {
        return buildRoundedDrawable(context, 0, 8, 0, 8);
    }

    private static GradientDrawable buildRoundedDrawable(Context context, int leftTopDp, int rightTopDp, int leftBottomDp, int rightBottomDp) {
        float leftTop = DpiConvert.dp2px(context, leftTopDp);
        float rightTop = DpiConvert.dp2px(context, rightTopDp);
        float leftBottom = DpiConvert.dp2px(context, leftBottomDp);
        float rightBottom = DpiConvert.dp2px(context, rightBottomDp);
        GradientDrawable drawable = new GradientDrawable();
        drawable.setColor(Color.parseColor("#CC202020"));
        drawable.setCornerRadii(new float[]{leftTop, leftTop, rightTop, rightTop, rightBottom, rightBottom, leftBottom, leftBottom});
        return drawable;
    }
}
