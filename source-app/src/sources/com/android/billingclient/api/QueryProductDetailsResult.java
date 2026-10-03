package com.android.billingclient.api;

import java.util.List;

public final class QueryProductDetailsResult {
    private final List<ProductDetails> productDetailsList;
    private final List<UnfetchedProduct> unfetchedProductList;

    QueryProductDetailsResult(List<ProductDetails> list, List<UnfetchedProduct> list2) {
        this.productDetailsList = list;
        this.unfetchedProductList = list2;
    }

    public static QueryProductDetailsResult create(List<ProductDetails> list, List<UnfetchedProduct> list2) {
        return new QueryProductDetailsResult(list, list2);
    }

    public List<ProductDetails> getProductDetailsList() {
        return this.productDetailsList;
    }

    public List<UnfetchedProduct> getUnfetchedProductList() {
        return this.unfetchedProductList;
    }
}
