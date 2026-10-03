local UITCChoiceBoxRewardGetCtrl = BaseClass("UITCChoiceBoxRewardGetCtrl", UIBaseCtrl)

function UITCChoiceBoxRewardGetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCChoiceBoxRewardGet)
end

return UITCChoiceBoxRewardGetCtrl
