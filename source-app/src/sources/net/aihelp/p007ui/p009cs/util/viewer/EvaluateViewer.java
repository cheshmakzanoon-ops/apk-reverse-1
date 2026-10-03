package net.aihelp.p007ui.p009cs.util.viewer;

import android.R;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.ColorStateList;
import android.text.TextUtils;
import android.util.SparseArray;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import java.util.ArrayList;
import java.util.List;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.core.p004ui.dialog.AlertDialog;
import net.aihelp.core.util.bus.EventBus;
import net.aihelp.core.util.bus.Subscribe;
import net.aihelp.core.util.bus.ThreadMode;
import net.aihelp.core.util.bus.event.EventCenter;
import net.aihelp.data.event.OrientationChangeEvent;
import net.aihelp.data.localize.config.FeedbackOpinionHelper;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.p007ui.widget.AIHelpRatingBar;
import net.aihelp.p007ui.wrapper.TextWatcherWrapper;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.DeviceUuidFactory;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SpUtil;
import net.aihelp.utils.Styles;
import org.json.JSONArray;
import org.json.JSONObject;

public class EvaluateViewer {
    private EditText etFeedback;
    private LinearLayout llFeedbackLayout;
    private AlertDialog rateSupportDialog;
    private int selectedRateValue = 5;
    private final List<String> selectedOptionIds = new ArrayList();
    private String inputFeedback = "";

    public interface OnConfirmEvaluateListener {
        void onAfterEvaluate();

        void onPostEvaluate();
    }

    public interface OnConfirmResolveStatusListener {
        void onConfirmResolve(boolean z);
    }

    public static EvaluateViewer getInstance() {
        return new EvaluateViewer();
    }

    public void show(Context context, OnConfirmEvaluateListener onConfirmEvaluateListener) {
        if (TicketStatusTracker.isTicketWaitForAskingResolveStatus) {
            askAboutIssueResolvedStatus(context, onConfirmEvaluateListener, null);
        } else {
            showRateSupport(context, onConfirmEvaluateListener);
        }
    }

    public void askAboutIssueResolvedStatus(final Context context, final OnConfirmEvaluateListener onConfirmEvaluateListener, final OnConfirmResolveStatusListener onConfirmResolveStatusListener) {
        final AlertDialog alertDialogCreate = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_issue_solve_status")).setGravity(80).fromBottom(true).setCancelableOntheOutside(onConfirmEvaluateListener != null).setWidthAndHeight(-1, -2).create();
        ((RelativeLayout) alertDialogCreate.getView(ResResolver.getViewId("aihelp_rl_issue_solve"))).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, Math.min(CustomConfig.CommonSetting.upperBackgroundAlpha + 0.6d, 0.8d)));
        Styles.reRenderTextView((TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_title")), ResResolver.getString("aihelp_resolution_request"));
        AIHelpButton aIHelpButton = (AIHelpButton) alertDialogCreate.getView(ResResolver.getViewId("aihelp_btn_unsolved"));
        aIHelpButton.setText(ResResolver.getString("aihelp_resolution_no"));
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EvaluateViewer.this.onSolveStatusConfirmed(context, alertDialogCreate, onConfirmEvaluateListener, onConfirmResolveStatusListener, false);
            }
        });
        AIHelpButton aIHelpButton2 = (AIHelpButton) alertDialogCreate.getView(ResResolver.getViewId("aihelp_btn_solved"));
        aIHelpButton2.setText(ResResolver.getString("aihelp_resolution_yes"));
        aIHelpButton2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EvaluateViewer.this.onSolveStatusConfirmed(context, alertDialogCreate, onConfirmEvaluateListener, onConfirmResolveStatusListener, true);
            }
        });
        alertDialogCreate.show();
    }

    public void onSolveStatusConfirmed(Context context, Dialog dialog, OnConfirmEvaluateListener onConfirmEvaluateListener, OnConfirmResolveStatusListener onConfirmResolveStatusListener, boolean z) {
        if (onConfirmResolveStatusListener != null) {
            dialog.dismiss();
            onConfirmResolveStatusListener.onConfirmResolve(z);
            return;
        }
        if (AppInfoUtil.validateNetwork(context)) {
            try {
                dialog.dismiss();
                if (onConfirmEvaluateListener != null) {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("userId", UserProfile.USER_ID);
                    jSONObject.put("deviceId", DeviceUuidFactory.m137id(context));
                    jSONObject.put("resolveType", z ? 1 : 2);
                    AIHelpRequest.getInstance().requestPostByJson(API.ASK_FOR_RESOLVE_STATUS, jSONObject, (BaseCallback) null);
                    TicketStatusTracker.isTicketWaitForAskingResolveStatus = false;
                    if (TicketStatusTracker.isTicketWaitForRating) {
                        showRateSupport(context, onConfirmEvaluateListener);
                    } else {
                        onConfirmEvaluate(context, onConfirmEvaluateListener);
                        showThanksAfterEvaluate(context, false);
                    }
                }
            } catch (Exception unused) {
            }
        }
    }

    private void showRateSupport(final Context context, final OnConfirmEvaluateListener onConfirmEvaluateListener) {
        this.rateSupportDialog = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_rate_support")).setGravity(80).fromBottom(true).setCancelableOntheOutside(true).setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialogInterface) {
                EventBus.getDefault().unregister(EvaluateViewer.this);
            }
        }).fullWidth().create();
        ((RelativeLayout) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_rl_rate_layout"))).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, Math.min(CustomConfig.CommonSetting.upperBackgroundAlpha + 0.6d, 0.8d)));
        Styles.reRenderTextView((TextView) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_tv_title")), CustomConfig.CustomerService.csInviteEvaluate);
        Styles.reRenderTextView((TextView) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_tv_rating_dislike")), ResResolver.getString("aihelp_rate_dissatisfied"));
        Styles.reRenderTextView((TextView) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_tv_rating_like")), ResResolver.getString("aihelp_rate_satisfied"));
        this.llFeedbackLayout = (LinearLayout) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_ll_feedback"));
        final SparseArray<JSONArray> opinionArray = FeedbackOpinionHelper.INSTANCE.getOpinionArray();
        resetFeedbackOptions(context, opinionArray.get(this.selectedRateValue));
        AIHelpRatingBar aIHelpRatingBar = (AIHelpRatingBar) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_rating_bar"));
        if (aIHelpRatingBar != null) {
            aIHelpRatingBar.setOnStatusChangedListener(new AIHelpRatingBar.OnStatusChangedListener() {
                @Override
                public void onRateStatusChanged(int i) {
                    EvaluateViewer.this.selectedOptionIds.clear();
                    EvaluateViewer.this.selectedRateValue = i;
                    EvaluateViewer.this.resetFeedbackOptions(context, (JSONArray) opinionArray.get(i));
                }
            });
        }
        AIHelpButton aIHelpButton = (AIHelpButton) this.rateSupportDialog.getView(ResResolver.getViewId("aihelp_btn_confirm"));
        aIHelpButton.setText(ResResolver.getString("aihelp_yes")).setFullWidth();
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (AppInfoUtil.validateNetwork(view.getContext())) {
                    EvaluateViewer evaluateViewer = EvaluateViewer.this;
                    evaluateViewer.showThanksAfterEvaluate(context, evaluateViewer.selectedRateValue == 5);
                    EvaluateViewer.this.rateSupportDialog.dismiss();
                    EvaluateViewer.this.onConfirmEvaluate(context, onConfirmEvaluateListener);
                }
            }
        });
        this.rateSupportDialog.show();
        EventBus.getDefault().register(this);
    }

    public void onConfirmEvaluate(Context context, final OnConfirmEvaluateListener onConfirmEvaluateListener) {
        String string;
        if (TicketStatusTracker.isTicketWaitForRating) {
            EditText editText = this.etFeedback;
            if (editText == null) {
                string = "";
            } else {
                string = editText.getText().toString();
            }
            try {
                JSONArray jSONArray = new JSONArray();
                JSONArray jSONArray2 = FeedbackOpinionHelper.INSTANCE.getOpinionArray().get(this.selectedRateValue);
                for (int i = 0; i < this.selectedOptionIds.size(); i++) {
                    String str = this.selectedOptionIds.get(i);
                    for (int i2 = 0; i2 < jSONArray2.length(); i2++) {
                        JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray2, i2);
                        if (str.equals(JsonHelper.optString(jsonObject, "id"))) {
                            jSONArray.put(jsonObject);
                        }
                    }
                }
                if (AppInfoUtil.validateNetwork(context)) {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("starIndex", this.selectedRateValue);
                    jSONObject.put("elseMsg", string);
                    jSONObject.put("chooseList", jSONArray);
                    jSONObject.put("userId", UserProfile.USER_ID);
                    AIHelpRequest.getInstance().requestPostByJson(API.EVALUATE_TICKET, jSONObject, new ReqCallback<String>() {
                        @Override
                        public void onReqSuccess(String str2) {
                            OnConfirmEvaluateListener onConfirmEvaluateListener2 = onConfirmEvaluateListener;
                            if (onConfirmEvaluateListener2 != null) {
                                onConfirmEvaluateListener2.onAfterEvaluate();
                            }
                        }
                    });
                    if (onConfirmEvaluateListener != null) {
                        onConfirmEvaluateListener.onPostEvaluate();
                    }
                }
            } catch (Exception unused) {
            }
        }
        SpUtil.getInstance().remove(Const.UNREAD_MESSAGE_TOKEN);
        TicketStatusTracker.resetTicketStatusFlags();
    }

    public void resetFeedbackOptions(Context context, JSONArray jSONArray) {
        if (CustomConfig.CustomerService.isEvaluateBadServiceEnable) {
            if (Styles.isLandscape()) {
                prepareFeedbackForLandscape(context, jSONArray);
            } else {
                prepareFeedbackForPortrait(context, jSONArray);
            }
        }
    }

    private void prepareFeedbackForPortrait(Context context, JSONArray jSONArray) {
        this.llFeedbackLayout.removeAllViews();
        if (jSONArray == null || jSONArray.length() <= 0) {
            return;
        }
        for (int i = 0; i < jSONArray.length(); i++) {
            this.llFeedbackLayout.addView(getFeedbackOptionItem(context, JsonHelper.getJsonObject(jSONArray, i)));
        }
        prepareFeedbackInput(context);
    }

    private void prepareFeedbackForLandscape(Context context, JSONArray jSONArray) {
        this.llFeedbackLayout.removeAllViews();
        if (jSONArray == null || jSONArray.length() <= 0) {
            return;
        }
        for (int i = 0; i < jSONArray.length(); i += 2) {
            View feedbackOptionItem = getFeedbackOptionItem(context, JsonHelper.getJsonObject(jSONArray, i));
            int i2 = i + 1;
            View feedbackOptionItem2 = i2 < jSONArray.length() ? getFeedbackOptionItem(context, JsonHelper.getJsonObject(jSONArray, i2)) : null;
            LinearLayout linearLayout = new LinearLayout(context);
            linearLayout.setOrientation(0);
            linearLayout.addView(feedbackOptionItem);
            if (feedbackOptionItem2 != null) {
                linearLayout.addView(feedbackOptionItem2);
            }
            this.llFeedbackLayout.addView(linearLayout);
        }
        prepareFeedbackInput(context);
    }

    private void prepareFeedbackInput(Context context) {
        View viewInflate = View.inflate(context, ResResolver.getLayoutId("aihelp_layout_feedback_input"), null);
        viewInflate.setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d), 8));
        ViewGroup.MarginLayoutParams marginLayoutParams = new ViewGroup.MarginLayoutParams(-1, -2);
        marginLayoutParams.topMargin = Styles.dpToPx(context, 10.0f);
        viewInflate.setLayoutParams(marginLayoutParams);
        EditText editText = (EditText) viewInflate.findViewById(ResResolver.getViewId("aihelp_et_feedback_input"));
        this.etFeedback = editText;
        Styles.reRenderTextView(editText, ResResolver.getString("aihelp_rate_additional_feedback_message"));
        final TextView textView = (TextView) viewInflate.findViewById(ResResolver.getViewId("aihelp_tv_max_length"));
        Styles.reRenderTextView(textView, "0/500", Styles.getColor(CustomConfig.CommonSetting.textColor));
        this.etFeedback.addTextChangedListener(new TextWatcherWrapper() {
            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
                textView.setText(String.format("%s/%s", Integer.valueOf(charSequence.length()), 500));
            }
        });
        this.etFeedback.setMaxHeight(Styles.dpToPx(context, 120.0f));
        if (!TextUtils.isEmpty(this.inputFeedback)) {
            this.etFeedback.setText(this.inputFeedback);
        }
        this.llFeedbackLayout.addView(viewInflate);
    }

    private View getFeedbackOptionItem(final Context context, final JSONObject jSONObject) {
        CheckBox checkBox = (CheckBox) View.inflate(context, ResResolver.getLayoutId("aihelp_layout_feedback_option"), null);
        String strOptString = JsonHelper.optString(jSONObject, "id");
        Styles.reRenderTextView(checkBox, JsonHelper.optString(jSONObject, "msg"));
        for (int i = 0; i < this.selectedOptionIds.size(); i++) {
            if (strOptString.equals(this.selectedOptionIds.get(i))) {
                checkBox.setChecked(true);
                break;
            }
        }
        checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean z) {
                if (z) {
                    EvaluateViewer.this.selectedOptionIds.add(JsonHelper.optString(jSONObject, "id"));
                } else {
                    EvaluateViewer.this.selectedOptionIds.remove(JsonHelper.optString(jSONObject, "id"));
                }
                EvaluateViewer.this.updateCheckBoxEnableStatus(context);
            }
        });
        checkBox.setButtonTintList(new ColorStateList(new int[][]{new int[]{-16842912}, new int[]{R.attr.state_checked}}, new int[]{Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d), Styles.getColor(CustomConfig.CommonSetting.interactElementTextColor)}));
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        layoutParams.weight = 1.0f;
        checkBox.setLayoutParams(layoutParams);
        return checkBox;
    }

    public void showThanksAfterEvaluate(final Context context, boolean z) {
        final AlertDialog alertDialogCreate = new AlertDialog.Builder(context).setContentView(ResResolver.getLayoutId("aihelp_dia_show_thanks")).setGravity(80).fromBottom(true).setCancelableOntheOutside(true).setWidthAndHeight(-1, -2).create();
        alertDialogCreate.getView(ResResolver.getViewId("aihelp_rl_show_thanks")).setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, Math.min(CustomConfig.CommonSetting.upperBackgroundAlpha + 0.6000000238418579d, 0.800000011920929d)));
        Styles.reRenderTextView((TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_thanks")), ResResolver.getString("aihelp_rate_finished"));
        Styles.reRenderTextView((TextView) alertDialogCreate.getView(ResResolver.getViewId("aihelp_tv_invite_rate")), ResResolver.getString("aihelp_rate_app_hint"), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.5d));
        AIHelpButton aIHelpButton = (AIHelpButton) alertDialogCreate.getView(ResResolver.getViewId("aihelp_go_rate"));
        aIHelpButton.setText(ResResolver.getString("aihelp_rate_button"));
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AppInfoUtil.goRateApp(context);
                alertDialogCreate.dismiss();
            }
        });
        alertDialogCreate.getView(ResResolver.getViewId("aihelp_ll_go_rate")).setVisibility((TicketStatusTracker.isAppRatable && z) ? 0 : 8);
        alertDialogCreate.show();
    }

    public void updateCheckBoxEnableStatus(Context context) {
        int childCount = this.llFeedbackLayout.getChildCount();
        if (!Styles.isLandscape()) {
            for (int i = 0; i < childCount; i++) {
                View childAt = this.llFeedbackLayout.getChildAt(i);
                if (childAt instanceof CheckBox) {
                    CheckBox checkBox = (CheckBox) childAt;
                    if (!checkBox.isChecked()) {
                        checkBox.setEnabled(this.selectedOptionIds.size() < CustomConfig.CustomerService.csEvaluateMaxCount);
                    }
                }
            }
            return;
        }
        for (int i2 = 0; i2 < childCount; i2++) {
            View childAt2 = this.llFeedbackLayout.getChildAt(i2);
            if (childAt2 instanceof LinearLayout) {
                LinearLayout linearLayout = (LinearLayout) childAt2;
                for (int i3 = 0; i3 < linearLayout.getChildCount(); i3++) {
                    View childAt3 = linearLayout.getChildAt(i3);
                    if (childAt3 instanceof CheckBox) {
                        CheckBox checkBox2 = (CheckBox) childAt3;
                        if (!checkBox2.isChecked()) {
                            checkBox2.setEnabled(this.selectedOptionIds.size() < CustomConfig.CustomerService.csEvaluateMaxCount);
                        }
                    }
                }
            }
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onEventComing(EventCenter eventCenter) {
        EditText editText;
        if (!(eventCenter instanceof OrientationChangeEvent) || (editText = this.etFeedback) == null) {
            return;
        }
        this.inputFeedback = editText.getText().toString();
        resetFeedbackOptions(this.etFeedback.getContext(), FeedbackOpinionHelper.INSTANCE.getOpinionArray().get(this.selectedRateValue));
    }
}
