package zendesk.guidekit.android.internal.data.mapper;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.guidekit.android.internal.rest.model.BrandDto;
import zendesk.guidekit.android.model.Brand;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"toBrand", "Lzendesk/guidekit/android/model/Brand;", "Lzendesk/guidekit/android/internal/rest/model/BrandDto;", "zendesk.guidekit_guidekit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class BrandsMapperKt {
    public static final Brand toBrand(BrandDto brandDto) {
        Intrinsics.checkNotNullParameter(brandDto, "<this>");
        return new Brand(brandDto.getChannelId(), brandDto.getSubdomain(), brandDto.getHostMapping());
    }
}
