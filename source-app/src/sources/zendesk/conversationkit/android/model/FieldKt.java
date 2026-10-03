package zendesk.conversationkit.android.model;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.rest.model.MessageFieldDto;
import zendesk.conversationkit.android.internal.rest.model.MessageFieldOptionDto;
import zendesk.conversationkit.android.internal.rest.model.SendFieldResponseDto;
import zendesk.conversationkit.android.internal.rest.model.SendFieldSelectDto;

@Metadata(m17d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u000e\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u0000\u001a\f\u0010\u0003\u001a\u00020\u0004*\u00020\u0001H\u0000¨\u0006\u0005"}, m18d2 = {"toField", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/conversationkit/android/internal/rest/model/MessageFieldDto;", "toSendFieldResponseDto", "Lzendesk/conversationkit/android/internal/rest/model/SendFieldResponseDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class FieldKt {

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
                iArr[FieldType.EMAIL.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[FieldType.SELECT.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final Field toField(MessageFieldDto messageFieldDto) {
        Intrinsics.checkNotNullParameter(messageFieldDto, "<this>");
        FieldType fieldTypeFindByValue = FieldType.INSTANCE.findByValue(messageFieldDto.getType());
        int i = fieldTypeFindByValue == null ? -1 : WhenMappings.$EnumSwitchMapping$0[fieldTypeFindByValue.ordinal()];
        if (i == 1) {
            String id = messageFieldDto.getId();
            String name = messageFieldDto.getName();
            String label = messageFieldDto.getLabel();
            String placeholder = messageFieldDto.getPlaceholder();
            String str = placeholder == null ? "" : placeholder;
            Integer minSize = messageFieldDto.getMinSize();
            int iIntValue = minSize != null ? minSize.intValue() : 1;
            Integer maxSize = messageFieldDto.getMaxSize();
            int iIntValue2 = maxSize != null ? maxSize.intValue() : 128;
            String text = messageFieldDto.getText();
            if (text == null) {
                text = "";
            }
            return new Field.Text(id, name, label, str, iIntValue, iIntValue2, text);
        }
        if (i == 2) {
            String id2 = messageFieldDto.getId();
            String name2 = messageFieldDto.getName();
            String label2 = messageFieldDto.getLabel();
            String placeholder2 = messageFieldDto.getPlaceholder();
            String str2 = placeholder2 == null ? "" : placeholder2;
            String email = messageFieldDto.getEmail();
            if (email == null) {
                email = "";
            }
            return new Field.Email(id2, name2, label2, str2, email);
        }
        if (i != 3) {
            return null;
        }
        String id3 = messageFieldDto.getId();
        String name3 = messageFieldDto.getName();
        String label3 = messageFieldDto.getLabel();
        String placeholder3 = messageFieldDto.getPlaceholder();
        String str3 = placeholder3 == null ? "" : placeholder3;
        List<MessageFieldOptionDto> options = messageFieldDto.getOptions();
        if (options == null) {
            options = CollectionsKt.emptyList();
        }
        List<MessageFieldOptionDto> list = options;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
        for (MessageFieldOptionDto messageFieldOptionDto : list) {
            arrayList.add(new FieldOption(messageFieldOptionDto.getName(), messageFieldOptionDto.getLabel()));
        }
        ArrayList arrayList2 = arrayList;
        Integer selectSize = messageFieldDto.getSelectSize();
        int iIntValue3 = selectSize != null ? selectSize.intValue() : 1;
        List<MessageFieldOptionDto> select = messageFieldDto.getSelect();
        if (select == null) {
            select = CollectionsKt.emptyList();
        }
        List<MessageFieldOptionDto> list2 = select;
        ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(list2, 10));
        for (MessageFieldOptionDto messageFieldOptionDto2 : list2) {
            arrayList3.add(new FieldOption(messageFieldOptionDto2.getName(), messageFieldOptionDto2.getLabel()));
        }
        return new Field.Select(id3, name3, label3, str3, arrayList2, iIntValue3, arrayList3);
    }

    public static final SendFieldResponseDto toSendFieldResponseDto(Field field) {
        Intrinsics.checkNotNullParameter(field, "<this>");
        if (field instanceof Field.Text) {
            return new SendFieldResponseDto.Text(field.getId(), field.getName(), field.getLabel(), ((Field.Text) field).getText());
        }
        if (field instanceof Field.Email) {
            return new SendFieldResponseDto.Email(field.getId(), field.getName(), field.getLabel(), ((Field.Email) field).getEmail());
        }
        if (!(field instanceof Field.Select)) {
            throw new NoWhenBranchMatchedException();
        }
        String id = field.getId();
        String name = field.getName();
        String label = field.getLabel();
        List<FieldOption> select = ((Field.Select) field).getSelect();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(select, 10));
        for (FieldOption fieldOption : select) {
            arrayList.add(new SendFieldSelectDto(fieldOption.getName(), fieldOption.getLabel()));
        }
        return new SendFieldResponseDto.Select(id, name, label, arrayList);
    }
}
