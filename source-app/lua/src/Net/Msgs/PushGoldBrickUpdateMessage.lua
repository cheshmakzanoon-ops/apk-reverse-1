local PushGoldBrickUpdateMessage = BaseClass("PushGoldBrickUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GoldBrickDataManager:ParseData(t)
  end
end

PushGoldBrickUpdateMessage.OnCreate = OnCreate
PushGoldBrickUpdateMessage.HandleMessage = HandleMessage
return PushGoldBrickUpdateMessage
