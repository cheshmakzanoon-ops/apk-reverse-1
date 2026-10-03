local ActivityGetRankRewardMessage = BaseClass("ActivityGetRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, actId, stage)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", actId)
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
        DataCenter.StrongestCommanderDataManager:ParseRankingRewardData(t)
      elseif actData.type == EnumActivity.WorldBoss.Type then
        DataCenter.ActBossDataManager:ParseRewardData(t)
      elseif actData.type == EnumActivity.AttackCityActivity.Type then
        DataCenter.ActivityAttackCityDataManager:UpdateRankRewardData(t)
        EventManager:GetInstance():Broadcast(EventId.ActivityAttackCityRankRewardDataUpdate)
      elseif actData.type == EnumActivity.MonsterInvasion.Type then
        DataCenter.ActivityMonsterInvasionDataManager:UpdateRankRewardData(t)
        EventManager:GetInstance():Broadcast(EventId.MonsterInvasionRankReward)
      elseif actData.type == EnumActivity.PersonalArmsNew.Type then
        DataCenter.ActivityPersonalArmsDataManager:UpdateRankRewardData(t)
        EventManager:GetInstance():Broadcast(EventId.PersonalArmsRankReward)
      elseif actData.type == EnumActivity.RevivalPlan.Type then
        DataCenter.RevivalPlanManager:ParseRankingRewardData(t)
      end
    end
  end
end

ActivityGetRankRewardMessage.OnCreate = OnCreate
ActivityGetRankRewardMessage.HandleMessage = HandleMessage
return ActivityGetRankRewardMessage
