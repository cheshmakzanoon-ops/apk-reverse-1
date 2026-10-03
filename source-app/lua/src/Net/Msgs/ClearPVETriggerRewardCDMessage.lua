local ClearPVETriggerRewardCDMessage = BaseClass("ClearPVETriggerRewardCDMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ClearPVETriggerRewardCDMessage:OnCreate(param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("level", param.level)
    self.sfsObj:PutInt("trigger", param.trigger)
  end
end

function ClearPVETriggerRewardCDMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    if t.errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
    return
  end
  local battleLevel = DataCenter.BattleLevel
  if battleLevel then
    battleLevel:OnClearPVETriggerRewardCDHandler(t)
  end
end

return ClearPVETriggerRewardCDMessage
