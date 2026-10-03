local UIBFDsbDuelActGetFinalRewardCtrl = BaseClass("UIBFDsbDuelActGetFinalRewardCtrl", UIBaseCtrl)

function UIBFDsbDuelActGetFinalRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActGetFinalReward)
end

return UIBFDsbDuelActGetFinalRewardCtrl
