package net.aihelp.core.util.permission;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface Permission {
    public static final int REQUEST_CODE_CUSTOMER_SERVICE = 1000;
    public static final int REQUEST_CODE_FORM = 1001;

    public enum Result {
        GRANTED,
        DENIED,
        RATIONAL,
        GO_SETTING,
        NONE,
        CANCELED
    }

    public enum State {
        AVAILABLE,
        UNAVAILABLE,
        ASKABLE,
        RATIONAL
    }

    int requestCode() default 0;
}
