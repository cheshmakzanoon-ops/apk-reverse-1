local base = UIBaseContainer
local KillZombieActivityPersonReward = BaseClass("KillZombieActivityPersonReward", base)
local reward_title_path = "reward_title"
local reward_item_path = "ScrollView/Viewport/RewardItem"
local reward_content_path = "ScrollView/Viewport/RewardContent"

function KillZombieActivityPersonReward:OnCreate()
  base.OnCreate(self)
  self.reward_title = self:AddComponent(UIText, reward_title_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.theCellItem = self.transform:Find(reward_item_path).gameObject
  self.theCellItem:GameObjectCreatePool()
end

function KillZombieActivityPersonReward:SetData(data)
  self.theData = data
  self:UpdateData()
end

function KillZombieActivityPersonReward:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content = nil
  self.reward_title = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
end

function KillZombieActivityPersonReward:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  base.OnRemoveListener(self)
end

function KillZombieActivityPersonReward:UpdateData()
  self.content:RemoveComponents(UICommonResItem)
  self.theCellItem:GameObjectRecycleAll()
  local mgr = DataCenter.ActivityListDataManager
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(1)
  local now_level = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_LEVEL, 0)
  local difficulty_select = mgr:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, now_level)
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  local kill_count = 0
  local now_data = dataList.data[difficulty_select]
  if now_data == nil or now_data.rewardListServer == nil then
    return
  end
  local levelList = now_data.rewardListServer.levelList
  local level_count = #levelList
  if kill_zombie_data ~= nil then
    kill_count = kill_zombie_data.count or 0
  end
  local floorChallengeCount = -1
  local minChallengeCount = 0
  for index, needCount in ipairs(levelList) do
    if needCount <= kill_count and needCount >= floorChallengeCount then
      floorChallengeCount = needCount
    end
    if index == 1 then
      minChallengeCount = needCount
    elseif needCount < minChallengeCount then
      minChallengeCount = needCount
    end
  end
  local curNeedCount = 0
  if floorChallengeCount ~= -1 then
    local floorindex = table.indexof(levelList, floorChallengeCount)
    local curChallengeIndex = math.min(level_count, floorindex + 1)
    curNeedCount = levelList[curChallengeIndex] or 0
  else
    curNeedCount = minChallengeCount
  end
  local rewardStr = now_data.rewardListServer[tostring(curNeedCount)]
  if rewardStr ~= nil and rewardStr ~= "" then
    local extraRewards = DataCenter.RewardManager:ParseRewardsStr(rewardStr)
    if extraRewards ~= nil then
      local goItem, theItem
      for i, item in ipairs(extraRewards) do
        local levelName = "item_" .. i
        goItem = self.theCellItem:GameObjectSpawn(self.content.transform)
        goItem.name = levelName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UICommonResItem, levelName)
        theItem:ReInit(item)
      end
    end
    self.reward_title:SetLocalText("2010363", kill_count, curNeedCount)
  end
end

return KillZombieActivityPersonReward
