local base = UIBaseView
local UILWBlackMarketProbabView = BaseClass("UILWBlackMarketProbabView", base)
local Localization = CS.GameEntry.Localization
local ProbabProductLine = require("UI.UILWBlackMarketProbab.Component.ProbabProductLine")
local contentList_path = "PopUpTitle/Common_bg_orange2/contentScroll"
local contentContainer_path = "PopUpTitle/Common_bg_orange2/contentScroll/viewport/content"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_txt_path = "PopUpTitle/Common_img_title/titleText"
local closePanel_btn_path = "panel"
local tabs_path = {
  "PopUpTitle/tabs/tab1",
  "PopUpTitle/tabs/tab2",
  "PopUpTitle/tabs/tab3",
  "PopUpTitle/tabs/tab4"
}
local tabSelecteds_path = {
  "PopUpTitle/tabs/tab1/selected1",
  "PopUpTitle/tabs/tab2/selected2",
  "PopUpTitle/tabs/tab3/selected3",
  "PopUpTitle/tabs/tab4/selected4"
}
local tabBtns_path = {
  "PopUpTitle/tabs/tab1/btn1",
  "PopUpTitle/tabs/tab2/btn2",
  "PopUpTitle/tabs/tab3/btn3",
  "PopUpTitle/tabs/tab4/btn4"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.marketType, self.ruleDesc, self.actPara6 = self:GetUserData()
  self.actPara6s = {}
  for k, v in string.gmatch(self.actPara6, "(%d+);(%d+)") do
    self.actPara6s[tonumber(k)] = tonumber(v)
  end
  self.ruleTxt = Localization:GetString(self.ruleDesc)
  local randomPools = DataCenter.ActBlackMarketTemplateDataManager:GetTypeRandomPoolTypes(self.marketType)
  for i = 1, #randomPools do
    self.tabs[i]:SetActive(randomPools[i] ~= nil)
  end
  self:GotoTab(1)
end

local function OnDestroy(self)
  self.contentContainer:RemoveAllComponentes()
  self.contentList:ClearAllItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local showInfo = self.showData[index]
  local item
  if type(showInfo) == "string" then
    item = loopScroll:NewListViewItem("desc_txt")
    local script = self.contentContainer:GetComponent(item.gameObject.name, UIText)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.contentContainer:AddComponent(UIText, objectName)
    end
    script:SetText(showInfo)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(script.rectTransform)
  else
    item = loopScroll:NewListViewItem("productsLine")
    local script = self.contentContainer:GetComponent(item.gameObject.name, ProbabProductLine)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.contentContainer:AddComponent(ProbabProductLine, objectName)
    end
    script:SetActive(true)
    script:SetData(showInfo[1], showInfo[2])
  end
  return item
end

local function ComponentDefine(self)
  self.contentList = self:AddComponent(UILoopListView2, contentList_path)
  self.contentContainer = self:AddComponent(UIBaseContainer, contentContainer_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.closePanel_btn = self:AddComponent(UIButton, closePanel_btn_path)
  self.tabs = {
    self:AddComponent(UIBaseContainer, tabs_path[1]),
    self:AddComponent(UIBaseContainer, tabs_path[2]),
    self:AddComponent(UIBaseContainer, tabs_path[3]),
    self:AddComponent(UIBaseContainer, tabs_path[4])
  }
  self.tabSelecteds = {
    self:AddComponent(UIBaseContainer, tabSelecteds_path[1]),
    self:AddComponent(UIBaseContainer, tabSelecteds_path[2]),
    self:AddComponent(UIBaseContainer, tabSelecteds_path[3]),
    self:AddComponent(UIBaseContainer, tabSelecteds_path[4])
  }
  self.tabBtns = {
    self:AddComponent(UIButton, tabBtns_path[1]),
    self:AddComponent(UIButton, tabBtns_path[2]),
    self:AddComponent(UIButton, tabBtns_path[3]),
    self:AddComponent(UIButton, tabBtns_path[4])
  }
  self.contentList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  for i = 1, #self.tabBtns do
    self.tabBtns[i]:SetOnClick(function()
      self:GotoTab(i)
    end)
  end
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.contentList = nil
  self.contentContainer = nil
  self.close_btn = nil
  self.title_txt = nil
  self.closePanel_btn = nil
  self.tabs = nil
  self.tabSelecteds = nil
  self.tabBtns = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshProbabProductList(self)
  local _showData = {}
  if self.curTab == 1 then
    self.probabInfos = nil
    _showData[1] = self.ruleTxt
  else
    self.probabInfos = DataCenter.ActBlackMarketTemplateDataManager:GetProbabInfo(self.marketType, self.curTab - 2)
    _showData[1] = Localization:GetString("blackmarket_desc10", self.actPara6s[self.curTab - 2], self.probabInfos.poolCount) or ""
    for i = 1, #self.probabInfos.pools do
      local lineData = self.probabInfos.pools[i]
      if i % 2 == 1 then
        local length = #_showData + 1
        _showData[length] = {}
        _showData[length][1] = lineData
      else
        _showData[#_showData][2] = lineData
      end
    end
  end
  self.showData = _showData
  self.contentList:SetListItemCount(#self.showData, false, false)
  self.contentList:RefreshAllShownItem()
end

local function GotoTab(self, tabIndex)
  if self.curTab ~= nil and self.curTab == tabIndex then
    return
  end
  self.curTab = tabIndex
  RefreshProbabProductList(self)
  for i = 1, #self.tabSelecteds do
    self.tabSelecteds[i]:SetActive(i == tabIndex)
  end
end

UILWBlackMarketProbabView.OnCreate = OnCreate
UILWBlackMarketProbabView.OnDestroy = OnDestroy
UILWBlackMarketProbabView.OnEnable = OnEnable
UILWBlackMarketProbabView.OnDisable = OnDisable
UILWBlackMarketProbabView.ComponentDefine = ComponentDefine
UILWBlackMarketProbabView.ComponentDestroy = ComponentDestroy
UILWBlackMarketProbabView.DataDefine = DataDefine
UILWBlackMarketProbabView.DataDestroy = DataDestroy
UILWBlackMarketProbabView.GotoTab = GotoTab
return UILWBlackMarketProbabView
