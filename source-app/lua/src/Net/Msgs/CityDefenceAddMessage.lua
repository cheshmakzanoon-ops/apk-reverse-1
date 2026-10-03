local CityDefenceAddMessage = BaseClass("CityDefenceAddMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
      UIUtil.ShowTipsId(300541)
    end
    DataCenter.DefenceWallDataManager:UpdateDefenceWallData(t)
    DataCenter.DefenceWallDataManager:UpdateColdDownTime(t)
  end
end

CityDefenceAddMessage.OnCreate = OnCreate
CityDefenceAddMessage.HandleMessage = HandleMessage
return CityDefenceAddMessage
