local UIHeroDecomposeCtrl = BaseClass("UIHeroDecomposeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDecompose)
end

local function GetPanelData(self)
end

UIHeroDecomposeCtrl.CloseSelf = CloseSelf
UIHeroDecomposeCtrl.GetPanelData = GetPanelData
return UIHeroDecomposeCtrl
