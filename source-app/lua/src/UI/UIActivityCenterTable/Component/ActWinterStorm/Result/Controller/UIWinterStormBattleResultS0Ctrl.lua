local UIWinterStormBattleResultS0Ctrl = BaseClass("UIWinterStormBattleResultS0Ctrl", UIBaseCtrl)

function UIWinterStormBattleResultS0Ctrl:SignClose()
  self.onceAgain = false
  self.signTime = UITimeManager:GetInstance():GetServerSeconds()
end

function UIWinterStormBattleResultS0Ctrl:BaseClose()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.signTime ~= nil and curTime - self.signTime < 3 then
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormBattleResultS0, {anim = false})
  DataCenter.ActWinterStormManager:ReqRewardInfo()
  if self.onceAgain then
    BattleFieldUtil.BackToCity(BattleFieldType.WinterStorm, function()
      DataCenter.ActWinterStormManager:SendMatch()
    end)
  else
    BattleFieldUtil.BackToCity(BattleFieldType.WinterStorm)
  end
end

function UIWinterStormBattleResultS0Ctrl:CloseSelf()
  self.onceAgain = false
  self:BaseClose()
end

function UIWinterStormBattleResultS0Ctrl:OnceAgain()
  local inBattleTime = DataCenter.ActWinterStormManager:CheckInBattleTime()
  if not inBattleTime then
    UIUtil.ShowTipsId("winter_battlefield_tips1037")
    return
  end
  self.onceAgain = true
  self:BaseClose()
end

function UIWinterStormBattleResultS0Ctrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIWinterStormBattleResultS0Ctrl
