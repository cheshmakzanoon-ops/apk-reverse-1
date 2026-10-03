local LWUISeasonTowerRankView = BaseClass("LWUISeasonTowerRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local LWUISeasonTowerRankCellComponent = require("UI.LWUISeasonTower.UISeasonTowerRank.Component.LWUISeasonTowerRankCellComponent")
local self_player_item_path = "SeasonTowerObj/Container/selfPlayerItem"
local DefaultSelectIndex = 1
local RankType = {All = 1, Stage = 2}

function LWUISeasonTowerRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.selfPlayerItem = self:AddComponent(LWUISeasonTowerRankCellComponent, self_player_item_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self:InitTabs()
end

function LWUISeasonTowerRankView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISeasonTowerRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnRankingRewards = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnRankingRewards:SetOnClick(function()
    self:OnBtnRankingRewardsClick()
  end)
  self.textTxtEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 6)
  self.compContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function LWUISeasonTowerRankView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.scrollView = nil
  self.compContent = nil
  self.btnRankingRewards = nil
  self.textTxtEmpty = nil
  self.compUICommonToggleList = nil
  self.compContainer = nil
  self.btnPanel = nil
end

function LWUISeasonTowerRankView:DataDefine()
  self.curStageId = -1
  self.selectIndex = -1
  self.tabStageIdList = {}
  self.showDataList = {}
end

function LWUISeasonTowerRankView:DataDestroy()
  self.curStageId = -1
  self.selectIndex = -1
  self.tabStageIdList = nil
  self.showDataList = nil
end

function LWUISeasonTowerRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTowerRankRefresh, self.OnRankRefresh)
end

function LWUISeasonTowerRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTowerRankRefresh, self.OnRankRefresh)
  base.OnRemoveListener(self)
end

function LWUISeasonTowerRankView:OnEnable()
  base.OnEnable(self)
end

function LWUISeasonTowerRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUISeasonTowerRankView:OnBtnRankingRewardsClick()
  local data = self.ctrl:GetRankData(self.curStageId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISeasonTowerRankReward, {anim = true}, data.selfRankData)
end

function LWUISeasonTowerRankView:InitTabs()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  local template = stageData:GetTemplate()
  local param = {}
  param.itemsDataList = {
    [RankType.Stage] = {
      name = Localization:GetString("season_tower_rank_stage", Localization:GetString(template.name))
    },
    [RankType.All] = {
      name = Localization:GetString("season_tower_rank_point")
    }
  }
  param.defaultSelectIndex = DefaultSelectIndex
  param.isCanScroll = true
  
  function param.onItemSelect(index, itemData)
    self:OnTabSelect(index, itemData)
  end
  
  function param.isShowRed()
    return false
  end
  
  self.compUICommonToggleList:ReInit(param)
end

function LWUISeasonTowerRankView:OnTabSelect(index)
  if self.selectIndex == index then
    return
  end
  self.selectIndex = index
  self.curStageId = self:GetStageId()
  self:RequestRank()
  self:RefreshView()
end

function LWUISeasonTowerRankView:GetStageId()
  local stageId = -1
  if self.selectIndex == RankType.Stage then
    local stageData = DataCenter.LWSeasonTowerManager:GetCurSelectStageData()
    stageId = stageData and stageData.stageId or -1
  end
  return stageId
end

function LWUISeasonTowerRankView:RequestRank()
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerRank, {
    stageId = self:GetStageId()
  })
end

function LWUISeasonTowerRankView:OnRankRefresh(stageId)
  if stageId ~= self.curStageId then
    return
  end
  self:RefreshList()
end

function LWUISeasonTowerRankView:RefreshView()
  local data = self.ctrl:GetRankData(self.curStageId)
  if data == nil then
    self:ClearScroll()
    self.textTxtEmpty:SetActive(false)
    self.scrollView:SetActive(false)
    self.selfPlayerItem:SetActive(false)
    self.btnRankingRewards:SetActive(false)
    return
  end
  self:RefreshList()
end

function LWUISeasonTowerRankView:RefreshList()
  self.btnRankingRewards:SetActive(self.curStageId == -1)
  local sizeDelta = self.compContainer:GetSizeDelta()
  if self.curStageId == -1 then
    sizeDelta.y = 895
  else
    sizeDelta.y = 1037
  end
  self.compContainer:SetSizeDelta(sizeDelta)
  self:ClearScroll()
  local data = self.ctrl:GetRankData(self.curStageId)
  if data == nil then
    self.textTxtEmpty:SetLocalText(302187)
    self.textTxtEmpty:SetActive(true)
    self.scrollView:SetActive(false)
    self.selfPlayerItem:SetActive(false)
    return
  end
  self.showDataList = data.rankList or {}
  local empty = self.showDataList == nil or #self.showDataList <= 0
  self.textTxtEmpty:SetActive(empty)
  self.scrollView:SetActive(not empty)
  if empty then
    self.textTxtEmpty:SetLocalText(302187)
    self.selfPlayerItem:SetActive(false)
    return
  end
  self.scrollView:SetTotalCount(#self.showDataList)
  self.scrollView:RefillCells()
  local scrollViewSize = self.scrollView:GetSizeDelta()
  if data.selfRankData ~= nil then
    self.selfPlayerItem:SetActive(true)
    self.selfPlayerItem:SetData(data.selfRankData, true, self.curStageId)
    if self.selectIndex == RankType.All then
      scrollViewSize.y = 750
    else
      scrollViewSize.y = 875
    end
  else
    self.selfPlayerItem:SetActive(false)
    scrollViewSize.y = 1000
  end
  self.scrollView:SetSizeDelta(scrollViewSize)
end

function LWUISeasonTowerRankView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWUISeasonTowerRankCellComponent)
  self.showDataList = {}
end

function LWUISeasonTowerRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(LWUISeasonTowerRankCellComponent, itemObj)
  if cellItem ~= nil and self.showDataList ~= nil then
    cellItem:SetData(self.showDataList[index], false, self.curStageId)
  end
end

function LWUISeasonTowerRankView:OnRankItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, LWUISeasonTowerRankCellComponent)
end

function LWUISeasonTowerRankView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return LWUISeasonTowerRankView
