package zendesk.guidekit.android.internal.data;

import dagger.internal.Factory;

public final class BrandsInMemoryDataSource_Factory implements Factory<BrandsInMemoryDataSource> {
    @Override
    public BrandsInMemoryDataSource get() {
        return newInstance();
    }

    public static BrandsInMemoryDataSource_Factory create() {
        return InstanceHolder.INSTANCE;
    }

    public static BrandsInMemoryDataSource newInstance() {
        return new BrandsInMemoryDataSource();
    }

    private static final class InstanceHolder {
        private static final BrandsInMemoryDataSource_Factory INSTANCE = new BrandsInMemoryDataSource_Factory();

        private InstanceHolder() {
        }
    }
}
