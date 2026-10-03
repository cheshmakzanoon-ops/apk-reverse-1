local IdleGameEventGetMessage = BaseClass("IdleGameEventGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventGetMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", param.playerUid)
  self.sfsObj:PutLong("eventUuid", param.eventUuid)
  self.sfsObj:PutInt("clientParam", param.type)
end

function IdleGameEventGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId("t11_idle_game_desc_84")
  else
    DataCenter.T11IdleGameDataManager:AddInvitePlayerInfoDict(t.idleGameEvent.uuid, t.helpUsers)
    DataCenter.T11IdleGameDataManager:CheckOpenTaskEventAllianceHelpView(t)
  end
end

return IdleGameEventGetMessage
