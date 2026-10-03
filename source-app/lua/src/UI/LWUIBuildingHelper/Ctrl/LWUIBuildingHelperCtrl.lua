local LWUIBuildingHelperCtrl = BaseClass("LWUIBuildingHelperCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIBuildingHelperView)
end

LWUIBuildingHelperCtrl.CloseSelf = CloseSelf
return LWUIBuildingHelperCtrl
