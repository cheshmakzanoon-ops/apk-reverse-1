local AcceptAllianceAutoInviteMessage = BaseClass("AcceptAllianceAutoInviteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceAutoInviteManager:ClearAllInvite()
  end
end

AcceptAllianceAutoInviteMessage.OnCreate = OnCreate
AcceptAllianceAutoInviteMessage.HandleMessage = HandleMessage
return AcceptAllianceAutoInviteMessage
