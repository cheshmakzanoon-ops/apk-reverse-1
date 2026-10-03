local UserSettingMessage = BaseClass("UserSettingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, value)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("value", value)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    LuaEntry.Player:SetUserSetting(t.type, t.value)
    if t.type == UserSettingKey.SeasonResourceSetting and t.value then
      DataCenter.SeasonResourceDownloadManager:ParseMsg(t.value)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonResourceDownloadIndexSync)
    end
    if t.type == UserSettingKey.ALLIANCE_RALLY_HIDE_TEXT and t.value then
      EventManager:GetInstance():Broadcast(EventId.UpdateSelfAllianceRallyPointBubble)
    end
    if t.type == UserSettingKey.REFUSE_POWER_HELPER or t.type == UserSettingKey.EliminateVirus then
      UIUtil.ShowTipsId(120094)
    end
  end
end

UserSettingMessage.OnCreate = OnCreate
UserSettingMessage.HandleMessage = HandleMessage
return UserSettingMessage
