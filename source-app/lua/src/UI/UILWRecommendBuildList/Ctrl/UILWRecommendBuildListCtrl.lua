local UILWRecommendBuildListCtrl = BaseClass("UILWRecommendBuildListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWRecommendBuildList)
end

UILWRecommendBuildListCtrl.CloseSelf = CloseSelf
return UILWRecommendBuildListCtrl
