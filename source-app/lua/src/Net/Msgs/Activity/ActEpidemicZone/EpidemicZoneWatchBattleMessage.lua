local EpidemicZoneWatchBattleMessage = BaseClass("EpidemicZoneWatchBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneWatchBattleMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneWatchBattleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:OnHandleEnterBattleMessage(t, true)
end

return EpidemicZoneWatchBattleMessage
