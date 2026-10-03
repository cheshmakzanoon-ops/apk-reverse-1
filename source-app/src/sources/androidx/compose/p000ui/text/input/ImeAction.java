package androidx.compose.p000ui.text.input;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.webkit.Profile;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/input/ImeAction;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class ImeAction {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Unspecified = m1452constructorimpl(-1);
    private static final int Default = m1452constructorimpl(1);
    private static final int None = m1452constructorimpl(0);

    private static final int f0Go = m1452constructorimpl(2);
    private static final int Search = m1452constructorimpl(3);
    private static final int Send = m1452constructorimpl(4);
    private static final int Previous = m1452constructorimpl(5);
    private static final int Next = m1452constructorimpl(6);
    private static final int Done = m1452constructorimpl(7);

    public static final ImeAction m1451boximpl(int i) {
        return new ImeAction(i);
    }

    private static int m1452constructorimpl(int i) {
        return i;
    }

    public static boolean m1453equalsimpl(int i, Object obj) {
        return (obj instanceof ImeAction) && i == ((ImeAction) obj).getValue();
    }

    public static final boolean m1454equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1455hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1453equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1455hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private ImeAction(int i) {
        this.value = i;
    }

    public String toString() {
        return m1456toStringimpl(this.value);
    }

    public static String m1456toStringimpl(int i) {
        if (m1454equalsimpl0(i, Unspecified)) {
            return "Unspecified";
        }
        if (m1454equalsimpl0(i, None)) {
            return "None";
        }
        if (m1454equalsimpl0(i, Default)) {
            return Profile.DEFAULT_PROFILE_NAME;
        }
        if (m1454equalsimpl0(i, f0Go)) {
            return "Go";
        }
        if (m1454equalsimpl0(i, Search)) {
            return "Search";
        }
        if (m1454equalsimpl0(i, Send)) {
            return "Send";
        }
        if (m1454equalsimpl0(i, Previous)) {
            return "Previous";
        }
        if (m1454equalsimpl0(i, Next)) {
            return "Next";
        }
        return m1454equalsimpl0(i, Done) ? "Done" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u001d\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R$\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R$\u0010\t\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\n\u0010\u0002\u001a\u0004\b\u000b\u0010\u0007R$\u0010\f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\r\u0010\u0002\u001a\u0004\b\u000e\u0010\u0007R$\u0010\u000f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0010\u0010\u0002\u001a\u0004\b\u0011\u0010\u0007R$\u0010\u0012\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0013\u0010\u0002\u001a\u0004\b\u0014\u0010\u0007R$\u0010\u0015\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0016\u0010\u0002\u001a\u0004\b\u0017\u0010\u0007R$\u0010\u0018\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0019\u0010\u0002\u001a\u0004\b\u001a\u0010\u0007R$\u0010\u001b\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u001c\u0010\u0002\u001a\u0004\b\u001d\u0010\u0007R$\u0010\u001e\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u001f\u0010\u0002\u001a\u0004\b \u0010\u0007\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006!"}, d2 = {"Landroidx/compose/ui/text/input/ImeAction$Companion;", "", "()V", Profile.DEFAULT_PROFILE_NAME, "Landroidx/compose/ui/text/input/ImeAction;", "getDefault-eUduSuo$annotations", "getDefault-eUduSuo", "()I", "I", "Done", "getDone-eUduSuo$annotations", "getDone-eUduSuo", "Go", "getGo-eUduSuo$annotations", "getGo-eUduSuo", "Next", "getNext-eUduSuo$annotations", "getNext-eUduSuo", "None", "getNone-eUduSuo$annotations", "getNone-eUduSuo", "Previous", "getPrevious-eUduSuo$annotations", "getPrevious-eUduSuo", "Search", "getSearch-eUduSuo$annotations", "getSearch-eUduSuo", "Send", "getSend-eUduSuo$annotations", "getSend-eUduSuo", "Unspecified", "getUnspecified-eUduSuo$annotations", "getUnspecified-eUduSuo", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void m1458getDefaulteUduSuo$annotations() {
        }

        public static void m1459getDoneeUduSuo$annotations() {
        }

        public static void m1460getGoeUduSuo$annotations() {
        }

        public static void m1461getNexteUduSuo$annotations() {
        }

        public static void m1462getNoneeUduSuo$annotations() {
        }

        public static void m1463getPreviouseUduSuo$annotations() {
        }

        public static void m1464getSearcheUduSuo$annotations() {
        }

        public static void m1465getSendeUduSuo$annotations() {
        }

        public static void m1466getUnspecifiedeUduSuo$annotations() {
        }

        private Companion() {
        }

        public final int m1475getUnspecifiedeUduSuo() {
            return ImeAction.Unspecified;
        }

        public final int m1467getDefaulteUduSuo() {
            return ImeAction.Default;
        }

        public final int m1471getNoneeUduSuo() {
            return ImeAction.None;
        }

        public final int m1469getGoeUduSuo() {
            return ImeAction.f0Go;
        }

        public final int m1473getSearcheUduSuo() {
            return ImeAction.Search;
        }

        public final int m1474getSendeUduSuo() {
            return ImeAction.Send;
        }

        public final int m1472getPreviouseUduSuo() {
            return ImeAction.Previous;
        }

        public final int m1470getNexteUduSuo() {
            return ImeAction.Next;
        }

        public final int m1468getDoneeUduSuo() {
            return ImeAction.Done;
        }
    }
}
