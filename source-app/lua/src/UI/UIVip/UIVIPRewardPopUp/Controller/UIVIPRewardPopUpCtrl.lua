local UIVIPRewardPopUpCtrl = BaseClass("UIVIPRewardPopUpCtrl", UIBaseCtrl)

function UIVIPRewardPopUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVIPRewardPopUp)
end

function UIVIPRewardPopUpCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UIVIPRewardPopUpCtrl
