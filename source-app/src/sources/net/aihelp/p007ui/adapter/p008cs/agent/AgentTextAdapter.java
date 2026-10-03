package net.aihelp.p007ui.adapter.p008cs.agent;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.BotMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.ExternalUrl;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.p009cs.util.viewer.SelfServiceViewer;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.DeviceUuidFactory;
import net.aihelp.utils.FastClickValidator;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import org.json.JSONObject;

public class AgentTextAdapter extends BaseMsgAdapter {
    public AgentTextAdapter(Context context) {
        super(context);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_agent");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 3;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        LinearLayout linearLayout = (LinearLayout) viewHolder.getView(getViewId("aihelp_agent_message_container"));
        linearLayout.setBackground(getAdminBackgroundDrawable(this.isCurrentRtl));
        linearLayout.removeAllViews();
        boolean z = message instanceof BotMessage;
        Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), z ? CustomConfig.CustomerService.csBotSupportPortrait : CustomConfig.CustomerService.csManualSupportPortrait, CustomConfig.CustomerService.isPortraitVisible, z ? "aihelp_svg_portrait_robot" : "aihelp_svg_portrait_agent");
        Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_nickname")), message.getNickname(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(message.getNickname()), 13);
        if (z) {
            convertElvaBotTextMsg(linearLayout, (BotMessage) message);
            viewHolder.setVisible(getViewId("aihelp_iv_translate"), false);
        } else {
            viewHolder.setVisible(getViewId("aihelp_iv_translate"), Const.TOGGLE_TRANSLATE_CS_MESSAGE);
            convertSupportTextMsg(viewHolder, linearLayout, message, i);
        }
    }

    private void convertSupportTextMsg(ViewHolder viewHolder, ViewGroup viewGroup, Message message, int i) {
        TextView msg = getMsg(message.getContent(), message.isEnableInteraction());
        msg.setTextColor(Color.parseColor(CustomConfig.CommonSetting.textColor));
        prepareTranslate(viewHolder, msg, i);
        viewGroup.addView(msg);
    }

    private void convertElvaBotTextMsg(ViewGroup viewGroup, final BotMessage botMessage) {
        if (!TextUtils.isEmpty(botMessage.getContent())) {
            viewGroup.addView(getMsg(botMessage.getContent(), botMessage.isEnableInteraction()));
        }
        if (botMessage.hasExternalUrl()) {
            final ExternalUrl externalUrl = botMessage.getExternalUrl();
            viewGroup.addView(getHighlightedClickableTextView(externalUrl.getTitle(), new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    String link = externalUrl.getLink();
                    if (!AppInfoUtil.isUrlStillNeedResponding(AgentTextAdapter.this.mContext, link) || AgentTextAdapter.this.mWrapper == null) {
                        return;
                    }
                    AgentTextAdapter.this.mWrapper.onUrlClicked(false, link);
                }
            }));
        }
        if (!botMessage.hasSelfService() || botMessage.getSelfService().isEnableSend()) {
            return;
        }
        viewGroup.addView(getHighlightedClickableTextView(ResResolver.getString("aihelp_view_details"), new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (AgentTextAdapter.this.mWrapper == null || !FastClickValidator.validate()) {
                    return;
                }
                new SelfServiceViewer().getService(AgentTextAdapter.this.mContext, botMessage.getSelfService());
            }
        }));
    }

    private void prepareTranslate(final ViewHolder viewHolder, final TextView textView, int i) {
        if (Const.TOGGLE_TRANSLATE_CS_MESSAGE) {
            textView.setMaxWidth(Styles.getScreenWidth(this.mContext) - dip2px(this.mContext, 165.0d));
            final String string = textView.getText().toString();
            final StringBuilder sb = new StringBuilder(string);
            viewHolder.setOnClickListener(getViewId("aihelp_iv_translate"), new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    try {
                        JSONObject jSONObject = new JSONObject();
                        jSONObject.put("deviceId", DeviceUuidFactory.m137id(AgentTextAdapter.this.mContext));
                        jSONObject.put("playerId", UserProfile.USER_ID);
                        jSONObject.put("content", string);
                        AIHelpRequest.getInstance().requestPostByJson(API.TRANSLATE_MESSAGE, jSONObject, new ReqCallback<String>() {
                            @Override
                            public void onReqSuccess(String str) {
                                StringBuilder sb2 = sb;
                                sb2.append("\n---------\n");
                                sb2.append(str);
                                textView.setText(sb.toString());
                                textView.setMaxWidth(Integer.MAX_VALUE);
                            }
                        });
                        viewHolder.setVisible(AgentTextAdapter.this.getViewId("aihelp_iv_translate"), false);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    }
}
