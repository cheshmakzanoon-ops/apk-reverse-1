local UserGiveUpDesertMessage = BaseClass("UserGiveUpDesertMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  elseif t and t.uid and LuaEntry.Player.uid == t.uid then
    local uuid = t.uuid
    UIUtil.ShowTips(Localization:GetString("season_tips192"))
    DataCenter.DesertDataManager:UpdateOneDesertData(t)
    if uuid ~= nil then
      EventManager:GetInstance():Broadcast(EventId.UserDismissDesert, uuid)
      WorldDesertEffectManager:GetInstance():CheckShowDesert(uuid)
    end
  end
end

UserGiveUpDesertMessage.OnCreate = OnCreate
UserGiveUpDesertMessage.HandleMessage = HandleMessage
return UserGiveUpDesertMessage
