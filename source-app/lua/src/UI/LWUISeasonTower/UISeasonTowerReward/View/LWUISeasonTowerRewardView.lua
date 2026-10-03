local LWUISeasonTowerRewardView = BaseClass("LWUISeasonTowerRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local LWUISeasonTowerRewardCellComponent = require("UI.LWUISeasonTower.UISeasonTowerRank.Component.LWUISeasonTowerRewardCellComponent")
local SeasonTowerSelectItemComponent = require("UI.LWUISeasonTower.UISeasonTowerMain.Component.SeasonTowerSelectItemComponent")
local ToggleConfig = {
  [SeasonTowerConfig.RewardType.Group] = {
    name = Localization:GetString("season_tower_reward_point")
  },
  [SeasonTowerConfig.RewardType.Stage] = {
    name = Localization:GetString("season_tower_reward_stage")
  }
}

function LWUISeasonTowerRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitToggle()
end

function LWUISeasonTowerRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISeasonTowerRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnClaimAll = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClaimAll:SetOnClick(function()
    self:OnBtnClaimAllClick()
  end)
  self.textTxtEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 6)
  self.compArea = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textAreaNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnArrow = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnArrow:SetOnClick(function()
    self:OnBtnArrowClick()
  end)
  self.compContentArea = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.areaScrollView = self.viewSkin:AddComponent(self, UIScrollView, 11)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.areaScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnAreaItemMoveIn(itemObj, index)
  end)
  self.areaScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnAreaItemMoveOut(itemObj, index)
  end)
end

function LWUISeasonTowerRewardView:ComponentDestroy()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWUISeasonTowerRewardCellComponent)
  self.areaScrollView:ClearCells()
  self.areaScrollView:RemoveComponents(SeasonTowerSelectItemComponent)
  self.viewSkin = nil
  self.btnClose = nil
  self.scrollView = nil
  self.compContent = nil
  self.btnClaimAll = nil
  self.textTxtEmpty = nil
  self.compUICommonToggleList = nil
  self.compArea = nil
  self.textAreaNameTxt = nil
  self.btnArrow = nil
  self.compContentArea = nil
  self.areaScrollView = nil
  self.btnMask = nil
  self.btnPanel = nil
end

function LWUISeasonTowerRewardView:DataDefine()
  self.showDataList = {}
  self.curSelectIndex = -1
  local tab, index = self:GetDefaultSelectTabAndStage()
  self.defaultSelectIndex = tab
  self.curSelectStageIndex = index
end

function LWUISeasonTowerRewardView:DataDestroy()
  self.showDataList = {}
  self.curSelectIndex = -1
  self.defaultSelectIndex = SeasonTowerConfig.RewardType.Group
  self.curSelectStageIndex = -1
end

function LWUISeasonTowerRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTowerRewardRefresh, self.RefreshView)
end

function LWUISeasonTowerRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTowerRewardRefresh, self.RefreshView)
  base.OnRemoveListener(self)
end

function LWUISeasonTowerRewardView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUISeasonTowerRewardView:OnBtnClaimAllClick()
  local stageId = -1
  if self.curSelectIndex == SeasonTowerConfig.RewardType.Stage then
    local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(self.curSelectStageIndex)
    stageId = stageData.stageId
  end
  DataCenter.LWSeasonTowerManager:ClaimReward(stageId)
end

function LWUISeasonTowerRewardView:OnBtnRankingRewardsClick()
end

function LWUISeasonTowerRewardView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(LWUISeasonTowerRewardCellComponent, itemObj)
  if cellItem ~= nil and self.showDataList ~= nil then
    cellItem:SetData(self.showDataList[index], self.curSelectIndex)
  end
end

function LWUISeasonTowerRewardView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, LWUISeasonTowerRewardCellComponent)
end

function LWUISeasonTowerRewardView:OnAreaItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.areaScrollView:AddComponent(SeasonTowerSelectItemComponent, itemObj)
  local stageList = DataCenter.LWSeasonTowerManager.stageList
  local param = {}
  param.data = stageList[index]
  param.index = index
  
  function param.selectFunc(i)
    self.curSelectStageIndex = i
    self.isShowArea = false
    self:RefreshAreaDropDown()
    self:RefreshView()
  end
  
  param.selectIndex = self.curSelectStageIndex
  param.parentType = SeasonTowerConfig.SelectItemUI.Reward
  cellItem:SetData(param)
end

function LWUISeasonTowerRewardView:OnAreaItemMoveOut(itemObj, index)
  self.areaScrollView:RemoveComponent(itemObj.name, SeasonTowerSelectItemComponent)
end

function LWUISeasonTowerRewardView:InitToggle()
  local data = {}
  data.itemsDataList = ToggleConfig
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.defaultSelectIndex = self.defaultSelectIndex
  self.compUICommonToggleList:ReInit(data)
end

function LWUISeasonTowerRewardView:OnSelectToggle(index, itemData)
  if self.curSelectIndex == index then
    return
  end
  self.curSelectIndex = index
  self:RefreshView()
end

function LWUISeasonTowerRewardView:RefreshView()
  if self.curSelectIndex == SeasonTowerConfig.RewardType.Group then
    self.showDataList = DataCenter.LWSeasonTowerManager:GetGroupScoreRewards() or {}
  elseif self.curSelectIndex == SeasonTowerConfig.RewardType.Stage then
    self.showDataList = DataCenter.LWSeasonTowerManager:GetStageScoreRewards(self.curSelectStageIndex) or {}
  end
  local hasReward = false
  for _, v in ipairs(self.showDataList) do
    if v.received == SeasonTowerConfig.RewardState.CanReceive then
      hasReward = true
      break
    end
  end
  self.btnClaimAll:SetActive(hasReward)
  self:RefreshList()
end

function LWUISeasonTowerRewardView:RefreshList()
  local offset = self.scrollView:GetOffsetMax()
  if self.curSelectIndex == SeasonTowerConfig.RewardType.Group then
    self.compArea:SetActive(false)
    offset.y = -287
  else
    self.compArea:SetActive(true)
    offset.y = -340
    self:RefreshAreaDropDown()
  end
  self.scrollView:SetOffsetMax(offset)
  if self.showDataList ~= nil and #self.showDataList > 0 then
    self.scrollView:SetActive(true)
    self.textTxtEmpty:SetActive(false)
    self.scrollView:SetTotalCount(#self.showDataList)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
    self.textTxtEmpty:SetLocalText("season_tower_rank_none")
    self.textTxtEmpty:SetActive(true)
  end
end

function LWUISeasonTowerRewardView:RefreshAreaDropDown()
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(self.curSelectStageIndex)
  if stageData == nil then
    return
  end
  local template = stageData:GetTemplate()
  self.textAreaNameTxt:SetLocalText(template.name)
  self.compContentArea:SetActive(self.isShowArea)
  local stageList = DataCenter.LWSeasonTowerManager.stageList
  self.areaScrollView:SetTotalCount(#stageList)
  self.areaScrollView:RefillCells()
end

function LWUISeasonTowerRewardView:OnBtnArrowClick()
  self.isShowArea = not self.isShowArea
  self:RefreshAreaDropDown()
end

function LWUISeasonTowerRewardView:OnBtnMaskClick()
  self.isShowArea = false
  self:RefreshAreaDropDown()
end

function LWUISeasonTowerRewardView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUISeasonTowerRewardView:GetDefaultSelectTabAndStage()
  local hasGroupReward = DataCenter.LWSeasonTowerManager:HasRewardToClaim(-1)
  local stageRewardIndex = DataCenter.LWSeasonTowerManager:GetSelectStageIndex()
  local stageList = DataCenter.LWSeasonTowerManager.stageList
  for i, v in ipairs(stageList) do
    if v:IsStageOpen() and DataCenter.LWSeasonTowerManager:HasRewardToClaim(i) then
      stageRewardIndex = i
      break
    end
  end
  local defaultSelectTab = SeasonTowerConfig.RewardType.Group
  if not hasGroupReward and stageRewardIndex then
    defaultSelectTab = SeasonTowerConfig.RewardType.Stage
  end
  return defaultSelectTab, stageRewardIndex
end

return LWUISeasonTowerRewardView
