local UIScratchOffRecordPageCtrl = BaseClass("UIScratchOffRecordPageCtrl", UIBaseCtrl)

function UIScratchOffRecordPageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ScratchOffRewardDetailPage)
end

return UIScratchOffRecordPageCtrl
