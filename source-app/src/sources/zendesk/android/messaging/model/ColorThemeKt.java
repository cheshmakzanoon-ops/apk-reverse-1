package zendesk.android.messaging.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.settings.internal.model.ColorThemeDto;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"toColorTheme", "Lzendesk/android/messaging/model/ColorTheme;", "Lzendesk/android/settings/internal/model/ColorThemeDto;", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ColorThemeKt {
    public static final ColorTheme toColorTheme(ColorThemeDto colorThemeDto) {
        Intrinsics.checkNotNullParameter(colorThemeDto, "<this>");
        return new ColorTheme(colorThemeDto.getPrimaryColor(), colorThemeDto.getOnPrimaryColor(), colorThemeDto.getMessageColor(), colorThemeDto.getOnMessageColor(), colorThemeDto.getActionColor(), colorThemeDto.getOnActionColor(), colorThemeDto.getInboundMessageColor(), colorThemeDto.getSystemMessageColor(), colorThemeDto.getBackgroundColor(), colorThemeDto.getOnBackgroundColor(), colorThemeDto.getElevatedColor(), colorThemeDto.getNotifyColor(), colorThemeDto.getSuccessColor(), colorThemeDto.getDangerColor(), colorThemeDto.getOnDangerColor(), colorThemeDto.getDisabledColor(), colorThemeDto.getIconColor(), colorThemeDto.getActionBackgroundColor(), colorThemeDto.getOnActionBackgroundColor());
    }
}
