local RewardPreviewCell = BaseClass("RewardPreviewCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local commonItem_path = "IconNode/UICommonResItem"
local itemName_path = "TxtName"
local itemCount_path = "TxtNum"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.commonItemN = self:AddComponent(UICommonResItem, commonItem_path)
  self.itemNameN = self:AddComponent(UIText, itemName_path)
  self.itemCountN = self:AddComponent(UIText, itemCount_path)
end

local function ComponentDestroy(self)
  self.commonItemN = nil
  self.itemNameN = nil
  self.itemCountN = nil
end

local function DataDefine(self)
  self.rewardParam = nil
end

local function DataDestroy(self)
  self.rewardParam = nil
end

local function SetItem(self, rewardParam)
  self.rewardParam = rewardParam
  self:RefreshAll()
end

local function RefreshAll(self)
  if not self.rewardParam then
    return
  end
  local param = {}
  param.rewardType = self.rewardParam.type
  local tempCount = 0
  if self.rewardParam.value then
    if type(self.rewardParam.value) == "table" then
      local dic = self.rewardParam.value
      param.itemId = dic.id
      tempCount = dic.num or 0
    else
      tempCount = self.rewardParam.value
    end
  else
    tempCount = 0
  end
  self.commonItemN:ReInit(param)
  self.itemNameN:SetText(self.commonItemN:GetResName())
  self.itemCountN:SetText(tempCount)
end

RewardPreviewCell.OnCreate = OnCreate
RewardPreviewCell.OnDestroy = OnDestroy
RewardPreviewCell.ComponentDefine = ComponentDefine
RewardPreviewCell.ComponentDestroy = ComponentDestroy
RewardPreviewCell.DataDefine = DataDefine
RewardPreviewCell.DataDestroy = DataDestroy
RewardPreviewCell.SetItem = SetItem
RewardPreviewCell.RefreshAll = RefreshAll
RewardPreviewCell.AddTimer = AddTimer
RewardPreviewCell.SetRemainTime = SetRemainTime
RewardPreviewCell.DelTimer = DelTimer
RewardPreviewCell.OnClickJumpBtn = OnClickJumpBtn
return RewardPreviewCell
