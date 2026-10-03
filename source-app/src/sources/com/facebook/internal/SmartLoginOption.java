package com.facebook.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.util.Arrays;
import java.util.EnumSet;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\t\n\u0002\b\b\b\u0086\u0001\u0018\u0000 \n2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\nB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\t¨\u0006\u000b"}, d2 = {"Lcom/facebook/internal/SmartLoginOption;", "", SDKConstants.PARAM_VALUE, "", "(Ljava/lang/String;IJ)V", "getValue", "()J", "None", "Enabled", "RequireConfirm", "Companion", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public enum SmartLoginOption {
    None(0),
    Enabled(1),
    RequireConfirm(2);

    private static final EnumSet<SmartLoginOption> ALL;

    public static final Companion INSTANCE = new Companion(null);
    private final long value;

    @JvmStatic
    public static final EnumSet<SmartLoginOption> parseOptions(long j) {
        return INSTANCE.parseOptions(j);
    }

    SmartLoginOption(long j) {
        this.value = j;
    }

    public final long getValue() {
        return this.value;
    }

    static {
        EnumSet<SmartLoginOption> enumSetAllOf = EnumSet.allOf(SmartLoginOption.class);
        Intrinsics.checkNotNullExpressionValue(enumSetAllOf, "allOf(SmartLoginOption::class.java)");
        ALL = enumSetAllOf;
    }

    @Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0007\u001a\u00020\bH\u0007R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\t"}, d2 = {"Lcom/facebook/internal/SmartLoginOption$Companion;", "", "()V", "ALL", "Ljava/util/EnumSet;", "Lcom/facebook/internal/SmartLoginOption;", "parseOptions", "bitmask", "", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final EnumSet<SmartLoginOption> parseOptions(long bitmask) {
            EnumSet<SmartLoginOption> enumSetNoneOf = EnumSet.noneOf(SmartLoginOption.class);
            for (SmartLoginOption smartLoginOption : SmartLoginOption.ALL) {
                if ((smartLoginOption.getValue() & bitmask) != 0) {
                    enumSetNoneOf.add(smartLoginOption);
                }
            }
            Intrinsics.checkNotNullExpressionValue(enumSetNoneOf, "result");
            return enumSetNoneOf;
        }
    }

    public static SmartLoginOption[] valuesCustom() {
        SmartLoginOption[] smartLoginOptionArrValuesCustom = values();
        return (SmartLoginOption[]) Arrays.copyOf(smartLoginOptionArrValuesCustom, smartLoginOptionArrValuesCustom.length);
    }
}
