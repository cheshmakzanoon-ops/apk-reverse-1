package net.aihelp.p007ui.adapter.p008cs.agent;

import android.content.Context;
import android.view.View;
import android.widget.TextView;
import java.util.List;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.UserMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.Answer;
import net.aihelp.data.model.rpa.msg.bot.Faq;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.widget.AIHelpEvaluateButtonView;
import net.aihelp.utils.FastClickValidator;
import net.aihelp.utils.Styles;
import org.json.JSONObject;

public class AgentAnswerAdapter extends AgentFaqAdapter {
    private AIHelpEvaluateButtonView mEvaluateButtonView;

    public AgentAnswerAdapter(Context context) {
        super(context);
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 5;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        super.convert(viewHolder, message, i);
        if (message instanceof BotMessage) {
            BotMessage botMessage = (BotMessage) message;
            if (botMessage.hasBotAnswers()) {
                List<Answer> botAnswers = botMessage.getBotAnswers();
                int i2 = 0;
                if (isSingleFaqMatched(botMessage)) {
                    this.llContainer.removeAllViews();
                    Answer answer = botMessage.getBotAnswers().get(0);
                    this.llContainer.addView(getSingleFAQItem(botMessage, answer.getFaqData()));
                    if (answer.getFaqData().hasAttachedForm()) {
                        prepareFaqFormLayout(this.llContainer, answer.getFaqData());
                    }
                    prepareEvaluateLayout(viewHolder, botMessage, answer.getFaqData());
                    return;
                }
                while (i2 < botAnswers.size()) {
                    Answer answer2 = botAnswers.get(i2);
                    i2++;
                    this.llContainer.addView(getListItem(i2, botMessage, answer2));
                }
            }
        }
    }

    private boolean isSingleFaqMatched(BotMessage botMessage) {
        if (!botMessage.hasBotAnswers() || botMessage.getBotAnswers().size() != 1) {
            return false;
        }
        Answer answer = botMessage.getBotAnswers().get(0);
        return answer.getType() == 1 && answer.getFaqData() != null;
    }

    private TextView getListItem(int i, final BotMessage botMessage, Answer answer) {
        final String title = answer.getTitle();
        final Faq.FaqData faqData = answer.getFaqData();
        TextView listItem = super.getListItem(i, title, botMessage, faqData);
        listItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public final void onClick(View view) {
                this.f$0.m135x6fae2da0(title, botMessage, faqData, view);
            }
        });
        return listItem;
    }

    void m135x6fae2da0(String str, BotMessage botMessage, Faq.FaqData faqData, View view) {
        if (TicketStatusTracker.isTicketServingByAnswerBot()) {
            sendRPAMessageWithBotAnswer(str);
        } else {
            botMessage.setUserFeedback(-1);
            checkoutFaqDetail(botMessage, faqData);
        }
    }

    private void sendRPAMessageWithBotAnswer(String str) {
        if (this.mWrapper == null || !FastClickValidator.validate()) {
            return;
        }
        UserMessage userTextMsg = Message.getUserTextMsg(str);
        userTextMsg.setRequestParams(str, 1, 6);
        this.mWrapper.onBotAnswerSelected(userTextMsg);
        AIHelpEventTracker.getInstance().onAnswerBotSelected();
    }

    private void prepareEvaluateLayout(ViewHolder viewHolder, final BotMessage botMessage, final Faq.FaqData faqData) {
        AIHelpEvaluateButtonView aIHelpEvaluateButtonView = (AIHelpEvaluateButtonView) viewHolder.getView(getViewId("aihelp_evaluate_view"));
        this.mEvaluateButtonView = aIHelpEvaluateButtonView;
        aIHelpEvaluateButtonView.setMaxWidth(Styles.getScreenWidth(this.mContext) - Styles.dpToPx(this.mContext, 110.0f));
        this.mEvaluateButtonView.refreshViewState(botMessage.getUserFeedback());
        this.mEvaluateButtonView.setOnAIHelpEvaluateViewCallback(new AIHelpEvaluateButtonView.OnAIHelpEvaluateViewCallback() {
            @Override
            public void onEvaluated(boolean z) {
                botMessage.setUserFeedback(z ? 1 : 2);
            }

            @Override
            public JSONObject requestDataForFeedback() {
                JSONObject jSONObject = new JSONObject();
                try {
                    jSONObject.put("mainId", faqData.getMainId());
                    jSONObject.put("contentId", faqData.getContentId());
                    jSONObject.put("isClickDetail", faqData.isFaqViewed());
                    jSONObject.put("pointMessageId", String.valueOf(botMessage.getTimestamp()));
                } catch (Exception unused) {
                }
                return jSONObject;
            }
        });
        this.llContainer.setMinimumWidth(this.mEvaluateButtonView.getMinWidth());
    }

    @Override
    public void onEvaluated(BotMessage botMessage, boolean z) {
        AIHelpEvaluateButtonView aIHelpEvaluateButtonView = this.mEvaluateButtonView;
        if (aIHelpEvaluateButtonView != null) {
            aIHelpEvaluateButtonView.refreshViewState(botMessage.getUserFeedback());
        }
    }
}
