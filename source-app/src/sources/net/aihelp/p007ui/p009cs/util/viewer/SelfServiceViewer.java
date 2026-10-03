package net.aihelp.p007ui.p009cs.util.viewer;

import android.content.Context;
import android.content.DialogInterface;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import java.util.Iterator;
import java.util.UUID;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.dialog.AlertDialog;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.SelfService;
import net.aihelp.p007ui.adapter.BillingListAdapter;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.FastClickValidator;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import org.json.JSONArray;
import org.json.JSONObject;

public class SelfServiceViewer implements View.OnClickListener {
    private BillingListAdapter mAdapter;
    private RelativeLayout mEmptyLayout;
    private ImageView mIvClose;
    private TextView mTvSend;
    private OnSelfServiceConfirmListener onSelfServiceConfirmListener;
    private AlertDialog selfServiceDialog;

    public interface OnSelfServiceConfirmListener {
        void onSelected(Message message);
    }

    public void getService(Context context, SelfService selfService) {
        AlertDialog alertDialogCreate = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_selecting_bill")).setGravity(80).fromBottom(true).setCancelableOntheOutside(true).setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialogInterface) {
                EventBus.getDefault().unregister(SelfServiceViewer.this);
            }
        }).setWidthAndHeight(-1, 500).setHeightByDevice().create();
        this.selfServiceDialog = alertDialogCreate;
        ((LinearLayout) alertDialogCreate.findViewById(ResResolver.getViewId("aihelp_ll_bill_dialog"))).setBackgroundColor(Styles.getColor(CustomConfig.CommonSetting.upperBackgroundColor));
        TextView textView = (TextView) this.selfServiceDialog.findViewById(ResResolver.getViewId("aihelp_tv_send"));
        this.mTvSend = textView;
        Styles.reRenderTextView(textView, ResResolver.getString("aihelp_send"), Styles.getColor(CustomConfig.CommonSetting.interactElementTextColor));
        this.mTvSend.setOnClickListener(this);
        ImageView imageView = (ImageView) this.selfServiceDialog.findViewById(ResResolver.getViewId("aihelp_iv_close"));
        this.mIvClose = imageView;
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_close_dialog");
        this.mIvClose.setOnClickListener(this);
        this.mEmptyLayout = (RelativeLayout) this.selfServiceDialog.findViewById(ResResolver.getViewId("aihelp_rl_empty"));
        ListView listView = (ListView) this.selfServiceDialog.findViewById(ResResolver.getViewId("aihelp_lv_bill"));
        BillingListAdapter billingListAdapter = new BillingListAdapter(context, selfService.isEnableSend());
        this.mAdapter = billingListAdapter;
        billingListAdapter.setOnOrderCheckedListener(new BillingListAdapter.OnOrderCheckedListener() {
            @Override
            public void onOrderChecked() {
                SelfServiceViewer.this.mTvSend.setEnabled(true);
                SelfServiceViewer.this.mTvSend.setAlpha(1.0f);
            }
        });
        listView.setAdapter((ListAdapter) this.mAdapter);
        this.selfServiceDialog.show();
        this.mTvSend.setVisibility(selfService.isEnableSend() ? 0 : 8);
        this.mIvClose.setVisibility(selfService.isEnableSend() ? 8 : 0);
        try {
            JSONArray jSONArray = new JSONArray(selfService.getSelfServiceData());
            if (jSONArray.length() > 0) {
                this.mAdapter.update(jSONArray);
            } else {
                showEmpty();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        EventBus.getDefault().register(this);
    }

    private void showEmpty() {
        this.mTvSend.setVisibility(8);
        this.mIvClose.setVisibility(8);
        this.mEmptyLayout.setVisibility(0);
        ((TextView) this.mEmptyLayout.findViewById(ResResolver.getViewId("aihelp_tv_error_desc"))).setText(ResResolver.getString("aihelp_data_not_found_msg"));
    }

    @Override
    public void onClick(View view) {
        AlertDialog alertDialog;
        if (view.getId() == ResResolver.getViewId("aihelp_tv_send") && FastClickValidator.validate() && AppInfoUtil.validateNetwork(view.getContext())) {
            String checkedBill = this.mAdapter.getCheckedBill();
            if (!TextUtils.isEmpty(checkedBill)) {
                try {
                    StringBuilder sb = new StringBuilder();
                    JSONObject jSONObject = new JSONObject(checkedBill);
                    Iterator<String> itKeys = jSONObject.keys();
                    while (itKeys.hasNext()) {
                        String next = itKeys.next();
                        sb.append(next);
                        sb.append(": ");
                        sb.append(jSONObject.opt(next));
                        sb.append("\n");
                    }
                    String strTrim = sb.toString().trim();
                    UserMessage userTextMsg = Message.getUserTextMsg(strTrim);
                    userTextMsg.setRequestParams(strTrim, 1, 4);
                    OnSelfServiceConfirmListener onSelfServiceConfirmListener = this.onSelfServiceConfirmListener;
                    if (onSelfServiceConfirmListener != null) {
                        onSelfServiceConfirmListener.onSelected(userTextMsg);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            AlertDialog alertDialog2 = this.selfServiceDialog;
            if (alertDialog2 != null && alertDialog2.isShowing()) {
                this.selfServiceDialog.dismiss();
            }
        }
        if (view.getId() == ResResolver.getViewId("aihelp_iv_close") && FastClickValidator.validate() && (alertDialog = this.selfServiceDialog) != null && alertDialog.isShowing()) {
            this.selfServiceDialog.dismiss();
        }
    }

    public JSONObject getRequestParams(String str, int i) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("input", str);
            jSONObject.put("skip", false);
            jSONObject.put("inputFormat", i);
            jSONObject.put("inputData", "");
            jSONObject.put("eventId", UUID.randomUUID().toString().replace("-", ""));
            return jSONObject;
        } catch (Exception unused) {
            return new JSONObject();
        }
    }

    public void setOnSelfServiceConfirmListener(OnSelfServiceConfirmListener onSelfServiceConfirmListener) {
        this.onSelfServiceConfirmListener = onSelfServiceConfirmListener;
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(OrientationChangeEvent orientationChangeEvent) {
        AlertDialog alertDialog = this.selfServiceDialog;
        if (alertDialog == null || !alertDialog.isShowing()) {
            return;
        }
        this.selfServiceDialog.dismiss();
    }
}
