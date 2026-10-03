local AllMainBuildEnvTmpInfoMessage = BaseClass("AllMainBuildEnvTmpInfoMessage", SFSBaseMessage)
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
  DataCenter.SeasonSnowStormDataManager:UpdateAllMainBuildTemp(t)
end

AllMainBuildEnvTmpInfoMessage.OnCreate = OnCreate
AllMainBuildEnvTmpInfoMessage.HandleMessage = HandleMessage
return AllMainBuildEnvTmpInfoMessage
