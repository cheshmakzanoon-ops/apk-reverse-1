package zendesk.conversationkit.android.model;

import java.util.Locale;
import java.util.Map;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.rest.model.MessageActionDto;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u000e\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"toAction", "Lzendesk/conversationkit/android/model/MessageAction;", "Lzendesk/conversationkit/android/internal/rest/model/MessageActionDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessageActionKt {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[MessageActionType.values().length];
            try {
                iArr[MessageActionType.BUY.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[MessageActionType.LINK.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[MessageActionType.LOCATION_REQUEST.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[MessageActionType.POSTBACK.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[MessageActionType.REPLY.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[MessageActionType.SHARE.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[MessageActionType.WEBVIEW.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final MessageAction toAction(MessageActionDto messageActionDto) {
        String strValueOf;
        Intrinsics.checkNotNullParameter(messageActionDto, "<this>");
        MessageActionType messageActionTypeFindByValue = MessageActionType.INSTANCE.findByValue(messageActionDto.getType());
        switch (messageActionTypeFindByValue == null ? -1 : WhenMappings.$EnumSwitchMapping$0[messageActionTypeFindByValue.ordinal()]) {
            case -1:
                return null;
            case 0:
            default:
                throw new NoWhenBranchMatchedException();
            case 1:
                String id = messageActionDto.getId();
                Map<String, Object> metadata = messageActionDto.getMetadata();
                if (metadata == null) {
                    metadata = MapsKt.emptyMap();
                }
                Map<String, Object> map = metadata;
                String text = messageActionDto.getText();
                String str = text == null ? "" : text;
                String uri = messageActionDto.getUri();
                String str2 = uri == null ? "" : uri;
                Long amount = messageActionDto.getAmount();
                long jLongValue = amount != null ? amount.longValue() : 0L;
                String currency = messageActionDto.getCurrency();
                return new MessageAction.Buy(id, map, str, str2, jLongValue, currency == null ? "" : currency, Intrinsics.areEqual(messageActionDto.getState(), "paid") ? MessageActionBuyState.PAID : MessageActionBuyState.OFFERED);
            case 2:
                String id2 = messageActionDto.getId();
                Map<String, Object> metadata2 = messageActionDto.getMetadata();
                if (metadata2 == null) {
                    metadata2 = MapsKt.emptyMap();
                }
                String text2 = messageActionDto.getText();
                if (text2 == null) {
                    text2 = "";
                }
                String uri2 = messageActionDto.getUri();
                if (uri2 == null) {
                    uri2 = "";
                }
                Boolean bool = messageActionDto.getDefault();
                return new MessageAction.Link(id2, metadata2, text2, uri2, bool != null ? bool.booleanValue() : false);
            case 3:
                String id3 = messageActionDto.getId();
                Map<String, Object> metadata3 = messageActionDto.getMetadata();
                if (metadata3 == null) {
                    metadata3 = MapsKt.emptyMap();
                }
                String text3 = messageActionDto.getText();
                return new MessageAction.LocationRequest(id3, metadata3, text3 != null ? text3 : "");
            case 4:
                String id4 = messageActionDto.getId();
                Map<String, Object> metadata4 = messageActionDto.getMetadata();
                if (metadata4 == null) {
                    metadata4 = MapsKt.emptyMap();
                }
                Map<String, Object> map2 = metadata4;
                String text4 = messageActionDto.getText();
                String str3 = text4 == null ? "" : text4;
                String payload = messageActionDto.getPayload();
                if (payload == null) {
                    payload = "";
                }
                return new MessageAction.Postback(id4, map2, str3, payload, false);
            case 5:
                String id5 = messageActionDto.getId();
                Map<String, Object> metadata5 = messageActionDto.getMetadata();
                if (metadata5 == null) {
                    metadata5 = MapsKt.emptyMap();
                }
                Map<String, Object> map3 = metadata5;
                String text5 = messageActionDto.getText();
                String str4 = text5 == null ? "" : text5;
                String iconUrl = messageActionDto.getIconUrl();
                String payload2 = messageActionDto.getPayload();
                if (payload2 == null) {
                    payload2 = "";
                }
                return new MessageAction.Reply(id5, map3, str4, iconUrl, payload2);
            case 6:
                String id6 = messageActionDto.getId();
                Map<String, Object> metadata6 = messageActionDto.getMetadata();
                if (metadata6 == null) {
                    metadata6 = MapsKt.emptyMap();
                }
                return new MessageAction.Share(id6, metadata6);
            case 7:
                String id7 = messageActionDto.getId();
                Map<String, Object> metadata7 = messageActionDto.getMetadata();
                if (metadata7 == null) {
                    metadata7 = MapsKt.emptyMap();
                }
                Map<String, Object> map4 = metadata7;
                String text6 = messageActionDto.getText();
                String str5 = text6 == null ? "" : text6;
                String uri3 = messageActionDto.getUri();
                String str6 = uri3 == null ? "" : uri3;
                String fallback = messageActionDto.getFallback();
                String str7 = fallback == null ? "" : fallback;
                Boolean bool2 = messageActionDto.getDefault();
                boolean zBooleanValue = bool2 != null ? bool2.booleanValue() : false;
                Boolean openOnReceive = messageActionDto.getOpenOnReceive();
                boolean zBooleanValue2 = openOnReceive != null ? openOnReceive.booleanValue() : false;
                String size = messageActionDto.getSize();
                if (size != null) {
                    strValueOf = size.toUpperCase(Locale.ROOT);
                    Intrinsics.checkNotNullExpressionValue(strValueOf, "toUpperCase(...)");
                    if (strValueOf == null) {
                        strValueOf = String.valueOf(MessageActionSize.FULL);
                    }
                } else {
                    strValueOf = String.valueOf(MessageActionSize.FULL);
                }
                return new MessageAction.WebView(id7, map4, str5, str6, str7, zBooleanValue, zBooleanValue2, MessageActionSize.valueOf(strValueOf));
        }
    }
}
