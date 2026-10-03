local EpidemicZoneBattleFreeSpeedMarchInfoMessage = BaseClass("EpidemicZoneBattleFreeSpeedMarchInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleFreeSpeedMarchInfoMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattleFreeSpeedMarchInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleFreeSpeedInfo(t)
end

return EpidemicZoneBattleFreeSpeedMarchInfoMessage
