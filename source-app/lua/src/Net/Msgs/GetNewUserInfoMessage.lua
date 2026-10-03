local GetNewUserInfoMessage = BaseClass("GetNewUserInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, fetchProfileHint)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  if type(fetchProfileHint) == "boolean" and fetchProfileHint then
    self.sfsObj:PutUtfString("profile_hint", "1")
  elseif type(fetchProfileHint) == "string" then
    self.sfsObj:PutUtfString("profile_hint", fetchProfileHint)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.uid ~= nil and t.uid ~= "" then
    DataCenter.PlayerInfoDataManager:RefreshPlayerData(t)
    if t.uid == LuaEntry.Player:GetUid() then
      DataCenter.PlayerPowerDataManager:RefreshPowerData(t)
      DataCenter.LWDevelopRecommendManager:UpdatePowerRate(t)
      DataCenter.PlayerInfoDataManager:OnReceiveNewUserInfo(t.uid)
    end
    EventManager:GetInstance():Broadcast(EventId.GetNewUserInfoSucc, t.uid)
    local userMgr = ChatManager2:GetInstance().User
    userMgr:ChangeUserInfo(t)
  end
end

GetNewUserInfoMessage.OnCreate = OnCreate
GetNewUserInfoMessage.HandleMessage = HandleMessage
return GetNewUserInfoMessage
