local UIActGiftGivingDropPanelCtrl = BaseClass("UIActGiftGivingDropPanelCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIActGiftGivingDropPanelCtrl.CloseSelf = CloseSelf
UIActGiftGivingDropPanelCtrl.Close = Close
return UIActGiftGivingDropPanelCtrl
