package net.aihelp.core.p004ui.glide.load;

import net.aihelp.core.p004ui.glide.load.engine.Resource;

public interface Transformation<T> {
    String getId();

    Resource<T> transform(Resource<T> resource, int i, int i2);
}
