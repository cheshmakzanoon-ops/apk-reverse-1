package net.aihelp.p007ui.adapter.p008cs.user;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
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

public class UserImageAdapter extends BaseMsgAdapter {
    public UserImageAdapter(Context context, Fragment fragment) {
        super(context, fragment);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_user_image");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 11;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        if (message instanceof FileMessage) {
            final FileMessage fileMessage = (FileMessage) message;
            Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csUserPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_user");
            viewHolder.setVisible(getViewId("aihelp_iv_msg_retry"), false);
            final AIHelpLoadingImageView aIHelpLoadingImageView = (AIHelpLoadingImageView) viewHolder.getView(getViewId("aihelp_iv_holder"));
            aIHelpLoadingImageView.loadIntoImageView(this.mContext, fileMessage);
            if (fileMessage.getMsgStatus() == 3) {
                viewHolder.setVisible(getViewId("aihelp_iv_msg_retry"), true);
                viewHolder.setOnClickListener(getViewId("aihelp_iv_msg_retry"), getFileRetryListener(i, message));
            } else {
                aIHelpLoadingImageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (aIHelpLoadingImageView.isLoading()) {
                            return;
                        }
                        PreviewActivity.startAct(UserImageAdapter.this.mFragment, PreviewInfo.get(fileMessage.getContent()));
                    }
                });
            }
        }
    }
}
