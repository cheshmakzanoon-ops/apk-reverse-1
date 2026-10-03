local SeasonCallbackPvpReduceNumQueryMessage = BaseClass("SeasonCallbackPvpReduceNumQueryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonCallbackPvpReduceNumQueryMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonCallbackPvpReduceNumQueryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local pvpReduceNum = t.pvpReduceNum
  DataCenter.SeasonCallbackManager:SetCallbackData(SeasonCallbackSpecialEffect.PvpSoldierDeathReduce, pvpReduceNum)
end

return SeasonCallbackPvpReduceNumQueryMessage
