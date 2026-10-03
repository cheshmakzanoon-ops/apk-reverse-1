local LWBeginnerCityEventKillBossMessage = BaseClass("LWBeginnerCityEventKillBossMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bossIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("bossIndex", bossIndex - 1)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.CityEventFakePVPBattleDataGet, t)
end

LWBeginnerCityEventKillBossMessage.OnCreate = OnCreate
LWBeginnerCityEventKillBossMessage.HandleMessage = HandleMessage
return LWBeginnerCityEventKillBossMessage
