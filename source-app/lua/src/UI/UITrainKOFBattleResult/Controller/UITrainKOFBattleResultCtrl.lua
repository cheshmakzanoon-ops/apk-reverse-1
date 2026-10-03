local UITrainKOFBattleResultCtrl = BaseClass("UITrainKOFBattleResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainKOFBattleResult)
end

UITrainKOFBattleResultCtrl.CloseSelf = CloseSelf
return UITrainKOFBattleResultCtrl
