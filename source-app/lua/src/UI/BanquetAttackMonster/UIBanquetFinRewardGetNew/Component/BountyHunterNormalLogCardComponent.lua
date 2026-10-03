local BountyHunterNormalLogCardComponent = BaseClass("BountyHunterNormalLogCardComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"
local reward_content_path = "RewardArea/Scroll View/Viewport/RewardContent"
local time_text_path = "TimeText"
local desc_text_path = "DescText"

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
  self.TitleNameText = self:TryAddComponent(UITextMeshProUGUIEx, "TitleNameText")
end

local function ComponentDestroy(self)
  self.rewardContent:RemoveAllComponentes(UICommonResItem)
  self.commonResItem.gameObject:GameObjectRecycleAll()
  self.rewardContent = nil
  self.TitleNameText = nil
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
  self.timeStamp = data.createTime
  self.type = data.type
  self.confId = data.cfgId
  self:RefreshBaseInfo()
  self:RefreshReward()
end

function BountyHunterNormalLogCardComponent:RefreshBaseInfo()
  self.timeText:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(self.timeStamp * 1000))
  if self.TitleNameText then
    self.TitleNameText:SetLocalText("activity_partynew_record_desc6")
  end
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(self.confId)
  if curMonsterTemp then
    self.descText:SetLocalText(curMonsterTemp.record_tips, Localization:GetString(curMonsterTemp.name))
  end
end

function BountyHunterNormalLogCardComponent:RefreshReward()
  self.rewardContent:RemoveAllComponentes(UICommonResItem)
  self.commonResItem.gameObject:GameObjectRecycleAll()
  if not self.data and not self.data.reward then
    return
  end
  for _, v in ipairs(self.data.reward) do
    local obj = self.commonResItem.gameObject:GameObjectSpawn(self.rewardContent.transform)
    local name = tostring(NameCount)
    obj.name = name
    NameCount = NameCount + 1
    local rewardItem = self.rewardContent:AddComponent(UICommonResItem, name)
    rewardItem:ParseInfo(v)
  end
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
