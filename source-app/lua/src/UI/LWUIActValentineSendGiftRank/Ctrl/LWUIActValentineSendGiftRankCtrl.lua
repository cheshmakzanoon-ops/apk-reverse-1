local ValentineSendGiftRankCtrl = BaseClass("ValentineSendGiftRankCtrl", UIBaseCtrl)

function ValentineSendGiftRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineSendGiftRank)
end

return ValentineSendGiftRankCtrl
