local UIS0AllianceBossBuildRecordCtrl = BaseClass("UIS0AllianceBossBuildRecordCtrl", UIBaseCtrl)

function UIS0AllianceBossBuildRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIS0AllianceBossBuildRecord)
end

return UIS0AllianceBossBuildRecordCtrl
