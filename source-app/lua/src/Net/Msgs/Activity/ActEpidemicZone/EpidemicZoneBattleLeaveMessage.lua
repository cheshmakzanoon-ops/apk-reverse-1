local EpidemicZoneBattleLeaveMessage = BaseClass("EpidemicZoneBattleLeaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleLeaveMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattleLeaveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleLeave(t)
end

return EpidemicZoneBattleLeaveMessage
