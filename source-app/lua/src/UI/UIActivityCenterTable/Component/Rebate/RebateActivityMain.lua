local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local RebateActivityMain = BaseClass("RebateActivityMain", base)
local Localization = CS.GameEntry.Localization
local RebateGiftContent = require("UI.UIActivityCenterTable.Component.Rebate.RebateGiftContent")
local RebateShopContent = require("UI.UIActivityCenterTable.Component.Rebate.RebateShopContent")
local tab_path = "RightView/topSelectContent/Tab%d"
local tab_btn_path = "Btn"
local tab_select_path = "Select"
local tab_name_path = "name"
local tab_red_path = "red"
local bg1_path = "RightView/bg1"
local bg2_path = "RightView/bg2"
local content1_path = "RightView/content1"
local content2_path = "RightView/content2"

function RebateActivityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function RebateActivityMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RebateActivityMain:ComponentDefine()
  self.tabs = {}
  for i = 1, 2 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, tab_select_path)
    tab.tab_name = tab.tab:AddComponent(UIText, tab_name_path)
    tab.tab_btn = tab.tab:AddComponent(UIButton, tab_btn_path)
    tab.tab_red = tab.tab:AddComponent(UIBaseContainer, tab_red_path)
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
  self.bg1 = self:AddComponent(UIBaseContainer, bg1_path)
  self.bg2 = self:AddComponent(UIBaseContainer, bg2_path)
  self.content1 = self:AddComponent(RebateGiftContent, content1_path)
  self.content2 = self:AddComponent(RebateShopContent, content2_path)
end

function RebateActivityMain:ComponentDestroy()
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
  self.bg1 = nil
  self.bg2 = nil
  self.content1 = nil
  self.content2 = nil
end

function RebateActivityMain:DataDefine()
  self.activityId = -1
  self.selectIndex = 1
  self.showTabData = {
    RebateActivityTab.Gift,
    RebateActivityTab.Shop
  }
  self.showContent = {
    [RebateActivityTab.Gift] = self.content1,
    [RebateActivityTab.Shop] = self.content2
  }
  self.showBg = {
    [RebateActivityTab.Gift] = self.bg1,
    [RebateActivityTab.Shop] = self.bg2
  }
end

function RebateActivityMain:DataDestroy()
  self.activityId = nil
  self.selectIndex = nil
  self.showTabData = nil
  self.showContent = nil
  self.showBg = nil
end

function RebateActivityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshBar)
end

function RebateActivityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshBar)
  base.OnRemoveListener(self)
end

function RebateActivityMain:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
  local shopRednum = DataCenter.ActivityListDataManager:GetRebateactivityRedNum(self.activityId)
  local shopIndex = 2
  if self.showTabData[shopIndex] ~= nil then
    self.tabs[shopIndex].tab_red:SetActive(0 < shopRednum)
  end
end

function RebateActivityMain:RefreshContent()
  local curType = self.showTabData[self.selectIndex]
  if curType == nil then
    return
  end
  for k, v in pairs(self.showContent) do
    if k == curType then
      v:SetActive(true)
      v:SetData(self.activityId)
    else
      v:SetActive(false)
    end
  end
  for k, v in pairs(self.showBg) do
    if k == curType then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function RebateActivityMain:RefreshView()
  self:RefreshBar()
  self:RefreshContent()
end

function RebateActivityMain:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshView()
end

function RebateActivityMain:ReInit()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab:SetActive(true)
      self.tabs[i].tab_name:SetText(self:GetTabNameByType(self.showTabData[i]))
    else
      self.tabs[i].tab:SetActive(false)
    end
  end
end

function RebateActivityMain:GetTabNameByType(type)
  local name = ""
  if type == RebateActivityTab.Gift then
    name = Localization:GetString("2000542")
  elseif type == RebateActivityTab.Shop then
    name = Localization:GetString("2000543")
  end
  return name
end

function RebateActivityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self:RefreshView()
end

function RebateActivityMain:UpdateData()
  self:RefreshView()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

return RebateActivityMain
