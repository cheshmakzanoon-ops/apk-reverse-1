package net.aihelp.p007ui.adapter.p008cs;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.text.SpannableStringBuilder;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.text.style.UnderlineSpan;
import android.view.View;
import android.widget.TextView;
import androidx.fragment.app.Fragment;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.ItemViewDelegate;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.data.model.rpa.msg.bot.FormUrl;
import net.aihelp.p007ui.adapter.MessageListAdapter;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;
import net.aihelp.utils.URLEncodeUtil;
import net.aihelp.utils.UploadFileHelper;

public abstract class BaseMsgAdapter implements ItemViewDelegate<Message> {
    protected List<Message> dataList;
    protected boolean isCurrentRtl;
    protected final Context mContext;
    protected final Fragment mFragment;
    protected MessageListAdapter.OnClickedListenerWrapper mWrapper;

    @Override
    public void onDataSourceUpdated(List<Message> list) {
    }

    public BaseMsgAdapter(Context context) {
        this(context, null);
    }

    public BaseMsgAdapter(Context context, Fragment fragment) {
        this.dataList = new ArrayList();
        this.mContext = context;
        this.mFragment = fragment;
        this.isCurrentRtl = context.getResources().getConfiguration().getLayoutDirection() == 1;
    }

    protected View.OnClickListener getRetryListener(final int i, final Message message) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (BaseMsgAdapter.this.mWrapper != null) {
                    message.setTimestamp(System.currentTimeMillis());
                    Message message2 = message;
                    message2.setMsgStatus(message2 instanceof FileMessage ? 2 : 1);
                    BaseMsgAdapter.this.mWrapper.onRetrySendingMessage(i, message);
                }
            }
        };
    }

    protected View.OnClickListener getFileRetryListener(final int i, final Message message) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (BaseMsgAdapter.this.mWrapper != null) {
                    message.setTimestamp(System.currentTimeMillis());
                    message.setMsgStatus(2);
                    BaseMsgAdapter.this.mWrapper.onRetrySendingMessage(i, message);
                    UploadFileHelper.INSTANCE.setOnUploadFileListener(new UploadFileHelper.OnUploadFileListener() {
                        @Override
                        public void onFileUploaded(String str) {
                            boolean zIsEmpty = TextUtils.isEmpty(str);
                            Message message2 = message;
                            if (zIsEmpty) {
                                str = message.getContent();
                            }
                            message2.setContent(str);
                            message.setMsgStatus(!zIsEmpty ? 1 : 3);
                            BaseMsgAdapter.this.mWrapper.onRetrySendingMessage(i, message);
                        }
                    }).performUpload(new File(message.getContent()));
                }
            }
        };
    }

    protected Drawable getAdminBackgroundDrawable(boolean z) {
        int colorWithAlpha = Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha);
        if (z) {
            return Styles.getDrawableWithCorner(colorWithAlpha, 15, 0, 15, 15);
        }
        return Styles.getDrawableWithCorner(colorWithAlpha, 0, 15, 15, 15);
    }

    public void setOnClickedListenerWrapper(MessageListAdapter.OnClickedListenerWrapper onClickedListenerWrapper) {
        this.mWrapper = onClickedListenerWrapper;
    }

    protected TextView getMsg(String str, boolean z) {
        if (!TextUtils.isEmpty(str) && str.contains("&formUrlTitle=") && Pattern.compile("(http:|https:)(//)((?!\").)*?(&formUrlTitle=)*?").matcher(str).matches()) {
            String str2 = str + "&fromSdk=1&isCustom=1";
            Matcher matcher = Pattern.compile("(?<=(formUrlTitle=)).*(?=(&fromSdk=1&isCustom=1))").matcher(str2);
            final FormUrl formUrl = new FormUrl(matcher.find() ? URLEncodeUtil.decode(matcher.group()) : str2, str2);
            return getHighlightedClickableTextView(formUrl.getTitle(), new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    String link = formUrl.getLink();
                    if (!AppInfoUtil.isUrlStillNeedResponding(BaseMsgAdapter.this.mContext, link) || BaseMsgAdapter.this.mWrapper == null) {
                        return;
                    }
                    BaseMsgAdapter.this.mWrapper.onUrlClicked(true, link);
                }
            });
        }
        TextView textView = new TextView(this.mContext);
        textView.setTextSize(15.0f);
        textView.setLineSpacing(dip2px(this.mContext, 3.0d), 1.0f);
        textView.setTextColor(Color.parseColor(CustomConfig.CommonSetting.textColor));
        textView.setTextIsSelectable(true);
        boolean z2 = ("XiaoMi".equalsIgnoreCase(Build.MANUFACTURER) || "RedMi".equalsIgnoreCase(Build.MANUFACTURER)) && Build.VERSION.SDK_INT == 30;
        boolean z3 = "samsung".equalsIgnoreCase(Build.MANUFACTURER) && Build.VERSION.SDK_INT <= 26;
        if (z2 || z3) {
            textView.setText(str);
        } else {
            textView.setText(getUrlSupportedText(str));
            textView.setMovementMethod(LinkMovementMethod.getInstance());
        }
        return textView;
    }

    protected TextView getHighlightedClickableTextView(String str, View.OnClickListener onClickListener) {
        TextView textView = new TextView(this.mContext);
        textView.setText(str);
        textView.setTextSize(14.0f);
        textView.setTextColor(Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor));
        textView.setPadding(0, dip2px(this.mContext, 5.0d), 0, dip2px(this.mContext, 5.0d));
        textView.setOnClickListener(onClickListener);
        return textView;
    }

    protected SpannableStringBuilder getUrlSupportedText(String str) {
        return getUrlSupportedText(str, CustomConfig.CommonSetting.interactElementTextColor);
    }

    protected SpannableStringBuilder getUrlSupportedText(String str, final String str2) {
        if (TextUtils.isEmpty(str)) {
            return new SpannableStringBuilder("");
        }
        SpannableStringBuilder spannableStringBuilder = new SpannableStringBuilder(str);
        Matcher matcher = Pattern.compile("\\S+(://)\\S+").matcher(spannableStringBuilder);
        while (matcher.find()) {
            int iStart = matcher.start();
            int iEnd = matcher.end();
            final String strGroup = matcher.group();
            spannableStringBuilder.setSpan(new ClickableSpan() {
                @Override
                public void onClick(View view) {
                    if (!AppInfoUtil.isUrlStillNeedResponding(BaseMsgAdapter.this.mContext, strGroup) || BaseMsgAdapter.this.mWrapper == null) {
                        return;
                    }
                    BaseMsgAdapter.this.mWrapper.onUrlClicked(false, strGroup);
                }

                @Override
                public void updateDrawState(TextPaint textPaint) {
                    textPaint.setColor(Color.parseColor(str2));
                }
            }, iStart, iEnd, 34);
            spannableStringBuilder.setSpan(new UnderlineSpan(), iStart, iEnd, 34);
        }
        return spannableStringBuilder;
    }

    protected int getViewId(String str) {
        return ResResolver.getViewId(str);
    }

    protected int dip2px(Context context, double d) {
        return (int) ((d * ((double) context.getResources().getDisplayMetrics().density)) + 0.5d);
    }
}
