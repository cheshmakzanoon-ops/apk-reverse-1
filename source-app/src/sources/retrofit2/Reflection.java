package retrofit2;

import android.os.Build;
import androidx.compose.ui.graphics.Api26Bitmap$;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import javax.annotation.Nullable;

class Reflection {
    boolean isDefaultMethod(Method method) {
        return false;
    }

    Reflection() {
    }

    @Nullable
    Object invokeDefaultMethod(Method method, Class<?> cls, Object obj, @Nullable Object[] objArr) throws Throwable {
        throw new AssertionError();
    }

    String describeMethodParameter(Method method, int i) {
        return "parameter #" + (i + 1);
    }

    static class Java8 extends Reflection {
        Java8() {
        }

        @Override
        boolean isDefaultMethod(Method method) {
            return method.isDefault();
        }

        @Override
        Object invokeDefaultMethod(Method method, Class<?> cls, Object obj, @Nullable Object[] objArr) throws Throwable {
            return DefaultMethodSupport.invoke(method, cls, obj, objArr);
        }

        @Override
        String describeMethodParameter(Method method, int i) {
            Parameter parameter = Api26Bitmap$.ExternalSyntheticApiModelOutline0.m(method)[i];
            if (parameter.isNamePresent()) {
                return "parameter '" + parameter.getName() + '\'';
            }
            return super.describeMethodParameter(method, i);
        }
    }

    static final class Android24 extends Reflection {
        Android24() {
        }

        @Override
        boolean isDefaultMethod(Method method) {
            return method.isDefault();
        }

        @Override
        Object invokeDefaultMethod(Method method, Class<?> cls, Object obj, @Nullable Object[] objArr) throws Throwable {
            if (Build.VERSION.SDK_INT < 26) {
                throw new UnsupportedOperationException("Calling default methods on API 24 and 25 is not supported");
            }
            return DefaultMethodSupport.invoke(method, cls, obj, objArr);
        }
    }
}
