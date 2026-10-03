local WorldFavoGetMessage = BaseClass("WorldFavoGetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, serverId, worldId)
  base.OnCreate(self)
  self.sfsObj:PutInt("server", tonumber(serverId))
  if worldId == nil then
    self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  else
    self.sfsObj:PutInt("worldId", tonumber(worldId))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(280154)
  else
    DataCenter.WorldFavoDataManager:InitBookmarkDict(t)
  end
end

WorldFavoGetMessage.OnCreate = OnCreate
WorldFavoGetMessage.HandleMessage = HandleMessage
return WorldFavoGetMessage
