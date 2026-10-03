local DispatchTreasurePushExchangeMessage = BaseClass("DispatchTreasurePushExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.SplinterExchangeManager:SetShowExchangeRedPoint(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasurePushExchangeMessage.OnCreate = OnCreate
DispatchTreasurePushExchangeMessage.HandleMessage = HandleMessage
return DispatchTreasurePushExchangeMessage
