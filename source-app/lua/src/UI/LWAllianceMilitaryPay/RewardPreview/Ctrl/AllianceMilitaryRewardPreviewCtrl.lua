local AllianceMilitaryRewardPreviewCtrl = BaseClass("AllianceMilitaryRewardPreviewCtrl", UIBaseCtrl)

function AllianceMilitaryRewardPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AllianceMilitaryRewardPreviewView)
end

return AllianceMilitaryRewardPreviewCtrl
