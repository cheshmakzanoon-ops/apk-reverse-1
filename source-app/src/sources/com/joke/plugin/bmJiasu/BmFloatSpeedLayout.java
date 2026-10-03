package com.joke.plugin.bmJiasu;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.text.SpannableString;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.joke.assistanttool.BmFloatMenuLayout;
import com.joke.assistanttool.utils.BmParentToolConstant;
import com.joke.assistanttool.utils.BmParentUILoad;
import com.joke.assistanttool.utils.CenterAlignImageSpan;
import com.joke.assistanttool.utils.DpiConvert;
import com.joke.connectdevice.utils.ActivityRegistry;
import com.joke.connectdevice.utils.BmAutoConfig;
import com.joke.speedfloatingball.utils.MLog;
import java.util.Locale;

public class BmFloatSpeedLayout extends LinearLayout {
    private static final String KEY_SPEED = "KEY_SPEED_NUMER";
    private static final double MAX_SPEED_VALUE = 50.0d;
    private static final double MINIMAL_RATIO = -50.0d;
    public static final int TYPE_SPEED_STATE_START = 2;
    public static final int TYPE_SPEED_STATE_STOP = 3;
    private int currentSpeedMode;
    private boolean currentSpeedState;
    private double currentSpeedValue;
    private final int dp14;
    private final int dp48;
    private final int dp8;
    private final int dpHeight;
    private TextView lastSelectedMoreRate;
    private GridLayout moreRateExpand;
    private LinearLayout rootContainer;
    private BmSpeedChangeListener speedChangeListener;
    private TextView speedTextView;
    private LinearLayout speedTypeChoice;
    private ImageView stateImageView;
    private TextView stateTextView;

    public BmFloatSpeedLayout(Context context, String tips) {
        super(context);
        this.dpHeight = DpiConvert.dp2px(context, 50);
        this.dp48 = DpiConvert.dp2px(context, 42);
        this.dp14 = DpiConvert.dp2px(context, 14);
        this.dp8 = DpiConvert.dp2px(context, 8);
        this.currentSpeedMode = JiaSuModeConfig.getCurrentMode(context);
        float storedSpeed = BmAutoConfig.getFloat(context, KEY_SPEED + JiaSuModeConfig.getSpeedKeySuffix(this.currentSpeedMode));
        this.currentSpeedValue = storedSpeed == 0.0f ? 0.0d : storedSpeed;
        initView(context);
    }

    private void initView(Context context) {
        setOrientation(1);
        setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
        this.rootContainer = new LinearLayout(context);
        this.rootContainer.setOrientation(0);
        this.rootContainer.setBackground(BmFloatMenuLayout.getBgShapeDrawable(context));
        this.rootContainer.setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
        this.rootContainer.addView(createAdjustButton(context, false));
        this.rootContainer.addView(createSpeedView(context));
        this.rootContainer.addView(createAdjustButton(context, true));
        this.rootContainer.addView(createStateButton(context));
        this.rootContainer.addView(createMoreButton(context));
        this.rootContainer.addView(createCoreButton(context));
        addView(this.rootContainer);
        this.moreRateExpand = expandMoreRateLayout(context);
        this.moreRateExpand.setVisibility(8);
        addView(this.moreRateExpand);
        this.speedTypeChoice = getSpeedTypeChoice(context);
        this.speedTypeChoice.setVisibility(8);
        addView(this.speedTypeChoice);
    }

    private View createAdjustButton(Context context, final boolean increase) {
        String str;
        if (increase) {
            str = BmParentToolConstant.bm_plugin_jiasu_shiftup;
        } else {
            str = BmParentToolConstant.bm_plugin_jiasu_shiftdown;
        }
        ImageView icon = initItemImageView(context, str);
        TextView text = initItemTextView(context, increase ? "Add" : "Subtract");
        LinearLayout container = initItemParentView(context, icon, text);
        container.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.lambda$createAdjustButton$0(increase, view);
            }
        });
        return container;
    }

    public void lambda$createAdjustButton$0(boolean increase, View v) {
        double value = this.currentSpeedValue + (increase ? 0.5d : -0.5d);
        if (increase && value > MAX_SPEED_VALUE) {
            return;
        }
        if (!increase && value < MINIMAL_RATIO) {
            return;
        }
        this.currentSpeedValue = value;
        triggerStart();
        clearMoreRateSelection();
    }

    private View createSpeedView(Context context) {
        this.speedTextView = initItemTextView(context, formatSpeed(this.currentSpeedValue));
        this.speedTextView.setTextSize(2, 14.0f);
        return initItemParentView(context, null, this.speedTextView);
    }

    private View createStateButton(Context context) {
        this.stateImageView = initItemImageView(context, BmParentToolConstant.bm_plugin_jiasu_start);
        this.stateTextView = initItemTextView(context, "Start");
        LinearLayout container = initItemParentView(context, this.stateImageView, this.stateTextView);
        container.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.lambda$createStateButton$0(view);
            }
        });
        return container;
    }

    public void lambda$createStateButton$0(View v) {
        updateSpeedValueView();
        this.currentSpeedState = !this.currentSpeedState;
        updateStateView(this.currentSpeedState);
        if (this.speedChangeListener == null) {
            return;
        }
        this.speedChangeListener.onSpeedChange(this.currentSpeedState ? 2 : 3, this.currentSpeedValue, this.currentSpeedMode);
    }

    private View createMoreButton(Context context) {
        ImageView icon = initItemImageView(context, BmParentToolConstant.bm_plugin_jiasu_more_rate);
        TextView text = initItemTextView(context, "More");
        LinearLayout container = initItemParentView(context, icon, text);
        container.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.lambda$createMoreButton$0(view);
            }
        });
        return container;
    }

    public void lambda$createMoreButton$0(View v) {
        if (this.speedTypeChoice.getVisibility() == 0) {
            this.speedTypeChoice.setVisibility(8);
        }
        this.moreRateExpand.setVisibility(this.moreRateExpand.getVisibility() != 0 ? 0 : 8);
    }

    private View createCoreButton(Context context) {
        ImageView icon = initItemImageView(context, getModeIconName(this.currentSpeedMode));
        TextView text = initItemTextView(context, JiaSuModeConfig.getModeLabel(this.currentSpeedMode));
        LinearLayout container = initItemParentView(context, icon, text);
        container.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.lambda$createCoreButton$0(view);
            }
        });
        return container;
    }

    public void lambda$createCoreButton$0(View v) {
        if (this.moreRateExpand.getVisibility() == 0) {
            this.moreRateExpand.setVisibility(8);
        }
        this.speedTypeChoice.setVisibility(this.speedTypeChoice.getVisibility() != 0 ? 0 : 8);
    }

    @Override
    public void setBackground(Drawable drawable) {
        if (this.rootContainer != null) {
            this.rootContainer.setBackground(drawable);
        }
    }

    public void setBgDrawable(Drawable drawable) {
        if (this.rootContainer != null) {
            this.rootContainer.setBackground(drawable);
        }
    }

    private void triggerStart() {
        updateSpeedValueView();
        this.currentSpeedState = true;
        updateStateView(true);
        if (this.speedChangeListener != null) {
            this.speedChangeListener.onSpeedChange(2, this.currentSpeedValue, this.currentSpeedMode);
        }
    }

    private void clearMoreRateSelection() {
        if (this.lastSelectedMoreRate != null) {
            this.lastSelectedMoreRate.setTextColor(-1);
        }
    }

    private void updateSpeedValueView() {
        if (this.speedTextView != null) {
            this.speedTextView.setText(formatSpeed(this.currentSpeedValue));
        }
    }

    private String formatSpeed(double speed) {
        return String.format(Locale.US, "%.1f", Double.valueOf(speed));
    }

    private void updateStateView(boolean speedState) {
        if (speedState) {
            this.stateImageView.setImageDrawable(BmParentUILoad.getDrawable(BmParentToolConstant.bm_plugin_jiasu_stop));
            this.stateTextView.setText("Pause");
        } else {
            this.stateImageView.setImageDrawable(BmParentUILoad.getDrawable(BmParentToolConstant.bm_plugin_jiasu_start));
            this.stateTextView.setText("Start");
        }
    }

    private LinearLayout initItemParentView(Context context, ImageView imageView, TextView textView) {
        LinearLayout container = new LinearLayout(context);
        container.setLayoutParams(new LinearLayout.LayoutParams(this.dp48, this.dpHeight));
        container.setOrientation(1);
        container.setGravity(17);
        if (imageView != null) {
            container.addView(imageView);
        }
        if (textView != null) {
            container.addView(textView);
        }
        return container;
    }

    private ImageView initItemImageView(Context context, String drawableName) {
        ImageView imageView = new ImageView(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(this.dp14, this.dp14);
        params.bottomMargin = this.dp8;
        imageView.setLayoutParams(params);
        imageView.setImageDrawable(BmParentUILoad.getDrawable(drawableName));
        return imageView;
    }

    private TextView initItemTextView(Context context, String text) {
        TextView textView = new TextView(context);
        textView.setLayoutParams(new LinearLayout.LayoutParams(-2, -2));
        textView.setTextColor(-1);
        textView.setTextSize(2, 9.0f);
        textView.setText(text);
        return textView;
    }

    private GridLayout expandMoreRateLayout(Context context) {
        GridLayout layout = new GridLayout(context);
        layout.setBackground(BmFloatMenuLayout.getBgShapeDrawable(context));
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(-2, -2);
        params.topMargin = DpiConvert.dp2px(context, 2);
        layout.setLayoutParams(params);
        layout.setColumnCount(2);
        double[] speeds = {0.5d, 1.0d, 1.5d, 2.0d, 2.5d, 10.0d, 15.0d, 20.0d};
        for (double speed : speeds) {
            TextView item = new TextView(context);
            item.setWidth(DpiConvert.dp2px(context, 120));
            item.setHeight(DpiConvert.dp2px(context, 33));
            item.setGravity(17);
            item.setTextColor(-1);
            item.setTextSize(2, 14.0f);
            item.setText(String.format(Locale.US, "%sX", Double.valueOf(speed)));
            item.setOnClickListener(new View.OnClickListener() {
                @Override
                public final void onClick(View view) {
                    this.f$0.lambda$expandMoreRateLayout$0(view);
                }
            });
            layout.addView(item);
        }
        return layout;
    }

    public void lambda$expandMoreRateLayout$0(View v) {
        if (this.lastSelectedMoreRate != null) {
            this.lastSelectedMoreRate.setTextColor(-1);
        }
        TextView textView = (TextView) v;
        this.lastSelectedMoreRate = textView;
        textView.setTextColor(Color.parseColor("#0089FF"));
        this.currentSpeedValue = parseDouble(textView.getText().toString().replace("X", ""), 1.0d);
        if (this.currentSpeedValue < MINIMAL_RATIO || this.currentSpeedValue >= MAX_SPEED_VALUE) {
            return;
        }
        triggerStart();
    }

    private LinearLayout getSpeedTypeChoice(Context context) {
        LinearLayout layout = new LinearLayout(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(-1, -2);
        params.topMargin = DpiConvert.dp2px(context, 2);
        layout.setLayoutParams(params);
        layout.setOrientation(1);
        layout.setBackground(BmFloatMenuLayout.getBgShapeDrawable(context));
        layout.addView(buildCoreRow(context, 1, new Runnable() {
            @Override
            public final void run() {
                this.f$0.lambda$getSpeedTypeChoice$0();
            }
        }));
        layout.addView(buildCoreRow(context, 2, new Runnable() {
            @Override
            public final void run() {
                this.f$0.lambda$getSpeedTypeChoice$1();
            }
        }));
        layout.addView(buildCoreRow(context, 3, new Runnable() {
            @Override
            public final void run() {
                this.f$0.lambda$getSpeedTypeChoice$2();
            }
        }));
        TextView hintText = new TextView(context);
        hintText.setLayoutParams(new LinearLayout.LayoutParams(-2, -2));
        hintText.setPadding(DpiConvert.dp2px(context, 12), DpiConvert.dp2px(context, 12), DpiConvert.dp2px(context, 12), this.dp8);
        hintText.setTextColor(Color.parseColor("#909090"));
        hintText.setTextSize(2, 10.0f);
        showImageText(hintText, context);
        layout.addView(hintText);
        return layout;
    }

    public void lambda$getSpeedTypeChoice$0() {
        if (this.currentSpeedMode != 1) {
            showSpeedTypeDialog(1);
        }
    }

    public void lambda$getSpeedTypeChoice$1() {
        if (this.currentSpeedMode != 2) {
            showSpeedTypeDialog(2);
        }
    }

    public void lambda$getSpeedTypeChoice$2() {
        if (this.currentSpeedMode != 3) {
            showSpeedTypeDialog(3);
        }
    }

    private LinearLayout buildCoreRow(Context context, int targetMode, final Runnable action) {
        LinearLayout linearLayout = new LinearLayout(context);
        linearLayout.setOrientation(0);
        linearLayout.setPadding(DpiConvert.dp2px(context, 12), DpiConvert.dp2px(context, 12), DpiConvert.dp2px(context, 12), 0);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
        boolean checked = this.currentSpeedMode == targetMode;
        int dp16 = DpiConvert.dp2px(context, 16);
        int dp8Value = DpiConvert.dp2px(context, 8);
        ImageView icon = new ImageView(context);
        icon.setLayoutParams(new LinearLayout.LayoutParams(dp16, dp16));
        icon.setImageDrawable(BmParentUILoad.getDrawable(getModeIconName(targetMode)));
        linearLayout.addView(icon);
        TextView text = new TextView(context);
        LinearLayout.LayoutParams textParams = new LinearLayout.LayoutParams(0, -2);
        textParams.weight = 1.0f;
        text.setLayoutParams(textParams);
        text.setPadding(dp8Value, 0, 0, 0);
        text.setText(getModeDescription(targetMode));
        text.setTextSize(2, 11.0f);
        text.setTextColor(checked ? -1 : Color.parseColor("#909090"));
        linearLayout.addView(text);
        ImageView checkIcon = new ImageView(context);
        checkIcon.setLayoutParams(new LinearLayout.LayoutParams(dp16, dp16));
        checkIcon.setImageDrawable(BmParentUILoad.getDrawable(BmParentToolConstant.bm_magic_icon_speed_check_white));
        checkIcon.setVisibility(checked ? 0 : 8);
        linearLayout.addView(checkIcon);
        linearLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                action.run();
            }
        });
        return linearLayout;
    }

    private void showSpeedTypeDialog(final int targetMode) {
        Activity activity = ActivityRegistry.getInstance().getActivity();
        if (activity == null || activity.isFinishing() || activity.isDestroyed()) {
            return;
        }
        String modeLabel = JiaSuModeConfig.getModeLabel(targetMode);
        new AlertDialog.Builder(activity).setTitle("Tips").setMessage("You'll need to restart the game to switch to " + modeLabel + ".").setNegativeButton("Cancel", (DialogInterface.OnClickListener) null).setPositiveButton("Restart", new DialogInterface.OnClickListener() {
            @Override
            public final void onClick(DialogInterface dialogInterface, int i) {
                this.f$0.lambda$showSpeedTypeDialog$0(targetMode, dialogInterface, i);
            }
        }).show();
    }

    public void lambda$showSpeedTypeDialog$0(int targetMode, DialogInterface dialog, int which) {
        JiaSuModeConfig.setCurrentMode(getContext(), targetMode);
        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public final void run() {
                BmFloatSpeedLayout.lambda$showSpeedTypeDialog$1();
            }
        }, 1000L);
    }

    static void lambda$showSpeedTypeDialog$1() {
        ActivityRegistry.getInstance().finish();
        Process.killProcess(Process.myPid());
        System.exit(0);
    }

    private void showImageText(TextView textView, Context context) {
        SpannableString string = new SpannableString("  Default is Core1. If Speed Hack is not working, try switching between Core1, Core2 and Core3.");
        Drawable drawable = BmParentUILoad.getDrawable("bm_magic_icon_speed_type_hint.png");
        int dp12 = DpiConvert.dp2px(context, 12);
        drawable.setBounds(0, 0, dp12, dp12);
        CenterAlignImageSpan imageSpan = new CenterAlignImageSpan(drawable);
        string.setSpan(imageSpan, 0, 1, 1);
        textView.setText(string);
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            MLog.m2e(e);
            return defaultValue;
        }
    }

    private String getModeIconName(int speedMode) {
        switch (JiaSuModeConfig.normalizeMode(speedMode)) {
            case 2:
                return BmParentToolConstant.bm_magic_icon_speed_type_core2;
            case 3:
                return "bm_magic_icon_speed_type_hint.png";
            default:
                return BmParentToolConstant.bm_magic_icon_speed_type_core1;
        }
    }

    private String getModeDescription(int speedMode) {
        switch (JiaSuModeConfig.normalizeMode(speedMode)) {
            case 2:
                return "Core2 Uses the original CheatPlusPlus loader path.";
            case 3:
                return "Core3 Uses the new extended scan path for split APK and Unity.";
            default:
                return "Core1 Uses the legacy libbasic/libcall hook.";
        }
    }

    public void setSpeedChangeListener(BmSpeedChangeListener speedChangeListener) {
        this.speedChangeListener = speedChangeListener;
    }
}
