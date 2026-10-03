package retrofit2;

import cn.thinkingdata.android.j$;
import java.lang.invoke.MethodHandles;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import javax.annotation.Nullable;

final class DefaultMethodSupport {

    @Nullable
    private static Constructor<MethodHandles.Lookup> lookupConstructor;

    @Nullable
    static Object invoke(Method method, Class<?> cls, Object obj, @Nullable Object[] objArr) throws Throwable {
        Constructor<MethodHandles.Lookup> declaredConstructor = lookupConstructor;
        if (declaredConstructor == null) {
            declaredConstructor = j$.ExternalSyntheticApiModelOutline0.m().getDeclaredConstructor(Class.class, Integer.TYPE);
            declaredConstructor.setAccessible(true);
            lookupConstructor = declaredConstructor;
        }
        return j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(declaredConstructor.newInstance(cls, -1)), method, cls), obj), objArr);
    }

    private DefaultMethodSupport() {
    }
}
