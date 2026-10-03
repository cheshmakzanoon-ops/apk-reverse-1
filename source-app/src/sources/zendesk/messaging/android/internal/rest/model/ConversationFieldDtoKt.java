package zendesk.messaging.android.internal.rest.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.validation.model.ConversationField;
import zendesk.messaging.android.internal.validation.model.FieldType;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u000e\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"toConversationField", "Lzendesk/messaging/android/internal/validation/model/ConversationField;", "Lzendesk/messaging/android/internal/rest/model/ConversationFieldDto;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationFieldDtoKt {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[FieldType.values().length];
            try {
                iArr[FieldType.TEXT.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[FieldType.CHECKBOX.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[FieldType.MULTI_LINE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[FieldType.DATE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[FieldType.REGEXP.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[FieldType.NUMBER.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[FieldType.DECIMAL.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr[FieldType.DROP_DOWN.ordinal()] = 8;
            } catch (NoSuchFieldError unused8) {
            }
            try {
                iArr[FieldType.MULTI_SELECT.ordinal()] = 9;
            } catch (NoSuchFieldError unused9) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final ConversationField toConversationField(ConversationFieldDto conversationFieldDto) {
        Intrinsics.checkNotNullParameter(conversationFieldDto, "<this>");
        FieldType fieldTypeFindByValue = FieldType.INSTANCE.findByValue(conversationFieldDto.getType());
        switch (fieldTypeFindByValue == null ? -1 : WhenMappings.$EnumSwitchMapping$0[fieldTypeFindByValue.ordinal()]) {
            case 1:
                return new ConversationField.Text(String.valueOf(conversationFieldDto.getId()));
            case 2:
                return new ConversationField.CheckBox(String.valueOf(conversationFieldDto.getId()));
            case 3:
                return new ConversationField.TextArea(String.valueOf(conversationFieldDto.getId()));
            case 4:
                return new ConversationField.Date(String.valueOf(conversationFieldDto.getId()), conversationFieldDto.getRegexp());
            case 5:
                return new ConversationField.Regex(String.valueOf(conversationFieldDto.getId()), conversationFieldDto.getRegexp());
            case 6:
                return new ConversationField.Number(String.valueOf(conversationFieldDto.getId()), conversationFieldDto.getRegexp());
            case 7:
                return new ConversationField.Decimal(String.valueOf(conversationFieldDto.getId()), conversationFieldDto.getRegexp());
            case 8:
                return new ConversationField.Tagger(String.valueOf(conversationFieldDto.getId()), conversationFieldDto.getOptions());
            case 9:
                return new ConversationField.MultiSelect(String.valueOf(conversationFieldDto.getId()), conversationFieldDto.getOptions());
            default:
                Logger.m225w(Reflection.getOrCreateKotlinClass(FieldType.class).getSimpleName(), conversationFieldDto.getType() + " is currently not supported", new Object[0]);
                return null;
        }
    }
}
