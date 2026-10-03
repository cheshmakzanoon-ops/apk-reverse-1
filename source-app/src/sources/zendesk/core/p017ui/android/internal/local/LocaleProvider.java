package zendesk.core.p017ui.android.internal.local;

import android.content.Context;
import androidx.core.os.ConfigurationCompat;
import java.util.Locale;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.InternalZendeskUIApi;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0005\u001a\u00020\u00068F¢\u0006\u0006\u001a\u0004\b\u0007\u0010\b¨\u0006\t"}, m18d2 = {"Lzendesk/core/ui/android/internal/local/LocaleProvider;", "", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "locale", "Ljava/util/Locale;", "getLocale", "()Ljava/util/Locale;", "zendesk.core.ui_core-ui"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@InternalZendeskUIApi
public final class LocaleProvider {
    public static final int $stable = 8;
    private final Context context;

    @Inject
    public LocaleProvider(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.context = context;
    }

    public final Locale getLocale() {
        try {
            Locale locale = ConfigurationCompat.getLocales(this.context.getResources().getConfiguration()).get(0);
            if (locale == null) {
                locale = Locale.getDefault();
            }
            Intrinsics.checkNotNull(locale);
            return locale;
        } catch (Exception unused) {
            Locale locale2 = Locale.getDefault();
            Intrinsics.checkNotNull(locale2);
            return locale2;
        }
    }
}
