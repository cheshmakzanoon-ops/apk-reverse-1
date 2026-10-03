local NickNameChangeMessage = BaseClass("NickNameChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, nickName)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("nickName", nickName)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  else
    if t.gold ~= nil then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    UIUtil.ShowTipsId(280032)
    if t.nickName ~= nil then
      DataCenter.PlayerInfoDataManager:ChangeSelfName(t.nickName)
      LuaEntry.Player:SetName(t.nickName)
    end
    if t.lastUpdateTime then
      LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
    end
    LuaEntry.Player.renameTime = LuaEntry.Player.renameTime + 1
    EventManager:GetInstance():Broadcast(EventId.NickNameChangeEvent)
    local uid = LuaEntry.Player.uid
    local userMgr = ChatManager2:GetInstance().User
    local userInfo = userMgr:getChatUserInfo(uid)
    userInfo.info_ok = false
    userMgr:requestSingleUserInfo(uid)
  end
end

NickNameChangeMessage.OnCreate = OnCreate
NickNameChangeMessage.HandleMessage = HandleMessage
return NickNameChangeMessage
