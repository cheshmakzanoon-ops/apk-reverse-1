package net.aihelp.core.p004ui.glide.load.resource;

import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class UnitTransformation<T> implements Transformation<T> {
    private static final Transformation<?> TRANSFORMATION = new UnitTransformation();

    @Override
    public Resource<T> transform(Resource<T> resource, int i, int i2) {
        return resource;
    }

    public static <T> UnitTransformation<T> get() {
        return (UnitTransformation) TRANSFORMATION;
    }

    @Override
    public String getId() {
        return "";
    }
}
