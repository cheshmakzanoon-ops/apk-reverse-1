local base = UIBaseView
local LWDecorationBookMainView = BaseClass("LWDecorationBookMainView", base)
local Localization = CS.GameEntry.Localization
local LWUIDecorationBookOverview = require("UI.LWDecorationBook.Component.LWUIDecorationBookOverview")
local LWUIDecorationBookIllustratedDetail = require("UI.LWDecorationBook.Component.LWUIDecorationBookIllustratedDetail")
local SelectColor = Color.New(0.99, 0.8, 0.44)
local UnselectColor = Color.New(1, 0.9, 8)
local TabName = {
  [DecorationBookTab.Overview] = "building_center_pagename1",
  [DecorationBookTab.Illustrated] = "building_center_pagename2"
}
local panelContainer_path = "safeArea/panelContainer"
local closeBtn_path = "safeArea/BottomBar/BtnBack"
local toggle_path = "safeArea/tabsSv/Viewport/Content/Toggle"
local assetsPath = "Assets/Main/Prefabs/UI/UIDecorationBook/%s.prefab"
local info_btn_path = "safeArea/TopBar/InfoBtn"
local subPanelConf = {
  [DecorationBookTab.Overview] = {
    Asset = "UIDecorationBookOverview",
    Script = LWUIDecorationBookOverview
  },
  [DecorationBookTab.Illustrated] = {
    Asset = "UIDecorationBookillustratedDetail",
    Script = LWUIDecorationBookIllustratedDetail
  }
}

function LWDecorationBookMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function LWDecorationBookMainView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWDecorationBookMainView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, "safeArea/BottomBar/BtnBack")
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
  self.togglesTbN = {}
  for i = 1, 2 do
    local tempPath = toggle_path .. i
    local toggle = self:AddComponent(UIButton, tempPath)
    toggle:SetOnClick(function()
      self:ChangeShowType(i)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.nameN = toggle:AddComponent(UIText, "activityName")
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    table.insert(self.togglesTbN, newTog)
  end
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:DecoInfoBtnClick()
  end)
end

function LWDecorationBookMainView:ComponentDestroy()
  self.closeBtnN = nil
  self.rankBtnN = nil
  self.rewardBtnN = nil
  self.togglesTbN = nil
  self.infoBtnN = nil
  self.panelContainerN = nil
  self.rankBtnTxtN = nil
  self.rewardBtnTxtN = nil
end

function LWDecorationBookMainView:DataDefine()
  self.panelList = {}
  self.reqList = {}
  self.curTabIndex = nil
end

function LWDecorationBookMainView:DataDestroy()
  self.panelList = nil
  self.reqList = nil
  self.curTabIndex = nil
end

function LWDecorationBookMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorateRedPoint, self.OnRefreshCallback)
end

function LWDecorationBookMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorateRedPoint, self.OnRefreshCallback)
  base.OnRemoveListener(self)
end

function LWDecorationBookMainView:InitUI()
  local targetTabIndex = self:GetUserData()
  targetTabIndex = targetTabIndex or DecorationBookTab.Overview
  targetTabIndex = self:RefreshTabs(targetTabIndex)
  self:ChangeShowType(targetTabIndex)
end

function LWDecorationBookMainView:RefreshAll()
  local tempIndex = self:RefreshTabs(self.curTabIndex)
  self:ChangeShowType(tempIndex)
end

function LWDecorationBookMainView:RefreshTabs(targetTabIndex)
  for i, v in ipairs(self.togglesTbN) do
    v.nameN:SetText(TabName[i] and Localization:GetString(TabName[i]) or "")
    v.isVisible = true
    v.toggleN:SetActive(true)
  end
  targetTabIndex = targetTabIndex or 1
  if not self.togglesTbN[targetTabIndex].isVisible then
    for i, v in ipairs(self.togglesTbN) do
      if v.isVisible then
        targetTabIndex = i
        break
      end
    end
  end
  return targetTabIndex
end

function LWDecorationBookMainView:OnRefreshCallback()
  self:RefreshRed()
end

function LWDecorationBookMainView:ChangeShowType(tabIndex)
  for i = 1, #self.togglesTbN do
    self.togglesTbN[i].chooseN:SetActive(i == tabIndex)
  end
  local prefabName = subPanelConf[tabIndex].Asset
  if self.curTabIndex and prefabName == subPanelConf[self.curTabIndex].Asset then
    self.curTabIndex = tabIndex
    self:RefreshOnShowPanel()
  elseif not self.panelList[prefabName] then
    if self.reqList[prefabName] then
      return
    end
    local assetFullPath = string.format(assetsPath, prefabName)
    self.reqList[prefabName] = self:GameObjectInstantiateAsync(assetFullPath, function(request)
      if request.isError then
        return
      end
      if self.curTabIndex then
        self.panelList[subPanelConf[self.curTabIndex].Asset]:SetActive(false)
      end
      self.curTabIndex = tabIndex
      local go = request.gameObject
      go.transform:SetParent(self.panelContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local v3 = go.transform.position
      v3.x = 0
      v3.y = 0
      go.transform.position = v3
      local cell = self.panelContainerN:AddComponent(subPanelConf[tabIndex].Script, go)
      self.panelList[prefabName] = cell
      self.panelList[prefabName]:SetActive(true)
      self:RefreshOnShowPanel()
    end)
  else
    if self.curTabIndex then
      self.panelList[subPanelConf[self.curTabIndex].Asset]:SetActive(false)
    end
    self.curTabIndex = tabIndex
    self.panelList[prefabName]:SetActive(true)
    self:RefreshOnShowPanel()
  end
end

function LWDecorationBookMainView:RefreshOnShowPanel()
  local tempPanel = subPanelConf[self.curTabIndex].Asset
  local showType = self.curTabIndex
  self.panelList[tempPanel]:ShowPanel(showType)
  self:RefreshRed()
end

function LWDecorationBookMainView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function LWDecorationBookMainView:RefreshRed()
  for i, v in ipairs(self.togglesTbN) do
    local redCount = self:GetRedCountByType(i)
    if redCount and 0 < redCount then
      v.redN:SetActive(true)
    else
      v.redN:SetActive(false)
    end
  end
end

function LWDecorationBookMainView:GetRedCountByType(tabType)
  if tabType == DecorationBookTab.Illustrated then
    local redCount = DataCenter.BuildManager:IsDecoratorHasRedDot() and 1 or 0
    return redCount
  else
    return 0
  end
end

function LWDecorationBookMainView:DecoInfoBtnClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("decoration_info")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return LWDecorationBookMainView
