package androidx.compose.material3;

import android.content.res.Configuration;
import android.os.Build;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.core.os.ConfigurationCompat;
import java.util.Locale;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0011\u0010\u0000\u001a\u00060\u0001j\u0002`\u0002H\u0001¢\u0006\u0002\u0010\u0003¨\u0006\u0004"}, d2 = {"defaultLocale", "Ljava/util/Locale;", "Landroidx/compose/material3/CalendarLocale;", "(Landroidx/compose/runtime/Composer;I)Ljava/util/Locale;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CalendarLocale_androidKt {
    public static final Locale defaultLocale(Composer composer, int i) {
        Locale localeDefaultLocale;
        ComposerKt.sourceInformationMarkerStart(composer, -1612326743, "C(defaultLocale):CalendarLocale.android.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1612326743, i, -1, "androidx.compose.material3.defaultLocale (CalendarLocale.android.kt:30)");
        }
        if (Build.VERSION.SDK_INT >= 24) {
            composer.startReplaceGroup(-1190822718);
            ComposerKt.sourceInformation(composer, "32@1187L15");
            localeDefaultLocale = Locale24.INSTANCE.defaultLocale(composer, 6);
            composer.endReplaceGroup();
        } else {
            composer.startReplaceGroup(100135232);
            ComposerKt.sourceInformation(composer, "34@1274L7");
            ProvidableCompositionLocal<Configuration> localConfiguration = AndroidCompositionLocals_androidKt.getLocalConfiguration();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localConfiguration);
            ComposerKt.sourceInformationMarkerEnd(composer);
            localeDefaultLocale = ConfigurationCompat.getLocales((Configuration) objConsume).get(0);
            if (localeDefaultLocale == null) {
                localeDefaultLocale = Locale.getDefault();
            }
            composer.endReplaceGroup();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return localeDefaultLocale;
    }
}
