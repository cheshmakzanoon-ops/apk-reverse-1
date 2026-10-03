local UIPlayerHeadIconSelectCtrl = BaseClass("UIPlayerHeadIconSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerHeadIconSelect)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPlayerHeadIconSelectCtrl.CloseSelf = CloseSelf
UIPlayerHeadIconSelectCtrl.Close = Close
return UIPlayerHeadIconSelectCtrl
