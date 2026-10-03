local UIBFDsbDuelActRulesView = BaseClass("UIBFDsbDuelActRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ToggleEnum = {
  TimeDetail = 1,
  GroupRules = 2,
  MatchDetail = 3,
  RewardDetail = 4
}
local ContentConfig = {
  [ToggleEnum.TimeDetail] = {
    componentPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesTimeDetail.prefab",
    componentClass = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesTimeDetail")
  },
  [ToggleEnum.GroupRules] = {
    componentPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesGroupRulesDetail.prefab",
    componentClass = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesGroupRulesDetail")
  },
  [ToggleEnum.MatchDetail] = {
    componentPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesMatchDetail.prefab",
    componentClass = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesMatchDetail")
  },
  [ToggleEnum.RewardDetail] = {
    componentPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesRewardDetail.prefab",
    componentClass = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesRewardDetail")
  }
}
local UIBFDsbDuelActRulesToggle = require("UI.BFDsbDuel.BFDsbDuelRules.Component.UIBFDsbDuelActRulesToggle")

function UIBFDsbDuelActRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIBFDsbDuelActRulesView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compTabListView = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compToggleGroupRules = self.viewSkin:AddComponent(self, UIBFDsbDuelActRulesToggle, 3)
  self.compToggleTimeDetail = self.viewSkin:AddComponent(self, UIBFDsbDuelActRulesToggle, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnServerInfo = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnServerInfo:SetOnClick(function()
    self:OnBtnServerInfoClick()
  end)
  self.compToggleMatchDetail = self.viewSkin:AddComponent(self, UIBFDsbDuelActRulesToggle, 10)
  self.compToggleRewardDetail = self.viewSkin:AddComponent(self, UIBFDsbDuelActRulesToggle, 11)
  self.compTab = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.toggles = {
    self.compToggleTimeDetail,
    self.compToggleGroupRules,
    self.compToggleMatchDetail,
    self.compToggleRewardDetail
  }
  self.contentComponents = {}
  self.loadingComponents = {}
  self.contentRequests = {}
end

function UIBFDsbDuelActRulesView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.compTabListView = nil
  self.compToggleGroupRules = nil
  self.compToggleTimeDetail = nil
  self.compContent = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textServer = nil
  self.btnServerInfo = nil
  self.compToggleMatchDetail = nil
  self.compToggleRewardDetail = nil
  self.compTab = nil
  if self.contentRequests then
    for tabId, req in pairs(self.contentRequests) do
      if req then
        self:GameObjectDestroy(req)
      end
    end
  end
  self.contentComponents = nil
  self.loadingComponents = nil
  self.contentRequests = nil
  self.toggles = nil
  self.currentTabId = nil
end

function UIBFDsbDuelActRulesView:DataDefine()
  self.textTitle:SetText(Localization:GetString("dsb_duel_interface_1034"))
end

function UIBFDsbDuelActRulesView:DataDestroy()
end

function UIBFDsbDuelActRulesView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DSBDuelChangeRulesViewTab, self.OnChangeTab)
end

function UIBFDsbDuelActRulesView:OnRemoveListener()
  self:RemoveUIListener(EventId.DSBDuelChangeRulesViewTab, self.OnChangeTab)
  base.OnRemoveListener(self)
end

local TOGGLE_WIDTH = 320

function UIBFDsbDuelActRulesView:OnChangeTab(tabId)
  if 0 < tabId and tabId <= #self.toggles then
    local targetPosX = math.max(-(4 * (TOGGLE_WIDTH - 10) - 720), -(tabId - 1) * TOGGLE_WIDTH)
    self.compTab.rectTransform:Set_anchoredPosition(targetPosX, 0)
    self.toggles[tabId].toggle:SetIsOn(true)
  end
end

function UIBFDsbDuelActRulesView:OnTabClick(tabId)
  if self.currentTabId == tabId then
    return
  end
  self.currentTabId = tabId
  self:UpdateContent(tabId)
end

function UIBFDsbDuelActRulesView:UpdateContent(tabId)
  self.textServer:SetActive(tabId ~= BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Reward)
  for key, component in pairs(self.contentComponents) do
    if component and component.gameObject then
      component.gameObject:SetActive(false)
    end
  end
  local config = ContentConfig[tabId]
  if not config then
    return
  end
  if self.contentComponents[tabId] then
    local component = self.contentComponents[tabId]
    component.gameObject:SetActive(true)
    local dataList = self.ctrl:GetRulesData(tabId)
    if dataList then
      component:UpdateData(dataList)
    end
    return
  end
  if self.loadingComponents[tabId] then
    return
  end
  self.loadingComponents[tabId] = true
  self.contentRequests[tabId] = self:GameObjectInstantiateAsync(config.componentPath, function(req)
    self.loadingComponents[tabId] = nil
    if IsNull(req.gameObject) then
      Logger.LogError("Load content component failed: " .. config.componentPath)
      return
    end
    if IsNull(self.compContent.gameObject) then
      return
    end
    local go = req.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_pivot(0.5, 1)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_anchoredPosition(0, 0)
    go.name = "Content_" .. tabId
    local componentClass = config.componentClass
    if not componentClass then
      Logger.LogError("Component class is nil: " .. tabId)
      return
    end
    local newCom = self:AddComponent(componentClass, "PopUpTitle/Common_bg_orange2/Content/" .. go.name)
    self.contentComponents[tabId] = newCom
    local dataList = self.ctrl:GetRulesData(tabId)
    if dataList then
      newCom:UpdateData(dataList)
    end
  end)
end

function UIBFDsbDuelActRulesView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActRulesView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActRulesView:OnBtnServerInfoClick()
  local serverList = BattlefieldDsbDuelUtils.ActInfo:GetServerList() or {}
  local str = Localization:GetString("dsb_duel_guide_tips_1015", table.count(serverList), " " .. table.concat(serverList, ","))
  UIUtil.ShowBubbleTips(str, self.btnServerInfo.transform.position, -15, -30, 0)
end

function UIBFDsbDuelActRulesView:ReInit()
  for i, toggle in ipairs(self.toggles) do
    toggle:ReInit({
      tabId = i,
      clickHandler = function(tabId)
        self:OnTabClick(tabId)
      end
    })
  end
  local targetTabId, extParam = self:GetUserData()
  self.extParam = extParam
  targetTabId = targetTabId or ToggleEnum.TimeDetail
  self:OnChangeTab(targetTabId)
  self:UpdateContent(targetTabId)
  local serverList = BattlefieldDsbDuelUtils.ActInfo:GetServerList() or {}
  self.textServer:SetLocalText("dsb_duel_guide_tips_1015", table.count(serverList), table.concat(serverList, ","))
end

return UIBFDsbDuelActRulesView
