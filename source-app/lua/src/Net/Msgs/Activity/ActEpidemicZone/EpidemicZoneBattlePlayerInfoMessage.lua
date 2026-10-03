local EpidemicZoneBattlePlayerInfoMessage = BaseClass("EpidemicZoneBattlePlayerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattlePlayerInfoMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattlePlayerInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattlePlayerInfo(t)
end

return EpidemicZoneBattlePlayerInfoMessage
