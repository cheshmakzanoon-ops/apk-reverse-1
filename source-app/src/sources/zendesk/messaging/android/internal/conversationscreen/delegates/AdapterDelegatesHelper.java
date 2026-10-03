package zendesk.messaging.android.internal.conversationscreen.delegates;

import android.content.Context;
import android.net.Uri;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.core.p017ui.android.internal.model.MessagePosition;
import zendesk.core.p017ui.android.internal.model.MessageShape;
import zendesk.messaging.C1256R;
import zendesk.messaging.android.internal.extension.ViewKtxKt;
import zendesk.messaging.android.internal.model.MessageReceipt;
import zendesk.messaging.android.internal.model.MessageSize;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.p026ui.android.conversation.actionbutton.ActionButton;
import zendesk.p026ui.android.conversation.avatar.AvatarImageRendering;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;
import zendesk.p026ui.android.conversation.avatar.AvatarImageView;
import zendesk.p026ui.android.conversation.avatar.AvatarMask;
import zendesk.p026ui.android.conversation.imagecell.ImageCellDirection;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptPosition;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptRendering;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptState;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000ª\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J-\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0000¢\u0006\u0002\b\u0010J\u001d\u0010\u0011\u001a\u00020\u00072\u0006\u0010\u0012\u001a\u00020\t2\u0006\u0010\u0013\u001a\u00020\u0014H\u0000¢\u0006\u0002\b\u0015J\u001d\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\f\u001a\u00020\rH\u0001¢\u0006\u0002\b\u001aJ\u001d\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\f\u001a\u00020\rH\u0000¢\u0006\u0002\b\u001dJ\u0010\u0010\u001e\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0002J\u0010\u0010\u001f\u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u0019H\u0002J\u0010\u0010 \u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0002J\u0010\u0010!\u001a\u00020\u001c2\u0006\u0010\u0018\u001a\u00020\u0019H\u0002J?\u0010\"\u001a\u00020\u00072\u0006\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010&2\u0006\u0010'\u001a\u00020\u000b2\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020\r2\u0006\u0010+\u001a\u00020,H\u0000¢\u0006\u0002\b-J/\u0010.\u001a\u00020\u00072\u0006\u0010/\u001a\u0002002\b\u00101\u001a\u0004\u0018\u00010&2\u0006\u0010'\u001a\u00020\u000b2\u0006\u0010+\u001a\u00020,H\u0000¢\u0006\u0002\b2JO\u00103\u001a\u00020\u00072\u0006\u00104\u001a\u0002052\b\u00106\u001a\u0004\u0018\u0001072\u0006\u0010\f\u001a\u00020\r2\u0006\u00108\u001a\u0002092\u0006\u0010:\u001a\u00020;2\u0006\u0010<\u001a\u00020;2\u0006\u0010'\u001a\u00020\u000b2\u0006\u0010+\u001a\u00020,H\u0000¢\u0006\u0002\b=J\u0010\u0010>\u001a\u00020;2\u0006\u0010'\u001a\u00020\u000bH\u0002J!\u0010?\u001a\n\u0012\u0004\u0012\u00020A\u0018\u00010@*\u00020\u000b2\u0006\u0010B\u001a\u00020CH\u0000¢\u0006\u0002\bDJ$\u0010E\u001a\n\u0012\u0004\u0012\u00020A\u0018\u00010@*\n\u0012\u0004\u0012\u00020F\u0018\u00010@2\u0006\u0010B\u001a\u00020CH\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006G"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/delegates/AdapterDelegatesHelper;", "", "()V", "LABEL_ALPHA", "", "PENDING_ALPHA_FACTOR", "adjustDirectionAndWidth", "", "view", "Landroid/view/View;", "content", "Lzendesk/conversationkit/android/model/MessageContent;", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "contentView", "Landroid/widget/LinearLayout;", "adjustDirectionAndWidth$zendesk_messaging_messaging_android", "adjustSpacing", "itemView", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "adjustSpacing$zendesk_messaging_messaging_android", "getCellDrawable", "", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "getCellDrawable$zendesk_messaging_messaging_android", "getImageCellDirection", "Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "getImageCellDirection$zendesk_messaging_messaging_android", "inboundCellDrawable", "inboundImageCellDirection", "outboundCellDrawable", "outboundImageCellDirection", "renderAvatar", "avatarView", "Lzendesk/ui/android/conversation/avatar/AvatarImageView;", "avatarUrl", "", "messageContent", "messageSize", "Lzendesk/messaging/android/internal/model/MessageSize;", "messageDirection", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "renderAvatar$zendesk_messaging_messaging_android", "renderLabel", "labelView", "Landroid/widget/TextView;", "labelText", "renderLabel$zendesk_messaging_messaging_android", "renderReceipt", "receiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "showIcon", "", "isUnsupported", "renderReceipt$zendesk_messaging_messaging_android", "shouldShowNonContentViewComponents", "getCellActions", "", "Lzendesk/ui/android/conversation/actionbutton/ActionButton;", "context", "Landroid/content/Context;", "getCellActions$zendesk_messaging_messaging_android", "toListOfActionButton", "Lzendesk/conversationkit/android/model/MessageAction;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AdapterDelegatesHelper {
    public static final AdapterDelegatesHelper INSTANCE = new AdapterDelegatesHelper();
    private static final float LABEL_ALPHA = 0.65f;
    private static final float PENDING_ALPHA_FACTOR = 0.66f;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;
        public static final int[] $EnumSwitchMapping$1;
        public static final int[] $EnumSwitchMapping$2;

        static {
            int[] iArr = new int[MessagePosition.values().length];
            try {
                iArr[MessagePosition.STANDALONE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[MessagePosition.GROUP_TOP.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[MessagePosition.GROUP_MIDDLE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[MessagePosition.GROUP_BOTTOM.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
            int[] iArr2 = new int[MessageShape.values().length];
            try {
                iArr2[MessageShape.STANDALONE.ordinal()] = 1;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr2[MessageShape.GROUP_TOP.ordinal()] = 2;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr2[MessageShape.GROUP_MIDDLE.ordinal()] = 3;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr2[MessageShape.GROUP_BOTTOM.ordinal()] = 4;
            } catch (NoSuchFieldError unused8) {
            }
            $EnumSwitchMapping$1 = iArr2;
            int[] iArr3 = new int[MessageDirection.values().length];
            try {
                iArr3[MessageDirection.INBOUND.ordinal()] = 1;
            } catch (NoSuchFieldError unused9) {
            }
            try {
                iArr3[MessageDirection.OUTBOUND.ordinal()] = 2;
            } catch (NoSuchFieldError unused10) {
            }
            $EnumSwitchMapping$2 = iArr3;
        }
    }

    private AdapterDelegatesHelper() {
    }

    public final void adjustSpacing$zendesk_messaging_messaging_android(View itemView, MessagePosition position) {
        Intrinsics.checkNotNullParameter(itemView, "itemView");
        Intrinsics.checkNotNullParameter(position, "position");
        int dimensionPixelSize = itemView.getResources().getDimensionPixelSize(R.dimen.zuia_vertical_spacing_small);
        int dimensionPixelSize2 = itemView.getResources().getDimensionPixelSize(R.dimen.zuia_vertical_spacing_large);
        int i = WhenMappings.$EnumSwitchMapping$0[position.ordinal()];
        if (i == 1) {
            dimensionPixelSize = dimensionPixelSize2;
        } else if (i != 2 && i != 3) {
            if (i != 4) {
                throw new NoWhenBranchMatchedException();
            }
            dimensionPixelSize = dimensionPixelSize2;
        }
        itemView.setPaddingRelative(0, 0, 0, dimensionPixelSize);
    }

    public final int getCellDrawable$zendesk_messaging_messaging_android(MessageShape shape, MessageDirection direction) {
        Intrinsics.checkNotNullParameter(shape, "shape");
        Intrinsics.checkNotNullParameter(direction, "direction");
        if (direction == MessageDirection.INBOUND) {
            return inboundCellDrawable(shape);
        }
        return outboundCellDrawable(shape);
    }

    private final int inboundCellDrawable(MessageShape shape) {
        int i = WhenMappings.$EnumSwitchMapping$1[shape.ordinal()];
        if (i == 1) {
            return R.drawable.zuia_message_cell_inbound_shape_single;
        }
        if (i == 2) {
            return R.drawable.zuia_message_cell_inbound_shape_top;
        }
        if (i == 3) {
            return R.drawable.zuia_message_cell_inbound_shape_middle;
        }
        if (i == 4) {
            return R.drawable.zuia_message_cell_inbound_shape_bottom;
        }
        throw new NoWhenBranchMatchedException();
    }

    private final int outboundCellDrawable(MessageShape shape) {
        int i = WhenMappings.$EnumSwitchMapping$1[shape.ordinal()];
        if (i == 1) {
            return R.drawable.zuia_message_cell_outbound_shape_single;
        }
        if (i == 2) {
            return R.drawable.zuia_message_cell_outbound_shape_top;
        }
        if (i == 3) {
            return R.drawable.zuia_message_cell_outbound_shape_middle;
        }
        if (i == 4) {
            return R.drawable.zuia_message_cell_outbound_shape_bottom;
        }
        throw new NoWhenBranchMatchedException();
    }

    public final void renderLabel$zendesk_messaging_messaging_android(TextView labelView, String labelText, MessageContent messageContent, MessagingTheme messagingTheme) {
        Intrinsics.checkNotNullParameter(labelView, "labelView");
        Intrinsics.checkNotNullParameter(messageContent, "messageContent");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        TextView textView = labelView;
        textView.setVisibility(shouldShowNonContentViewComponents(messageContent) ? 0 : 8);
        if (shouldShowNonContentViewComponents(messageContent)) {
            String str = labelText;
            labelView.setText(str);
            textView.setVisibility(str == null || str.length() == 0 ? 8 : 0);
            labelView.setTextColor(ViewKtxKt.adjustAlpha(messagingTheme.getOnBackgroundColor(), 0.65f));
        }
    }

    public final void renderAvatar$zendesk_messaging_messaging_android(AvatarImageView avatarView, final String avatarUrl, MessageContent messageContent, MessageSize messageSize, MessageDirection messageDirection, final MessagingTheme messagingTheme) {
        Unit unit;
        Intrinsics.checkNotNullParameter(avatarView, "avatarView");
        Intrinsics.checkNotNullParameter(messageContent, "messageContent");
        Intrinsics.checkNotNullParameter(messageSize, "messageSize");
        Intrinsics.checkNotNullParameter(messageDirection, "messageDirection");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        AvatarImageView avatarImageView = avatarView;
        avatarImageView.setVisibility(shouldShowNonContentViewComponents(messageContent) ? 0 : 8);
        if (shouldShowNonContentViewComponents(messageContent)) {
            if (MessageSize.FULL_WIDTH == messageSize) {
                avatarView.setVisibility(8);
                return;
            }
            if (avatarUrl != null) {
                avatarView.render(new Function1<AvatarImageRendering, AvatarImageRendering>() {
                    {
                        super(1);
                    }

                    @Override
                    public final AvatarImageRendering invoke(AvatarImageRendering rendering) {
                        Intrinsics.checkNotNullParameter(rendering, "rendering");
                        AvatarImageRendering.Builder builder = rendering.toBuilder();
                        final String str = avatarUrl;
                        final MessagingTheme messagingTheme2 = messagingTheme;
                        return builder.state(new Function1<AvatarImageState, AvatarImageState>() {
                            {
                                super(1);
                            }

                            @Override
                            public final AvatarImageState invoke(AvatarImageState state) {
                                Intrinsics.checkNotNullParameter(state, "state");
                                return AvatarImageState.copy$default(state, Uri.parse(str), false, 0, Integer.valueOf(messagingTheme2.getInboundMessageColor()), AvatarMask.CIRCLE, 6, null);
                            }
                        }).build();
                    }
                });
                avatarImageView.setVisibility(0);
                unit = Unit.INSTANCE;
            } else {
                unit = null;
            }
            if (unit == null) {
                avatarView.setVisibility(messageDirection == MessageDirection.INBOUND ? 4 : 8);
            }
        }
    }

    public final void renderReceipt$zendesk_messaging_messaging_android(MessageReceiptView receiptView, final MessageReceipt receipt, final MessageDirection direction, final MessageStatus status, final boolean showIcon, final boolean isUnsupported, MessageContent messageContent, final MessagingTheme messagingTheme) {
        int i;
        Intrinsics.checkNotNullParameter(receiptView, "receiptView");
        Intrinsics.checkNotNullParameter(direction, "direction");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(messageContent, "messageContent");
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        MessageReceiptView messageReceiptView = receiptView;
        messageReceiptView.setVisibility(shouldShowNonContentViewComponents(messageContent) ? 0 : 8);
        if (shouldShowNonContentViewComponents(messageContent)) {
            if (receipt != null) {
                receiptView.render(new Function1<MessageReceiptRendering, MessageReceiptRendering>() {
                    {
                        super(1);
                    }

                    @Override
                    public final MessageReceiptRendering invoke(MessageReceiptRendering receiptViewRendering) {
                        Intrinsics.checkNotNullParameter(receiptViewRendering, "receiptViewRendering");
                        MessageReceiptRendering.Builder builder = receiptViewRendering.toBuilder();
                        final MessagingTheme messagingTheme2 = messagingTheme;
                        final MessageReceipt messageReceipt = receipt;
                        final boolean z = showIcon;
                        final MessageDirection messageDirection = direction;
                        final MessageStatus messageStatus = status;
                        final boolean z2 = isUnsupported;
                        return builder.state(new Function1<MessageReceiptState, MessageReceiptState>() {
                            {
                                super(1);
                            }

                            @Override
                            public final MessageReceiptState invoke(MessageReceiptState state) {
                                Intrinsics.checkNotNullParameter(state, "state");
                                int iAdjustAlpha = ViewKtxKt.adjustAlpha(messagingTheme2.getOnBackgroundColor(), 0.65f);
                                int onDangerColor = messagingTheme2.getOnDangerColor();
                                MessageReceiptState.Builder builderShowIcon = state.toBuilder().label(messageReceipt.getLabel()).showIcon(z);
                                MessageDirection messageDirection2 = messageDirection;
                                MessageStatus messageStatus2 = messageStatus;
                                boolean z3 = z2;
                                MessagingTheme messagingTheme3 = messagingTheme2;
                                if ((messageDirection2 == MessageDirection.INBOUND && (messageStatus2 instanceof MessageStatus.Failed)) || ((messageDirection2 == MessageDirection.INBOUND && z3) || (messageDirection2 == MessageDirection.INBOUND && (messageStatus2 instanceof MessageStatus.DownloadFailed)))) {
                                    builderShowIcon.messageReceiptPosition(MessageReceiptPosition.INBOUND_FAILED);
                                    builderShowIcon.shouldAnimateReceipt(false);
                                    builderShowIcon.labelColor(onDangerColor);
                                    builderShowIcon.iconColor(onDangerColor);
                                } else if (messageDirection2 == MessageDirection.INBOUND) {
                                    builderShowIcon.shouldAnimateReceipt(false);
                                    int inboundMessageColor = messagingTheme3.getInboundMessageColor();
                                    builderShowIcon.messageReceiptPosition(MessageReceiptPosition.INBOUND);
                                    builderShowIcon.labelColor(iAdjustAlpha);
                                    builderShowIcon.iconColor(inboundMessageColor);
                                } else {
                                    int messageColor = messagingTheme3.getMessageColor();
                                    if (messageStatus2 instanceof MessageStatus.Pending) {
                                        builderShowIcon.messageReceiptPosition(MessageReceiptPosition.OUTBOUND_SENDING);
                                        builderShowIcon.shouldAnimateReceipt(true);
                                        builderShowIcon.labelColor(iAdjustAlpha);
                                        builderShowIcon.iconColor(ViewKtxKt.adjustAlpha(messageColor, 0.66f));
                                    } else if (messageStatus2 instanceof MessageStatus.Sent) {
                                        builderShowIcon.messageReceiptPosition(MessageReceiptPosition.OUTBOUND_SENT);
                                        builderShowIcon.shouldAnimateReceipt(false);
                                        builderShowIcon.labelColor(iAdjustAlpha);
                                        builderShowIcon.iconColor(messageColor);
                                    } else {
                                        if (messageStatus2 instanceof MessageStatus.Failed ? true : messageStatus2 instanceof MessageStatus.DownloadFailed) {
                                            builderShowIcon.messageReceiptPosition(MessageReceiptPosition.OUTBOUND_FAILED);
                                            builderShowIcon.shouldAnimateReceipt(false);
                                            builderShowIcon.labelColor(onDangerColor);
                                            builderShowIcon.iconColor(onDangerColor);
                                        } else if (messageStatus2 instanceof MessageStatus.Downloading) {
                                            builderShowIcon.showIcon(true);
                                            builderShowIcon.messageReceiptPosition(MessageReceiptPosition.OUTBOUND_SENT);
                                            builderShowIcon.shouldAnimateReceipt(false);
                                            builderShowIcon.labelColor(iAdjustAlpha);
                                            builderShowIcon.iconColor(messageColor);
                                        }
                                    }
                                }
                                return builderShowIcon.getState();
                            }
                        }).build();
                    }
                });
                messageReceiptView.setVisibility(0);
                ViewGroup.LayoutParams layoutParams = receiptView.getLayoutParams();
                Intrinsics.checkNotNull(layoutParams, "null cannot be cast to non-null type android.widget.FrameLayout.LayoutParams");
                FrameLayout.LayoutParams layoutParams2 = (FrameLayout.LayoutParams) layoutParams;
                int i2 = WhenMappings.$EnumSwitchMapping$2[direction.ordinal()];
                if (i2 == 1) {
                    i = 8388611;
                } else {
                    if (i2 != 2) {
                        throw new NoWhenBranchMatchedException();
                    }
                    i = 8388613;
                }
                layoutParams2.gravity = i;
                receiptView.setLayoutParams(layoutParams2);
                return;
            }
            messageReceiptView.setVisibility(8);
        }
    }

    private final boolean shouldShowNonContentViewComponents(MessageContent messageContent) {
        boolean z;
        List<MessageAction> actions;
        MessageContent.Text text = messageContent instanceof MessageContent.Text ? (MessageContent.Text) messageContent : null;
        String text2 = text != null ? text.getText() : null;
        if (text2 == null) {
            text2 = "";
        }
        boolean z2 = text2.length() == 0;
        if (text == null || (actions = text.getActions()) == null) {
            z = false;
        } else {
            ArrayList arrayList = new ArrayList();
            for (Object obj : actions) {
                if (obj instanceof MessageAction.Reply) {
                    arrayList.add(obj);
                }
            }
            z = !arrayList.isEmpty();
        }
        return (z2 && z) ? false : true;
    }

    public final List<ActionButton> getCellActions$zendesk_messaging_messaging_android(MessageContent messageContent, Context context) {
        Intrinsics.checkNotNullParameter(messageContent, "<this>");
        Intrinsics.checkNotNullParameter(context, "context");
        if (messageContent instanceof MessageContent.Text) {
            return toListOfActionButton(((MessageContent.Text) messageContent).getActions(), context);
        }
        if (messageContent instanceof MessageContent.Image) {
            return toListOfActionButton(((MessageContent.Image) messageContent).getActions(), context);
        }
        return null;
    }

    public final void adjustDirectionAndWidth$zendesk_messaging_messaging_android(View view, MessageContent content, final MessageDirection direction, LinearLayout contentView) {
        Intrinsics.checkNotNullParameter(view, "view");
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(direction, "direction");
        Intrinsics.checkNotNullParameter(contentView, "contentView");
        final int dimensionPixelSize = view.getResources().getDimensionPixelSize(R.dimen.zuia_horizontal_spacing_small);
        final int dimensionPixelSize2 = view.getResources().getDimensionPixelSize(C1256R.dimen.zma_cell_inbound_margin_end);
        final int dimensionPixelSize3 = view.getResources().getDimensionPixelSize(C1256R.dimen.zma_cell_outbound_margin_end);
        view.setMinimumWidth(view.getResources().getDimensionPixelSize(C1256R.dimen.zma_message_cell_min_width));
        boolean z = content instanceof MessageContent.FileUpload;
        boolean z2 = z && ((MessageContent.FileUpload) content).isImageMimeType();
        if ((content instanceof MessageContent.Form) || (content instanceof MessageContent.FormResponse)) {
            ViewKtxKt.edgeToEdge(view, new Function1<LinearLayout.LayoutParams, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(LinearLayout.LayoutParams layoutParams) {
                    invoke2(layoutParams);
                    return Unit.INSTANCE;
                }

                public final void invoke2(LinearLayout.LayoutParams edgeToEdge) {
                    Intrinsics.checkNotNullParameter(edgeToEdge, "$this$edgeToEdge");
                    edgeToEdge.setMarginEnd(dimensionPixelSize);
                }
            });
            return;
        }
        if (content instanceof MessageContent.Carousel) {
            ViewKtxKt.edgeToEdge(view);
            return;
        }
        if ((content instanceof MessageContent.Image) || z2) {
            ViewKtxKt.edgeToEdge(view, new Function1<LinearLayout.LayoutParams, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(LinearLayout.LayoutParams layoutParams) {
                    invoke2(layoutParams);
                    return Unit.INSTANCE;
                }

                public final void invoke2(LinearLayout.LayoutParams edgeToEdge) {
                    Intrinsics.checkNotNullParameter(edgeToEdge, "$this$edgeToEdge");
                    if (direction == MessageDirection.INBOUND) {
                        edgeToEdge.setMarginEnd(dimensionPixelSize2);
                    } else {
                        edgeToEdge.setMarginStart(dimensionPixelSize3);
                        edgeToEdge.setMarginEnd(dimensionPixelSize);
                    }
                }
            });
            return;
        }
        if ((content instanceof MessageContent.File) || z || (content instanceof MessageContent.Text) || (content instanceof MessageContent.Unsupported)) {
            ViewKtxKt.wrap(view, new Function1<LinearLayout.LayoutParams, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(LinearLayout.LayoutParams layoutParams) {
                    invoke2(layoutParams);
                    return Unit.INSTANCE;
                }

                public final void invoke2(LinearLayout.LayoutParams wrap) {
                    Intrinsics.checkNotNullParameter(wrap, "$this$wrap");
                    if (direction == MessageDirection.INBOUND) {
                        wrap.setMarginEnd(dimensionPixelSize2);
                    } else {
                        wrap.setMarginStart(dimensionPixelSize3);
                        wrap.setMarginEnd(dimensionPixelSize);
                    }
                }
            });
            contentView.setGravity(direction == MessageDirection.OUTBOUND ? 8388613 : 8388611);
        }
    }

    public final ImageCellDirection getImageCellDirection$zendesk_messaging_messaging_android(MessageShape shape, MessageDirection direction) {
        Intrinsics.checkNotNullParameter(shape, "shape");
        Intrinsics.checkNotNullParameter(direction, "direction");
        if (direction == MessageDirection.INBOUND) {
            return inboundImageCellDirection(shape);
        }
        return outboundImageCellDirection(shape);
    }

    private final ImageCellDirection inboundImageCellDirection(MessageShape shape) {
        int i = WhenMappings.$EnumSwitchMapping$1[shape.ordinal()];
        if (i == 1) {
            return ImageCellDirection.INBOUND_SINGLE;
        }
        if (i == 2) {
            return ImageCellDirection.INBOUND_TOP;
        }
        if (i == 3) {
            return ImageCellDirection.INBOUND_MIDDLE;
        }
        if (i == 4) {
            return ImageCellDirection.INBOUND_BOTTOM;
        }
        throw new NoWhenBranchMatchedException();
    }

    private final ImageCellDirection outboundImageCellDirection(MessageShape shape) {
        int i = WhenMappings.$EnumSwitchMapping$1[shape.ordinal()];
        if (i == 1) {
            return ImageCellDirection.OUTBOUND_SINGLE;
        }
        if (i == 2) {
            return ImageCellDirection.OUTBOUND_TOP;
        }
        if (i == 3) {
            return ImageCellDirection.OUTBOUND_MIDDLE;
        }
        if (i == 4) {
            return ImageCellDirection.OUTBOUND_BOTTOM;
        }
        throw new NoWhenBranchMatchedException();
    }

    private final List<ActionButton> toListOfActionButton(List<? extends MessageAction> list, Context context) {
        ActionButton actionButton;
        if (list == null) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        for (MessageAction messageAction : list) {
            if (messageAction instanceof MessageAction.Reply) {
                actionButton = null;
            } else if (messageAction instanceof MessageAction.Link) {
                MessageAction.Link link = (MessageAction.Link) messageAction;
                actionButton = new ActionButton(link.getText(), link.getUri(), null, false, "LINK_MESSAGE_ACTION", null, false, null, 236, null);
            } else if (messageAction instanceof MessageAction.WebView) {
                MessageAction.WebView webView = (MessageAction.WebView) messageAction;
                actionButton = new ActionButton(webView.getText(), webView.getUri(), webView.getFallback(), false, "WEBVIEW_MESSAGE_ACTION", null, false, MessageActionSize.valueOf(webView.getSize().name()), 104, null);
            } else if (messageAction instanceof MessageAction.Postback) {
                actionButton = new ActionButton(((MessageAction.Postback) messageAction).getText(), null, null, false, null, messageAction.getId(), false, null, 222, null);
            } else {
                String string = context.getString(R.string.zuia_option_not_supported);
                Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
                actionButton = new ActionButton(string, null, null, false, null, null, false, null, 246, null);
            }
            if (actionButton != null) {
                arrayList.add(actionButton);
            }
        }
        return arrayList;
    }
}
