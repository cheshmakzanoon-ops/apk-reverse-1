local LWUIGoldTreeHelpCtrl = BaseClass("LWUIGoldTreeHelpCtrl", UIBaseCtrl)

function LWUIGoldTreeHelpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGoldTreeHelp)
end

return LWUIGoldTreeHelpCtrl
