package zendesk.messaging.android.internal;

import androidx.core.content.FileProvider;
import kotlin.Metadata;
import zendesk.messaging.C1256R;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/ZendeskFileProvider;", "Landroidx/core/content/FileProvider;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskFileProvider extends FileProvider {
    public ZendeskFileProvider() {
        super(C1256R.xml.zendesk_files_path);
    }
}
