local GetAllianceAutoInviteInfoMessage = BaseClass("GetAllianceAutoInviteInfoMessage", SFSBaseMessage)
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
    DataCenter.AllianceAutoInviteManager:UpdateAutoInviteList(t)
  end
end

GetAllianceAutoInviteInfoMessage.OnCreate = OnCreate
GetAllianceAutoInviteInfoMessage.HandleMessage = HandleMessage
return GetAllianceAutoInviteInfoMessage
