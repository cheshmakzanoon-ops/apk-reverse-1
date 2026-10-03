local base = UIBaseContainer
local CaveExplorationReward = BaseClass("CaveExplorationReward", base)
local Localization = CS.GameEntry.Localization
local itemParent_path = "itemParent"
local commonItem_path = "itemParent/UICommonResItem"
local empty_path = "empty"
local effect1_path = "itemParent/Eff_ui_S3_Cave_shuaxin"
local effect2_path = "itemParent/Eff_ui_S3_Mummy_main_buff_reward_loop"

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
  self.itemParent = self:AddComponent(UIBaseContainer, itemParent_path)
  self.commonItem = self:AddComponent(UIBaseContainer, commonItem_path)
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.effect1 = self:AddComponent(UIBaseContainer, effect1_path)
  self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
  self.resItem = self:AddComponent(UICommonResItem, commonItem_path)
  self.effect1:SetActive(false)
  self.effect2:SetActive(false)
end

local function ComponentDestroy(self)
  self.itemParent = nil
  self.commonItem = nil
  self.empty = nil
  self.effect1 = nil
  self.effect2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CaveExplorationReward:ReInit(data, isShowEffect)
  self.data = data
  if self.data.isEmpty then
    self.empty:SetActive(true)
    self.itemParent:SetActive(false)
  else
    self.empty:SetActive(false)
    self.itemParent:SetActive(true)
    self.resItem:ReInit(self.data.rewardData)
    if isShowEffect and self.resItem.qualityIndex and self.resItem.qualityIndex >= 4 then
      self.effect2:SetActive(true)
    else
      self.effect2:SetActive(false)
    end
    self.effect1:SetActive(self.data.isNew)
  end
end

function CaveExplorationReward:OnNextRewardBtnClick()
  if self.data and self.data.pathReward then
    local reward = DataCenter.RewardManager:ReturnRewardParamForView(self.data.pathReward)
    local diamond = self.data.pathValue
    local parame = reward
    local x = self.nextRewardBtn.transform.position.x
    local y = self.nextRewardBtn.transform.position.y
    local width = self.nextRewardBtn.rectTransform.rect.height
    local btnAnchor = CommonBoxShowRewardTipAnchor.Down
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonBoxShowRewardTip, Localization:GetString("370101", diamond), x, y, btnAnchor, width, 0, parame)
  end
end

CaveExplorationReward.OnCreate = OnCreate
CaveExplorationReward.OnDestroy = OnDestroy
CaveExplorationReward.OnEnable = OnEnable
CaveExplorationReward.OnDisable = OnDisable
CaveExplorationReward.ComponentDefine = ComponentDefine
CaveExplorationReward.ComponentDestroy = ComponentDestroy
CaveExplorationReward.DataDefine = DataDefine
CaveExplorationReward.DataDestroy = DataDestroy
return CaveExplorationReward
