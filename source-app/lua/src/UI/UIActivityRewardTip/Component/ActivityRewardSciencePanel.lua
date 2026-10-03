local ActivityOverviewItem = BaseClass("ActivityOverviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local scienceBg_path = "ScienceBg/Item_Bg"
local scienceIcon_path = "ScienceBg/ScienceIcon"
local scienceDesc_path = "ScienceBg/ScienceName"
local jumpBtn_path = "ScienceBg/jumpBtn"
local jumpBtnTxt_path = "ScienceBg/jumpBtn/jumpBtnTxt"

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
  self.scienceBgN = self:AddComponent(UIImage, scienceBg_path)
  self.scienceIconN = self:AddComponent(UIImage, scienceIcon_path)
  self.scienceDescN = self:AddComponent(UIText, scienceDesc_path)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.jumpBtnTxtN = self:AddComponent(UIText, jumpBtnTxt_path)
  self.jumpBtnTxtN:SetLocalText(110003)
end

local function ComponentDestroy(self)
  self.scienceBgN = nil
  self.scienceIconN = nil
  self.scienceDescN = nil
  self.jumpBtnN = nil
  self.jumpBtnTxtN = nil
end

local function DataDefine(self)
  self.rewardScienceInfo = nil
end

local function DataDestroy(self)
  self.rewardScienceInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, rewardScience)
  self.rewardScienceInfo = rewardScience
  self:RefreshAll()
end

local function RefreshAll(self)
  local scienceId = self.rewardScienceInfo.scienceId
  local dialogId = self.rewardScienceInfo.dialogId
  local scienceTemplate = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
  self.scienceIconN:LoadSprite(string.format(LoadPath.ScienceIcons, scienceTemplate.icon))
  self.scienceDescN:SetLocalText(dialogId)
end

local function OnClickJumpBtn(self)
  local id = self.rewardScienceInfo.scienceId
  self.view.ctrl:CloseSelf()
  GoToUtil.GotoScience(id)
end

ActivityOverviewItem.OnCreate = OnCreate
ActivityOverviewItem.OnDestroy = OnDestroy
ActivityOverviewItem.ComponentDefine = ComponentDefine
ActivityOverviewItem.ComponentDestroy = ComponentDestroy
ActivityOverviewItem.DataDefine = DataDefine
ActivityOverviewItem.DataDestroy = DataDestroy
ActivityOverviewItem.OnAddListener = OnAddListener
ActivityOverviewItem.OnRemoveListener = OnRemoveListener
ActivityOverviewItem.ShowPanel = ShowPanel
ActivityOverviewItem.RefreshAll = RefreshAll
ActivityOverviewItem.OnClickJumpBtn = OnClickJumpBtn
return ActivityOverviewItem
