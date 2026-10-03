local UITCCardRecruitProbabilityView = BaseClass("UITCCardRecruitProbabilityView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CARD_COUNT_PRE_ROW = 5
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local BattleCardBoxPoolTemplate = require("DataCenter.TacticalCardManager.Template.BattleCardBoxPoolTemplate")
local ProbabilityNoticeItemTopComponent = require("UI.LWUITCCardProbability.Component.ProbabilityNoticeItemTopComponent")
local ProbabilityCardTypeComponent = require("UI.LWUITCCardProbability.Component.ProbabilityCardTypeComponent")
local ProbabilityNoticeItemMiddleComponent = require("UI.LWUITCCardProbability.Component.ProbabilityNoticeItemMiddleComponent")
local PointRewardComponent = require("UI.LWUITCCardProbability.Component.PointRewardComponent")
local ITEM_TYPE = {
  QualityTitle = 1,
  CardTypeTitle = 2,
  CoreCardItem = 3,
  OtherCardItem = 4,
  PointRewardTitle = 5
}
local ITEM_NAME_CONFIG = {
  [ITEM_TYPE.QualityTitle] = {
    prefabName = "ProbabilityNoticeItemTop",
    cls = ProbabilityNoticeItemTopComponent
  },
  [ITEM_TYPE.CardTypeTitle] = {
    prefabName = "ProbabilityCardType",
    cls = ProbabilityCardTypeComponent
  },
  [ITEM_TYPE.CoreCardItem] = {
    prefabName = "ProbabilityNoticeItemMiddle_Core",
    cls = ProbabilityNoticeItemMiddleComponent
  },
  [ITEM_TYPE.OtherCardItem] = {
    prefabName = "ProbabilityNoticeItemMiddle_Normal",
    cls = ProbabilityNoticeItemMiddleComponent
  },
  [ITEM_TYPE.PointRewardTitle] = {
    prefabName = "CardPointRewardTxt",
    cls = PointRewardComponent
  }
}
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local u_i_common_tab_group_path = "Root/UICommonTabGroup"
local scroll_path = "Root/scroll"
local content_path = "Root/scroll/Viewport/Content"
local item_root_path = "ItemRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectBoxId = self:GetUserData()
  self:ReInit()
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
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabGroup = self:AddComponent(UICommonTabGroup, u_i_common_tab_group_path)
  self.tabGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style1)
  self.scrollView = self:AddComponent(UILoopListView2, scroll_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  local itemRoot = self:AddComponent(UIBaseContainer, item_root_path)
  itemRoot:SetActive(false)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.cardPoolShowData = {}
  self.items = {}
end

local function DataDestroy(self)
  self.cardPoolShowData = nil
  self.items = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UITCCardRecruitProbabilityView:ReInit()
  local currentSeason = DataCenter.SeasonDataManager:GetSeason()
  self.boxTmpDataList = {}
  self.curShowCardPoolId = 1
  local tmpList = DataCenter.TacticalCardDataManager:GetAllBoxGoodsIdBySeason(currentSeason)
  if tmpList then
    for i, v in pairs(tmpList) do
      table.insert(self.boxTmpDataList, v)
    end
  end
  table.sort(self.boxTmpDataList, function(a, b)
    local aQuality = a:GetQuality()
    local bQuality = b:GetQuality()
    if aQuality ~= bQuality then
      return aQuality > bQuality
    end
    return a.id < b.id
  end)
  if self.curSelectBoxId then
    for i, v in pairs(self.boxTmpDataList) do
      if v.id == self.curSelectBoxId then
        self.curShowCardPoolId = i
        break
      end
    end
  end
  self:InitTabGroup()
end

function UITCCardRecruitProbabilityView:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UITCCardRecruitProbabilityView:GetTabGroupList()
  local groupList = {}
  for index, value in ipairs(self.boxTmpDataList) do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = value:GetName()
    temp.selectBgPath = "Assets/Main/Sprites/UI/UILWAlliance/common_wintag03_sel.png"
    groupList[index] = temp
  end
  return groupList
end

function UITCCardRecruitProbabilityView:OnGroupLoadFinsh()
  if self.curShowCardPoolId then
    self.tabGroup:SelectTab(self.curShowCardPoolId, true)
  else
    self.tabGroup:SelectTab(1)
  end
end

function UITCCardRecruitProbabilityView:OnClickTab(index)
  if not self.boxTmpDataList[index] then
    return
  end
  self.curShowCardPoolId = self.boxTmpDataList[index].card_pool_show
  self.curShowCardBoxIndex = index
  local curCardPoolShowData = self.cardPoolShowData[self.curShowCardPoolId]
  if not curCardPoolShowData then
    curCardPoolShowData = self:GetCardPoolShowData(self.curShowCardPoolId)
    self.cardPoolShowData[self.curShowCardPoolId] = curCardPoolShowData
  end
  self.scrollView:SetListItemCount(#curCardPoolShowData, false, false)
  self.scrollView:RefreshAllShownItem()
  self.scrollView:MovePanelToItemIndex(0, 0)
end

function UITCCardRecruitProbabilityView:GetCurCardPoolShowData()
  return self.cardPoolShowData[self.curShowCardPoolId]
end

function UITCCardRecruitProbabilityView:GetCardPoolShowData(poolId)
  local allCardProbList = {}
  local cardProbDic = {}
  local rowLine = LocalController:instance():getLine(TableName.TacticalCardBoxPool, poolId)
  local tmp = BattleCardBoxPoolTemplate.New()
  tmp:UpdateData(rowLine)
  if not tmp then
    return
  end
  local weightInfoStr = tmp:GetCardPool()
  if not weightInfoStr then
    return
  end
  local totalWeight = 0
  weightInfoStr = string.split(weightInfoStr, "|")
  for _, v in ipairs(weightInfoStr) do
    local cardWeight = string.split(v, ";")
    if #cardWeight == 2 then
      local weight = toInt(cardWeight[1])
      totalWeight = totalWeight + weight
      local cardId = toInt(cardWeight[2])
      local cardTmp = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
      local quality = cardTmp.color
      local type = cardTmp.type
      local cardProbData = {
        cardTmp = cardTmp,
        prob = 0,
        weight = weight
      }
      table.insert(allCardProbList, cardProbData)
      if not cardProbDic[quality] then
        cardProbDic[quality] = {}
      end
      if not cardProbDic[quality][type] then
        cardProbDic[quality][type] = {}
      end
      table.insert(cardProbDic[quality][type], cardProbData)
    end
  end
  for _, v in ipairs(allCardProbList) do
    v.prob = v.weight / totalWeight
  end
  local showDataList = {}
  local currentBoxConfig = self.boxTmpDataList[self.curShowCardBoxIndex or 1]
  if currentBoxConfig and currentBoxConfig.box_point and 0 < currentBoxConfig.box_point then
    local pointRewardItem = {
      itemType = ITEM_TYPE.PointRewardTitle,
      data = Localization:GetString("battle_card_box_point", currentBoxConfig:GetName(), currentBoxConfig.box_point)
    }
    table.insert(showDataList, pointRewardItem)
  end
  for quality = TacticalCardQualityType.Orange, TacticalCardQualityType.White, -1 do
    local qualityTitleData = {}
    local qualityTotalWeight = 0
    qualityTitleData.itemType = ITEM_TYPE.QualityTitle
    qualityTitleData.data = Localization:GetString(TacticalQualityNameConfig[quality])
    qualityTitleData.prob = 0
    table.insert(showDataList, qualityTitleData)
    local showDataCountBefore = #showDataList
    local showCardType = {
      TacticalCardType.Core,
      TacticalCardType.Battle,
      TacticalCardType.Economy
    }
    for _, v in ipairs(showCardType) do
      local cardType = v
      local qualityData = cardProbDic[quality]
      if qualityData then
        local allDataList = qualityData[cardType]
        if allDataList then
          local titleData = {}
          titleData.itemType = ITEM_TYPE.CardTypeTitle
          titleData.data = Localization:GetString(TacticalCardNameConfig[cardType])
          table.insert(showDataList, titleData)
          local rowCount = math.ceil(#allDataList / CARD_COUNT_PRE_ROW)
          for i = 1, rowCount do
            local rowDataList = {}
            rowDataList.itemType = v == TacticalCardType.Core and ITEM_TYPE.CoreCardItem or ITEM_TYPE.OtherCardItem
            local cardDataList = {}
            rowDataList.data = cardDataList
            table.insert(showDataList, rowDataList)
            local startIndex = 1 + (i - 1) * CARD_COUNT_PRE_ROW
            local endIndex = startIndex + CARD_COUNT_PRE_ROW - 1
            for j = startIndex, endIndex do
              if allDataList[j] then
                table.insert(cardDataList, allDataList[j])
                qualityTotalWeight = qualityTotalWeight + allDataList[j].weight
              end
            end
          end
        end
      end
    end
    local showDataCountAfter = #showDataList
    if showDataCountAfter == showDataCountBefore then
      table.remove(showDataList, #showDataList)
    else
      qualityTitleData.prob = qualityTotalWeight / totalWeight
    end
  end
  return showDataList
end

function UITCCardRecruitProbabilityView:RefreshView()
end

function UITCCardRecruitProbabilityView:GetScrollItem(listview, index)
  local dataList = self:GetCurCardPoolShowData()
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local itemConfig = ITEM_NAME_CONFIG[dataList[index].itemType]
  local itemName = itemConfig.prefabName
  local cls = itemConfig.cls
  local csItem = listview:NewListViewItem(itemName)
  if self.items[csItem] == nil then
    local nameStr = tostring(NameCount)
    NameCount = NameCount + 1
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(cls, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(dataList[index])
  end
  return csItem
end

UITCCardRecruitProbabilityView.OnCreate = OnCreate
UITCCardRecruitProbabilityView.OnDestroy = OnDestroy
UITCCardRecruitProbabilityView.OnEnable = OnEnable
UITCCardRecruitProbabilityView.OnDisable = OnDisable
UITCCardRecruitProbabilityView.ComponentDefine = ComponentDefine
UITCCardRecruitProbabilityView.ComponentDestroy = ComponentDestroy
UITCCardRecruitProbabilityView.DataDefine = DataDefine
UITCCardRecruitProbabilityView.DataDestroy = DataDestroy
UITCCardRecruitProbabilityView.OnAddListener = OnAddListener
UITCCardRecruitProbabilityView.OnRemoveListener = OnRemoveListener
return UITCCardRecruitProbabilityView
