local UIActDropPopupPanelCtrl = BaseClass("UIActDropPopupPanelCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActDropPopupPanel, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIActDropPopupPanelCtrl.CloseSelf = CloseSelf
UIActDropPopupPanelCtrl.Close = Close
return UIActDropPopupPanelCtrl
