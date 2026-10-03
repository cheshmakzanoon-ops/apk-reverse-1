local FeiJiQiFeiMessage = BaseClass("FeiJiQiFeiMessage", SFSBaseMessage)
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

FeiJiQiFeiMessage.OnCreate = OnCreate
FeiJiQiFeiMessage.HandleMessage = HandleMessage
return FeiJiQiFeiMessage
