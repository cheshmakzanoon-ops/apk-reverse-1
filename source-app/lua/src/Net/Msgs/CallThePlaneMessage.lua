local CallThePlaneMessage = BaseClass("CallThePlaneMessage", SFSBaseMessage)
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
  elseif t.resourceExchangeInfo ~= nil then
    DataCenter.TradeCenterDataManager:UpdateData(t.resourceExchangeInfo)
  end
end

CallThePlaneMessage.OnCreate = OnCreate
CallThePlaneMessage.HandleMessage = HandleMessage
return CallThePlaneMessage
