local GenderChangeMessage = BaseClass("GenderChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, gender, skipCheck)
  base.OnCreate(self)
  self.sfsObj:PutInt("gender", gender)
  if skipCheck then
    self.sfsObj:PutBool("skipCheck", skipCheck)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  local leftTime = t.errorPara2
  if errCode ~= nil then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(tonumber(leftTime[1]))
    UIUtil.ShowTips(Localization:GetString(errCode, delta))
  else
    if t.gold ~= nil then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    UIUtil.ShowTipsId(110277)
    if t.gender ~= nil then
      DataCenter.PlayerInfoDataManager:ChangeSelfGender(t.gender)
      LuaEntry.Player:SetGender(t.gender)
    end
    LuaEntry.Player.chGenderTime = LuaEntry.Player.chGenderTime + 1
    EventManager:GetInstance():Broadcast(EventId.GenderChangeEvent)
    ChatManager2:GetInstance().User:__onReceiveUserGender(LuaEntry.Player.uid, LuaEntry.Player.gender)
    local uid = LuaEntry.Player.uid
    local userMgr = ChatManager2:GetInstance().User
    local userInfo = userMgr:getChatUserInfo(uid)
    userInfo.info_ok = false
    userMgr:requestSingleUserInfo(uid)
  end
end

GenderChangeMessage.OnCreate = OnCreate
GenderChangeMessage.HandleMessage = HandleMessage
return GenderChangeMessage
