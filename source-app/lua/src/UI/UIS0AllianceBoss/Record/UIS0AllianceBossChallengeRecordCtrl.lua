local UIS0AllianceBossChallengeRecordCtrl = BaseClass("UIS0AllianceBossChallengeRecordCtrl", UIBaseCtrl)

function UIS0AllianceBossChallengeRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIS0AllianceBossChallengeRecord)
end

return UIS0AllianceBossChallengeRecordCtrl
