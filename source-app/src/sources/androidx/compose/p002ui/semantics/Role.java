package androidx.compose.p002ui.semantics;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/semantics/Role;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class Role {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Button = m6605constructorimpl(0);
    private static final int Checkbox = m6605constructorimpl(1);
    private static final int Switch = m6605constructorimpl(2);
    private static final int RadioButton = m6605constructorimpl(3);
    private static final int Tab = m6605constructorimpl(4);
    private static final int Image = m6605constructorimpl(5);
    private static final int DropdownList = m6605constructorimpl(6);

    public static final Role m6604boximpl(int i) {
        return new Role(i);
    }

    private static int m6605constructorimpl(int i) {
        return i;
    }

    public static boolean m6606equalsimpl(int i, Object obj) {
        return (obj instanceof Role) && i == ((Role) obj).getValue();
    }

    public static final boolean m6607equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m6608hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m6606equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m6608hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0014"}, d2 = {"Landroidx/compose/ui/semantics/Role$Companion;", "", "()V", "Button", "Landroidx/compose/ui/semantics/Role;", "getButton-o7Vup1c", "()I", "I", "Checkbox", "getCheckbox-o7Vup1c", "DropdownList", "getDropdownList-o7Vup1c", "Image", "getImage-o7Vup1c", "RadioButton", "getRadioButton-o7Vup1c", "Switch", "getSwitch-o7Vup1c", "Tab", "getTab-o7Vup1c", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m6611getButtono7Vup1c() {
            return Role.Button;
        }

        public final int m6612getCheckboxo7Vup1c() {
            return Role.Checkbox;
        }

        public final int m6616getSwitcho7Vup1c() {
            return Role.Switch;
        }

        public final int m6615getRadioButtono7Vup1c() {
            return Role.RadioButton;
        }

        public final int m6617getTabo7Vup1c() {
            return Role.Tab;
        }

        public final int m6614getImageo7Vup1c() {
            return Role.Image;
        }

        public final int m6613getDropdownListo7Vup1c() {
            return Role.DropdownList;
        }
    }

    private Role(int i) {
        this.value = i;
    }

    public String toString() {
        return m6609toStringimpl(this.value);
    }

    public static String m6609toStringimpl(int i) {
        if (m6607equalsimpl0(i, Button)) {
            return "Button";
        }
        if (m6607equalsimpl0(i, Checkbox)) {
            return "Checkbox";
        }
        if (m6607equalsimpl0(i, Switch)) {
            return "Switch";
        }
        if (m6607equalsimpl0(i, RadioButton)) {
            return "RadioButton";
        }
        if (m6607equalsimpl0(i, Tab)) {
            return "Tab";
        }
        if (m6607equalsimpl0(i, Image)) {
            return "Image";
        }
        return m6607equalsimpl0(i, DropdownList) ? "DropdownList" : "Unknown";
    }
}
