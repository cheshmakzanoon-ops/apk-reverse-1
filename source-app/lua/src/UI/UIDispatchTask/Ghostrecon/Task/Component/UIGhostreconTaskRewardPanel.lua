local base = UIBaseContainer
local UIGhostreconTaskRewardPanel = BaseClass("UIGhostreconTaskRewardPanel", base)
local titleText_path = "TitleImg1/TitleText"
local scrollView_path = "ScrollView"
local titleImg1_path = "TitleImg1"
local titleImg2_path = "TitleImg1/TitleImg2"

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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.titleImg1 = self:AddComponent(UIRawImage, titleImg1_path)
  self.titleImg2 = self:AddComponent(UIRawImage, titleImg2_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.titleText:SetLocalText("ghostrecon_010")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleText = nil
  self.scrollView = nil
  self.titleImg1 = nil
  self.titleImg2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.taskInfo = nil
  self.cfg = nil
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UICommonResItem, itemObj)
  local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
  local cellData = self.cfg.reward[index]
  if 0 < buildAddNum and cellData.itemId == itemId then
    cellData = DeepCopy(cellData)
    cellData.count = cellData.count + buildAddNum
    cellData.isShowArrow = true
  end
  cellItem:ReInit(cellData)
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

local function SetData(self, uuid)
  self.uuid = uuid
  self.taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  self.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.taskInfo.cfgId)
  self.scrollView:SetTotalCount(#self.cfg.reward)
  self.scrollView:RefillCells()
  self.titleImg1:LoadSprite(UIAssets.GhostreconTexturePath .. self.cfg.imgSet.RewardTitleImg)
  self.titleImg2:LoadSprite(UIAssets.GhostreconTexturePath .. self.cfg.imgSet.RewardTitleImg)
end

UIGhostreconTaskRewardPanel.OnCreate = OnCreate
UIGhostreconTaskRewardPanel.OnDestroy = OnDestroy
UIGhostreconTaskRewardPanel.OnEnable = OnEnable
UIGhostreconTaskRewardPanel.OnDisable = OnDisable
UIGhostreconTaskRewardPanel.ComponentDefine = ComponentDefine
UIGhostreconTaskRewardPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTaskRewardPanel.DataDefine = DataDefine
UIGhostreconTaskRewardPanel.DataDestroy = DataDestroy
UIGhostreconTaskRewardPanel.OnItemMoveIn = OnItemMoveIn
UIGhostreconTaskRewardPanel.OnItemMoveOut = OnItemMoveOut
UIGhostreconTaskRewardPanel.ClearScroll = ClearScroll
UIGhostreconTaskRewardPanel.SetData = SetData
return UIGhostreconTaskRewardPanel
