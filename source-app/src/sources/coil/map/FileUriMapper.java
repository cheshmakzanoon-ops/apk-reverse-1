package coil.map;

import android.net.Uri;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.request.Options;
import coil.util.Utils;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.share.internal.ShareInternalUtility;
import java.io.File;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001B\u0005¢\u0006\u0002\u0010\u0004J\u0010\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0002H\u0002J\u001a\u0010\b\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0007\u001a\u00020\u00022\u0006\u0010\t\u001a\u00020\nH\u0016¨\u0006\u000b"}, d2 = {"Lcoil/map/FileUriMapper;", "Lcoil/map/Mapper;", "Landroid/net/Uri;", "Ljava/io/File;", "()V", "isApplicable", "", "data", "map", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class FileUriMapper implements Mapper<Uri, File> {
    @Override
    public File map(Uri data, Options options) {
        if (!isApplicable(data)) {
            return null;
        }
        if (Intrinsics.areEqual(data.getScheme(), ShareInternalUtility.STAGING_PARAM)) {
            String path = data.getPath();
            if (path != null) {
                return new File(path);
            }
            return null;
        }
        return new File(data.toString());
    }

    private final boolean isApplicable(Uri data) {
        if (Utils.isAssetUri(data)) {
            return false;
        }
        String scheme = data.getScheme();
        if (scheme != null && !Intrinsics.areEqual(scheme, ShareInternalUtility.STAGING_PARAM)) {
            return false;
        }
        String path = data.getPath();
        if (path == null) {
            path = "";
        }
        return StringsKt.startsWith$default(path, '/', false, 2, (Object) null) && Utils.getFirstPathSegment(data) != null;
    }
}
