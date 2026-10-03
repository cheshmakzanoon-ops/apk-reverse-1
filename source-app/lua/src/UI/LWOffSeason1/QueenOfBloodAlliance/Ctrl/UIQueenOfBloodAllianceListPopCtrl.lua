local UIQueenOfBloodAllianceListPopCtrl = BaseClass("UIQueenOfBloodAllianceListPopCtrl", UIBaseCtrl)

function UIQueenOfBloodAllianceListPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIQueenOfBloodAllianceListPop)
end

return UIQueenOfBloodAllianceListPopCtrl
