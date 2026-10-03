package org.chromium.support_lib_boundary;

import java.util.Map;

public interface PrefetchParamsBoundaryInterface {
    Map<String, String> getAdditionalHeaders();

    String getNoVarySearchHint();
}
