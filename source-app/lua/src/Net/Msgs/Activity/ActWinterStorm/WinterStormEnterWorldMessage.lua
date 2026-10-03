local WinterStormEnterWorldMessage = BaseClass("WinterStormEnterWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormEnterWorldMessage:OnCreate()
  base.OnCreate(self)
end

function WinterStormEnterWorldMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "winter_battlefield_interface_tips1075" then
      DataCenter.ActWinterStormManager:SendResult()
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  DataCenter.ActWinterStormManager:OnHandleEnterBattleMessage(t)
end

return WinterStormEnterWorldMessage
