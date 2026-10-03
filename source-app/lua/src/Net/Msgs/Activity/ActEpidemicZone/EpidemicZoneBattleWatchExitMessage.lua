local EpidemicZoneBattleWatchExitMessage = BaseClass("EpidemicZoneBattleWatchExitMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneBattleWatchExitMessage:OnCreate(group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

function EpidemicZoneBattleWatchExitMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return EpidemicZoneBattleWatchExitMessage
