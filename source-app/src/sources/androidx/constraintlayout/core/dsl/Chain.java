package androidx.constraintlayout.core.dsl;

import com.facebook.internal.AnalyticsEvents;
import com.facebook.internal.security.CertificateUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public abstract class Chain extends Helper {
    protected static final Map<Style, String> styleMap;
    private Style mStyle;
    protected ArrayList<Ref> references;

    public enum Style {
        PACKED,
        SPREAD,
        SPREAD_INSIDE
    }

    static {
        HashMap map = new HashMap();
        styleMap = map;
        map.put(Style.SPREAD, "'spread'");
        map.put(Style.SPREAD_INSIDE, "'spread_inside'");
        map.put(Style.PACKED, "'packed'");
    }

    public Chain(String str) {
        super(str, new Helper.HelperType(""));
        this.mStyle = null;
        this.references = new ArrayList<>();
    }

    public Style getStyle() {
        return this.mStyle;
    }

    public void setStyle(Style style) {
        this.mStyle = style;
        this.configMap.put(AnalyticsEvents.PARAMETER_LIKE_VIEW_STYLE, styleMap.get(style));
    }

    public String referencesToString() {
        if (this.references.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder("[");
        Iterator<Ref> it = this.references.iterator();
        while (it.hasNext()) {
            sb.append(it.next().toString());
        }
        sb.append("]");
        return sb.toString();
    }

    public Chain addReference(Ref ref) {
        this.references.add(ref);
        this.configMap.put("contains", referencesToString());
        return this;
    }

    public Chain addReference(String str) {
        return addReference(Ref.parseStringToRef(str));
    }

    public class Anchor {
        Constraint.Anchor mConnection = null;
        int mGoneMargin = Integer.MIN_VALUE;
        int mMargin;
        final Constraint.Side mSide;

        Anchor(Constraint.Side side) {
            this.mSide = side;
        }

        public String getId() {
            return Chain.this.name;
        }

        public void build(StringBuilder sb) {
            if (this.mConnection != null) {
                sb.append(this.mSide.toString().toLowerCase());
                sb.append(CertificateUtil.DELIMITER);
                sb.append(this);
                sb.append(",\n");
            }
        }

        public String toString() {
            StringBuilder sb = new StringBuilder("[");
            if (this.mConnection != null) {
                sb.append("'");
                sb.append(this.mConnection.getId());
                sb.append("','");
                sb.append(this.mConnection.mSide.toString().toLowerCase());
                sb.append("'");
            }
            if (this.mMargin != 0) {
                sb.append(",");
                sb.append(this.mMargin);
            }
            if (this.mGoneMargin != Integer.MIN_VALUE) {
                if (this.mMargin == 0) {
                    sb.append(",0,");
                    sb.append(this.mGoneMargin);
                } else {
                    sb.append(",");
                    sb.append(this.mGoneMargin);
                }
            }
            sb.append("]");
            return sb.toString();
        }
    }
}
