package androidx.compose.p000ui.text.input;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/text/input/KeyboardCapitalization;", "", SDKConstants.PARAM_VALUE, "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@JvmInline
public final class KeyboardCapitalization {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Unspecified = m1489constructorimpl(-1);
    private static final int None = m1489constructorimpl(0);
    private static final int Characters = m1489constructorimpl(1);
    private static final int Words = m1489constructorimpl(2);
    private static final int Sentences = m1489constructorimpl(3);

    public static final KeyboardCapitalization m1488boximpl(int i) {
        return new KeyboardCapitalization(i);
    }

    private static int m1489constructorimpl(int i) {
        return i;
    }

    public static boolean m1490equalsimpl(int i, Object obj) {
        return (obj instanceof KeyboardCapitalization) && i == ((KeyboardCapitalization) obj).getValue();
    }

    public static final boolean m1491equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m1492hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m1490equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m1492hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private KeyboardCapitalization(int i) {
        this.value = i;
    }

    public String toString() {
        return m1493toStringimpl(this.value);
    }

    public static String m1493toStringimpl(int i) {
        if (m1491equalsimpl0(i, Unspecified)) {
            return "Unspecified";
        }
        if (m1491equalsimpl0(i, None)) {
            return "None";
        }
        if (m1491equalsimpl0(i, Characters)) {
            return "Characters";
        }
        if (m1491equalsimpl0(i, Words)) {
            return "Words";
        }
        return m1491equalsimpl0(i, Sentences) ? "Sentences" : "Invalid";
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0011\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R$\u0010\u0003\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007R$\u0010\t\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\n\u0010\u0002\u001a\u0004\b\u000b\u0010\u0007R$\u0010\f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\r\u0010\u0002\u001a\u0004\b\u000e\u0010\u0007R$\u0010\u000f\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0010\u0010\u0002\u001a\u0004\b\u0011\u0010\u0007R$\u0010\u0012\u001a\u00020\u00048\u0006X\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\b\u0012\u0004\b\u0013\u0010\u0002\u001a\u0004\b\u0014\u0010\u0007\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0015"}, d2 = {"Landroidx/compose/ui/text/input/KeyboardCapitalization$Companion;", "", "()V", "Characters", "Landroidx/compose/ui/text/input/KeyboardCapitalization;", "getCharacters-IUNYP9k$annotations", "getCharacters-IUNYP9k", "()I", "I", "None", "getNone-IUNYP9k$annotations", "getNone-IUNYP9k", "Sentences", "getSentences-IUNYP9k$annotations", "getSentences-IUNYP9k", "Unspecified", "getUnspecified-IUNYP9k$annotations", "getUnspecified-IUNYP9k", "Words", "getWords-IUNYP9k$annotations", "getWords-IUNYP9k", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void m1495getCharactersIUNYP9k$annotations() {
        }

        public static void m1496getNoneIUNYP9k$annotations() {
        }

        public static void m1497getSentencesIUNYP9k$annotations() {
        }

        public static void m1498getUnspecifiedIUNYP9k$annotations() {
        }

        public static void m1499getWordsIUNYP9k$annotations() {
        }

        private Companion() {
        }

        public final int m1503getUnspecifiedIUNYP9k() {
            return KeyboardCapitalization.Unspecified;
        }

        public final int m1501getNoneIUNYP9k() {
            return KeyboardCapitalization.None;
        }

        public final int m1500getCharactersIUNYP9k() {
            return KeyboardCapitalization.Characters;
        }

        public final int m1504getWordsIUNYP9k() {
            return KeyboardCapitalization.Words;
        }

        public final int m1502getSentencesIUNYP9k() {
            return KeyboardCapitalization.Sentences;
        }
    }
}
