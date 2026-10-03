package zendesk.messaging.android.internal.validation;

import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\u001a2\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001*\b\u0012\u0004\u0012\u00020\u00050\u00042\u0012\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001H\u0000¨\u0006\u0007"}, m18d2 = {"getOnlyValidFields", "", "", "", "", "Lzendesk/messaging/android/internal/validation/ValidationError;", "fieldsToValidate", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationFieldValidatorKt {
    public static final Map<String, Object> getOnlyValidFields(List<? extends ValidationError> list, Map<String, ? extends Object> fieldsToValidate) {
        Intrinsics.checkNotNullParameter(list, "<this>");
        Intrinsics.checkNotNullParameter(fieldsToValidate, "fieldsToValidate");
        Map<String, Object> mutableMap = MapsKt.toMutableMap(fieldsToValidate);
        for (ValidationError validationError : list) {
            if (validationError instanceof ValidationError.FieldValidationFailed) {
                mutableMap.remove(((ValidationError.FieldValidationFailed) validationError).getId());
            }
        }
        return mutableMap;
    }
}
