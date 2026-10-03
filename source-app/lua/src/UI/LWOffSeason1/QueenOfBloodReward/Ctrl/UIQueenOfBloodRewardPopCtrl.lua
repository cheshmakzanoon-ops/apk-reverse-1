local UIQueenOfBloodRewardPopCtrl = BaseClass("UIQueenOfBloodRewardPopCtrl", UIBaseCtrl)

function UIQueenOfBloodRewardPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIQueenOfBloodRewardPop)
end

return UIQueenOfBloodRewardPopCtrl
