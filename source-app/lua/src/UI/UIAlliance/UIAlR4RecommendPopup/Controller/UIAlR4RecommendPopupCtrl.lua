local UIAlR4RecommendPopupCtrl = BaseClass("UIAlR4RecommendPopupCtrl", UIBaseCtrl)

function UIAlR4RecommendPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlR4RecommendPopup)
end

return UIAlR4RecommendPopupCtrl
