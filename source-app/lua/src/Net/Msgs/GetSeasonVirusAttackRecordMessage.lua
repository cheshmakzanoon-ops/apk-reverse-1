local GetSeasonVirusAttackRecordMessage = BaseClass("GetSeasonVirusAttackRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.LWSeasonBossLoginDataManager:ParseBossBattleReportData(t)
  end
end

GetSeasonVirusAttackRecordMessage.HandleMessage = HandleMessage
return GetSeasonVirusAttackRecordMessage
