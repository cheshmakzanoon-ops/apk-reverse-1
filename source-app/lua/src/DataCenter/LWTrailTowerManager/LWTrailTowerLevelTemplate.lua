local LWTrailTowerLevelTemplate = BaseClass("LWTrailTowerLevelTemplate")

function LWTrailTowerLevelTemplate:__init()
  self.id = 0
  self.levelOrder = 0
  self.towerId = 0
  self.levelGroup = 0
  self.levelType = 0
  self.preStageId = 0
  self.levelArmyId = 0
  self.sceneId = 0
  self.rewardShowStr = {}
  self.rewardShow = nil
end

function LWTrailTowerLevelTemplate:__delete()
  self.id = nil
  self.levelOrder = nil
  self.towerId = nil
  self.levelGroup = nil
  self.levelType = nil
  self.preStageId = nil
  self.levelArmyId = nil
  self.sceneId = nil
  self.rewardShowStr = nil
  self.rewardShow = nil
end

function LWTrailTowerLevelTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.levelOrder = row:getValue("level_order") or 0
  self.towerId = row:getValue("tower_id") or 0
  self.levelGroup = row:getValue("level_group") or 0
  self.levelType = row:getValue("leveltype") or 0
  self.preStageId = row:getValue("pre_level") or 0
  self.levelArmyId = row:getValue("level_armyid") or 0
  self.sceneId = row:getValue("scene_id") or 0
  self.rewardShowStr = row:getValue("reward_show") or {}
end

function LWTrailTowerLevelTemplate:GetReward()
  if self.rewardShow == nil then
    self.rewardShow = {}
    for k, rewardStr in ipairs(self.rewardShowStr) do
      local rewardData = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
      if rewardData then
        table.insert(self.rewardShow, rewardData)
      end
    end
  end
  return self.rewardShow
end

return LWTrailTowerLevelTemplate
