local AllianceMemberEnvTempInfoMessage = BaseClass("AllianceMemberEnvTempInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonSnowStormDataManager:UpdateAllianceMemberTemp(t)
end

AllianceMemberEnvTempInfoMessage.OnCreate = OnCreate
AllianceMemberEnvTempInfoMessage.HandleMessage = HandleMessage
return AllianceMemberEnvTempInfoMessage
