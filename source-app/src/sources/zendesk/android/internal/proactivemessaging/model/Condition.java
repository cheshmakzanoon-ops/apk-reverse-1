package zendesk.android.internal.proactivemessaging.model;

import java.util.List;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import zendesk.android.internal.proactivemessaging.model.serializer.ExpressionSerializer;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 *2\u00020\u0001:\u0002)*B?\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0010\b\u0001\u0010\b\u001a\n\u0012\u0004\u0012\u00020\n\u0018\u00010\t\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB#\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t¢\u0006\u0002\u0010\u000eJ\t\u0010\u0017\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0007HÆ\u0003J\u000f\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\n0\tHÆ\u0003J-\u0010\u001a\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\tHÆ\u0001J\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001f\u001a\u00020 HÖ\u0001J&\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020\u00002\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020'HÁ\u0001¢\u0006\u0002\b(R\"\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000f\u0010\u0010\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016¨\u0006+"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Condition;", "", "seen1", "", "type", "Lzendesk/android/internal/proactivemessaging/model/ConditionType;", "function", "Lzendesk/android/internal/proactivemessaging/model/ConditionFunction;", "expressions", "", "Lzendesk/android/internal/proactivemessaging/model/Expression;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/android/internal/proactivemessaging/model/ConditionType;Lzendesk/android/internal/proactivemessaging/model/ConditionFunction;Ljava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/android/internal/proactivemessaging/model/ConditionType;Lzendesk/android/internal/proactivemessaging/model/ConditionFunction;Ljava/util/List;)V", "getExpressions$annotations", "()V", "getExpressions", "()Ljava/util/List;", "getFunction", "()Lzendesk/android/internal/proactivemessaging/model/ConditionFunction;", "getType", "()Lzendesk/android/internal/proactivemessaging/model/ConditionType;", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Condition {
    private final List<Expression> expressions;
    private final ConditionFunction function;
    private final ConditionType type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, new ArrayListSerializer(ExpressionSerializer.INSTANCE)};

    public static Condition copy$default(Condition condition, ConditionType conditionType, ConditionFunction conditionFunction, List list, int i, Object obj) {
        if ((i & 1) != 0) {
            conditionType = condition.type;
        }
        if ((i & 2) != 0) {
            conditionFunction = condition.function;
        }
        if ((i & 4) != 0) {
            list = condition.expressions;
        }
        return condition.copy(conditionType, conditionFunction, list);
    }

    @SerialName("args")
    public static void getExpressions$annotations() {
    }

    public final ConditionType getType() {
        return this.type;
    }

    public final ConditionFunction getFunction() {
        return this.function;
    }

    public final List<Expression> component3() {
        return this.expressions;
    }

    public final Condition copy(ConditionType type, ConditionFunction function, List<? extends Expression> expressions) {
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(function, "function");
        Intrinsics.checkNotNullParameter(expressions, "expressions");
        return new Condition(type, function, expressions);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Condition)) {
            return false;
        }
        Condition condition = (Condition) other;
        return this.type == condition.type && this.function == condition.function && Intrinsics.areEqual(this.expressions, condition.expressions);
    }

    public int hashCode() {
        return (((this.type.hashCode() * 31) + this.function.hashCode()) * 31) + this.expressions.hashCode();
    }

    public String toString() {
        return "Condition(type=" + this.type + ", function=" + this.function + ", expressions=" + this.expressions + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Condition$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Condition;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Condition> serializer() {
            return Condition$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Condition(int i, ConditionType conditionType, ConditionFunction conditionFunction, @SerialName("args") List list, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, Condition$$serializer.INSTANCE.getDescriptor());
        }
        this.type = conditionType;
        this.function = conditionFunction;
        this.expressions = list;
    }

    public Condition(ConditionType type, ConditionFunction function, List<? extends Expression> expressions) {
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(function, "function");
        Intrinsics.checkNotNullParameter(expressions, "expressions");
        this.type = type;
        this.function = function;
        this.expressions = expressions;
    }

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(Condition self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, ConditionType.ConditionTypeSerializer.INSTANCE, self.type);
        output.encodeSerializableElement(serialDesc, 1, ConditionFunction.ConditionFunctionSerializer.INSTANCE, self.function);
        output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.expressions);
    }

    public final ConditionType getType() {
        return this.type;
    }

    public final ConditionFunction getFunction() {
        return this.function;
    }

    public final List<Expression> getExpressions() {
        return this.expressions;
    }
}
