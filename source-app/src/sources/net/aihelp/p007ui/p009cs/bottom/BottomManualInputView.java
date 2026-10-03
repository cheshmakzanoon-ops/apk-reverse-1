package net.aihelp.p007ui.p009cs.bottom;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.content.Context;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import java.io.File;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.core.util.permission.AIHelpPermissions;
import net.aihelp.data.attachment.IAttachmentPickerListener;
import net.aihelp.data.event.HideAttachmentMenuEvent;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.KeyboardChangeHelper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public class BottomManualInputView extends BottomAttachmentView implements View.OnClickListener, IAttachmentPickerListener {
    private final ImageView ivAttach;
    private final LinearLayout llToolContainer;
    private final View vToolsLayout;

    public BottomManualInputView(Context context) {
        super(context);
        removeAllViews();
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_input_for_manual"), this);
        ImageView imageView = (ImageView) findViewById(ResResolver.getViewId("aihelp_iv_attach"));
        this.ivAttach = imageView;
        imageView.setOnClickListener(this);
        boolean z = true;
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_add_attachment", true);
        this.vToolsLayout = findViewById(ResResolver.getViewId("aihelp_rl_tool"));
        findViewById(ResResolver.getViewId("aihelp_v_divider")).setBackgroundColor(Styles.getColorWithAlpha(Styles.isLightColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha)) ? -16777216 : -1, 0.1d));
        LinearLayout linearLayout = (LinearLayout) findViewById(ResResolver.getViewId("aihelp_ll_tool_item"));
        this.llToolContainer = linearLayout;
        if (CustomConfig.UploadLimit.isImageEnableUploading || CustomConfig.UploadLimit.isVideoEnableUploading) {
            linearLayout.addView(getToolItemView(1));
        }
        if (CustomConfig.UploadLimit.isFileEnableUploading) {
            linearLayout.addView(getToolItemView(2));
        }
        prepareInputView();
        if (!CustomConfig.UploadLimit.isImageEnableUploading && !CustomConfig.UploadLimit.isVideoEnableUploading && !CustomConfig.UploadLimit.isFileEnableUploading) {
            z = false;
        }
        imageView.setVisibility(z ? 0 : 8);
        ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) this.etInput.getLayoutParams();
        marginLayoutParams.leftMargin = Styles.dpToPx(context, z ? 0.0f : 15.0f);
        this.etInput.setLayoutParams(marginLayoutParams);
    }

    @Override
    public void onClick(View view) {
        super.onClick(view);
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_btn_send") && this.mListener != null) {
            String strTrim = this.etInput.getText().toString().trim();
            UserMessage userTextMsg = Message.getUserTextMsg(strTrim);
            userTextMsg.setDuringRPAProcedure(false);
            userTextMsg.setRequestParams(strTrim, 1, 1);
            this.mListener.onUserAction(userTextMsg);
            this.etInput.setText("");
        }
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_iv_attach")) {
            if (this.vToolsLayout.getHeight() == 0) {
                SoftInputUtil.hideSoftInput(getContext(), this);
                toggleToolMenu(true);
            } else {
                this.etInput.requestFocus();
                SoftInputUtil.showSoftInput(getContext());
                toggleToolMenu(false);
            }
        }
    }

    private void toggleToolMenu(final boolean z) {
        int[] iArr;
        if (z) {
            iArr = new int[]{0, Styles.dpToPx(getContext(), 118.0f)};
        } else {
            iArr = new int[]{Styles.dpToPx(getContext(), 118.0f), 0};
        }
        ValueAnimator valueAnimatorOfInt = ValueAnimator.ofInt(iArr);
        valueAnimatorOfInt.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator valueAnimator) {
                int iIntValue = ((Integer) valueAnimator.getAnimatedValue()).intValue();
                if (BottomManualInputView.this.mListener != null) {
                    BottomManualInputView.this.mListener.scrollBy(iIntValue);
                }
                ViewGroup.LayoutParams layoutParams = BottomManualInputView.this.vToolsLayout.getLayoutParams();
                layoutParams.height = iIntValue;
                BottomManualInputView.this.vToolsLayout.setLayoutParams(layoutParams);
            }
        });
        valueAnimatorOfInt.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animator) {
                if (!KeyboardChangeHelper.isKeyboardShown(BottomManualInputView.this)) {
                    BottomManualInputView.this.etInput.clearFocus();
                }
                if (!z || BottomManualInputView.this.mListener == null) {
                    return;
                }
                BottomManualInputView.this.mListener.scrollToBottom();
            }
        });
        valueAnimatorOfInt.setDuration(250L);
        valueAnimatorOfInt.start();
    }

    @Override
    public void onPickSuccess(File file) {
        if (this.bundle == null || !this.bundle.getBoolean(IntentValues.BOTTOM_TICKET_FINISHED)) {
            super.onPickSuccess(file);
        }
    }

    private View getToolItemView(final int i) {
        int iDpToPx;
        String str;
        String str2;
        int iDpToPx2;
        if (i == 1) {
            String string = ResResolver.getString("aihelp_albums");
            iDpToPx = Styles.dpToPx(getContext(), 30.0f);
            str = string;
            str2 = "aihelp_svg_ic_image";
            iDpToPx2 = Styles.dpToPx(getContext(), 25.0f);
        } else if (i != 2) {
            str2 = "";
            iDpToPx = 0;
            iDpToPx2 = 0;
            str = "";
        } else {
            String string2 = ResResolver.getString("aihelp_file");
            int iDpToPx3 = Styles.dpToPx(getContext(), 25.0f);
            str = string2;
            str2 = "aihelp_svg_ic_file";
            iDpToPx2 = Styles.dpToPx(getContext(), 30.0f);
            iDpToPx = iDpToPx3;
        }
        View viewInflate = View.inflate(getContext(), ResResolver.getLayoutId("aihelp_tool_item_view"), null);
        viewInflate.setBackground(Styles.getClickableDrawableForList());
        viewInflate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Fragment hostFragment;
                if (BottomManualInputView.this.mListener == null || (hostFragment = BottomManualInputView.this.mListener.getHostFragment()) == null) {
                    return;
                }
                String[] strArr = {"android.permission.READ_EXTERNAL_STORAGE"};
                if (Build.VERSION.SDK_INT >= 33) {
                    strArr = new String[]{"android.permission.READ_MEDIA_IMAGES", "android.permission.READ_MEDIA_VIDEO"};
                }
                AIHelpPermissions.getInstance().setHost(hostFragment).setRequestCode(1000).setRequestPermission(strArr).request(BottomManualInputView.this.getContext(), i);
            }
        });
        ((LinearLayout) viewInflate.findViewById(ResResolver.getViewId("aihelp_ll_icon_container"))).setBackground(Styles.getDrawable(Styles.getColorWithAlpha(Styles.isLightColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha)) ? -16777216 : -1, 0.1d), 10));
        ImageView imageView = (ImageView) viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_tool_icon"));
        imageView.setLayoutParams(new LinearLayout.LayoutParams(iDpToPx, iDpToPx2));
        Styles.reRenderImageView(imageView, str2);
        TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_title"));
        Styles.reRenderTextView(textView, str);
        textView.setTextSize(2, 13.0f);
        return viewInflate;
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        EventBus.getDefault().register(this);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(EventCenter eventCenter) {
        if (!(eventCenter instanceof HideAttachmentMenuEvent) || this.vToolsLayout.getHeight() == 0) {
            return;
        }
        toggleToolMenu(false);
    }
}
