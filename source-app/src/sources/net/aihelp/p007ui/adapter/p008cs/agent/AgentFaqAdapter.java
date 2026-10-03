package net.aihelp.p007ui.adapter.p008cs.agent;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.Faq;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.p009cs.util.viewer.BotFaqViewer;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.FastClickValidator;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AgentFaqAdapter extends BaseMsgAdapter implements BotFaqViewer.OnFaqEvaluateListener {
    protected LinearLayout llContainer;

    public void onEvaluated(BotMessage botMessage, boolean z) {
    }

    public AgentFaqAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_agent_faq_like");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 4;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        if (message instanceof BotMessage) {
            BotMessage botMessage = (BotMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csBotSupportPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_robot");
            Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_nickname")), botMessage.getNickname(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(botMessage.getNickname()), 13);
            LinearLayout linearLayout = (LinearLayout) viewHolder.getView(getViewId("aihelp_agent_faq_container"));
            this.llContainer = linearLayout;
            linearLayout.setBackground(getAdminBackgroundDrawable(this.isCurrentRtl));
            this.llContainer.removeAllViews();
            this.llContainer.addView(getMsg(botMessage.getContent(), botMessage.isEnableInteraction()));
            if (botMessage.hasFaq()) {
                List<Faq.FaqData> faqDataList = botMessage.getFaq().getFaqDataList();
                if (faqDataList.size() == 1) {
                    Faq.FaqData faqData = faqDataList.get(0);
                    this.llContainer.addView(getSingleFAQItem(botMessage, faqData));
                    if (faqData.hasAttachedForm()) {
                        prepareFaqFormLayout(this.llContainer, faqData);
                    }
                } else {
                    int i2 = 0;
                    while (i2 < faqDataList.size()) {
                        Faq.FaqData faqData2 = faqDataList.get(i2);
                        i2++;
                        this.llContainer.addView(getListItem(i2, faqData2.getFaqTitle(), botMessage, faqData2));
                    }
                }
            }
            viewHolder.setVisible(getViewId("aihelp_evaluate_view"), false);
        }
    }

    protected TextView getListItem(int i, String str, BotMessage botMessage, Faq.FaqData faqData) {
        TextView textView = new TextView(this.mContext);
        textView.setText(String.format("%s. %s", Integer.valueOf(i), str));
        textView.setTextSize(15.0f);
        textView.setClickable(true);
        textView.setTextColor(Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor));
        textView.setOnClickListener(getFaqViewer(botMessage, faqData));
        textView.setPadding(0, dip2px(this.mContext, 5.0d), 0, dip2px(this.mContext, 0.0d));
        return textView;
    }

    protected View getSingleFAQItem(BotMessage botMessage, Faq.FaqData faqData) {
        LinearLayout linearLayout = new LinearLayout(this.mContext);
        linearLayout.setOrientation(1);
        if (!TextUtils.isEmpty(faqData.getTemplate())) {
            TextView textView = new TextView(this.mContext);
            textView.setTextSize(15.0f);
            textView.setLineSpacing(dip2px(this.mContext, 3.0d), 1.0f);
            textView.setTextColor(Color.parseColor(CustomConfig.CommonSetting.textColor));
            textView.setText(faqData.getTemplate());
            linearLayout.addView(textView);
        }
        TextView textView2 = new TextView(this.mContext);
        textView2.setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
        textView2.setTextSize(15.0f);
        textView2.setGravity(17);
        textView2.setLineSpacing(dip2px(this.mContext, 3.0d), 1.0f);
        textView2.setTextColor(Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor));
        textView2.setPadding(0, dip2px(this.mContext, 7.0d), 0, dip2px(this.mContext, 7.0d));
        textView2.setText(ResResolver.getString("aihelp_view_details"));
        textView2.setOnClickListener(getFaqViewer(botMessage, faqData));
        textView2.setVisibility(faqData.isShowMore() ? 0 : 8);
        linearLayout.addView(textView2);
        if (!faqData.isShowMore() && !faqData.isFaqViewed()) {
            faqData.setFaqViewed(true);
            trackAnswerFaqChecked(faqData);
        }
        return linearLayout;
    }

    protected void prepareFaqFormLayout(LinearLayout linearLayout, final Faq.FaqData faqData) {
        View view = new View(this.mContext);
        view.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d));
        view.setLayoutParams(new ViewGroup.MarginLayoutParams(-2, dip2px(this.mContext, 1.0d)));
        view.setPadding(0, dip2px(this.mContext, 10.0d), 0, 0);
        linearLayout.addView(view);
        TextView textView = new TextView(this.mContext);
        textView.setLayoutParams(new ViewGroup.MarginLayoutParams(-2, -2));
        textView.setPadding(0, dip2px(this.mContext, 10.0d), 0, 0);
        Styles.reRenderTextView(textView, ResResolver.getString("aihelp_form_hint"));
        linearLayout.addView(textView);
        TextView highlightedClickableTextView = getHighlightedClickableTextView(faqData.getFormTitle(), new View.OnClickListener() {
            @Override
            public void onClick(View view2) {
                String formUrl = faqData.getFormUrl();
                if (!AppInfoUtil.isUrlStillNeedResponding(AgentFaqAdapter.this.mContext, formUrl) || AgentFaqAdapter.this.mWrapper == null) {
                    return;
                }
                AgentFaqAdapter.this.mWrapper.onUrlClicked(true, formUrl);
            }
        });
        highlightedClickableTextView.setLayoutParams(new ViewGroup.MarginLayoutParams(-2, -2));
        highlightedClickableTextView.setTypeface(Typeface.defaultFromStyle(1));
        highlightedClickableTextView.setPadding(0, dip2px(this.mContext, 5.0d), 0, 0);
        linearLayout.addView(highlightedClickableTextView);
    }

    private View.OnClickListener getFaqViewer(final BotMessage botMessage, final Faq.FaqData faqData) {
        return new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.m136x9567bd85(botMessage, faqData, view);
            }
        };
    }

    void m136x9567bd85(BotMessage botMessage, Faq.FaqData faqData, View view) {
        checkoutFaqDetail(botMessage, faqData);
    }

    protected void checkoutFaqDetail(BotMessage botMessage, Faq.FaqData faqData) {
        if (faqData == null || !FastClickValidator.validate()) {
            return;
        }
        faqData.setFaqViewed(true);
        trackAnswerFaqChecked(faqData);
        BotFaqViewer.INSTANCE.show(this.mContext, botMessage, faqData, this);
    }

    private void trackAnswerFaqChecked(Faq.FaqData faqData) {
        AIHelpEventTracker.getInstance().checkedFAQInBot(faqData.getFaqSource(), String.valueOf(faqData.getMainId()), String.valueOf(faqData.getContentId()));
    }
}
