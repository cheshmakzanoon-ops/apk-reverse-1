package net.aihelp.p007ui.adapter.p008cs.agent;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AgentFileAdapter extends BaseMsgAdapter {
    public AgentFileAdapter(Context context, Fragment fragment) {
        super(context, fragment);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_agent_file");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 9;
    }

    @Override
    public void convert(ViewHolder viewHolder, final Message message, int i) {
        if (message instanceof FileMessage) {
            final FileMessage fileMessage = (FileMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csManualSupportPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_agent");
            Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_nickname")), fileMessage.getNickname(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(fileMessage.getNickname()), 13);
            RelativeLayout relativeLayout = (RelativeLayout) viewHolder.getView(getViewId("aihelp_rl_file_container"));
            relativeLayout.setBackground(getAdminBackgroundDrawable(this.isCurrentRtl));
            relativeLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    PreviewActivity.startAct(AgentFileAdapter.this.mFragment, PreviewInfo.get(fileMessage.getContent(), fileMessage.getFileName()));
                }
            });
            TextView textView = (TextView) viewHolder.getView(getViewId("aihelp_tv_file_name"));
            textView.setMaxWidth(getRightfulMaxWidthForFileName());
            Styles.reRenderTextView(textView, fileMessage.getFileName(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), true, 14);
            Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_file_size")), fileMessage.getFileSize(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), true, 14);
            Styles.reRenderImageView((ImageView) viewHolder.getView(getViewId("aihelp_iv_file")), "aihelp_svg_ic_file", Styles.getColor(CustomConfig.CommonSetting.highlightedColor));
            Styles.reRenderImageView((ImageView) viewHolder.getView(getViewId("aihelp_iv_download")), "aihelp_svg_ic_download", Styles.getColor(CustomConfig.CommonSetting.highlightedColor));
            viewHolder.getView(ResResolver.getViewId("aihelp_iv_download")).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    AppInfoUtil.openWithBrowser(AgentFileAdapter.this.mContext, message.getContent());
                }
            });
        }
    }

    private int getRightfulMaxWidthForFileName() {
        return ((((((Styles.getScreenWidth(this.mContext) - dip2px(this.mContext, 39.0d)) - dip2px(this.mContext, 20.0d)) - dip2px(this.mContext, 20.0d)) - dip2px(this.mContext, 36.0d)) - dip2px(this.mContext, 20.0d)) - dip2px(this.mContext, 23.0d)) - dip2px(this.mContext, 60.0d);
    }
}
