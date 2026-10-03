local LWEffectOverviewView = BaseClass("LWEffectOverviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWEffectOverviewItem = require("UI.LWEffectOverview.Component.LWEffectOverviewCanFoldItem")
local CityShieldPage = require("UI.UILWCityShield.Component.CityShieldPage")
local titlePath = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local black_mask_path = "UICommonPopUpTitle/panel"
local content_path = "Root/Scroll/Viewport/Content"
local tab_path = "Root/TabLayout/Viewport/Content/Tab%d"
local tab_btn_path = "Btn"
local tab_select_path = "Select"
local tab_unselect_path = "UnSelect"
local tab_name_path = "name"
local info_btn_path = "Root/InfoBtn"
local TabType = {
  Shield = 1,
  Combat = 2,
  Economic = 3
}

function LWEffectOverviewView:OnCreate()
  base.OnCreate(self)
  self.data = DataCenter.LWEffectOverviewManager:GetShowData()
  self.selectIndex = 1
  self.showData = {}
  self.showTabData = {}
  table.insert(self.showTabData, TabType.Shield)
  for k, v in pairs(self.data) do
    local template = DataCenter.LWEffectOverviewManager:GetTemplate(v.id)
    local type = template.type
    if self.showData[type] == nil then
      self.showData[type] = {}
      table.insert(self.showTabData, type)
    end
    table.insert(self.showData[type], k)
  end
  table.sort(self.showTabData)
  for k, v in pairs(self.showData) do
    table.sort(v, function(a, b)
      local aTemplate = DataCenter.LWEffectOverviewManager:GetTemplate(self.data[a].id)
      local bTemplate = DataCenter.LWEffectOverviewManager:GetTemplate(self.data[b].id)
      if aTemplate and bTemplate then
        return aTemplate.index < bTemplate.index
      else
        return 0
      end
    end)
  end
  self:ComponentDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(62261, false)
end

function LWEffectOverviewView:OnDestroy()
  self:ComponentDestroy()
  self:CloseIntervalUpdateTimer()
  base.OnDestroy(self)
end

function LWEffectOverviewView:ComponentDefine()
  self.title = self:AddComponent(UIText, titlePath)
  self.title:SetLocalText(110288)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabs = {}
  for i = 1, 3 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, tab_select_path)
    tab.tab_unselect = tab.tab:AddComponent(UIBaseContainer, tab_unselect_path)
    tab.tab_name = tab.tab:AddComponent(UIText, tab_name_path)
    tab.tab_btn = tab.tab:AddComponent(UIButton, tab_btn_path)
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
  self.scroll = self:AddComponent(UIBaseContainer, "Root/Scroll")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.shieldPage = self:AddComponent(CityShieldPage, "Root/ShieldScrollView")
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("overview_sys_desc")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
end

function LWEffectOverviewView:ComponentDestroy()
  self:ClearList()
  self.title = nil
  self.close_btn = nil
  self.maskBtnN = nil
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
  self.scroll = nil
  self.content = nil
  self.info_btn = nil
end

function LWEffectOverviewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EffectOverviewDataDirty, self.RefreshView)
  self:AddUIListener(EventId.EffectNumChange, self.RefreshView)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function LWEffectOverviewView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EffectOverviewDataDirty, self.RefreshView)
  self:RemoveUIListener(EventId.EffectNumChange, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
end

function LWEffectOverviewView:ReInit()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab:SetActive(true)
      self.tabs[i].tab_name:SetText(self:GetTabNameByType(self.showTabData[i]))
    else
      self.tabs[i].tab:SetActive(false)
    end
  end
  self:RefreshBar()
  self:RefreshContent()
  self:StartIntervalUpdateTimer()
end

function LWEffectOverviewView:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function LWEffectOverviewView:RefreshContent()
  if self.selectIndex == TabType.Combat or self.selectIndex == TabType.Economic then
    self.info_btn:SetActive(true)
    self.shieldPage:SetActive(false)
    self.scroll:SetActive(true)
    self.content:SetAnchoredPositionXY(0, 0)
    self:ClearList()
    local showDataType = self.showTabData[self.selectIndex]
    if self.showData[showDataType] == nil then
      return
    end
    local showData = self.showData[showDataType]
    for k, v in pairs(showData) do
      self.cellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.UICommonPropertyCanFoldItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(k)
        go.name = nameStr
        self.cells[k] = self.content:AddComponent(LWEffectOverviewItem, nameStr)
        self.data[v].isShowDetail = true
        self.cells[k]:Refresh(self.data[v])
      end)
    end
  elseif self.selectIndex == TabType.Shield then
    self.info_btn:SetActive(false)
    self.scroll:SetActive(false)
    self.shieldPage:SetActive(true)
    self.shieldPage:Refresh()
  end
end

function LWEffectOverviewView:ClearList()
  if self.cellReqs then
    self.content:RemoveComponents(LWEffectOverviewItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWEffectOverviewView:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshBar()
  self:RefreshContent()
end

function LWEffectOverviewView:RefreshView()
  self.data = DataCenter.LWEffectOverviewManager:GetShowData()
  self:RefreshBar()
  self:RefreshContent()
end

function LWEffectOverviewView:GetTabNameByType(type)
  local name = ""
  if type == TabType.Shield then
    name = Localization:GetString("2000494")
  elseif type == TabType.Combat then
    name = Localization:GetString("110289")
  elseif type == TabType.Economic then
    name = Localization:GetString("110290")
  end
  return name
end

function LWEffectOverviewView:StartIntervalUpdateTimer()
  self:CloseIntervalUpdateTimer()
  self.intervalRefreshTimer = TimerManager:GetInstance():GetTimer(30, function()
    self:RefreshView()
  end, nil, true, false, false)
  self.intervalRefreshTimer:Start()
end

function LWEffectOverviewView:CloseIntervalUpdateTimer()
  if not self.intervalRefreshTimer then
    return
  end
  self.intervalRefreshTimer:Stop()
  self.intervalRefreshTimer = nil
end

return LWEffectOverviewView
