package zendesk.android.internal.proactivemessaging.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ReplaceWith;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.json.JsonElement;
import kotlinx.serialization.json.JsonElementKt;
import kotlinx.serialization.json.JsonElementSerializer;
import kotlinx.serialization.json.JsonPrimitive;
import zendesk.android.internal.proactivemessaging.EvaluationLanguageMapper;
import zendesk.android.internal.proactivemessaging.model.serializer.ExpressionSerializer;
import zendesk.android.pageviewevents.PageView;
import zendesk.conversationkit.android.model.VisitType;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b1\u0018\u0000 \u00132\u00020\u0001:\u0003\u0012\u0013\u0014B\u0007\b\u0004¢\u0006\u0002\u0010\u0002J%\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0000¢\u0006\u0002\b\u000bJ\u0014\u0010\f\u001a\u00020\u0004*\u00020\r2\u0006\u0010\u000e\u001a\u00020\bH\u0002J\u0014\u0010\u000f\u001a\u00020\u0004*\u00020\r2\u0006\u0010\u000e\u001a\u00020\u0010H\u0002J\u0014\u0010\u0011\u001a\u00020\u0004*\u00020\r2\u0006\u0010\u000e\u001a\u00020\nH\u0002\u0082\u0001\u0002\u0015\r¨\u0006\u0016"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Expression;", "", "()V", "evaluate", "", "event", "Lzendesk/android/pageviewevents/PageView;", "locale", "Ljava/util/Locale;", "visitType", "Lzendesk/conversationkit/android/model/VisitType;", "evaluate$zendesk_zendesk_android", "evaluateAsALocale", "Lzendesk/android/internal/proactivemessaging/model/Expression$ExpressionClass;", "targetValue", "evaluateAsAString", "", "evaluateAsAVisitType", "BoolValue", "Companion", "ExpressionClass", "Lzendesk/android/internal/proactivemessaging/model/Expression$BoolValue;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable(with = ExpressionSerializer.class)
public abstract class Expression {

    public static final Companion INSTANCE = new Companion(null);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;
        public static final int[] $EnumSwitchMapping$1;

        static {
            int[] iArr = new int[ExpressionFunction.values().length];
            try {
                iArr[ExpressionFunction.EQUALS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ExpressionFunction.NOT_EQUALS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ExpressionFunction.CONTAINS_ANY_STRING.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[ExpressionFunction.CONTAINS_NONE_STRING.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[ExpressionFunction.UNKNOWN.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            $EnumSwitchMapping$0 = iArr;
            int[] iArr2 = new int[ExpressionTarget.values().length];
            try {
                iArr2[ExpressionTarget.PATH.ordinal()] = 1;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr2[ExpressionTarget.PAGE_TITLE.ordinal()] = 2;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr2[ExpressionTarget.USER_TYPE.ordinal()] = 3;
            } catch (NoSuchFieldError unused8) {
            }
            try {
                iArr2[ExpressionTarget.LANGUAGE.ordinal()] = 4;
            } catch (NoSuchFieldError unused9) {
            }
            try {
                iArr2[ExpressionTarget.UNKNOWN.ordinal()] = 5;
            } catch (NoSuchFieldError unused10) {
            }
            $EnumSwitchMapping$1 = iArr2;
        }
    }

    public Expression(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Expression$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Expression;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Expression> serializer() {
            return ExpressionSerializer.INSTANCE;
        }
    }

    private Expression() {
    }

    @Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 32\u00020\u0001:\u000223BO\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\t\u0012\u0010\b\u0001\u0010\n\u001a\n\u0012\u0004\u0012\u00020\f\u0018\u00010\u000b\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fB+\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b¢\u0006\u0002\u0010\u0010J\t\u0010\u001e\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001f\u001a\u00020\u0007HÆ\u0003J\t\u0010 \u001a\u00020\tHÆ\u0003J\u000f\u0010!\u001a\b\u0012\u0004\u0012\u00020\f0\u000bHÆ\u0003J7\u0010\"\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\u000e\b\u0002\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bHÆ\u0001J\u0013\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010&HÖ\u0003J\t\u0010'\u001a\u00020\u0003HÖ\u0001J\t\u0010(\u001a\u00020)HÖ\u0001J&\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020\u00002\u0006\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u000200HÁ\u0001¢\u0006\u0002\b1R\"\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0011\u0010\u0012\u001a\u0004\b\u0013\u0010\u0014R\u001c\u0010\u0006\u001a\u00020\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0015\u0010\u0012\u001a\u0004\b\u0016\u0010\u0017R\u001c\u0010\b\u001a\u00020\t8\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0018\u0010\u0012\u001a\u0004\b\u0019\u0010\u001aR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001b\u0010\u0012\u001a\u0004\b\u001c\u0010\u001d¨\u00064"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Expression$ExpressionClass;", "Lzendesk/android/internal/proactivemessaging/model/Expression;", "seen1", "", "type", "Lzendesk/android/internal/proactivemessaging/model/ExpressionType;", "function", "Lzendesk/android/internal/proactivemessaging/model/ExpressionFunction;", "target", "Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;", "args", "", "Lkotlinx/serialization/json/JsonElement;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/android/internal/proactivemessaging/model/ExpressionType;Lzendesk/android/internal/proactivemessaging/model/ExpressionFunction;Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;Ljava/util/List;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/android/internal/proactivemessaging/model/ExpressionType;Lzendesk/android/internal/proactivemessaging/model/ExpressionFunction;Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;Ljava/util/List;)V", "getArgs$annotations", "()V", "getArgs", "()Ljava/util/List;", "getFunction$annotations", "getFunction", "()Lzendesk/android/internal/proactivemessaging/model/ExpressionFunction;", "getTarget$annotations", "getTarget", "()Lzendesk/android/internal/proactivemessaging/model/ExpressionTarget;", "getType$annotations", "getType", "()Lzendesk/android/internal/proactivemessaging/model/ExpressionType;", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "toString", "", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("ExpressionClass")
    public static final class ExpressionClass extends Expression {
        private final List<JsonElement> args;
        private final ExpressionFunction function;
        private final ExpressionTarget target;
        private final ExpressionType type;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {null, null, null, new ArrayListSerializer(JsonElementSerializer.INSTANCE)};

        public static ExpressionClass copy$default(ExpressionClass expressionClass, ExpressionType expressionType, ExpressionFunction expressionFunction, ExpressionTarget expressionTarget, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                expressionType = expressionClass.type;
            }
            if ((i & 2) != 0) {
                expressionFunction = expressionClass.function;
            }
            if ((i & 4) != 0) {
                expressionTarget = expressionClass.target;
            }
            if ((i & 8) != 0) {
                list = expressionClass.args;
            }
            return expressionClass.copy(expressionType, expressionFunction, expressionTarget, list);
        }

        @SerialName("args")
        public static void getArgs$annotations() {
        }

        @SerialName("function")
        public static void getFunction$annotations() {
        }

        @SerialName("target")
        public static void getTarget$annotations() {
        }

        @SerialName("type")
        public static void getType$annotations() {
        }

        public final ExpressionType getType() {
            return this.type;
        }

        public final ExpressionFunction getFunction() {
            return this.function;
        }

        public final ExpressionTarget getTarget() {
            return this.target;
        }

        public final List<JsonElement> component4() {
            return this.args;
        }

        public final ExpressionClass copy(ExpressionType type, ExpressionFunction function, ExpressionTarget target, List<? extends JsonElement> args) {
            Intrinsics.checkNotNullParameter(type, "type");
            Intrinsics.checkNotNullParameter(function, "function");
            Intrinsics.checkNotNullParameter(target, "target");
            Intrinsics.checkNotNullParameter(args, "args");
            return new ExpressionClass(type, function, target, args);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ExpressionClass)) {
                return false;
            }
            ExpressionClass expressionClass = (ExpressionClass) other;
            return this.type == expressionClass.type && this.function == expressionClass.function && this.target == expressionClass.target && Intrinsics.areEqual(this.args, expressionClass.args);
        }

        public int hashCode() {
            return (((((this.type.hashCode() * 31) + this.function.hashCode()) * 31) + this.target.hashCode()) * 31) + this.args.hashCode();
        }

        public String toString() {
            return "ExpressionClass(type=" + this.type + ", function=" + this.function + ", target=" + this.target + ", args=" + this.args + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Expression$ExpressionClass$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Expression$ExpressionClass;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<ExpressionClass> serializer() {
                return Expression$ExpressionClass$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public ExpressionClass(int i, @SerialName("type") ExpressionType expressionType, @SerialName("function") ExpressionFunction expressionFunction, @SerialName("target") ExpressionTarget expressionTarget, @SerialName("args") List list, SerializationConstructorMarker serializationConstructorMarker) {
            super(null);
            if (15 != (i & 15)) {
                PluginExceptionsKt.throwMissingFieldException(i, 15, Expression$ExpressionClass$$serializer.INSTANCE.getDescriptor());
            }
            this.type = expressionType;
            this.function = expressionFunction;
            this.target = expressionTarget;
            this.args = list;
        }

        @JvmStatic
        public static final void write$Self$zendesk_zendesk_android(ExpressionClass self, CompositeEncoder output, SerialDescriptor serialDesc) {
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeSerializableElement(serialDesc, 0, ExpressionType.ExpressionTypeSerializer.INSTANCE, self.type);
            output.encodeSerializableElement(serialDesc, 1, ExpressionFunction.ExpressionFunctionSerializer.INSTANCE, self.function);
            output.encodeSerializableElement(serialDesc, 2, ExpressionTarget.ExpressionTargetSerializer.INSTANCE, self.target);
            output.encodeSerializableElement(serialDesc, 3, kSerializerArr[3], self.args);
        }

        public final ExpressionType getType() {
            return this.type;
        }

        public final ExpressionFunction getFunction() {
            return this.function;
        }

        public final ExpressionTarget getTarget() {
            return this.target;
        }

        public final List<JsonElement> getArgs() {
            return this.args;
        }

        public ExpressionClass(ExpressionType type, ExpressionFunction function, ExpressionTarget target, List<? extends JsonElement> args) {
            super(null);
            Intrinsics.checkNotNullParameter(type, "type");
            Intrinsics.checkNotNullParameter(function, "function");
            Intrinsics.checkNotNullParameter(target, "target");
            Intrinsics.checkNotNullParameter(args, "args");
            this.type = type;
            this.function = function;
            this.target = target;
            this.args = args;
        }
    }

    private final boolean evaluateAsAString(ExpressionClass expressionClass, String str) {
        JsonPrimitive jsonPrimitive;
        String contentOrNull;
        String contentOrNull2;
        String contentOrNull3;
        String contentOrNull4;
        int i = WhenMappings.$EnumSwitchMapping$0[expressionClass.getFunction().ordinal()];
        String str2 = "";
        if (i == 1) {
            Object objFirstOrNull = CollectionsKt.firstOrNull((List<? extends Object>) expressionClass.getArgs());
            jsonPrimitive = objFirstOrNull instanceof JsonPrimitive ? (JsonPrimitive) objFirstOrNull : null;
            if (jsonPrimitive != null && (contentOrNull = JsonElementKt.getContentOrNull(jsonPrimitive)) != null) {
                str2 = contentOrNull;
            }
            return StringsKt.equals(StringsKt.trim((CharSequence) str2).toString(), StringsKt.trim((CharSequence) str).toString(), true);
        }
        if (i == 2) {
            Object objFirstOrNull2 = CollectionsKt.firstOrNull((List<? extends Object>) expressionClass.getArgs());
            jsonPrimitive = objFirstOrNull2 instanceof JsonPrimitive ? (JsonPrimitive) objFirstOrNull2 : null;
            if (jsonPrimitive != null && (contentOrNull2 = JsonElementKt.getContentOrNull(jsonPrimitive)) != null) {
                str2 = contentOrNull2;
            }
            if (!StringsKt.equals(StringsKt.trim((CharSequence) str2).toString(), StringsKt.trim((CharSequence) str).toString(), true)) {
                return true;
            }
        } else if (i == 3) {
            String lowerCase = StringsKt.trim((CharSequence) str).toString().toLowerCase(Locale.ROOT);
            Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
            List<JsonElement> args = expressionClass.getArgs();
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(args, 10));
            for (JsonElement jsonElement : args) {
                JsonPrimitive jsonPrimitive2 = jsonElement instanceof JsonPrimitive ? (JsonPrimitive) jsonElement : null;
                if (jsonPrimitive2 == null || (contentOrNull3 = JsonElementKt.getContentOrNull(jsonPrimitive2)) == null) {
                    contentOrNull3 = "";
                }
                String lowerCase2 = StringsKt.trim((CharSequence) contentOrNull3).toString().toLowerCase(Locale.ROOT);
                Intrinsics.checkNotNullExpressionValue(lowerCase2, "toLowerCase(...)");
                arrayList.add(lowerCase2);
            }
            ArrayList arrayList2 = arrayList;
            if (!(arrayList2 instanceof Collection) || !arrayList2.isEmpty()) {
                Iterator it = arrayList2.iterator();
                while (it.hasNext()) {
                    if (StringsKt.contains$default((CharSequence) lowerCase, (CharSequence) it.next(), false, 2, (Object) null)) {
                        return true;
                    }
                }
            }
        } else {
            if (i == 4) {
                String lowerCase3 = StringsKt.trim((CharSequence) str).toString().toLowerCase(Locale.ROOT);
                Intrinsics.checkNotNullExpressionValue(lowerCase3, "toLowerCase(...)");
                List<JsonElement> args2 = expressionClass.getArgs();
                ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(args2, 10));
                for (JsonElement jsonElement2 : args2) {
                    JsonPrimitive jsonPrimitive3 = jsonElement2 instanceof JsonPrimitive ? (JsonPrimitive) jsonElement2 : null;
                    if (jsonPrimitive3 == null || (contentOrNull4 = JsonElementKt.getContentOrNull(jsonPrimitive3)) == null) {
                        contentOrNull4 = "";
                    }
                    String lowerCase4 = StringsKt.trim((CharSequence) contentOrNull4).toString().toLowerCase(Locale.ROOT);
                    Intrinsics.checkNotNullExpressionValue(lowerCase4, "toLowerCase(...)");
                    arrayList3.add(lowerCase4);
                }
                ArrayList arrayList4 = arrayList3;
                if ((arrayList4 instanceof Collection) && arrayList4.isEmpty()) {
                    return true;
                }
                Iterator it2 = arrayList4.iterator();
                while (it2.hasNext()) {
                    if (StringsKt.contains$default((CharSequence) lowerCase3, (CharSequence) it2.next(), false, 2, (Object) null)) {
                    }
                }
                return true;
            }
            if (i != 5) {
                throw new NoWhenBranchMatchedException();
            }
        }
        return false;
    }

    private final boolean evaluateAsALocale(ExpressionClass expressionClass, Locale locale) {
        String contentOrNull;
        Object objFirstOrNull = CollectionsKt.firstOrNull((List<? extends Object>) expressionClass.getArgs());
        JsonPrimitive jsonPrimitive = objFirstOrNull instanceof JsonPrimitive ? (JsonPrimitive) objFirstOrNull : null;
        if (jsonPrimitive == null || (contentOrNull = JsonElementKt.getContentOrNull(jsonPrimitive)) == null) {
            contentOrNull = "";
        }
        String lowerCase = StringsKt.replace$default(contentOrNull, '_', '-', false, 4, (Object) null).toLowerCase(Locale.ROOT);
        Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
        int i = WhenMappings.$EnumSwitchMapping$0[expressionClass.getFunction().ordinal()];
        if (i == 1) {
            if (StringsKt.contains$default((CharSequence) lowerCase, '-', false, 2, (Object) null)) {
                Locale localeForLanguageTag = Locale.forLanguageTag(lowerCase);
                EvaluationLanguageMapper.Companion companion = EvaluationLanguageMapper.INSTANCE;
                String languageTag = locale.toLanguageTag();
                Intrinsics.checkNotNullExpressionValue(languageTag, "toLanguageTag(...)");
                return Intrinsics.areEqual(localeForLanguageTag, Locale.forLanguageTag(companion.mapLanguage$zendesk_zendesk_android(languageTag, lowerCase)));
            }
            return Intrinsics.areEqual(lowerCase, locale.getLanguage());
        }
        if (i != 2) {
            if (i != 3 && i != 4 && i != 5) {
                throw new NoWhenBranchMatchedException();
            }
        } else if (StringsKt.contains$default((CharSequence) lowerCase, '-', false, 2, (Object) null)) {
            Locale localeForLanguageTag2 = Locale.forLanguageTag(lowerCase);
            EvaluationLanguageMapper.Companion companion2 = EvaluationLanguageMapper.INSTANCE;
            String languageTag2 = locale.toLanguageTag();
            Intrinsics.checkNotNullExpressionValue(languageTag2, "toLanguageTag(...)");
            if (!Intrinsics.areEqual(localeForLanguageTag2, Locale.forLanguageTag(companion2.mapLanguage$zendesk_zendesk_android(languageTag2, lowerCase)))) {
                return true;
            }
        } else if (!Intrinsics.areEqual(lowerCase, locale.getLanguage())) {
            return true;
        }
        return false;
    }

    private final boolean evaluateAsAVisitType(ExpressionClass expressionClass, VisitType visitType) {
        String contentOrNull;
        int i = WhenMappings.$EnumSwitchMapping$0[expressionClass.getFunction().ordinal()];
        if (i != 1) {
            if (i == 2 || i == 3 || i == 4 || i == 5) {
                return false;
            }
            throw new NoWhenBranchMatchedException();
        }
        Object objFirstOrNull = CollectionsKt.firstOrNull((List<? extends Object>) expressionClass.getArgs());
        JsonPrimitive jsonPrimitive = objFirstOrNull instanceof JsonPrimitive ? (JsonPrimitive) objFirstOrNull : null;
        if (jsonPrimitive == null || (contentOrNull = JsonElementKt.getContentOrNull(jsonPrimitive)) == null) {
            contentOrNull = "";
        }
        return StringsKt.equals(contentOrNull, visitType.name(), true);
    }

    public final boolean evaluate$zendesk_zendesk_android(PageView event, Locale locale, VisitType visitType) {
        Intrinsics.checkNotNullParameter(event, "event");
        Intrinsics.checkNotNullParameter(locale, "locale");
        Intrinsics.checkNotNullParameter(visitType, "visitType");
        if (this instanceof BoolValue) {
            return ((BoolValue) this).getValue();
        }
        if (this instanceof ExpressionClass) {
            ExpressionClass expressionClass = (ExpressionClass) this;
            int i = WhenMappings.$EnumSwitchMapping$1[expressionClass.getTarget().ordinal()];
            if (i == 1) {
                return evaluateAsAString(expressionClass, event.getUrl());
            }
            if (i == 2) {
                return evaluateAsAString(expressionClass, event.getPageTitle());
            }
            if (i == 3) {
                return evaluateAsAVisitType(expressionClass, visitType);
            }
            if (i == 4) {
                return evaluateAsALocale(expressionClass, locale);
            }
            if (i == 5) {
                return false;
            }
            throw new NoWhenBranchMatchedException();
        }
        throw new NoWhenBranchMatchedException();
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0001\u0018\u0000 \u00152\u00020\u0001:\u0002\u0014\u0015B!\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\r\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ&\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012HÁ\u0001¢\u0006\u0002\b\u0013R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Expression$BoolValue;", "Lzendesk/android/internal/proactivemessaging/model/Expression;", "seen1", "", "value", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(IZLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Z)V", "getValue", "()Z", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("BoolValue")
    public static final class BoolValue extends Expression {

        public static final Companion INSTANCE = new Companion(null);
        private final boolean value;

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/Expression$BoolValue$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Expression$BoolValue;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<BoolValue> serializer() {
                return Expression$BoolValue$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public BoolValue(int i, boolean z, SerializationConstructorMarker serializationConstructorMarker) {
            super(null);
            if (1 != (i & 1)) {
                PluginExceptionsKt.throwMissingFieldException(i, 1, Expression$BoolValue$$serializer.INSTANCE.getDescriptor());
            }
            this.value = z;
        }

        public BoolValue(boolean z) {
            super(null);
            this.value = z;
        }

        public final boolean getValue() {
            return this.value;
        }
    }
}
