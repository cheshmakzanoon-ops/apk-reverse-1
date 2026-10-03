local UITrainBattleRecordCtrl = BaseClass("UITrainBattleRecordCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainBattleRecord)
end

UITrainBattleRecordCtrl.CloseSelf = CloseSelf
return UITrainBattleRecordCtrl
