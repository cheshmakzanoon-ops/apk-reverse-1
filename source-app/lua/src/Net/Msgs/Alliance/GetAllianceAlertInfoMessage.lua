local GetAllianceAlertInfoMessage = BaseClass("GetAllianceAlertInfoMessage", SFSBaseMessage)
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
  elseif t.infos then
    DataCenter.AllianceAlertDataManager:InitAllianceAlertList(t.infos)
  end
end

GetAllianceAlertInfoMessage.OnCreate = OnCreate
GetAllianceAlertInfoMessage.HandleMessage = HandleMessage
return GetAllianceAlertInfoMessage
