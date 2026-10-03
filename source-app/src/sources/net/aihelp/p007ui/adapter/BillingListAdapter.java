package net.aihelp.p007ui.adapter;

import android.content.Context;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.widget.AppCompatRadioButton;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.model.p005cs.storyline.BotBillEntity;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import org.json.JSONArray;
import org.json.JSONObject;

public class BillingListAdapter extends BaseAdapter {
    private final boolean isEnableSend;
    private OnOrderCheckedListener listener;
    private final List<BotBillEntity> mBillingList = new ArrayList();
    private final Context mContext;
    private BotBillEntity mCurrentCheckedEntity;

    public interface OnOrderCheckedListener {
        void onOrderChecked();
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    public BillingListAdapter(Context context, boolean z) {
        this.isEnableSend = z;
        this.mContext = context;
    }

    public void update(JSONArray jSONArray) {
        for (int i = 0; i < jSONArray.length(); i++) {
            try {
                this.mBillingList.add(new BotBillEntity(jSONArray.optString(i)));
            } catch (Exception unused) {
                return;
            }
        }
        notifyDataSetChanged();
    }

    private TextView getBillInfo(String str, String str2) {
        TextView textView = new TextView(this.mContext);
        textView.setTextSize(2, 14.0f);
        textView.setPadding(0, 7, 0, 7);
        try {
            String strOptString = new JSONObject(str).optString(str2);
            ForegroundColorSpan foregroundColorSpan = new ForegroundColorSpan(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.5d));
            ForegroundColorSpan foregroundColorSpan2 = new ForegroundColorSpan(Styles.getColor(CustomConfig.CommonSetting.textColor));
            SpannableStringBuilder spannableStringBuilder = new SpannableStringBuilder();
            spannableStringBuilder.append((CharSequence) str2).append((CharSequence) ": ");
            spannableStringBuilder.setSpan(foregroundColorSpan, 0, str2.length(), 33);
            spannableStringBuilder.append((CharSequence) strOptString);
            spannableStringBuilder.setSpan(foregroundColorSpan2, str2.length(), ((str2.length() + 3) + strOptString.length()) - 1, 33);
            textView.setTextDirection(5);
            textView.setText(spannableStringBuilder);
        } catch (Exception unused) {
        }
        return textView;
    }

    private ArrayList<String> getSortedKeys(String str) {
        ArrayList<String> arrayList = new ArrayList<>();
        try {
            Iterator<String> itKeys = new JSONObject(str).keys();
            while (itKeys.hasNext()) {
                arrayList.add(itKeys.next());
            }
        } catch (Exception unused) {
        }
        return arrayList;
    }

    @Override
    public int getCount() {
        return this.mBillingList.size();
    }

    @Override
    public BotBillEntity getItem(int i) {
        if (this.mBillingList.size() == 0) {
            return null;
        }
        return this.mBillingList.get(i);
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        ViewHolder viewHolder;
        if (view == null) {
            view = View.inflate(this.mContext, ResResolver.getLayoutId("aihelp_ada_billing_list"), null);
            viewHolder = new ViewHolder(view);
            view.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) view.getTag();
        }
        final BotBillEntity botBillEntity = this.mBillingList.get(i);
        viewHolder.vDivider.setVisibility(i == 0 ? 8 : 0);
        viewHolder.vDivider.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.1d));
        viewHolder.radioButton.setBackground(Styles.makeSelector(this.mContext));
        viewHolder.radioButton.setChecked(botBillEntity.isChecked());
        viewHolder.billContainer.removeAllViews();
        Iterator<String> it = getSortedKeys(botBillEntity.getOriginJson()).iterator();
        while (it.hasNext()) {
            viewHolder.billContainer.addView(getBillInfo(botBillEntity.getOriginJson(), it.next()));
        }
        if (this.isEnableSend) {
            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view2) {
                    if (BillingListAdapter.this.mCurrentCheckedEntity != null) {
                        BillingListAdapter.this.mCurrentCheckedEntity.setChecked(false);
                    }
                    botBillEntity.setChecked(true);
                    BillingListAdapter.this.mCurrentCheckedEntity = botBillEntity;
                    BillingListAdapter.this.notifyDataSetChanged();
                    if (BillingListAdapter.this.listener != null) {
                        BillingListAdapter.this.listener.onOrderChecked();
                    }
                }
            });
        } else {
            viewHolder.radioButton.setVisibility(8);
        }
        return view;
    }

    public String getCheckedBill() {
        BotBillEntity botBillEntity = this.mCurrentCheckedEntity;
        if (botBillEntity != null) {
            return botBillEntity.getOriginJson();
        }
        return "";
    }

    private static class ViewHolder {
        private final LinearLayout billContainer;
        private final AppCompatRadioButton radioButton;
        private final View vDivider;

        private ViewHolder(View view) {
            this.vDivider = view.findViewById(ResResolver.getViewId("aihelp_bill_divider"));
            this.billContainer = (LinearLayout) view.findViewById(ResResolver.getViewId("aihelp_ll_bill"));
            this.radioButton = view.findViewById(ResResolver.getViewId("aihelp_rb_bill"));
        }
    }

    public void setOnOrderCheckedListener(OnOrderCheckedListener onOrderCheckedListener) {
        this.listener = onOrderCheckedListener;
    }
}
