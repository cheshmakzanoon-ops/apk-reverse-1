local PushAllianceCityEffectMessage = BaseClass("PushAllianceCityEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushAllianceCityEffectMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceCityEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode then
    UIUtil.ShowTipsId(errCode)
  elseif t.effect ~= nil then
    local theEffectType = t.type
    if theEffectType ~= nil then
      if theEffectType == 1 then
        DataCenter.WorldAllianceCityDataManager:UpdateAllianceCityEffect(t, false)
      elseif theEffectType == 2 then
        DataCenter.WorldAllianceCityDataManager:UpdateAllianceCityEffect(t, true)
      else
        if theEffectType == 3 then
          DataCenter.WorldAllianceCityDataManager:UpdateAllianceCityEffect(t, false, true)
        else
        end
      end
    else
      DataCenter.WorldAllianceCityDataManager:UpdateAllianceCityEffect(t, false)
    end
  end
end

return PushAllianceCityEffectMessage
