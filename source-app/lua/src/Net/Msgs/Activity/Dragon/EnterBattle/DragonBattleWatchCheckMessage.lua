local DragonBattleWatchCheckMessage = BaseClass("DragonBattleWatchCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DragonBattleWatchCheckMessage:OnCreate(targetServerId, worldId, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServerId", targetServerId)
  self.sfsObj:PutInt("worldId", worldId)
  self.sfsObj:PutInt("group", group)
end

function DragonBattleWatchCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDragonManager:OnHandleEnterBattleMessage(t, true)
end

return DragonBattleWatchCheckMessage
