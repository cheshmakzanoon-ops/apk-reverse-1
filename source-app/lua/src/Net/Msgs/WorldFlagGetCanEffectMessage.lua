local WorldFlagGetCanEffectMessage = BaseClass("WorldFlagGetCanEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WarFlagDataManager:HandleFlagAboutMe(t)
  end
end

WorldFlagGetCanEffectMessage.OnCreate = OnCreate
WorldFlagGetCanEffectMessage.HandleMessage = HandleMessage
return WorldFlagGetCanEffectMessage
