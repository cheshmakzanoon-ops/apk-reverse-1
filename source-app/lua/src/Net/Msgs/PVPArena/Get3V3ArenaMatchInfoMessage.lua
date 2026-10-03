local Get3V3ArenaMatchInfoMessage = BaseClass("Get3V3ArenaMatchInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.Arena3V3GetMessageError)
  else
    DataCenter.LW3V3Manager:ParseWeaponInfo(t.otherInfo)
    DataCenter.LW3V3ArenaManager:ParseOpponentData(t)
  end
end

Get3V3ArenaMatchInfoMessage.OnCreate = OnCreate
Get3V3ArenaMatchInfoMessage.HandleMessage = HandleMessage
return Get3V3ArenaMatchInfoMessage
