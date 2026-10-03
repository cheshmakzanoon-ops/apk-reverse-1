local UITreasureHuntNewBigRewardSelectItem = BaseClass("UITreasureHuntNewBigRewardSelectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.beSelect = self:AddComponent(UIBaseContainer, "beSelect")
  self.beRecommand = self:AddComponent(UIBaseContainer, "beRecommand")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.btn = nil
  self.beSelect = nil
  self.beRecommand = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, itemData, activityId, index)
  self.itemData = itemData
  self.activityId = activityId
  self.index = index
  if not itemData then
    self:SetActive(false)
    return
  end
  local rewardType = RewardType.GOODS
  local itemId = itemData.itemId
  local itemNum = itemData.count
  local rewardData = {
    rewardType = rewardType,
    itemId = itemId,
    count = itemNum
  }
  self:SetActive(true)
  self.resItem:ReInit(rewardData)
  self.beRecommand:SetActive(index == 1)
end

local function SetBeSelectData(self, selectIndex)
  self.selectIndex = selectIndex
  self.beSelect:SetActive(self.selectIndex == self.index)
end

local function OnBtnClick(self)
  if self.selectIndex == self.index then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewSelectFinalDigReward, self.activityId, self.index)
end

UITreasureHuntNewBigRewardSelectItem.OnCreate = OnCreate
UITreasureHuntNewBigRewardSelectItem.OnDestroy = OnDestroy
UITreasureHuntNewBigRewardSelectItem.ComponentDefine = ComponentDefine
UITreasureHuntNewBigRewardSelectItem.ComponentDestroy = ComponentDestroy
UITreasureHuntNewBigRewardSelectItem.DataDefine = DataDefine
UITreasureHuntNewBigRewardSelectItem.DataDestroy = DataDestroy
UITreasureHuntNewBigRewardSelectItem.SetData = SetData
UITreasureHuntNewBigRewardSelectItem.OnBtnClick = OnBtnClick
UITreasureHuntNewBigRewardSelectItem.SetBeSelectData = SetBeSelectData
return UITreasureHuntNewBigRewardSelectItem
