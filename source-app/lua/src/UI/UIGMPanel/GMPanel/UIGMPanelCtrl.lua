local UIGMPanelCtrl = BaseClass("UIGMPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
end

function UIGMPanelCtrl:GetPages()
  return GMUtils.GetPages()
end

UIGMPanelCtrl.CloseSelf = CloseSelf
return UIGMPanelCtrl
