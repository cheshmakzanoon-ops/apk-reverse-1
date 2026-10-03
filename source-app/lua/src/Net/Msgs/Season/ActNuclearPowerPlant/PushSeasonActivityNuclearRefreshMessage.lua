local PushSeasonActivityNuclearRefreshMessage = BaseClass("PushSeasonActivityNuclearRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    local msg = ""
    if t.errorMsg then
      msg = t.errorMsg
    end
    return
  end
  DataCenter.SeasonNuclearPowerPlantDataManager:UpdateBuildStartTime(t)
end

PushSeasonActivityNuclearRefreshMessage.OnCreate = OnCreate
PushSeasonActivityNuclearRefreshMessage.HandleMessage = HandleMessage
return PushSeasonActivityNuclearRefreshMessage
