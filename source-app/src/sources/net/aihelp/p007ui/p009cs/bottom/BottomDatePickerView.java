package net.aihelp.p007ui.p009cs.bottom;

import android.app.DatePickerDialog;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.DatePicker;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.widget.AppCompatImageButton;
import androidx.core.graphics.drawable.DrawableCompat;
import androidx.vectordrawable.graphics.drawable.VectorDrawableCompat;
import java.util.Calendar;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class BottomDatePickerView extends BottomBaseView implements View.OnClickListener {
    private AppCompatImageButton btnSend;
    private int currentDayOfMonth;
    private int currentMonth;
    private int currentYear;
    private LinearLayout llDatePicker;
    private DatePickerDialog pickerDialog;
    private TextView tvDate;

    public BottomDatePickerView(Context context) {
        this(context, null);
    }

    public BottomDatePickerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public BottomDatePickerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_bottom_date_picker"), this);
        this.llDatePicker = (LinearLayout) findViewById(ResResolver.getViewId("aihelp_ll_date"));
        this.tvDate = (TextView) findViewById(ResResolver.getViewId("aihelp_tv_date"));
        this.btnSend = findViewById(ResResolver.getViewId("aihelp_btn_send"));
        this.llDatePicker.setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d), 8));
        this.llDatePicker.setOnClickListener(this);
        Styles.reRenderTextView(this.tvDate, ResResolver.getString("aihelp_select_date"), 0.5f);
        this.btnSend.setOnClickListener(this);
        this.btnSend.setEnabled(false);
        Calendar calendar = Calendar.getInstance();
        this.currentYear = calendar.get(1);
        this.currentMonth = calendar.get(2);
        this.currentDayOfMonth = calendar.get(5);
    }

    @Override
    public void onClick(View view) {
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_ll_date")) {
            showDatePicker(this.currentYear, this.currentMonth, this.currentDayOfMonth);
        }
        if (AppInfoUtil.validateNetwork(getContext()) && view.getId() == ResResolver.getViewId("aihelp_btn_send") && AppInfoUtil.validateNetwork(getContext()) && this.mListener != null) {
            String strTrim = this.tvDate.getText().toString().trim();
            UserMessage userTextMsg = Message.getUserTextMsg(strTrim);
            userTextMsg.setRequestParams(strTrim, 3, 3);
            this.mListener.onUserAction(userTextMsg);
        }
    }

    public void updateSendButtonStatus(CharSequence charSequence) {
        try {
            VectorDrawableCompat vectorDrawableCompatCreate = VectorDrawableCompat.create(getResources(), ResResolver.getDrawableId("aihelp_svg_ic_send_msg"), (Resources.Theme) null);
            if (vectorDrawableCompatCreate != null) {
                int color = Color.parseColor("#C6C9D7");
                int color2 = Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor);
                if (!TextUtils.isEmpty(charSequence.toString().trim())) {
                    this.btnSend.setEnabled(true);
                    DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate).mutate(), color2);
                } else {
                    this.btnSend.setEnabled(false);
                    DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate).mutate(), color);
                }
                this.btnSend.setImageDrawable(vectorDrawableCompatCreate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
    public void onEventComing(OrientationChangeEvent orientationChangeEvent) {
        DatePickerDialog datePickerDialog = this.pickerDialog;
        if (datePickerDialog == null || !datePickerDialog.isShowing()) {
            return;
        }
        this.pickerDialog.dismiss();
        showDatePicker(this.currentYear, this.currentMonth, this.currentDayOfMonth);
    }

    private void showDatePicker(int i, int i2, int i3) {
        DatePickerDialog datePickerDialog = new DatePickerDialog(getContext(), new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker datePicker, int i4, int i5, int i6) {
                Object objValueOf;
                Object objValueOf2;
                BottomDatePickerView.this.currentYear = i4;
                BottomDatePickerView.this.currentMonth = i5;
                BottomDatePickerView.this.currentDayOfMonth = i6;
                Integer numValueOf = Integer.valueOf(BottomDatePickerView.this.currentYear);
                if (BottomDatePickerView.this.currentMonth + 1 < 10) {
                    objValueOf = "0" + (BottomDatePickerView.this.currentMonth + 1);
                } else {
                    objValueOf = Integer.valueOf(BottomDatePickerView.this.currentMonth + 1);
                }
                if (BottomDatePickerView.this.currentDayOfMonth < 10) {
                    objValueOf2 = "0" + BottomDatePickerView.this.currentDayOfMonth;
                } else {
                    objValueOf2 = Integer.valueOf(BottomDatePickerView.this.currentDayOfMonth);
                }
                String str = String.format("%s%s%s", numValueOf, objValueOf, objValueOf2);
                Styles.reRenderTextView(BottomDatePickerView.this.tvDate, str);
                BottomDatePickerView.this.updateSendButtonStatus(str);
            }
        }, i, i2, i3);
        this.pickerDialog = datePickerDialog;
        datePickerDialog.show();
    }
}
