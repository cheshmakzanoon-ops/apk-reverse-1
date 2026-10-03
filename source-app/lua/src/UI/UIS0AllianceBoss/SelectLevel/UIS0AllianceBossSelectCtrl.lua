local UIS0AllianceBossSelectCtrl = BaseClass("UIS0AllianceBossSelectCtrl", UIBaseCtrl)

function UIS0AllianceBossSelectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIS0AllianceBossSelect)
end

return UIS0AllianceBossSelectCtrl
