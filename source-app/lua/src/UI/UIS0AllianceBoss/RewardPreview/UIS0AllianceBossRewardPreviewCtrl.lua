local UIS0AllianceBossRewardPreviewCtrl = BaseClass("UIS0AllianceBossRewardPreviewCtrl", UIBaseCtrl)

function UIS0AllianceBossRewardPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIS0AllianceBossRewardPreview)
end

return UIS0AllianceBossRewardPreviewCtrl
