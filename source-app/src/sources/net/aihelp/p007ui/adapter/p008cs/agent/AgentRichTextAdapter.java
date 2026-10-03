package net.aihelp.p007ui.adapter.p008cs.agent;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import java.io.File;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.adapter.p008cs.BaseMsgAdapter;
import net.aihelp.p007ui.preview.PreviewActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.MediaUtils;
import net.aihelp.utils.RegexDefinition;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AgentRichTextAdapter extends BaseMsgAdapter {
    public AgentRichTextAdapter(Context context, Fragment fragment) {
        super(context, fragment);
    }

    @Override
    public int getItemViewLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_msg_agent");
    }

    @Override
    public boolean isForViewType(Message message, int i) {
        return message.getMsgType() == 8;
    }

    @Override
    public void convert(ViewHolder viewHolder, Message message, int i) {
        LinearLayout linearLayout = (LinearLayout) viewHolder.getView(getViewId("aihelp_agent_message_container"));
        linearLayout.setBackground(getAdminBackgroundDrawable(this.isCurrentRtl));
        linearLayout.removeAllViews();
        Styles.loadIcon((ImageView) viewHolder.getView(getViewId("aihelp_iv_portrait")), CustomConfig.CustomerService.csManualSupportPortrait, CustomConfig.CustomerService.isPortraitVisible, "aihelp_svg_portrait_agent");
        Styles.reRenderTextView((TextView) viewHolder.getView(getViewId("aihelp_tv_nickname")), message.getNickname(), Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.8d), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(message.getNickname()), 13);
        convertSupportTextMsg(viewHolder, linearLayout, message);
    }

    private void convertSupportTextMsg(ViewHolder viewHolder, ViewGroup viewGroup, Message message) {
        viewHolder.setVisible(getViewId("aihelp_tv_nickname"), CustomConfig.CustomerService.isNicknameVisible && !TextUtils.isEmpty(message.getNickname()));
        viewHolder.setText(getViewId("aihelp_tv_nickname"), message.getNickname());
        viewHolder.setTextColor(getViewId("aihelp_tv_nickname"), Color.parseColor(CustomConfig.CommonSetting.textColor));
        viewGroup.addView(getRichTextMsg(message.getContent(), message.isEnableInteraction()));
    }

    protected View getRichTextMsg(String str, boolean z) {
        LinearLayout linearLayout = new LinearLayout(this.mContext);
        linearLayout.setOrientation(1);
        linearLayout.setGravity(8388611);
        try {
            LinkedList linkedList = new LinkedList();
            int i = 0;
            linkedList.add(0);
            Matcher matcher = Pattern.compile(RegexDefinition.REGEX_RICH_TEXT).matcher(str);
            while (matcher.find()) {
                linkedList.add(Integer.valueOf(matcher.start()));
                linkedList.add(Integer.valueOf(matcher.end()));
            }
            if (((Integer) linkedList.getLast()).intValue() != str.length()) {
                linkedList.add(Integer.valueOf(str.length()));
            }
            while (i < linkedList.size() - 1) {
                int iIntValue = ((Integer) linkedList.get(i)).intValue();
                i++;
                String strTrim = str.substring(iIntValue, ((Integer) linkedList.get(i)).intValue()).trim();
                if (!Pattern.compile("\\s*?").matcher(strTrim).matches()) {
                    if (Pattern.compile(RegexDefinition.REGEX_IMAGE).matcher(strTrim).matches()) {
                        linearLayout.addView(getImageViewFromRichText(strTrim));
                    } else if (Pattern.compile(RegexDefinition.REGEX_VIDEO).matcher(strTrim).matches()) {
                        linearLayout.addView(getVideoViewFromRichText(strTrim));
                    } else {
                        linearLayout.addView(getTextViewFromRichText(strTrim, z));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return linearLayout;
    }

    private View getImageViewFromRichText(final String str) {
        ImageView imageView = new ImageView(this.mContext);
        ViewGroup.MarginLayoutParams marginLayoutParams = new ViewGroup.MarginLayoutParams(-2, -2);
        marginLayoutParams.topMargin = Styles.dpToPx(this.mContext, 3.0f);
        imageView.setLayoutParams(marginLayoutParams);
        imageView.setAdjustViewBounds(true);
        MediaUtils.scaleImageView(str, imageView, imageView, null);
        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                PreviewActivity.startAct(AgentRichTextAdapter.this.mFragment, PreviewInfo.get(str));
            }
        });
        return imageView;
    }

    private View getVideoViewFromRichText(final String str) {
        final View viewInflate = View.inflate(this.mContext, ResResolver.getLayoutId("aihelp_loading_image_view"), null);
        final ImageView imageView = (ImageView) viewInflate.findViewById(ResResolver.getViewId("aihelp_image_view"));
        final ImageView imageView2 = (ImageView) viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_play"));
        final View viewFindViewById = viewInflate.findViewById(ResResolver.getViewId("aihelp_v_mask"));
        final View viewFindViewById2 = viewInflate.findViewById(ResResolver.getViewId("aihelp_loading_view"));
        viewInflate.setLayoutParams(new LinearLayout.LayoutParams(dip2px(this.mContext, 120.0d), dip2px(this.mContext, 150.0d)));
        MediaUtils.getImageForVideo(str, new MediaUtils.OnLoadVideoImageListener() {
            @Override
            public void onLoadImage(File file) {
                MediaUtils.scaleImageView(file.getAbsolutePath(), imageView, viewInflate, new MediaUtils.OnImageScaledListener() {
                    @Override
                    public void onImageScaled() {
                        viewFindViewById.setVisibility(8);
                        viewFindViewById2.setVisibility(8);
                        imageView2.setVisibility(0);
                    }
                });
                viewInflate.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        PreviewActivity.startAct(AgentRichTextAdapter.this.mFragment, PreviewInfo.get(str));
                    }
                });
            }
        });
        return viewInflate;
    }

    private View getTextViewFromRichText(String str, boolean z) {
        TextView msg = getMsg(str, z);
        msg.setLayoutParams(new LinearLayout.LayoutParams(-2, -2));
        return msg;
    }
}
