local WorldGetAllianceCityEffectMessage = BaseClass("WorldGetAllianceCityEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:UpdateAllianceCityEffect(t, true)
  end
end

WorldGetAllianceCityEffectMessage.HandleMessage = HandleMessage
WorldGetAllianceCityEffectMessage.OnCreate = OnCreate
return WorldGetAllianceCityEffectMessage
