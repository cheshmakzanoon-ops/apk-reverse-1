package zendesk.messaging.android.internal.validation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.text.Regex;
import kotlin.text.StringsKt;
import zendesk.faye.internal.Bayeux;
import zendesk.messaging.android.internal.validation.model.FieldData;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0000\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u0007\b\u0001¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0005H\u0002J\u0017\u0010\u0007\u001a\u0004\u0018\u00010\u00052\u0006\u0010\b\u001a\u00020\tH\u0000¢\u0006\u0002\b\nJ\u0017\u0010\u000b\u001a\u0004\u0018\u00010\u00052\u0006\u0010\b\u001a\u00020\tH\u0000¢\u0006\u0002\b\fJ\u0017\u0010\r\u001a\u0004\u0018\u00010\u00052\u0006\u0010\b\u001a\u00020\tH\u0000¢\u0006\u0002\b\u000eJ\u0017\u0010\u000f\u001a\u0004\u0018\u00010\u00052\u0006\u0010\b\u001a\u00020\tH\u0000¢\u0006\u0002\b\u0010J\u0017\u0010\u0011\u001a\u0004\u0018\u00010\u00052\u0006\u0010\b\u001a\u00020\tH\u0000¢\u0006\u0002\b\u0012¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/validation/ValidationRules;", "", "()V", "convertValueToList", "", "", "value", "forCheckBox", Bayeux.KEY_DATA, "Lzendesk/messaging/android/internal/validation/model/FieldData;", "forCheckBox$zendesk_messaging_messaging_android", "forMultiSelect", "forMultiSelect$zendesk_messaging_messaging_android", "forRegex", "forRegex$zendesk_messaging_messaging_android", "forTagger", "forTagger$zendesk_messaging_messaging_android", "forText", "forText$zendesk_messaging_messaging_android", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ValidationRules {
    private static final String COMMON_MESSAGE_ERROR = "The value provided for the Conversation Field: %s is not correct. ";
    public static final String FIELD_ID_NOT_FOUND_ERROR = "Conversation Field: %s can not be validated. Please ensure that the provided ID is correct and the field is customer editable";
    public static final String NOT_EMPTY_VALUE = "Conversation Field: %s value can not be empty";
    public static final String PROVIDED_VALUE_NOT_CORRECT_ERROR = "The value provided for the Conversation Field: %s is not correct. Expected value of type %s for a field of type %s.";
    public static final String REGEX_VALUE_NOT_CORRECT = "The value provided for the Conversation Field: %s is not correct. Expected value did not pass the regular expression validation for a field of type %s";
    public static final String TAGGER_VALUE_NOT_CORRECT = "The value provided for the Conversation Field: %s is not correct. Available options are: %s for a field of type %s";
    public static final String UNABLE_VALIDATE_ERROR = "We were not able to validate your conversation fields at the moment. Ensure you have stable internet connection and try again.";

    @Inject
    public ValidationRules() {
    }

    public final String forText$zendesk_messaging_messaging_android(FieldData data) {
        Intrinsics.checkNotNullParameter(data, "data");
        if (!(data.getValue() instanceof String)) {
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(PROVIDED_VALUE_NOT_CORRECT_ERROR, Arrays.copyOf(new Object[]{data.getId(), Reflection.getOrCreateKotlinClass(String.class).getSimpleName(), data.getType()}, 3));
            Intrinsics.checkNotNullExpressionValue(str, "format(...)");
            return str;
        }
        if (((CharSequence) data.getValue()).length() != 0) {
            return null;
        }
        StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
        String str2 = String.format(NOT_EMPTY_VALUE, Arrays.copyOf(new Object[]{data.getId()}, 1));
        Intrinsics.checkNotNullExpressionValue(str2, "format(...)");
        return str2;
    }

    public final String forRegex$zendesk_messaging_messaging_android(FieldData data) {
        Intrinsics.checkNotNullParameter(data, "data");
        String regex = data.getRegex();
        if (regex == null || new Regex(regex).matches(data.getValue().toString())) {
            return null;
        }
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format(REGEX_VALUE_NOT_CORRECT, Arrays.copyOf(new Object[]{data.getId(), data.getType()}, 2));
        Intrinsics.checkNotNullExpressionValue(str, "format(...)");
        return str;
    }

    public final String forCheckBox$zendesk_messaging_messaging_android(FieldData data) {
        Intrinsics.checkNotNullParameter(data, "data");
        if (data.getValue() instanceof Boolean) {
            return null;
        }
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format(PROVIDED_VALUE_NOT_CORRECT_ERROR, Arrays.copyOf(new Object[]{data.getId(), Reflection.getOrCreateKotlinClass(Boolean.TYPE).getSimpleName(), data.getType()}, 3));
        Intrinsics.checkNotNullExpressionValue(str, "format(...)");
        return str;
    }

    public final String forTagger$zendesk_messaging_messaging_android(FieldData data) {
        Intrinsics.checkNotNullParameter(data, "data");
        if (!(data.getValue() instanceof String)) {
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(PROVIDED_VALUE_NOT_CORRECT_ERROR, Arrays.copyOf(new Object[]{data.getId(), Reflection.getOrCreateKotlinClass(String.class).getSimpleName(), data.getType()}, 3));
            Intrinsics.checkNotNullExpressionValue(str, "format(...)");
            return str;
        }
        List<String> options = data.getOptions();
        if (options != null && options.contains(data.getValue())) {
            return null;
        }
        StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
        String id = data.getId();
        List<String> options2 = data.getOptions();
        String str2 = String.format(TAGGER_VALUE_NOT_CORRECT, Arrays.copyOf(new Object[]{id, options2 != null ? CollectionsKt.joinToString$default(options2, ", ", null, null, 0, null, null, 62, null) : null, data.getType()}, 3));
        Intrinsics.checkNotNullExpressionValue(str2, "format(...)");
        return str2;
    }

    public final String forMultiSelect$zendesk_messaging_messaging_android(FieldData data) {
        Intrinsics.checkNotNullParameter(data, "data");
        if (!(data.getValue() instanceof String)) {
            StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
            String str = String.format(PROVIDED_VALUE_NOT_CORRECT_ERROR, Arrays.copyOf(new Object[]{data.getId(), Reflection.getOrCreateKotlinClass(String.class).getSimpleName(), data.getType()}, 3));
            Intrinsics.checkNotNullExpressionValue(str, "format(...)");
            return str;
        }
        List<String> options = data.getOptions();
        if (options != null && options.containsAll(convertValueToList((String) data.getValue()))) {
            return null;
        }
        StringCompanionObject stringCompanionObject2 = StringCompanionObject.INSTANCE;
        String id = data.getId();
        List<String> options2 = data.getOptions();
        String str2 = String.format(TAGGER_VALUE_NOT_CORRECT, Arrays.copyOf(new Object[]{id, options2 != null ? CollectionsKt.joinToString$default(options2, ", ", null, null, 0, null, null, 62, null) : null, data.getType()}, 3));
        Intrinsics.checkNotNullExpressionValue(str2, "format(...)");
        return str2;
    }

    private final List<String> convertValueToList(String value) {
        List listSplit$default = StringsKt.split$default((CharSequence) value, new String[]{","}, false, 0, 6, (Object) null);
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(listSplit$default, 10));
        Iterator it = listSplit$default.iterator();
        while (it.hasNext()) {
            arrayList.add(StringsKt.trim((CharSequence) it.next()).toString());
        }
        return CollectionsKt.toList(arrayList);
    }
}
