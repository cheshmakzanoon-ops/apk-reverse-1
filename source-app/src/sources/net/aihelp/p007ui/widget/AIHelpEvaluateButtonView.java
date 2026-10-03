package net.aihelp.p007ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;
import java.util.Iterator;
import net.aihelp.common.API;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import org.json.JSONObject;

public class AIHelpEvaluateButtonView extends FrameLayout implements View.OnClickListener {
    public static final int STATE_HELPFUL = 3;
    public static final int STATE_INVISIBLE = 2;
    public static final int STATE_NORMAL = 1;
    public static final int STATE_UNHELPFUL = 4;
    private OnAIHelpEvaluateViewCallback listener;
    private final AIHelpButton mBtnHelpful;
    private final AIHelpButton mBtnUnHelpful;
    private final TextView mTvShowThanks;
    private int maxWidth;
    private int minWidth;

    public static abstract class OnAIHelpEvaluateViewCallback {
        public void onEvaluated(boolean z) {
        }

        public JSONObject requestDataForFeedback() {
            return null;
        }
    }

    public int getMinWidth() {
        return this.minWidth;
    }

    private void resetEvaluateState() {
        setVisibility(0);
        this.mBtnHelpful.setVisibility(0);
        this.mBtnUnHelpful.setVisibility(0);
        this.mTvShowThanks.setVisibility(8);
    }

    private void setEvaluateState(int i) {
        resetEvaluateState();
        if (i != 1) {
            if (i == 2) {
                setVisibility(8);
                return;
            }
            if (i == 3 || i == 4) {
                this.mBtnHelpful.setVisibility(8);
                this.mBtnUnHelpful.setVisibility(8);
                this.mTvShowThanks.setVisibility(0);
                if (i == 3) {
                    Styles.reRenderTextView(this.mTvShowThanks, CustomConfig.CommonSetting.commonPositiveFeedbackHint, 0.5f);
                } else {
                    Styles.reRenderTextView(this.mTvShowThanks, CustomConfig.CommonSetting.commonNegativeFeedbackHint, 0.5f);
                }
                this.mTvShowThanks.measure(0, 0);
                this.minWidth = this.mTvShowThanks.getMeasuredWidth();
                return;
            }
            return;
        }
        int iMax = Math.max(this.mBtnUnHelpful.getMeasuredWidth(), this.mBtnHelpful.getMeasuredWidth());
        int i2 = iMax * 2;
        this.minWidth = Styles.dpToPx(getContext(), 20.0f) + i2;
        if (this.maxWidth > 0) {
            int iDpToPx = i2 + Styles.dpToPx(getContext(), 20.0f);
            int i3 = this.maxWidth;
            if (iDpToPx > i3) {
                iMax = (i3 - Styles.dpToPx(getContext(), 20.0f)) / 2;
            }
        }
        ViewGroup.LayoutParams layoutParams = this.mBtnUnHelpful.getLayoutParams();
        layoutParams.width = iMax;
        this.mBtnUnHelpful.setLayoutParams(layoutParams);
        ViewGroup.LayoutParams layoutParams2 = this.mBtnHelpful.getLayoutParams();
        layoutParams2.width = iMax;
        this.mBtnHelpful.setLayoutParams(layoutParams2);
    }

    public void setOnAIHelpEvaluateViewCallback(OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback) {
        this.listener = onAIHelpEvaluateViewCallback;
    }

    public AIHelpEvaluateButtonView(Context context) {
        this(context, null);
    }

    public AIHelpEvaluateButtonView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpEvaluateButtonView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View viewInflate = View.inflate(context, ResResolver.getLayoutId("aihelp_evaluate_button_view"), this);
        AIHelpButton aIHelpButton = (AIHelpButton) viewInflate.findViewById(ResResolver.getViewId("aihelp_btn_un_helpful"));
        this.mBtnUnHelpful = aIHelpButton;
        aIHelpButton.setText(ResResolver.getString("aihelp_faq_unhelpful"));
        aIHelpButton.measure(0, 0);
        AIHelpButton aIHelpButton2 = (AIHelpButton) viewInflate.findViewById(ResResolver.getViewId("aihelp_btn_helpful"));
        this.mBtnHelpful = aIHelpButton2;
        aIHelpButton2.setText(ResResolver.getString("aihelp_faq_helpful"));
        aIHelpButton2.measure(0, 0);
        this.mTvShowThanks = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_thanks"));
        aIHelpButton.setOnClickListener(this);
        aIHelpButton2.setOnClickListener(this);
    }

    public void refreshViewState(int i) {
        if (!CustomConfig.CommonSetting.isEvaluationForBotEnable) {
            setEvaluateState(2);
            return;
        }
        if (i == -1) {
            setEvaluateState(2);
            return;
        }
        if (i == 0) {
            setEvaluateState(1);
        } else if (i == 1) {
            setEvaluateState(3);
        } else {
            if (i != 2) {
                return;
            }
            setEvaluateState(4);
        }
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == ResResolver.getViewId("aihelp_btn_un_helpful")) {
            setEvaluateState(4);
            postHelpfulStatusForAnswerBot(false);
        }
        if (view.getId() == ResResolver.getViewId("aihelp_btn_helpful")) {
            setEvaluateState(3);
            postHelpfulStatusForAnswerBot(true);
        }
    }

    private void postHelpfulStatusForAnswerBot(boolean z) {
        OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback = this.listener;
        if (onAIHelpEvaluateViewCallback != null) {
            onAIHelpEvaluateViewCallback.onEvaluated(z);
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("type", z ? "like" : "unlike");
            OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback2 = this.listener;
            if (onAIHelpEvaluateViewCallback2 != null && onAIHelpEvaluateViewCallback2.requestDataForFeedback() != null) {
                JSONObject jSONObjectRequestDataForFeedback = this.listener.requestDataForFeedback();
                Iterator<String> itKeys = jSONObjectRequestDataForFeedback.keys();
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    jSONObject.put(next, jSONObjectRequestDataForFeedback.opt(next));
                }
            }
            AIHelpRequest.getInstance().requestPostByJson(API.EVALUATE_ANSWER_BOT_FAQ, jSONObject, (BaseCallback) null);
        } catch (Exception unused) {
        }
    }

    public void setMaxWidth(int i) {
        this.maxWidth = i;
    }
}
