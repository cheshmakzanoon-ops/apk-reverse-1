local UIS0AllianceBossBuildCtrl = BaseClass("UIS0AllianceBossBuildCtrl", UIBaseCtrl)

function UIS0AllianceBossBuildCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIS0AllianceBossBuild)
end

return UIS0AllianceBossBuildCtrl
