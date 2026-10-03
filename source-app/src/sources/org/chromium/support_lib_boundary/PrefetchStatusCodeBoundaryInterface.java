package org.chromium.support_lib_boundary;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.SOURCE)
public @interface PrefetchStatusCodeBoundaryInterface {
    public static final int FAILURE = 1;
    public static final int SUCCESS = 0;
}
