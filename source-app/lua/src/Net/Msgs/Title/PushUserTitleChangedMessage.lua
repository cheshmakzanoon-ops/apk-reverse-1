local PushUserTitleChangedMessage = BaseClass("PushUserTitleChangedMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserTitleChangedMessage:OnCreate()
  base.OnCreate(self)
end

function PushUserTitleChangedMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
  elseif t.title then
    local uid = LuaEntry.Player.uid
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid)
    if info ~= nil then
      DataCenter.PlayerInfoDataManager:ChangeSelfTitle(t.title)
      EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc, uid)
    end
    local userMgr = ChatManager2:GetInstance().User
    if userMgr then
      userMgr:ChangeUserTitle(uid, t.title)
    end
  end
end

return PushUserTitleChangedMessage
