local AllyDuelScoreGachaRulesView = BaseClass("AllyDuelScoreGachaRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllyDuelScoreGachaRulesTextItemComponent = require("UI/UIAllyDuel/Component/AllyDuelScoreGacha/AllyDuelScoreGachaRules/Component/AllyDuelScoreGachaRulesTextItemComponent")
local AllyDuelScoreGachaRulesGoodsItemComponent = require("UI/UIAllyDuel/Component/AllyDuelScoreGacha/AllyDuelScoreGachaRules/Component/AllyDuelScoreGachaRulesGoodsItemComponent")
AllyDuelScoreGachaRulesView.TabType = {Brief = 1, Detail = 2}

function AllyDuelScoreGachaRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.Brief
  self:UpdateTab()
  self:UpdateContent()
end

function AllyDuelScoreGachaRulesView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelScoreGachaRulesView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("alliance_duel_gacha_tips_1008"))
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
  self.compBriefItem1 = self:AddComponent(AllyDuelScoreGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem1")
  self.compBriefItem2 = self:AddComponent(AllyDuelScoreGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem2")
  self.compBriefItem3 = self:AddComponent(AllyDuelScoreGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem3")
  self.compBriefItem4 = self:AddComponent(AllyDuelScoreGachaRulesTextItemComponent, "BriefContent/Common_bg/BriefScroll/Viewport/BriefLayout/BriefItem4")
  self.compDetailCanvasGroup = self:AddComponent(UICanvasGroup, "DetailContent")
  self.compDetailContent = self:AddComponent(UIBaseContainer, "DetailContent")
  self.compDetailLayout = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout")
  self.compDetailScroll = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll")
  self.textItemTitle = self:AddComponent(UIText, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/ItemTitle/ItemTitleText")
  self.textItemTitle:SetText(Localization:GetString("alliance_duel_gacha_tips_1013"))
  self.textItemProbability = self:AddComponent(UIText, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/ItemTitle/ItemProbabilityText")
  self.compGoodsContent = self:AddComponent(UIBaseContainer, "DetailContent/Common_bg/DetailScroll/Viewport/DetailLayout/GoodsContent")
end

function AllyDuelScoreGachaRulesView:ComponentDestroy()
  self:ClearGoodsScroll()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTabLayout = nil
  self.compBriefContent = nil
  self.compBriefItem1 = nil
  self.compBriefItem2 = nil
  self.compBriefItem3 = nil
  self.compBriefItem4 = nil
  self.textItemTitle = nil
  self.textItemProbability = nil
  self.compGoodsContent = nil
  self.compTabList = nil
  self.compDetailScroll = nil
  self.compDetailCanvasGroup = nil
  self.compBriefTextContent = nil
  self.compDetailLayout = nil
end

function AllyDuelScoreGachaRulesView:DataDefine()
  self.hasInitTab = {}
  self.configId = self:GetUserData()
end

function AllyDuelScoreGachaRulesView:DataDestroy()
  self.hasInitTab = nil
end

function AllyDuelScoreGachaRulesView:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelScoreGachaRulesView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelScoreGachaRulesView:UpdateTab()
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

function AllyDuelScoreGachaRulesView:UpdateContent()
  if self.curSelectTab == nil or self.configId == nil then
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

function AllyDuelScoreGachaRulesView:UpdateBriefContent()
  self.compBriefItem1:ReInit(Localization:GetString("alliance_duel_gacha_tips_1010"))
  self.compBriefItem2:ReInit(Localization:GetString("alliance_duel_gacha_tips_1011"))
  self.compBriefItem3:ReInit(Localization:GetString("alliance_duel_gacha_tips_1012"))
  self.compBriefItem4:ReInit(Localization:GetString("alliance_duel_gacha_desc_1020"))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBriefTextContent.transform)
end

function AllyDuelScoreGachaRulesView:UpdateDetailContent()
  local goodsProbabilityStr = "100%"
  self.textItemProbability:SetText(goodsProbabilityStr)
  self:ClearGoodsScroll()
  local goodsTemplates = DataCenter.AllyDuelScoreGachaManager:GetAllProbabilityTemplate(self.configId)
  for i = 1, #goodsTemplates do
    if goodsTemplates[i].pos ~= -1 then
      local idx = i
      self.reqsGoods[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelScoreGacha/UIAllyDuelGachaRulesGoodsItem.prefab", function(request)
        if request.isError or self.compGoodsContent == nil then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.compGoodsContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = "item_goods_" .. tostring(idx)
        go.name = nameStr
        go.gameObject:SetActive(true)
        local cell = self.compGoodsContent:AddComponent(AllyDuelScoreGachaRulesGoodsItemComponent, go.name)
        cell:ReInit(self.configId, goodsTemplates[idx])
        self.itemsGoods[idx] = cell
      end)
    end
  end
end

function AllyDuelScoreGachaRulesView:ClearGoodsScroll()
  self.compGoodsContent:RemoveComponents(AllyDuelScoreGachaRulesGoodsItemComponent)
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

function AllyDuelScoreGachaRulesView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function AllyDuelScoreGachaRulesView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function AllyDuelScoreGachaRulesView:GetTabLocalText(tab)
  if tab == self.TabType.Brief then
    return Localization:GetString("alliance_duel_gacha_tips_1009")
  end
  if tab == self.TabType.Detail then
    return Localization:GetString("alliance_duel_gacha_tips_1013")
  end
  return ""
end

function AllyDuelScoreGachaRulesView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
end

return AllyDuelScoreGachaRulesView
