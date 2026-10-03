package zendesk.conversationkit.android.internal;

import java.util.Locale;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\u001a\f\u0010\u0004\u001a\u00020\u0005*\u00020\u0002H\u0000\"\u0016\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0003¨\u0006\u0006"}, m18d2 = {"imageMimeTypes", "", "", "[Ljava/lang/String;", "isImageMimeType", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileExtKt {
    private static final String[] imageMimeTypes = {"image/jpeg", "image/png", "image/gif", "image/jpg", "image/webp", "image/svg+xml"};

    public static final boolean isImageMimeType(String str) {
        Intrinsics.checkNotNullParameter(str, "<this>");
        String[] strArr = imageMimeTypes;
        String lowerCase = str.toLowerCase(Locale.ROOT);
        Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
        return ArraysKt.contains(strArr, lowerCase);
    }
}
