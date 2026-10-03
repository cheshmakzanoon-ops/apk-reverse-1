package net.aihelp.core.p004ui.glide.load;

import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class MultiTransformation<T> implements Transformation<T> {

    private String f84id;
    private final Collection<? extends Transformation<T>> transformations;

    @SafeVarargs
    public MultiTransformation(Transformation<T>... transformationArr) {
        if (transformationArr.length < 1) {
            throw new IllegalArgumentException("MultiTransformation must contain at least one Transformation");
        }
        this.transformations = Arrays.asList(transformationArr);
    }

    public MultiTransformation(Collection<? extends Transformation<T>> collection) {
        if (collection.size() < 1) {
            throw new IllegalArgumentException("MultiTransformation must contain at least one Transformation");
        }
        this.transformations = collection;
    }

    @Override
    public Resource<T> transform(Resource<T> resource, int i, int i2) {
        Iterator<? extends Transformation<T>> it = this.transformations.iterator();
        Resource<T> resource2 = resource;
        while (it.hasNext()) {
            Resource<T> resourceTransform = it.next().transform(resource2, i, i2);
            if (resource2 != null && !resource2.equals(resource) && !resource2.equals(resourceTransform)) {
                resource2.recycle();
            }
            resource2 = resourceTransform;
        }
        return resource2;
    }

    @Override
    public String getId() {
        if (this.f84id == null) {
            StringBuilder sb = new StringBuilder();
            Iterator<? extends Transformation<T>> it = this.transformations.iterator();
            while (it.hasNext()) {
                sb.append(it.next().getId());
            }
            this.f84id = sb.toString();
        }
        return this.f84id;
    }
}
