local DigTreasureGameGetRewardMessage = BaseClass("DigTreasureGameGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DigTreasureGameGetRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function DigTreasureGameGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local tRewardData = t.mapBoxList
    local tOldRewardData = DataCenter.DigTreasureManager:GetRewardData()
    local nBeginIndex = 0
    local nEndIndex = 0
    local nBeginLayer = 0
    local nEndLayer = 0
    for i, v in ipairs(tOldRewardData) do
      if v.rewardState == DigRewardState.CanGet then
        local cfg = DataCenter.DiggingDataTemplateManager:GetConfigData(v.mapConfigId)
        if nBeginIndex == 0 then
          nBeginIndex = i
          nBeginLayer = cfg.layer
        elseif i > nEndIndex then
          nEndIndex = i
          nEndLayer = cfg.layer
        end
      end
    end
    if tRewardData ~= nil then
      DataCenter.DigTreasureManager:UpdateRewardData(tRewardData)
    end
    local sDesc
    if nBeginIndex ~= 0 then
      if nEndIndex ~= 0 then
        sDesc = Localization:GetString("treasure_map_reward_tips_01", nBeginLayer, nEndLayer)
      else
        sDesc = Localization:GetString("treasure_map_reward_tips_02", nBeginLayer)
      end
    end
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, nil, sDesc)
    local tNewMap = t.newMap
    if tNewMap ~= nil then
      DataCenter.DigTreasureManager:UpdateNormalMapData(tNewMap)
      EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateMapData)
    end
  end
end

return DigTreasureGameGetRewardMessage
