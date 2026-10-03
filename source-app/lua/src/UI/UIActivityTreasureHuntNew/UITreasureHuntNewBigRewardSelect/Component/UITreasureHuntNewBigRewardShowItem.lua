local UITreasureHuntNewBigRewardShowItem = BaseClass("UITreasureHuntNewBigRewardShowItem", UIBaseContainer)
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
  end)
  self.closeContent = self:AddComponent(UIBaseContainer, "closeContent")
  self.tipTxt = self:AddComponent(UIText, "tipTxt")
  self.tipTxt2 = self:AddComponent(UIText, "tipTxt2")
  self.tipTxt3 = self:AddComponent(UIText, "tipTxt3")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.btn = nil
  self.closeContent = nil
  self.tipTxt = nil
  self.tipTxt2 = nil
  self.tipTxt3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, itemData, digInfo)
  self.itemData = itemData
  self.digInfo = digInfo
  local rewardType = RewardType.GOODS
  local itemId = itemData.big_reward_Preview
  local itemNum = itemData.count
  local rewardData = {
    rewardType = rewardType,
    itemId = itemId,
    count = itemNum
  }
  self:SetActive(true)
  self.resItem:ReInit(rewardData)
  local curLevel = self.digInfo.finishedLv + 1
  local itemLevel = itemData.level
  if curLevel < itemLevel then
    self.tipTxt:SetText("")
    self.tipTxt2:SetText("")
    self.tipTxt3:SetLocalText(2000826, itemLevel)
    self.closeContent:SetActive(true)
    CS.UIGray.SetGray(self.resItem.transform, false, true)
  elseif curLevel == itemLevel then
    self.tipTxt:SetText("")
    local names = DataCenter.RewardManager:GetRewardNames(rewardData)
    self.tipTxt2:SetText(names)
    self.tipTxt3:SetText("")
    self.closeContent:SetActive(false)
    CS.UIGray.SetGray(self.resItem.transform, false, true)
  elseif curLevel > itemLevel then
    self.tipTxt:SetLocalText(2000827)
    self.tipTxt2:SetText("")
    self.tipTxt3:SetText("")
    self.closeContent:SetActive(false)
    CS.UIGray.SetGray(self.resItem.transform, true, true)
  end
end

local function OnBtnClick(self)
end

UITreasureHuntNewBigRewardShowItem.OnCreate = OnCreate
UITreasureHuntNewBigRewardShowItem.OnDestroy = OnDestroy
UITreasureHuntNewBigRewardShowItem.ComponentDefine = ComponentDefine
UITreasureHuntNewBigRewardShowItem.ComponentDestroy = ComponentDestroy
UITreasureHuntNewBigRewardShowItem.DataDefine = DataDefine
UITreasureHuntNewBigRewardShowItem.DataDestroy = DataDestroy
UITreasureHuntNewBigRewardShowItem.SetData = SetData
UITreasureHuntNewBigRewardShowItem.OnBtnClick = OnBtnClick
return UITreasureHuntNewBigRewardShowItem
