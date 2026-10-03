package net.aihelp.p007ui.adapter.p008cs.agent;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.p007ui.widget.AIHelpLoadingImageView;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AgentImageAdapter extends BaseMsgAdapter {
    private Fragment fragment;

    public AgentImageAdapter(Context context, Fragment fragment) {
        super(context);
        this.fragment = fragment;
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_agent_image");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 6;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        if (message instanceof FileMessage) {
            final FileMessage fileMessage = (FileMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csManualSupportPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_agent");
            Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_nickname")), fileMessage.getNickname(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(fileMessage.getNickname()), 13);
            final AIHelpLoadingImageView aIHelpLoadingImageView = (AIHelpLoadingImageView) viewHolder.getView(getViewId("aihelp_iv_holder"));
            aIHelpLoadingImageView.loadIntoImageView(this.mContext, fileMessage);
            aIHelpLoadingImageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (aIHelpLoadingImageView.isLoading()) {
                        return;
                    }
                    PreviewActivity.startAct(AgentImageAdapter.this.fragment, PreviewInfo.get(fileMessage.getContent()));
                }
            });
        }
    }
}
