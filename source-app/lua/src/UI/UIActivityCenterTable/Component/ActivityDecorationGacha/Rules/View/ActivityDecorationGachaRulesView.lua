local ActivityDecorationGachaRulesView = BaseClass("ActivityDecorationGachaRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActivityDecorationGachaRulesClassItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Rules/Component/ActivityDecorationGachaRulesClassItemComponent")
local ActivityDecorationGachaRulesTextItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Rules/Component/ActivityDecorationGachaRulesTextItemComponent")
local ActivityDecorationGachaRulesGoodsItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Rules/Component/ActivityDecorationGachaRulesGoodsItemComponent")
local ActivityDecorationGachaRulesDecorationItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/Rules/Component/ActivityDecorationGachaRulesDecorationItemComponent")
ActivityDecorationGachaRulesView.TabType = {Brief = 1, Detail = 2}

function ActivityDecorationGachaRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.Brief
  self:UpdateTab()
  self:UpdateContent()
end

function ActivityDecorationGachaRulesView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaRulesView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("decoration_recruit_desc26"))
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
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
    local index = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.compBriefContent = self:AddComponent(UIBaseContainer, "BriefContent")
  self.compBriefTextContent = self:AddComponent(UIBaseContainer, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout")
  self.compNodeAttr1 = self:AddComponent(ActivityDecorationGachaRulesClassItemComponent, "BriefContent/Common_bg/recruitRateInfo/NodeAttr1")
  self.compNodeAttr2 = self:AddComponent(ActivityDecorationGachaRulesClassItemComponent, "BriefContent/Common_bg/recruitRateInfo/NodeAttr2")
  self.compNodeAttr3 = self:AddComponent(ActivityDecorationGachaRulesClassItemComponent, "BriefContent/Common_bg/recruitRateInfo/NodeAttr3")
  self.compBriefItem1 = self:AddComponent(ActivityDecorationGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem1")
  self.compBriefItem2 = self:AddComponent(ActivityDecorationGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem2")
  self.compBriefItem3 = self:AddComponent(ActivityDecorationGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem3")
  self.compBriefItem4 = self:AddComponent(ActivityDecorationGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem4")
  self.compDetailCanvasGroup = self:AddComponent(UICanvasGroup, "DetailContent")
  self.compDetailContent = self:AddComponent(UIBaseContainer, "DetailContent")
  self.compDetailLayout = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout")
  self.compDetailScroll = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll")
  self.textDecorationTitle = self:AddComponent(UIText, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/DecorationTitle/DecorationTitleText")
  self.textDecorationTitle:SetText(Localization:GetString("decoration_recruit_desc8"))
  self.textDecorationProbability = self:AddComponent(UIText, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/DecorationTitle/DecorationProbabilityText")
  self.compDecorationContent = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/DecorationContent")
  self.textItemTitle = self:AddComponent(UIText, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/ItemTitle/ItemTitleText")
  self.textItemTitle:SetText(Localization:GetString("decoration_recruit_desc9"))
  self.textItemProbability = self:AddComponent(UIText, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/ItemTitle/ItemProbabilityText")
  self.compGoodsContent = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/GoodsContent")
end

function ActivityDecorationGachaRulesView:ComponentDestroy()
  self:ClearDecorationScroll()
  self:ClearGoodsScroll()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabLayout = nil
  self.compBriefContent = nil
  self.compNodeAttr1 = nil
  self.compNodeAttr2 = nil
  self.compNodeAttr3 = nil
  self.compBriefItem1 = nil
  self.compBriefItem2 = nil
  self.compBriefItem3 = nil
  self.compBriefItem4 = nil
  self.textDecorationTitle = nil
  self.textDecorationProbability = nil
  self.compDecorationContent = nil
  self.textItemTitle = nil
  self.textItemProbability = nil
  self.compGoodsContent = nil
  self.compTabList = nil
  self.compDetailScroll = nil
  self.compDetailCanvasGroup = nil
  self.compBriefTextContent = nil
  self.compDetailLayout = nil
end

function ActivityDecorationGachaRulesView:DataDefine()
  self.hasInitTab = {}
  self.activityId = self:GetUserData()
end

function ActivityDecorationGachaRulesView:DataDestroy()
  self.hasInitTab = nil
end

function ActivityDecorationGachaRulesView:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaRulesView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaRulesView:UpdateTab()
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

function ActivityDecorationGachaRulesView:UpdateContent()
  if self.curSelectTab == nil or self.activityId == nil then
    return
  end
  self.compBriefContent:SetActive(self.curSelectTab == self.TabType.Brief)
  self.compDetailContent:SetActive(self.curSelectTab == self.TabType.Detail)
  if self.hasInitTab[self.curSelectTab] then
    return
  end
  if self.curSelectTab == self.TabType.Brief then
    self:UpdateBriefContent()
  end
  if self.curSelectTab == self.TabType.Detail then
    self:UpdateDetailContent()
  end
  self.hasInitTab[self.curSelectTab] = true
end

function ActivityDecorationGachaRulesView:UpdateBriefContent()
  self.compNodeAttr1:ReInit(self.activityId, 5)
  self.compNodeAttr2:ReInit(self.activityId, 4)
  self.compNodeAttr3:ReInit(self.activityId, 3)
  self.compBriefItem1:ReInit(Localization:GetString("decoration_recruit_desc30"))
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData ~= nil then
    local critRewardStr = activityData:GetCanCritDecorationNameStr()
    local critProb, critValue = DataCenter.ActivityDecorationGachaManager:GetCriticalParams(self.activityId)
    local critProbStr = string.formatDecimal(critProb / 100, 2) .. "%"
    self.compBriefItem2:ReInit(Localization:GetString("decoration_recruit_desc50", critRewardStr, critProbStr, tostring(critValue)))
    if activityData.data ~= nil then
      self.compBriefItem3:ReInit(Localization:GetString("decoration_recruit_desc32", tostring(activityData:GetPity())))
    end
  end
  self.compBriefItem4:ReInit(Localization:GetString("decoration_recruit_desc33"))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBriefTextContent.transform)
end

function ActivityDecorationGachaRulesView:UpdateDetailContent()
  local decorationProbability = DataCenter.ActivityDecorationGachaManager:GetTotalProbabilityByItemType(self.activityId, DataCenter.ActivityDecorationGachaManager.ItemType.Decoration)
  local decorationProbabilityStr = string.formatDecimal(decorationProbability / 100, 2) .. "%"
  self.textDecorationProbability:SetText(decorationProbabilityStr)
  local goodsProbability = DataCenter.ActivityDecorationGachaManager:GetTotalProbabilityByItemType(self.activityId, DataCenter.ActivityDecorationGachaManager.ItemType.Goods)
  local goodsProbabilityStr = string.formatDecimal(goodsProbability / 100, 2) .. "%"
  self.textItemProbability:SetText(goodsProbabilityStr)
  self.compDetailCanvasGroup:SetAlpha(0)
  local hasRebuildLayout = false
  self:ClearDecorationScroll()
  local decorationTemplates = DataCenter.ActivityDecorationGachaManager:GetAllProbabilityTemplate(self.activityId, DataCenter.ActivityDecorationGachaManager.ItemType.Decoration)
  local hasDoneDecoration = false
  local hasDoneGoods = false
  for i = 1, #decorationTemplates do
    self.reqsDecoration[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaRulesDecorationItem.prefab", function(request)
      if request.isError or self.compDecorationContent == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compDecorationContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_deco_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compDecorationContent:AddComponent(ActivityDecorationGachaRulesDecorationItemComponent, go.name)
      cell:ReInit(self.activityId, decorationTemplates[i])
      self.itemsDecoration[i] = cell
      if i == #decorationTemplates then
        hasDoneDecoration = true
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
  local goodsTemplates = DataCenter.ActivityDecorationGachaManager:GetAllProbabilityTemplate(self.activityId, DataCenter.ActivityDecorationGachaManager.ItemType.Goods)
  for i = 1, #goodsTemplates do
    self.reqsGoods[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaRulesGoodsItem.prefab", function(request)
      if request.isError or self.compGoodsContent == nil then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compGoodsContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "item_goods_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compGoodsContent:AddComponent(ActivityDecorationGachaRulesGoodsItemComponent, go.name)
      cell:ReInit(self.activityId, goodsTemplates[i])
      self.itemsGoods[i] = cell
      if i == #goodsTemplates then
        hasDoneGoods = true
        if not hasRebuildLayout and hasDoneDecoration then
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
end

function ActivityDecorationGachaRulesView:ClearDecorationScroll()
  self.compDecorationContent:RemoveComponents(ActivityDecorationGachaRulesDecorationItemComponent)
  if self.reqsDecoration and next(self.reqsDecoration) then
    for k, v in pairs(self.reqsDecoration) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqsDecoration = {}
  self.itemsDecoration = {}
end

function ActivityDecorationGachaRulesView:ClearGoodsScroll()
  self.compGoodsContent:RemoveComponents(ActivityDecorationGachaRulesGoodsItemComponent)
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

function ActivityDecorationGachaRulesView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function ActivityDecorationGachaRulesView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function ActivityDecorationGachaRulesView:GetTabLocalText(tab)
  if tab == self.TabType.Brief then
    return Localization:GetString("decoration_recruit_btn_name5")
  end
  if tab == self.TabType.Detail then
    return Localization:GetString("decoration_recruit_btn_name1")
  end
  return ""
end

function ActivityDecorationGachaRulesView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

return ActivityDecorationGachaRulesView
