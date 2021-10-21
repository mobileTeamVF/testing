//
//  ConfiguratorAlias.swift
//  TCL
//
//  Created by Mirza Ahmer Baig on 06/07/2018.
//  Copyright © 2018 Mirza Ahmer Baig. All rights reserved.
//

import UIKit

typealias categoriesCarouselCellConfigurator = CollectionCellConfigurator<CategoriesCarouselCell, CategoryModel>
typealias featuredProductsCarouselCellConfigurator = CollectionCellConfigurator<FeaturedProductsCarouselCell, ProductModel>
typealias imagePreviewCellConfigurator = CollectionCellConfigurator<ImagePreviewCVCell, String>

typealias productCollectionViewCellConfigurator = CollectionCellConfigurator<ProductCollectionViewCell, ProductModel>
typealias featuresDisplayCellConfigurator = CollectionCellConfigurator<FeaturesDisplayCell, String>
typealias featuresCollectionViewCellConfigurator = CollectionCellConfigurator<FeaturesCollectionViewCell, [String: String]>


//MARK: - TableView Cell Configurators
typealias cartQuantityTableViewCellConfigurator = TableCellConfigurator<CartQuantityTableViewCell, CartItem>
typealias technicalDescriptionCellConfigurator = TableCellConfigurator<TechnicalDescriptionCell, Dictionary<String, String>>
typealias tagsTableViewCellConfigurator = TableCellConfigurator<TagsTableViewCell, [[String: String]]>
typealias productDetailsInfoTableViewCellConfigurator = TableCellConfigurator<ProductDetailsInfoTableViewCell, ProductModel>
typealias productSlideShowTableViewCellConfigurator = TableCellConfigurator<ProductSlideShowTableViewCell, ProductModel>
typealias radioViewTableViewCellConfigurator = TableCellConfigurator<RadioViewTableViewCell, Int>
typealias productDetailTabCellConfigurator = TableCellConfigurator<ProductDetailTabCell, Int>
typealias addProductReviewCellConfigurator = TableCellConfigurator<AddProductReviewCell, String>
typealias productReviewCellConfigurator = TableCellConfigurator<ProductReviewTableViewCell, Dictionary<String, String>>
typealias productNoReviewCellConfigurator = TableCellConfigurator<ProductNoReviewTableViewCell, String>
typealias moreOptionsCellConfigurator = TableCellConfigurator<MoreOptionsTableViewCell, WebPageModel>
typealias authorizedDealerCardViewCellConfigurator = TableCellConfigurator<AuthorizedDealerCardViewCell, FlagshipStore>

