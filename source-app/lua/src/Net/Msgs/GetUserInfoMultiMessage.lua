local GetUserInfoMultiMessage = BaseClass("GetUserInfoMultiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uids)
  base.OnCreate(self)
  self.sfsObj:PutLuaArray("uids", uids)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if not t or table.IsNullOrEmpty(t.uids) then
    return
  end
  local userMgr = ChatManager2:GetInstance().User
  local selfUid = LuaEntry.Player:GetUid()
  local playerMgr = DataCenter.PlayerInfoDataManager
  local playerPowerMgr = DataCenter.PlayerPowerDataManager
  local lwDevMgr = DataCenter.LWDevelopRecommendManager
  for i, v in ipairs(t.uids) do
    playerMgr:RefreshPlayerData(v)
    if v.uid == selfUid then
      playerPowerMgr:RefreshPowerData(v)
      lwDevMgr:UpdatePowerRate(v)
      playerMgr:OnReceiveNewUserInfo(v.uid)
    end
    EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc, v.uid)
    userMgr:ChangeUserInfo(v)
  end
  EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoMultiSucc)
end

GetUserInfoMultiMessage.OnCreate = OnCreate
GetUserInfoMultiMessage.HandleMessage = HandleMessage
return GetUserInfoMultiMessage
