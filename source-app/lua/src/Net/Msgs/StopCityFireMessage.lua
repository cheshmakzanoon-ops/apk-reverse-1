local StopCityFireMessage = BaseClass("StopCityFireMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    LuaEntry.Effect:RemoveStatus(CityState.RuinedCity)
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
  else
    UIUtil.ShowTipsId(errCode)
  end
end

StopCityFireMessage.OnCreate = OnCreate
StopCityFireMessage.HandleMessage = HandleMessage
return StopCityFireMessage
