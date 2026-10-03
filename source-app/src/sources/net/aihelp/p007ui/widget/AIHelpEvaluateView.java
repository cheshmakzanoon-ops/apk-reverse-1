package net.aihelp.p007ui.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.appcompat.widget.AppCompatImageView;
import java.util.Iterator;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.p004ui.dialog.AlertDialog;
import net.aihelp.data.track.AIHelpEventTracker;
import net.aihelp.p007ui.wrapper.TextWatcherWrapper;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import net.aihelp.utils.ToastUtil;
import org.json.JSONObject;

public class AIHelpEvaluateView extends FrameLayout implements View.OnClickListener {
    public static final int FAQ_TYPE_BOT_FAQ = 1;
    public static final int FAQ_TYPE_FAQ_DETAIL = 2;
    public static final int FAQ_TYPE_OPERATE_ARTICLE = 3;
    public static final int STATE_INVISIBLE = 2;
    public static final int STATE_NORMAL = 1;
    public static final int STATE_PLAIN_TEXT = 3;
    public static final int STATE_REQUESTING_FEEDBACK = 4;
    private String contentId;
    private int evaluateTarget;
    private OnAIHelpEvaluateViewCallback listener;
    private final ViewGroup mAfterEvaluateLayout;
    private final ViewGroup mEvaluateFaqLayout;
    private final AIHelpButton mTvAdvice;
    private final TextView mTvShowThanks;
    private String mainId;
    private String title;

    public static abstract class OnAIHelpEvaluateViewCallback {
        public void onEvaluated(boolean z) {
        }

        public void onFeedbackConfirmed() {
        }

        public JSONObject requestDataForFeedback() {
            return null;
        }
    }

    public void setFaqData(String str, String str2, String str3) {
        this.title = str;
        this.mainId = str2;
        this.contentId = str3;
    }

    public void setEvaluateState(int i) {
        setVisibility(0);
        if (i == 2) {
            setVisibility(8);
            return;
        }
        if (i == 3) {
            this.mEvaluateFaqLayout.setVisibility(8);
            this.mAfterEvaluateLayout.setVisibility(0);
            this.mTvAdvice.setVisibility(8);
            Styles.reRenderTextView(this.mTvShowThanks, CustomConfig.CommonSetting.commonPositiveFeedbackHint, 0.5f);
            return;
        }
        if (i != 4) {
            return;
        }
        this.mEvaluateFaqLayout.setVisibility(8);
        this.mAfterEvaluateLayout.setVisibility(0);
        Styles.reRenderTextView(this.mTvShowThanks, CustomConfig.CommonSetting.commonNegativeFeedbackHint, 0.5f);
        this.mTvAdvice.setVisibility(CustomConfig.CommonSetting.isFaqUnhelpfulFeedbackEnable ? 0 : 8);
    }

    public void setOnAIHelpEvaluateViewCallback(OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback) {
        this.listener = onAIHelpEvaluateViewCallback;
    }

    public AIHelpEvaluateView(Context context) {
        this(context, null);
    }

    public AIHelpEvaluateView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpEvaluateView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.evaluateTarget = -1;
        int[] styleable = ResResolver.getStyleable("aihelp_evaluate_view");
        if (styleable != null) {
            TypedArray typedArrayObtainStyledAttributes = context.obtainStyledAttributes(attributeSet, styleable);
            this.evaluateTarget = typedArrayObtainStyledAttributes.getInt(ResResolver.getStyleableFieldIndex("aihelp_evaluate_view", "aihelp_evaluate_target"), -1);
            typedArrayObtainStyledAttributes.recycle();
        }
        View viewInflate = View.inflate(context, ResResolver.getLayoutId("aihelp_evaluate_view"), this);
        this.mEvaluateFaqLayout = (ViewGroup) viewInflate.findViewById(ResResolver.getViewId("aihelp_ll_evaluate_faq"));
        AppCompatImageView appCompatImageViewFindViewById = viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_un_helpful"));
        Styles.reRenderImageView((ImageView) appCompatImageViewFindViewById, "aihelp_svg_ic_un_helpful", true);
        AppCompatImageView appCompatImageViewFindViewById2 = viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_helpful"));
        Styles.reRenderImageView((ImageView) appCompatImageViewFindViewById2, "aihelp_svg_ic_helpful", true);
        this.mAfterEvaluateLayout = (ViewGroup) viewInflate.findViewById(ResResolver.getViewId("aihelp_ll_feedback"));
        this.mTvShowThanks = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_thanks"));
        AIHelpButton aIHelpButton = (AIHelpButton) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_advice"));
        this.mTvAdvice = aIHelpButton;
        aIHelpButton.setText(ResResolver.getString("aihelp_faq_feedback_suggest"));
        appCompatImageViewFindViewById.setOnClickListener(this);
        appCompatImageViewFindViewById2.setOnClickListener(this);
        aIHelpButton.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == ResResolver.getViewId("aihelp_iv_un_helpful")) {
            setEvaluateState(4);
            OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback = this.listener;
            if (onAIHelpEvaluateViewCallback != null) {
                onAIHelpEvaluateViewCallback.onEvaluated(false);
            }
            if (this.evaluateTarget != 1) {
                AIHelpEventTracker.getInstance().markedUnhelpful(this.mainId, this.contentId, this.title);
            }
        }
        if (view.getId() == ResResolver.getViewId("aihelp_iv_helpful")) {
            setEvaluateState(3);
            OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback2 = this.listener;
            if (onAIHelpEvaluateViewCallback2 != null) {
                onAIHelpEvaluateViewCallback2.onEvaluated(true);
            }
            if (this.evaluateTarget != 1) {
                AIHelpEventTracker.getInstance().markedHelpful(this.mainId, this.contentId, this.title);
            }
        }
        if (view.getId() == ResResolver.getViewId("aihelp_tv_advice")) {
            showAdviceAlert(view.getContext(), this.evaluateTarget, this.mainId);
        }
    }

    public void showAdviceAlert(final Context context, final int i, final String str) {
        final AlertDialog alertDialogCreate = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_advice")).setWidthByDevice().create();
        final EditText editText = (EditText) alertDialogCreate.getView(ResResolver.getViewId("aihelp_et_feedback"));
        TextView textView = (TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_title"));
        TextView textView2 = (TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_cancel"));
        final TextView textView3 = (TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_confirm"));
        editText.setHint(ResResolver.getString("aihelp_chat_hint"));
        textView.setText(ResResolver.getString("aihelp_faq_feedback"));
        textView2.setText(ResResolver.getString("aihelp_no"));
        textView3.setText(ResResolver.getString("aihelp_yes"));
        alertDialogCreate.setOnClickListener(ResResolver.getViewId("aihelp_tv_cancel"), new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                alertDialogCreate.dismiss();
            }
        });
        editText.addTextChangedListener(new TextWatcherWrapper() {
            @Override
            public void onTextChanged(CharSequence charSequence, int i2, int i3, int i4) {
                textView3.setEnabled(!TextUtils.isEmpty(charSequence.toString().trim()));
                textView3.setAlpha(TextUtils.isEmpty(charSequence) ? 0.5f : 1.0f);
            }
        });
        textView3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (TextUtils.isEmpty(editText.getText().toString().trim())) {
                    ToastUtil.INSTANCE.makeRawToast(context, ResResolver.getString("aihelp_faq_feedback"));
                    return;
                }
                alertDialogCreate.dismiss();
                AIHelpEvaluateView aIHelpEvaluateView = AIHelpEvaluateView.this;
                aIHelpEvaluateView.postFeedbackOnFaq(i, str, aIHelpEvaluateView.contentId, editText.getText().toString().trim(), String.valueOf(System.currentTimeMillis()));
                AIHelpEvaluateView.this.mTvAdvice.setVisibility(8);
                if (AIHelpEvaluateView.this.listener != null) {
                    AIHelpEvaluateView.this.listener.onFeedbackConfirmed();
                }
            }
        });
        alertDialogCreate.show();
    }

    public void postFeedbackOnFaq(int i, final String str, final String str2, final String str3, String str4) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("Language", Const.CORRECT_LANGUAGE);
            jSONObject.put("PlayerId", String.format("%s|%s", Const.APP_ID, UserProfile.USER_ID));
            jSONObject.put("PlayerName", UserProfile.USER_NAME);
            jSONObject.put("FaqId", str);
            jSONObject.put("contentId", str2);
            jSONObject.put("Message", str3);
            jSONObject.put("Type", i);
            jSONObject.put("CreateTime", str4);
            OnAIHelpEvaluateViewCallback onAIHelpEvaluateViewCallback = this.listener;
            if (onAIHelpEvaluateViewCallback != null && onAIHelpEvaluateViewCallback.requestDataForFeedback() != null) {
                JSONObject jSONObjectRequestDataForFeedback = this.listener.requestDataForFeedback();
                Iterator<String> itKeys = jSONObjectRequestDataForFeedback.keys();
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    jSONObject.put(next, jSONObjectRequestDataForFeedback.optString(next));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        AIHelpRequest.getInstance().requestPostByJson(API.FAQ_FEEDBACK_URL, jSONObject, new ReqCallback<String>() {
            @Override
            public void onReqSuccess(String str5) {
                AIHelpEventTracker.getInstance().submitSuggestion(str, str2, AIHelpEvaluateView.this.title, str3);
            }
        });
    }
}
