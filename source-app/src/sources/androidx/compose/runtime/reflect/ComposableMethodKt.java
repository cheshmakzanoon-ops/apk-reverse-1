package androidx.compose.runtime.reflect;

import androidx.compose.runtime.Composer;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.collections.IntIterator;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.SpreadBuilder;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u00006\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0000\u001a\u0018\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00012\u0006\u0010\u0004\u001a\u00020\u0001H\u0002\u001a\u0010\u0010\u0005\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u0001H\u0002\u001a\f\u0010\u0006\u001a\u0004\u0018\u00010\u0007*\u00020\b\u001a(\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\u000b0\n\"\u0006\b\u0000\u0010\u000b\u0018\u0001*\u0002H\u000b2\u0006\u0010\f\u001a\u00020\u0001H\u0082\b¢\u0006\u0002\u0010\r\u001a\f\u0010\u000e\u001a\u00020\u000f*\u00020\bH\u0002\u001a7\u0010\u0010\u001a\u00020\u0007*\u0006\u0012\u0002\b\u00030\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u001a\u0010\u0014\u001a\u000e\u0012\n\b\u0001\u0012\u0006\u0012\u0002\b\u00030\u00110\n\"\u0006\u0012\u0002\b\u00030\u0011¢\u0006\u0002\u0010\u0015\u001a\u0012\u0010\u0016\u001a\u0004\u0018\u00010\u0017*\u0006\u0012\u0002\b\u00030\u0011H\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0018"}, d2 = {"BITS_PER_INT", "", "changedParamCount", "realValueParams", "thisParams", "defaultParamCount", "asComposableMethod", "Landroidx/compose/runtime/reflect/ComposableMethod;", "Ljava/lang/reflect/Method;", "dup", "", "T", "count", "(Ljava/lang/Object;I)[Ljava/lang/Object;", "getComposableInfo", "Landroidx/compose/runtime/reflect/ComposableInfo;", "getDeclaredComposableMethod", "Ljava/lang/Class;", "methodName", "", "args", "(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Class;)Landroidx/compose/runtime/reflect/ComposableMethod;", "getDefaultValue", "", "runtime_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ComposableMethodKt {
    private static final int BITS_PER_INT = 31;

    private static final int changedParamCount(int i, int i2) {
        if (i == 0) {
            return 1;
        }
        return (int) Math.ceil(((double) (i + i2)) / 10.0d);
    }

    private static final int defaultParamCount(int i) {
        return (int) Math.ceil(((double) i) / 31.0d);
    }

    private static final ComposableInfo getComposableInfo(Method method) {
        Class<?>[] parameterTypes = method.getParameterTypes();
        int length = parameterTypes.length - 1;
        if (length < 0) {
            length = -1;
            break;
        }
        while (true) {
            int i = length - 1;
            if (Intrinsics.areEqual(parameterTypes[length], Composer.class)) {
                break;
            }
            if (i < 0) {
                length = -1;
                break;
            }
            length = i;
        }
        if (length == -1) {
            return new ComposableInfo(false, method.getParameterTypes().length, 0, 0);
        }
        int iChangedParamCount = changedParamCount(length, !Modifier.isStatic(method.getModifiers()) ? 1 : 0);
        int i2 = length + 1 + iChangedParamCount;
        int length2 = method.getParameterTypes().length;
        int iDefaultParamCount = length2 != i2 ? defaultParamCount(length) : 0;
        return new ComposableInfo(i2 + iDefaultParamCount == length2, length, iChangedParamCount, iDefaultParamCount);
    }

    public static final Object getDefaultValue(Class<?> cls) {
        String name = cls.getName();
        if (name != null) {
            switch (name.hashCode()) {
                case -1325958191:
                    if (name.equals("double")) {
                        return Double.valueOf(0.0d);
                    }
                    break;
                case 104431:
                    if (name.equals("int")) {
                        return 0;
                    }
                    break;
                case 3039496:
                    if (name.equals("byte")) {
                        return (byte) 0;
                    }
                    break;
                case 3052374:
                    if (name.equals("char")) {
                        return (char) 0;
                    }
                    break;
                case 3327612:
                    if (name.equals("long")) {
                        return 0L;
                    }
                    break;
                case 64711720:
                    if (name.equals("boolean")) {
                        return false;
                    }
                    break;
                case 97526364:
                    if (name.equals("float")) {
                        return Float.valueOf(0.0f);
                    }
                    break;
                case 109413500:
                    if (name.equals("short")) {
                        return (short) 0;
                    }
                    break;
            }
        }
        return null;
    }

    public static final ComposableMethod asComposableMethod(Method method) {
        ComposableInfo composableInfo = getComposableInfo(method);
        if (composableInfo.isComposable()) {
            return new ComposableMethod(method, composableInfo);
        }
        return null;
    }

    private static final <T> T[] dup(T t, int i) {
        Iterable iterableUntil = RangesKt.until(0, i);
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterableUntil, 10));
        IntIterator it = iterableUntil.iterator();
        while (it.hasNext()) {
            it.nextInt();
            arrayList.add(t);
        }
        Intrinsics.reifiedOperationMarker(0, "T?");
        return (T[]) arrayList.toArray(new Object[0]);
    }

    public static final ComposableMethod getDeclaredComposableMethod(Class<?> cls, String str, Class<?>... clsArr) throws NoSuchMethodException {
        Method declaredMethod;
        int iChangedParamCount = changedParamCount(clsArr.length, 0);
        try {
            SpreadBuilder spreadBuilder = new SpreadBuilder(3);
            spreadBuilder.addSpread(clsArr);
            spreadBuilder.add(Composer.class);
            Class cls2 = Integer.TYPE;
            Iterable iterableUntil = RangesKt.until(0, iChangedParamCount);
            ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterableUntil, 10));
            IntIterator it = iterableUntil.iterator();
            while (it.hasNext()) {
                it.nextInt();
                arrayList.add(cls2);
            }
            spreadBuilder.addSpread(arrayList.toArray(new Class[0]));
            declaredMethod = cls.getDeclaredMethod(str, (Class[]) spreadBuilder.toArray(new Class[spreadBuilder.size()]));
        } catch (ReflectiveOperationException unused) {
            int iDefaultParamCount = defaultParamCount(clsArr.length);
            try {
                SpreadBuilder spreadBuilder2 = new SpreadBuilder(4);
                spreadBuilder2.addSpread(clsArr);
                spreadBuilder2.add(Composer.class);
                Class cls3 = Integer.TYPE;
                Iterable iterableUntil2 = RangesKt.until(0, iChangedParamCount);
                ArrayList arrayList2 = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterableUntil2, 10));
                IntIterator it2 = iterableUntil2.iterator();
                while (it2.hasNext()) {
                    it2.nextInt();
                    arrayList2.add(cls3);
                }
                spreadBuilder2.addSpread(arrayList2.toArray(new Class[0]));
                Class cls4 = Integer.TYPE;
                Iterable iterableUntil3 = RangesKt.until(0, iDefaultParamCount);
                ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterableUntil3, 10));
                IntIterator it3 = iterableUntil3.iterator();
                while (it3.hasNext()) {
                    it3.nextInt();
                    arrayList3.add(cls4);
                }
                spreadBuilder2.addSpread(arrayList3.toArray(new Class[0]));
                declaredMethod = cls.getDeclaredMethod(str, (Class[]) spreadBuilder2.toArray(new Class[spreadBuilder2.size()]));
            } catch (ReflectiveOperationException unused2) {
                declaredMethod = null;
            }
        }
        if (declaredMethod == null) {
            throw new NoSuchMethodException(cls.getName() + '.' + str);
        }
        ComposableMethod composableMethodAsComposableMethod = asComposableMethod(declaredMethod);
        Intrinsics.checkNotNull(composableMethodAsComposableMethod);
        return composableMethodAsComposableMethod;
    }
}
