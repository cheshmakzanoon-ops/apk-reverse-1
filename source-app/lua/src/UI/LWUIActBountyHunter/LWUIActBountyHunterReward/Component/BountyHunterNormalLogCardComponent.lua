local BountyHunterNormalLogCardComponent = BaseClass("BountyHunterNormalLogCardComponent", UIBaseContainer)
local BountyHunterLogCardRewardComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterReward/Component/BountyHunterLogCardRewardComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "RewardItem"
local reward_content_path = "RewardArea/Scroll View/Viewport/RewardContent"
local time_text_path = "TimeText"
local desc_text_path = "DescText"
local LOG_TITLE_KEY_CONFIG = {
  [BountyHunterLogType.ATK_BOSS] = "activity_hunter_record_desc13",
  [BountyHunterLogType.FREE_CHEST] = "activity_hunter_record_desc14",
  [BountyHunterLogType.FULL_SCREEN_ATK] = "activity_hunter_record_desc15",
  [BountyHunterLogType.KILL] = "activity_hunter_record_desc16",
  [BountyHunterLogType.ATK_BOSS_BY_LASER] = "activity_hunter_record_desc18",
  [BountyHunterLogType.SUPER_SHOOT_NORMAL_MONSTER] = "activity_hunter_record_desc23",
  [BountyHunterLogType.SUPER_SHOOT_FLY_MONSTER] = "activity_hunter_record_desc24",
  [BountyHunterLogType.SUPER_SHOOT_FREE_CHEST] = "activity_hunter_record_desc25"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.commonResItem = self:AddComponent(UIBaseContainer, u_i_common_res_item_path)
  self.commonResItem.gameObject:GameObjectCreatePool()
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.timeText = self:AddComponent(UIText, time_text_path)
  self.descText = self:AddComponent(UIText, desc_text_path)
end

local function ComponentDestroy(self)
  self.rewardContent:RemoveAllComponentes(BountyHunterLogCardRewardComponent)
  self.commonResItem.gameObject:GameObjectRecycleAll()
  self.rewardContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function BountyHunterNormalLogCardComponent:SetData(data)
  self.data = data
  self.timeStamp = data.timestamp
  self.type = data.type
  self.confId = data.confId
  self:RefreshBaseInfo()
  self:RefreshReward()
end

function BountyHunterNormalLogCardComponent:RefreshBaseInfo()
  self.timeText:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.timeStamp * 1000))
  if self.type == BountyHunterLogType.KILL or self.type == BountyHunterLogType.ATK_BOSS or self.type == BountyHunterLogType.FULL_SCREEN_ATK then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, self.confId)
    if lineData then
      self.descText:SetLocalText(LOG_TITLE_KEY_CONFIG[self.type], Localization:GetString(lineData.name))
    end
  elseif self.type == BountyHunterLogType.FREE_CHEST then
    self.descText:SetLocalText(LOG_TITLE_KEY_CONFIG[BountyHunterLogType.FREE_CHEST])
  elseif self.type == BountyHunterLogType.ATK_BOSS_BY_LASER then
    local laserAtkName = Localization:GetString("activity_hunter_mian_ui_btn7")
    self.descText:SetLocalText(LOG_TITLE_KEY_CONFIG[BountyHunterLogType.ATK_BOSS_BY_LASER], laserAtkName)
  elseif self.type == BountyHunterLogType.SUPER_SHOOT_FREE_CHEST then
    self.descText:SetLocalText(LOG_TITLE_KEY_CONFIG[BountyHunterLogType.SUPER_SHOOT_FREE_CHEST], self.confId)
  elseif self.type == BountyHunterLogType.SUPER_SHOOT_NORMAL_MONSTER or self.type == BountyHunterLogType.SUPER_SHOOT_FLY_MONSTER then
    self.descText:SetLocalText(LOG_TITLE_KEY_CONFIG[self.type], self.confId)
  else
    self.descText:SetLocalText("")
  end
end

function BountyHunterNormalLogCardComponent:RefreshReward()
  self.rewardContent:RemoveAllComponentes(BountyHunterLogCardRewardComponent)
  self.commonResItem.gameObject:GameObjectRecycleAll()
  if not self.data or not self.data.extraReward then
    return
  end
  for _, v in ipairs(self.data.extraReward) do
    local obj = self.commonResItem.gameObject:GameObjectSpawn(self.rewardContent.transform)
    local name = tostring(NameCount)
    obj.name = name
    NameCount = NameCount + 1
    local rewardItem = self.rewardContent:AddComponent(BountyHunterLogCardRewardComponent, name)
    rewardItem:ParseInfo(v)
    local showEffect = self:IsShowEffect(v)
    rewardItem:SetEffect(showEffect)
  end
end

function BountyHunterNormalLogCardComponent:IsShowEffect(reward)
  if self.type == BountyHunterLogType.KILL or self.type == BountyHunterLogType.ATK_BOSS or self.type == BountyHunterLogType.FULL_SCREEN_ATK then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, self.confId)
    if lineData then
      local freeChestBornEffectRewards = {}
      if not table.IsNullOrEmpty(lineData.effect_list1) then
        for i, v in ipairs(lineData.effect_list1) do
          local stringList = string.split(v, ";")
          if #stringList == 3 then
            local rewardData = {
              rewardType = tonumber(stringList[1]),
              itemId = tonumber(stringList[2]),
              count = tonumber(stringList[3])
            }
            table.insert(freeChestBornEffectRewards, rewardData)
          end
        end
      end
      if not table.IsNullOrEmpty(lineData.effect_list2) then
        for i, v in ipairs(lineData.effect_list2) do
          local stringList = string.split(v, ";")
          if #stringList == 3 then
            local rewardData = {
              rewardType = tonumber(stringList[1]),
              itemId = tonumber(stringList[2]),
              count = tonumber(stringList[3])
            }
            table.insert(freeChestBornEffectRewards, rewardData)
          end
        end
      end
      for i, v in ipairs(freeChestBornEffectRewards) do
        if v.rewardType == reward.type and v.itemId == tonumber(reward.value.id) and v.count == tonumber(reward.value.num) then
          return true
        end
      end
    end
  end
  return false
end

BountyHunterNormalLogCardComponent.OnCreate = OnCreate
BountyHunterNormalLogCardComponent.OnDestroy = OnDestroy
BountyHunterNormalLogCardComponent.OnEnable = OnEnable
BountyHunterNormalLogCardComponent.OnDisable = OnDisable
BountyHunterNormalLogCardComponent.ComponentDefine = ComponentDefine
BountyHunterNormalLogCardComponent.ComponentDestroy = ComponentDestroy
BountyHunterNormalLogCardComponent.DataDefine = DataDefine
BountyHunterNormalLogCardComponent.DataDestroy = DataDestroy
BountyHunterNormalLogCardComponent.OnAddListener = OnAddListener
BountyHunterNormalLogCardComponent.OnRemoveListener = OnRemoveListener
return BountyHunterNormalLogCardComponent
