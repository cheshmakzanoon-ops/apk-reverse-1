local ActivityGetRankInfoMessage = BaseClass("ActivityGetRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, actId, startRanking, endRanking, stage)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", actId)
  if startRanking ~= nil and endRanking ~= nil then
    self.sfsObj:PutInt("start", startRanking)
    self.sfsObj:PutInt("end", endRanking)
  end
  if stage ~= nil then
    self.sfsObj:PutInt("stage", stage)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif not string.IsNullOrEmpty(t.activityId) then
    local actId = t.activityId
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
    if actData ~= nil then
      if actData.type == EnumActivity.StrongestCommander.Type then
        DataCenter.StrongestCommanderDataManager:ParseRankingData(t)
      elseif actData.type == EnumActivity.WorldBoss.Type then
        DataCenter.ActBossDataManager:ParseRankingData(t)
      elseif actData.type == EnumActivity.MonsterInvasion.Type then
        DataCenter.ActivityMonsterInvasionDataManager:ParseRankingData(t)
      elseif actData.type == EnumActivity.PersonalArmsNew.Type then
        DataCenter.ActivityPersonalArmsDataManager:ParseRankingData(t)
      elseif actData.type == EnumActivity.RevivalPlan.Type then
        DataCenter.RevivalPlanManager:ParseRankingData(t)
      end
    end
  end
end

ActivityGetRankInfoMessage.OnCreate = OnCreate
ActivityGetRankInfoMessage.HandleMessage = HandleMessage
return ActivityGetRankInfoMessage
