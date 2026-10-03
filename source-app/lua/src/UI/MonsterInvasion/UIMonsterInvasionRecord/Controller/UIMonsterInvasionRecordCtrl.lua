local UIMonsterInvasionRecordCtrl = BaseClass("UIMonsterInvasionRecordCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIMonsterInvasionRecord)
end

UIMonsterInvasionRecordCtrl.CloseSelf = CloseSelf
return UIMonsterInvasionRecordCtrl
