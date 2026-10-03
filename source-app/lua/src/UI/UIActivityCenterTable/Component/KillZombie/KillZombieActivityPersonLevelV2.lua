local KillZombieActivityPersonLevelV2 = BaseClass("KillZombieActivityPersonLevelV2", UIBaseContainer)
local base = UIBaseContainer
local PersonLevelItemV2 = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonLevelItemV2")
local level_item_v2_path = "LevelItemV2"
local content_path = "Viewport/Content"

function KillZombieActivityPersonLevelV2:OnCreate()
  base.OnCreate(self)
  self.listPersonalTaskItem = {}
  self.theItem = self.transform:Find(level_item_v2_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.scroll = self:AddComponent(UIScrollRect, "")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll:AddValueChangeListener(function()
    if self.itemCellList then
      for _, v in ipairs(self.itemCellList) do
        v.btn:SetIsOn(false)
      end
    end
  end)
  self.difficultyLevel = nil
end

function KillZombieActivityPersonLevelV2:StopDelayPoster()
  if self.delayPosterInvoke ~= nil then
    self.delayPosterInvoke:Stop()
    self.delayPosterInvoke = nil
  end
end

function KillZombieActivityPersonLevelV2:OnDestroy()
  self:StopDelayPoster()
  if self.itemCellList then
    for _, v in ipairs(self.itemCellList) do
      v.btn:SetIsOn(false)
    end
  end
  if self.tip_root_v2 then
    self.tip_root_v2:SetActive(false)
  end
  self.content:RemoveComponents(PersonLevelItemV2)
  self.theItem:GameObjectRecycleAll()
  self.difficultyLevel = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonLevelV2:ReInit(tip_root_v2, dataList, difficultyLevel)
  self.personalTaskList = dataList
  self.difficultyLevel = difficultyLevel
  self.tip_root_v2 = tip_root_v2
  self:StopDelayPoster()
  self.content:RemoveComponents(PersonLevelItemV2)
  self.theItem:GameObjectRecycleAll()
  local goItem, theItem
  local itemList = {}
  local theActiveItem
  local index = 0
  local indexActive = 0
  local curMaxSelectableDifficulty = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  local curMaxSelectableDifficultyLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(curMaxSelectableDifficulty)
  local curDifficultyLevelMin, curDifficultyLevelMax = DataCenter.ActivityKillZombieManager:GetMinMaxDifficultyWithTypeAndDifficultyLevel(1, curMaxSelectableDifficultyLevel)
  if curMaxSelectableDifficulty > curDifficultyLevelMax then
    local nextDifficultyLevel = curMaxSelectableDifficultyLevel + 1
    local nextDifficultyLevelMin, nextDifficultyLevelMax = DataCenter.ActivityKillZombieManager:GetMinMaxDifficultyWithTypeAndDifficultyLevel(1, nextDifficultyLevel)
    if 0 < nextDifficultyLevelMin then
      curMaxSelectableDifficulty = nextDifficultyLevelMin
    end
  end
  if dataList then
    for difficulty = dataList.min, dataList.max do
      local taskName = "item_" .. difficulty
      local data = dataList.data[difficulty]
      if data ~= nil then
        index = index + 1
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = taskName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(PersonLevelItemV2, taskName)
        theItem:SetData(difficulty, data, self, dataList.max, tip_root_v2, self.difficultyLevel)
        table.insert(itemList, theItem)
        local isSeasonOpen = DataCenter.ActivityKillZombieManager:IsDifficultyOpenedBySeasonTime(1, difficulty)
        local belowMax = difficulty > curMaxSelectableDifficulty
        theItem:SetLocked(not isSeasonOpen or belowMax)
        if difficulty == curMaxSelectableDifficulty and isSeasonOpen then
          theActiveItem = theItem
          indexActive = index
        end
      end
    end
  end
  self.itemCellList = itemList
  if theActiveItem and 0 < indexActive then
  else
    self.content:SetAnchoredPositionXY(0, 0)
    self.scroll:SetVerticalNormalizedPosition(1)
  end
end

return KillZombieActivityPersonLevelV2
