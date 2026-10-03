local UIQueenOfBloodMonsterTipCtrl = BaseClass("UIQueenOfBloodMonsterTipCtrl", UIBaseCtrl)

function UIQueenOfBloodMonsterTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIQueenOfBloodMonsterTip)
end

return UIQueenOfBloodMonsterTipCtrl
