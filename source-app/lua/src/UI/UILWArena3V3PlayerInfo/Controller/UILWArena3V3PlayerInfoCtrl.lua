local UILWArena3V3PlayerInfoCtrl = BaseClass("UILWArena3V3PlayerInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArena3V3PlayerInfo)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UILWArena3V3PlayerInfoCtrl.CloseSelf = CloseSelf
UILWArena3V3PlayerInfoCtrl.Close = Close
return UILWArena3V3PlayerInfoCtrl
