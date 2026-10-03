local AlAutoMarchCDMessage = BaseClass("AlAutoMarchCDMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SiegeDataManager:SetAllOutReadyTS(t)
  end
end

AlAutoMarchCDMessage.OnCreate = OnCreate
AlAutoMarchCDMessage.HandleMessage = HandleMessage
return AlAutoMarchCDMessage
