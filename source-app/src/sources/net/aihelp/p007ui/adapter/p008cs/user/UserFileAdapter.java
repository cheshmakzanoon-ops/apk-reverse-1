package net.aihelp.p007ui.adapter.p008cs.user;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import androidx.appcompat.widget.AppCompatImageButton;
import androidx.fragment.app.Fragment;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.core.p004ui.loading.indicator.LoadingIndicatorView;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class UserFileAdapter extends BaseMsgAdapter {
    public UserFileAdapter(Context context, Fragment fragment) {
        super(context, fragment);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_user_file");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 14;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        if (message instanceof FileMessage) {
            final FileMessage fileMessage = (FileMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csUserPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_user");
            RelativeLayout relativeLayout = (RelativeLayout) viewHolder.getView(ResResolver.getViewId("aihelp_rl_file_container"));
            relativeLayout.setBackground(getUserBackgroundDrawable(this.isCurrentRtl));
            relativeLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (fileMessage.getMsgStatus() == 1) {
                        PreviewActivity.startAct(UserFileAdapter.this.mFragment, PreviewInfo.get(fileMessage.getContent(), fileMessage.getFileName()));
                    }
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
                    AppInfoUtil.openWithBrowser(UserFileAdapter.this.mContext, fileMessage.getContent());
                }
            });
            LoadingIndicatorView loadingIndicatorView = (LoadingIndicatorView) viewHolder.getView(getViewId("aihelp_iv_msg_sending"));
            loadingIndicatorView.setIndicatorColor(Styles.getColor(CustomConfig.CommonSetting.textColor));
            AppCompatImageButton view = viewHolder.getView(getViewId("aihelp_iv_msg_retry"));
            int msgStatus = message.getMsgStatus();
            if (msgStatus == 1) {
                loadingIndicatorView.setVisibility(8);
                view.setVisibility(8);
            } else if (msgStatus == 2) {
                loadingIndicatorView.setVisibility(0);
                view.setVisibility(8);
            } else {
                if (msgStatus != 3) {
                    return;
                }
                loadingIndicatorView.setVisibility(8);
                view.setVisibility(0);
                view.setImageResource(ResResolver.getDrawableId("aihelp_svg_iv_msg_retry"));
                view.setOnClickListener(getFileRetryListener(i, message));
            }
        }
    }

    private int getRightfulMaxWidthForFileName() {
        return ((((((Styles.getScreenWidth(this.mContext) - dip2px(this.mContext, 60.0d)) - dip2px(this.mContext, 36.0d)) - dip2px(this.mContext, 20.0d)) - dip2px(this.mContext, 23.0d)) - dip2px(this.mContext, 20.0d)) - dip2px(this.mContext, 20.0d)) - dip2px(this.mContext, 39.0d);
    }

    private Drawable getUserBackgroundDrawable(boolean z) {
        int color = Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor);
        if (z) {
            return Styles.getDrawableWithCorner(color, 0, 15, 15, 15);
        }
        return Styles.getDrawableWithCorner(color, 15, 0, 15, 15);
    }
}
