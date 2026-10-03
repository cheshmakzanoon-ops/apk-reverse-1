local PushAllianceJoinWelcomeMsgThumbsUpMessage = BaseClass("PushAllianceJoinWelcomeMsgThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceJoinWelcomeMsgThumbsUpMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceJoinWelcomeMsgThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local infos = DataCenter.AllianceMemberDataManager:GetNewJoinMembersInfo()
    local info = infos[tostring(t.uid)]
    if info then
      info.thumbsUpCount = info.thumbsUpCount + 1
      local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid, true)
      if info.uid == LuaEntry.Player.uid and player then
        player.joinAllianceThumbsUpCount = player.joinAllianceThumbsUpCount + 1
      end
    end
    EventManager:GetInstance():Broadcast(EventId.CHAT_HIGH_FIVE_RECEIVE, t)
  end
end

return PushAllianceJoinWelcomeMsgThumbsUpMessage
