local UIActMonopolyRulesView = BaseClass("UIActMonopolyRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActMonopolyRulesGoodsItem = require("UI.UIActMonopoly.UIActMonopolyRules.Component.UIActMonopolyRulesGoodsItem")
local UIActMonopolyRulesEventItem = require("UI.UIActMonopoly.UIActMonopolyRules.Component.UIActMonopolyRulesEventItem")
local UIActMonopolyRulesManualItem = require("UI.UIActMonopoly.UIActMonopolyRules.Component.UIActMonopolyRulesManualItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local brief_text_path = "BriefContent/Common_bg_brief/BriefScroll/Viewport/BriefLayout/BriefText"
local UIActMonopolyRulesEventItem_path = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyRulesEventItem.prefab"
local UIActMonopolyRulesGoodsItem_path = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyRulesGoodsItem.prefab"
local UIActMonopolyRulesManualItem_path = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyRulesManualItem.prefab"
local item2_title_text_path = "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/Item2Title/Item2TitleText"
local item2_probability_text_path = "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/Item2Title/Item2ProbabilityText"
local goods2_content_path = "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/Goods2Content"
local manual_content_path = "ManualContent"
local manual_scroll_path = "ManualContent/Common_bg_manual/ManualScroll"
local manual_layout_path = "ManualContent/Common_bg_manual/ManualScroll/Viewport/ManualLayout"
local can_drag_img_path = "ManualContent/Common_bg_manual/canDragImg"
local common_activity_pop_up_bg_part_path = "CommonActivityPopUpBgPart"
local manual_common_bg_path = "ManualContent/Common_bg_manual"
local detail_common_bg_path = "DetailContent/Common_bg_detail"
local common_bg_brief_path = "BriefContent/Common_bg_brief"
UIActMonopolyRulesView.TabType = {
  Manual = 1,
  Brief = 2,
  Detail = 3
}

function UIActMonopolyRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.Manual
  self:UpdateTab()
  self:UpdateContent()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self:ModifyByConfig()
end

function UIActMonopolyRulesView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyRulesView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Common_img_title/titleText")
  self.textTitle:SetLocalText("decoration_recruit_desc26")
  self.btnClose = self:AddComponent(UIButton, "CommonActivityPopUpBgPart/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTabLayout = self:AddComponent(UIBaseContainer, "TabLayout")
  self.compTabList = {}
  for i, v in pairs(self.TabType) do
    local tab = {}
    tab.tabType = v
    local tabPath = "TabLayout/Tab" .. tostring(v)
    tab.objRoot = self:AddComponent(UIBaseContainer, tabPath)
    tab.objSelect = tab.objRoot:AddComponent(UIBaseContainer, "Select")
    tab.objUnSelect = tab.objRoot:AddComponent(UIBaseContainer, "UnSelect")
    tab.text = tab.objRoot:AddComponent(UIText, "Group/titleText")
    tab.btn = tab.objRoot:AddComponent(UIButton, "Btn")
    tab.unselectBg = tab.objRoot:AddComponent(UIImage, "UnSelect")
    tab.selectBg = tab.objRoot:AddComponent(UIImage, "Select")
    local index = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.compBriefContent = self:AddComponent(UIBaseContainer, "BriefContent")
  self.compBriefTextContent = self:AddComponent(UIBaseContainer, "BriefContent/Common_bg_brief/BriefScroll/Viewport/BriefLayout")
  self.brief_text = self:AddComponent(UITextMeshProUGUIEx, brief_text_path)
  self.compDetailCanvasGroup = self:AddComponent(UICanvasGroup, "DetailContent")
  self.compDetailContent = self:AddComponent(UIBaseContainer, "DetailContent")
  self.compDetailLayout = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout")
  self.compDetailScroll = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg_detail/DetailScroll")
  self.textEventTitle = self:AddComponent(UIText, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/EventTitle/EventTitleText")
  self.textEventTitle:SetLocalText("snow_season_gridname3")
  self.textEventProbability = self:AddComponent(UIText, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/EventTitle/EventProbabilityText")
  self.compEventContent = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/EventContent")
  self.textItemTitle = self:AddComponent(UIText, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/ItemTitle/ItemTitleText")
  self.textItemTitle:SetLocalText("item_name710050")
  self.textItemProbability = self:AddComponent(UIText, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/ItemTitle/ItemProbabilityText")
  self.compGoodsContent = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg_detail/DetailScroll/Viewport/DetailLayout/GoodsContent")
  self.item2_title_text = self:AddComponent(UITextMeshProUGUIEx, item2_title_text_path)
  self.item2_probability_text = self:AddComponent(UITextMeshProUGUIEx, item2_probability_text_path)
  self.goods2_content = self:AddComponent(UIBaseContainer, goods2_content_path)
  self.item2_title_text:SetLocalText("activity_halloween_uitips_007")
  self.manual_content = self:AddComponent(UIBaseContainer, manual_content_path)
  self.manual_scroll = self:AddComponent(UIScrollRect, manual_scroll_path)
  self.manual_layout = self:AddComponent(UIBaseContainer, manual_layout_path)
  self.can_drag_img = self:AddComponent(UIButton, can_drag_img_path)
  self.can_drag_img:SetOnClick(function()
    self:TryToNextManualItem()
  end)
  self.manual_scroll:AddValueChangeListener(function()
    self:OnManualScrollDrag()
  end)
  self.manualCommon_bg = self:AddComponent(UIImage, manual_common_bg_path)
  self.briefCommon_bg = self:AddComponent(UIImage, common_bg_brief_path)
  self.detailCommon_bg = self:AddComponent(UIImage, detail_common_bg_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, common_activity_pop_up_bg_part_path)
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIActMonopolyRulesView:ComponentDestroy()
  self:ClearManualScroll()
  self:ClearEventScroll()
  self:ClearGoodsScroll()
  self:ClearGoods2Scroll()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabLayout = nil
  self.compBriefContent = nil
  self.textEventTitle = nil
  self.textEventProbability = nil
  self.compEventContent = nil
  self.textItemTitle = nil
  self.textItemProbability = nil
  self.compGoodsContent = nil
  self.compTabList = nil
  self.compDetailScroll = nil
  self.compDetailCanvasGroup = nil
  self.compBriefTextContent = nil
  self.compDetailLayout = nil
  self.item2_title_text = nil
  self.item2_probability_text = nil
  self.goods2_content = nil
  self.manual_scroll:RemoveAllListeners()
  self.manual_content = nil
  self.manual_scroll = nil
  self.manual_layout = nil
  self.can_drag_img = nil
  self.manualCommon_bg = nil
  self.detailCommon_bg = nil
  self.briefCommon_bg = nil
  self.commonActivityPopUpBgPart = nil
end

function UIActMonopolyRulesView:DataDefine()
  self.hasInitTab = {}
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.activityInfo.richman_para)
  self.showTemp = self.activityInfo:GetShowConfigTemp()
end

function UIActMonopolyRulesView:DataDestroy()
  self.hasInitTab = nil
end

function UIActMonopolyRulesView:OnAddListener()
  base.OnAddListener(self)
end

function UIActMonopolyRulesView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActMonopolyRulesView:UpdateTab()
  if self.compTabList == nil then
    return
  end
  for i, v in pairs(self.compTabList) do
    local isSelect = self.curSelectTab == v.tabType
    v.objSelect:SetActive(isSelect)
    v.objUnSelect:SetActive(not isSelect)
    v.text:SetText(self:GetTabLocalText(v.tabType))
  end
end

function UIActMonopolyRulesView:UpdateContent()
  if self.curSelectTab == nil or self.activityId == nil then
    return
  end
  self.compBriefContent:SetActive(self.curSelectTab == self.TabType.Brief)
  self.compDetailContent:SetActive(self.curSelectTab == self.TabType.Detail)
  self.manual_content:SetActive(self.curSelectTab == self.TabType.Manual)
  if self.hasInitTab[self.curSelectTab] then
    return
  end
  if self.curSelectTab == self.TabType.Brief then
    self:UpdateBriefContent()
  end
  if self.curSelectTab == self.TabType.Detail then
    self:UpdateDetailContent()
  end
  if self.curSelectTab == self.TabType.Manual then
    self:UpdateManualContent()
  end
  self.hasInitTab[self.curSelectTab] = true
end

function UIActMonopolyRulesView:UpdateBriefContent()
  self.compBriefTextContent:SetAnchoredPositionXY(0, 0)
  self.brief_text:SetLocalText(self.activityInfo.story)
end

function UIActMonopolyRulesView:UpdateDetailContent()
  local dropGroupId = tonumber(self.paraTemp.drop_show_id)
  local eventTypeTempList = DataCenter.ActMonopolyDataManager:GetDropShowTempByGroupAndType(dropGroupId, ActMonopolyDropShowType.Event)
  local rewardTypeTempList = DataCenter.ActMonopolyDataManager:GetDropShowTempByGroupAndType(dropGroupId, ActMonopolyDropShowType.Reward)
  local actDetectTreasureTypeTempList = DataCenter.ActMonopolyDataManager:GetDropShowTempByGroupAndType(dropGroupId, ActMonopolyDropShowType.ActDetectTreasure)
  table.sort(eventTypeTempList, function(a, b)
    return a.order > b.order
  end)
  table.sort(rewardTypeTempList, function(a, b)
    return a.order > b.order
  end)
  table.sort(actDetectTreasureTypeTempList, function(a, b)
    return a.order > b.order
  end)
  local totalEventNum = 0
  for i, v in ipairs(eventTypeTempList) do
    totalEventNum = totalEventNum + v.drop_show
  end
  local totalRewardNum = 0
  for i, v in ipairs(rewardTypeTempList) do
    totalRewardNum = totalRewardNum + v.drop_show
  end
  local totalActDetectTreasureNum = 0
  for i, v in ipairs(actDetectTreasureTypeTempList) do
    totalActDetectTreasureNum = totalActDetectTreasureNum + v.drop_show
  end
  local eventTypeStr = string.formatDecimal(totalEventNum / 100, 2) .. "%"
  self.textEventProbability:SetText(eventTypeStr)
  local rewardTypeStr = string.formatDecimal(totalRewardNum / 100, 2) .. "%"
  self.textItemProbability:SetText(rewardTypeStr)
  local actDetectTreasureTypeStr = string.formatDecimal(totalActDetectTreasureNum / 100, 2) .. "%"
  self.item2_probability_text:SetText(actDetectTreasureTypeStr)
  self:ClearEventScroll()
  self.compDetailCanvasGroup:SetAlpha(0)
  local hasRebuildLayout = false
  local hasDoneEvent = false
  local hasDoneGoods = false
  for i = 1, #eventTypeTempList do
    self.reqsEvent[i] = self:GameObjectInstantiateAsync(UIActMonopolyRulesEventItem_path, function(request)
      if request.isError or self.compEventContent == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compEventContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_event_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compEventContent:AddComponent(UIActMonopolyRulesEventItem, go.name)
      cell:ReInit(self.activityId, eventTypeTempList[i])
      self.itemsEvent[i] = cell
      if i == #eventTypeTempList then
        hasDoneEvent = true
        if not hasRebuildLayout and hasDoneGoods then
          if self.compDetailLayout then
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compDetailLayout.transform)
          end
          if self.compDetailCanvasGroup then
            self.compDetailCanvasGroup:SetAlpha(1)
          end
          hasRebuildLayout = true
        end
      end
    end)
  end
  self:ClearGoodsScroll()
  for i = 1, #rewardTypeTempList do
    self.reqsGoods[i] = self:GameObjectInstantiateAsync(UIActMonopolyRulesGoodsItem_path, function(request)
      if request.isError or self.compGoodsContent == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compGoodsContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_goods_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compGoodsContent:AddComponent(UIActMonopolyRulesGoodsItem, go.name)
      cell:ReInit(self.activityId, rewardTypeTempList[i])
      self.itemsGoods[i] = cell
      if i == #rewardTypeTempList then
        hasDoneGoods = true
        if not hasRebuildLayout and hasDoneEvent then
          if self.compDetailLayout then
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compDetailLayout.transform)
          end
          if self.compDetailCanvasGroup then
            self.compDetailCanvasGroup:SetAlpha(1)
          end
          hasRebuildLayout = true
        end
      end
    end)
  end
  self:ClearGoods2Scroll()
  for i = 1, #actDetectTreasureTypeTempList do
    self.reqsGoods2[i] = self:GameObjectInstantiateAsync(UIActMonopolyRulesGoodsItem_path, function(request)
      if request.isError or self.goods2_content == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.goods2_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_goods2_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.goods2_content:AddComponent(UIActMonopolyRulesGoodsItem, go.name)
      cell:ReInit(self.activityId, actDetectTreasureTypeTempList[i])
      self.itemsGoods2[i] = cell
      if i == #actDetectTreasureTypeTempList then
        hasDoneGoods = true
        if not hasRebuildLayout and hasDoneEvent then
          if self.compDetailLayout then
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compDetailLayout.transform)
          end
          if self.compDetailCanvasGroup then
            self.compDetailCanvasGroup:SetAlpha(1)
          end
          hasRebuildLayout = true
        end
      end
    end)
    local titleData = self.paraTemp.dropshow_title
    if not string.IsNullOrEmpty(titleData) then
      local titleStrList = string.split(titleData, "|")
      if #titleStrList == 3 then
        self.textEventTitle:SetLocalText(titleStrList[1])
        self.textItemTitle:SetLocalText(titleStrList[2])
        self.item2_title_text:SetLocalText(titleStrList[3])
      end
    end
  end
end

function UIActMonopolyRulesView:UpdateManualContent()
  self.manual_layout:SetAnchoredPositionXY(0, 0)
  local guidIdList = {}
  if self.showTemp and not string.IsNullOrEmpty(self.showTemp.pic_guide) then
    guidIdList = string.string2array_num_oneSep(self.showTemp.pic_guide, "|")
  end
  local hasDoneManual = false
  self:ClearManualScroll()
  for i = 1, #guidIdList do
    self.reqsManual[i] = self:GameObjectInstantiateAsync(UIActMonopolyRulesManualItem_path, function(request)
      if request.isError or self.manual_layout == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.manual_layout.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_manual_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.manual_layout:AddComponent(UIActMonopolyRulesManualItem, go.name)
      cell:ReInit(self.activityId, guidIdList[i], i, #guidIdList)
      self.itemsManual[i] = cell
      if i == #guidIdList then
        hasDoneManual = true
        if hasDoneManual and self.manual_layout then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.manual_layout.transform)
          self:OnManualScrollDrag()
        end
      end
    end)
  end
end

function UIActMonopolyRulesView:ClearEventScroll()
  self.compEventContent:RemoveComponents(UIActMonopolyRulesEventItem)
  if self.reqsEvent and next(self.reqsEvent) then
    for k, v in pairs(self.reqsEvent) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqsEvent = {}
  self.itemsEvent = {}
end

function UIActMonopolyRulesView:ClearGoodsScroll()
  self.compGoodsContent:RemoveComponents(UIActMonopolyRulesGoodsItem)
  if self.reqsGoods and next(self.reqsGoods) then
    for k, v in pairs(self.reqsGoods) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqsGoods = {}
  self.itemsGoods = {}
end

function UIActMonopolyRulesView:ClearGoods2Scroll()
  self.goods2_content:RemoveComponents(UIActMonopolyRulesGoodsItem)
  if self.reqsGoods2 and next(self.reqsGoods2) then
    for k, v in pairs(self.reqsGoods2) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqsGoods2 = {}
  self.itemsGoods2 = {}
end

function UIActMonopolyRulesView:ClearManualScroll()
  self.manual_layout:RemoveComponents(UIActMonopolyRulesManualItem)
  if self.reqsManual and next(self.reqsManual) then
    for k, v in pairs(self.reqsManual) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqsManual = {}
  self.itemsManual = {}
end

function UIActMonopolyRulesView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActMonopolyRulesView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActMonopolyRulesView:GetTabLocalText(tab)
  if tab == self.TabType.Brief then
    return Localization:GetString("decoration_recruit_btn_name5")
  end
  if tab == self.TabType.Detail then
    return Localization:GetString("decoration_recruit_btn_name1")
  end
  if tab == self.TabType.Manual then
    return Localization:GetString("458020")
  end
  return ""
end

function UIActMonopolyRulesView:OnManualScrollDrag()
  local scrollSize = self.manual_scroll:GetSizeDelta()
  local layoutSize = self.manual_layout:GetSizeDelta()
  local layoutPos = self.manual_layout:GetAnchoredPosition()
  local isArrowShow = false
  if layoutSize.y > scrollSize.y and layoutPos.y < layoutSize.y - scrollSize.y - 10 then
    isArrowShow = true
  end
  self.can_drag_img:SetActive(isArrowShow)
end

function UIActMonopolyRulesView:TryToNextManualItem()
  local scrollSize = self.manual_scroll:GetSizeDelta()
  local layoutSize = self.manual_layout:GetSizeDelta()
  local layoutPos = self.manual_layout:GetAnchoredPosition()
  local maxPos = 0
  if layoutSize.y > scrollSize.y then
    maxPos = layoutSize.y - scrollSize.y - 10
  end
  if maxPos <= layoutPos.y then
    return
  end
  local curIndex = 0
  local curH = 0
  local curItemH = 0
  for i, item in ipairs(self.itemsManual) do
    local itemSize = item:GetSizeDelta()
    if layoutPos.y < curH + itemSize.y - 10 then
      curIndex = i
      curItemH = itemSize.y
      break
    end
    curH = curH + itemSize.y
  end
  local needToPos = curH + curItemH
  if maxPos < needToPos then
    needToPos = maxPos
  end
  self.manual_layout:SetAnchoredPositionXY(0, needToPos)
end

function UIActMonopolyRulesView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

function UIActMonopolyRulesView:ModifyByConfig()
  local configId = self.activityInfo:GetFestivalInterfaceCfgId()
  if configId == nil then
    return
  end
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, configId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. configId)
    return
  end
  if not string.IsNullOrEmpty(lineData.board_page) then
    local pageList = string.split(lineData.board_page, "|")
    for _, v in pairs(self.compTabList) do
      v.selectBg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[1]))
      v.unselectBg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[2]))
    end
  end
  if not string.IsNullOrEmpty(lineData.board_di_text) then
    local configList = string.split(lineData.board_di_text, "|")
    self.manualCommon_bg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, configList[1]))
    self.briefCommon_bg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, configList[1]))
    self.detailCommon_bg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, configList[1]))
  end
end

return UIActMonopolyRulesView
