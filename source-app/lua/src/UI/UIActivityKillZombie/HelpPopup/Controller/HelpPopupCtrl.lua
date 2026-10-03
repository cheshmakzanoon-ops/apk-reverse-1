local UIActivityKillZombieHelpPopupCtrl = BaseClass("UIActivityKillZombieHelpPopupCtrl", UIBaseCtrl)

function UIActivityKillZombieHelpPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityKillZombieHelpPopup)
end

return UIActivityKillZombieHelpPopupCtrl
