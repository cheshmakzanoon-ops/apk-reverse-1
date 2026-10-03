package coil.request;

import androidx.constraintlayout.widget.ConstraintLayout;
import coil.decode.SvgDecoder;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\u001a\u0012\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0000\u001a\u00020\u0002\u001a\f\u0010\u0000\u001a\u0004\u0018\u00010\u0002*\u00020\u0003¨\u0006\u0004"}, d2 = {"css", "Lcoil/request/ImageRequest$Builder;", "", "Lcoil/request/Parameters;", "coil-svg_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class Svgs {
    public static final ImageRequest.Builder css(ImageRequest.Builder builder, String str) {
        return ImageRequest.Builder.setParameter$default(builder, SvgDecoder.CSS_KEY, str, null, 4, null);
    }

    public static final String css(Parameters parameters) {
        return (String) parameters.value(SvgDecoder.CSS_KEY);
    }
}
