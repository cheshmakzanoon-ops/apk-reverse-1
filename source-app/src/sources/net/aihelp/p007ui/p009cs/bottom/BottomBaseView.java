package net.aihelp.p007ui.p009cs.bottom;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import androidx.appcompat.widget.AppCompatImageButton;
import androidx.fragment.app.FragmentActivity;
import java.io.File;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.SpKeys;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.data.attachment.IAttachmentPickerListener;
import net.aihelp.data.event.HideAttachmentMenuEvent;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.p007ui.p009cs.IServiceEventListener;
import net.aihelp.p007ui.wrapper.TextWatcherWrapper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.Styles;

public abstract class BottomBaseView extends LinearLayout implements View.OnClickListener, IAttachmentPickerListener {
    Activity activity;
    protected AppCompatImageButton btnSend;
    protected Bundle bundle;
    protected EditText etInput;
    protected IServiceEventListener mListener;
    protected RPAStep mStep;

    public void updateInputValidator(String str, boolean z) {
    }

    public void onClick(View view) {
    }

    public void onPickFailure(int i) {
    }

    public void onPickSuccess(File file) {
    }

    public void onPreviewCanceled(int i) {
    }

    public void onPreviewConfirmed(String str) {
    }

    public BottomBaseView(Context context) {
        super(context);
    }

    public BottomBaseView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    public BottomBaseView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    public void setBottomViewEventListener(Bundle bundle, RPAStep rPAStep, IServiceEventListener iServiceEventListener) {
        this.bundle = bundle;
        this.mStep = rPAStep;
        this.mListener = iServiceEventListener;
    }

    protected void prepareInputView() {
        this.etInput = (EditText) findViewById(ResResolver.getViewId("aihelp_et_input"));
        AppCompatImageButton appCompatImageButtonFindViewById = findViewById(ResResolver.getViewId("aihelp_btn_send"));
        this.btnSend = appCompatImageButtonFindViewById;
        if (this.etInput == null || appCompatImageButtonFindViewById == null) {
            return;
        }
        appCompatImageButtonFindViewById.setOnClickListener(this);
        this.btnSend.setEnabled(false);
        this.etInput.setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d), 8));
        Styles.reRenderTextView(this.etInput, CustomConfig.CustomerService.csInputHint);
        this.etInput.addTextChangedListener(new TextWatcherWrapper() {
            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
                BottomBaseView.this.updateInputValidator("", false);
                BottomBaseView.this.updateSendButtonStatus(charSequence);
            }
        });
        this.etInput.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    EventBus.getDefault().post(new HideAttachmentMenuEvent());
                    SoftInputUtil.showSoftInput(BottomBaseView.this.getContext());
                } else {
                    SoftInputUtil.hideSoftInput(BottomBaseView.this.getContext(), view);
                }
            }
        });
        this.etInput.setText(SpUtil.getInstance().getString(SpKeys.INPUT_DRAFT, ""));
    }

    public void updateSendButtonStatus(CharSequence charSequence) {
        try {
            if (this.btnSend != null) {
                boolean zIsEmpty = TextUtils.isEmpty(charSequence.toString().trim());
                boolean z = !zIsEmpty;
                this.btnSend.setEnabled(z);
                this.btnSend.setImageDrawable(Styles.getClickableDrawable(getContext(), "aihelp_svg_ic_send_msg", Color.parseColor(!zIsEmpty ? CustomConfig.CommonSetting.interactElementTextColor : "#C6C9D7"), z));
                if (this.btnSend.getContext().getResources().getConfiguration().getLayoutDirection() == 1) {
                    this.btnSend.setScaleX(-1.0f);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (this.etInput != null) {
            SpUtil.getInstance().put(SpKeys.INPUT_DRAFT, this.etInput.getText().toString().trim());
        }
    }

    public void setActivity(FragmentActivity fragmentActivity) {
        this.activity = fragmentActivity;
    }
}
