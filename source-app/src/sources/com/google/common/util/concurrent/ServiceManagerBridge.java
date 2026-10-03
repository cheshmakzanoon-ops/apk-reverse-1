package com.google.common.util.concurrent;

import com.google.common.collect.ImmutableMultimap;

@ElementTypesAreNonnullByDefault
interface ServiceManagerBridge {
    ImmutableMultimap<Service.State, Service> servicesByState();
}
