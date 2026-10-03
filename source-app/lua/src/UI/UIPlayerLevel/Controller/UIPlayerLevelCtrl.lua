local UIPlayerLevelCtrl = BaseClass("UIPlayerLevelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerLevel)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

UIPlayerLevelCtrl.CloseSelf = CloseSelf
UIPlayerLevelCtrl.Close = Close
return UIPlayerLevelCtrl
