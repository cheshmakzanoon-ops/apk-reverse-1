local UILWDominatorPropertyDetail = {
  Name = UIWindowNames.UILWDominatorPropertyDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWDominator/PropertyDetail/Controller/UILWDominatorPropertyDetailCtrl"),
  View = require("UI/UILWDominator/PropertyDetail/View/UILWDominatorPropertyDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorPropertyDetail.prefab"
}
return {UILWDominatorPropertyDetail = UILWDominatorPropertyDetail}
