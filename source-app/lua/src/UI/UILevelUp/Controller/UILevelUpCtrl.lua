local UILevelUp = BaseClass("UILevelUp", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILevelUp)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UILevelUp.CloseSelf = CloseSelf
UILevelUp.Close = Close
return UILevelUp
