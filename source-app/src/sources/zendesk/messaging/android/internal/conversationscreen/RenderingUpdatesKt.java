package zendesk.messaging.android.internal.conversationscreen;

import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.FieldOption;
import zendesk.p026ui.android.conversation.form.FieldResponse;

@Metadata(m17d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\u001a\u0010\u0010\u0000\u001a\u00060\u0001j\u0002`\u0002*\u00020\u0003H\u0002*\f\b\u0002\u0010\u0004\"\u00020\u00012\u00020\u0001**\b\u0000\u0010\u0005\u001a\u0004\b\u0000\u0010\u0006\"\u000e\u0012\u0004\u0012\u0002H\u0006\u0012\u0004\u0012\u0002H\u00060\u00072\u000e\u0012\u0004\u0012\u0002H\u0006\u0012\u0004\u0012\u0002H\u00060\u0007¨\u0006\b"}, m18d2 = {"toFieldResponseState", "Lzendesk/ui/android/conversation/form/FieldResponse;", "Lzendesk/messaging/android/internal/conversationscreen/FieldResponseState;", "Lzendesk/conversationkit/android/model/Field;", "FieldResponseState", "RenderingUpdate", "T", "Lkotlin/Function1;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class RenderingUpdatesKt {
    public static final FieldResponse toFieldResponseState(Field field) {
        String label;
        String label2 = field.getLabel();
        if (field instanceof Field.Text) {
            label = ((Field.Text) field).getText();
        } else if (field instanceof Field.Email) {
            label = ((Field.Email) field).getEmail();
        } else {
            if (!(field instanceof Field.Select)) {
                throw new NoWhenBranchMatchedException();
            }
            FieldOption fieldOption = (FieldOption) CollectionsKt.firstOrNull((List) ((Field.Select) field).getSelect());
            label = fieldOption != null ? fieldOption.getLabel() : null;
            if (label == null) {
                label = "";
            }
        }
        return new FieldResponse(label2, label);
    }
}
