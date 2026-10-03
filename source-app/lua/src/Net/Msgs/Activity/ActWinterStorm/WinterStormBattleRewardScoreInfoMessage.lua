local WinterStormBattleRewardScoreInfoMessage = BaseClass("WinterStormBattleRewardScoreInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormBattleRewardScoreInfoMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormBattleRewardScoreInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormBattleTask, {anim = true}, t)
  end
end

return WinterStormBattleRewardScoreInfoMessage
