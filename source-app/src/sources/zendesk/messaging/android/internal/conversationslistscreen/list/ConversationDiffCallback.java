package zendesk.messaging.android.internal.conversationslistscreen.list;

import androidx.recyclerview.widget.DiffUtil;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\bÂ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u0002H\u0016J\u0018\u0010\b\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u0002H\u0016¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/list/ConversationDiffCallback;", "Landroidx/recyclerview/widget/DiffUtil$ItemCallback;", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "()V", "areContentsTheSame", "", "oldItem", "newItem", "areItemsTheSame", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
final class ConversationDiffCallback extends DiffUtil.ItemCallback<ConversationEntry> {
    public static final ConversationDiffCallback INSTANCE = new ConversationDiffCallback();

    private ConversationDiffCallback() {
    }

    public boolean areItemsTheSame(ConversationEntry oldItem, ConversationEntry newItem) {
        Intrinsics.checkNotNullParameter(oldItem, "oldItem");
        Intrinsics.checkNotNullParameter(newItem, "newItem");
        return Intrinsics.areEqual(oldItem.getId(), newItem.getId());
    }

    public boolean areContentsTheSame(ConversationEntry oldItem, ConversationEntry newItem) {
        Intrinsics.checkNotNullParameter(oldItem, "oldItem");
        Intrinsics.checkNotNullParameter(newItem, "newItem");
        return Intrinsics.areEqual(oldItem, newItem);
    }
}
