local TacticalChipExchangeMessage = BaseClass("TacticalChipExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, mainUuid, exchangeUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("mainUuid", mainUuid)
  self.sfsObj:PutLong("exchangeUuid", exchangeUuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

TacticalChipExchangeMessage.OnCreate = OnCreate
TacticalChipExchangeMessage.HandleMessage = HandleMessage
return TacticalChipExchangeMessage
