local LWSeasonMainView = BaseClass("LWSeasonMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonMainTabItem = require("UI.LWSeason.LWSeasonMain.Component.LWSeasonMainTabItem")
local SeasonInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonInfo.SeasonInfo")
local UILWActPeriodicCard = require("UI.LWSeason.LWSeasonMain.Component.UILWActPeriodicCard")
local lastActiveId
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local top_bar_path = "Root/TopBar"
local tab_path = "Root/TopBar/Tab"
local tab_item_path = "Root/TopBar/Tab/TabItem"
local content_path = "Root/Container/Content"
local mask_path = "mask"

function LWSeasonMainView:InitTabList()
  self:RegisterTab(SeasonInfo, "Assets/Main/Prefabs/UI/LWSeason/LWSeasonMainPage.prefab", nil, "100356")
  local activityList = self.ctrl:GetActivityGroupList()
  for i, v in ipairs(activityList) do
    if v and v.name and v.id then
      Logger.Log("\232\181\155\229\173\163\230\180\187\229\138\168: " .. v.id)
      self:RegisterTab(nil, nil, v, v.name)
    end
  end
end

function LWSeasonMainView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self:ComponentDefine()
  self.initFinish = false
  self:InitTabList()
  self.top_bar:SetHorizontalNormalizedPosition(0)
  self.initFinish = true
  local activeIndex = 1
  local activeTab = self.tabList[1]
  if param ~= nil then
    lastActiveId = tostring(param)
  end
  if lastActiveId ~= nil then
    for index, tab in ipairs(self.tabList) do
      if tab and tab:GetActive() and tab.activityId == lastActiveId then
        activeTab = tab
        activeIndex = index
        break
      end
    end
  end
  if activeTab then
    activeTab:SetIsOn(true)
    local count = #self.tabList
    if self.tabActive == nil then
      activeTab:OnSelectStatusChanged(true)
    end
    if 3 < count then
      self.top_bar:SetHorizontalNormalizedPosition((activeIndex - 1) / (count - 1))
    else
      self.top_bar:SetHorizontalNormalizedPosition(0)
    end
  end
  self.mask:SetActive(false)
end

function LWSeasonMainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonWeekCardInfo, self.OnWeekCardUpdate)
  self:AddUIListener(EventId.SeasonMainViewMaskShow, self.ShowMask)
  self:AddUIListener(EventId.SeasonMainViewMaskHide, self.HideMask)
end

function LWSeasonMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonWeekCardInfo, self.OnWeekCardUpdate)
  self:RemoveUIListener(EventId.SeasonMainViewMaskShow, self.ShowMask)
  self:RemoveUIListener(EventId.SeasonMainViewMaskHide, self.HideMask)
  base.OnRemoveListener(self)
end

function LWSeasonMainView:ComponentDefine()
  self.tabActive = nil
  self.tabList = {}
  self.panelList = {}
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("100356")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.top_bar = self:AddComponent(UIScrollRect, top_bar_path)
  self.tab_item = self.transform:Find(tab_item_path).gameObject
  self.tab_item:GameObjectCreatePool()
  self.tab_root = self:AddComponent(UIBaseContainer, tab_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.mask = self:AddComponent(UIBaseContainer, mask_path)
end

function LWSeasonMainView:ComponentDestroy()
  self.TabWeekCard = nil
  self.tab_root:RemoveComponents(LWSeasonMainTabItem)
  self.tab_item:GameObjectRecycleAll()
  for k, v in pairs(self.panelList) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.tabList = {}
  self.panelList = {}
  self.btn_back = nil
  self:HideMask()
  self.mask = nil
end

function LWSeasonMainView:RegisterTab(class, assetPath, data, tabName, tabIdentify)
  local goItem = self.tab_item:GameObjectSpawn(self.tab_root.transform)
  local index = #self.tabList + 1
  if data and data.id then
    goItem.name = "tab_" .. data.id
  elseif tabName then
    goItem.name = "tab_" .. tabName
  else
    goItem.name = "tab_" .. index
  end
  goItem:SetActive(true)
  local theTabItem = self.tab_root:AddComponent(LWSeasonMainTabItem, goItem.name)
  theTabItem:ReInit(index, class, assetPath, data, tabName, tabIdentify)
  table.insert(self.tabList, theTabItem)
  return theTabItem
end

function LWSeasonMainView:ShowTabItemAnim()
  if self.tabActive ~= nil then
    local tabTransform = self.tab_root.transform
    local x = tabTransform.anchoredPosition.x
    local min_x = 300 - 300 * self.tabActive.index
    local max_x = min_x + self.rectTransform.rect.width - 300
    if x < min_x then
      tabTransform:DOMove(tabTransform.position + Vector3(min_x - x, 0, 0), 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuart)
    elseif x > max_x then
      tabTransform:DOMove(tabTransform.position + Vector3(max_x - x, 0, 0), 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuart)
    end
  end
end

function LWSeasonMainView:OnTabActive(tab)
  if not self.initFinish or self.tabActive == tab then
    return
  end
  local tempComp = self.tabActive and self.tabActive.content_ui or nil
  lastActiveId = tab.activityId
  self.tabActive = tab
  if tab.assetPath and tab.class then
    local activityId = tab.activityId
    local activityData = tab.data
    local cell = tab.content_ui
    if cell ~= nil and self.panelList[tab.index] then
      cell:SetActive(true)
      cell:SetData(activityId, activityData)
      self:ShowTabItemAnim()
      if tempComp then
        tempComp:SetActive(false)
      end
      return
    end
    self.panelList[tab.index] = self:GameObjectInstantiateAsync(tab.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      rectTransform:Set_offsetMin(0, 0)
      rectTransform:Set_offsetMax(0, 0)
      go.name = "tab_" .. tab.index
      local newCell = self.content:AddComponent(tab.class, go.name)
      newCell:SetData(activityId, activityData)
      tab.content_ui = newCell
      if self.tabActive == tab then
        newCell:SetActive(true)
        self:ShowTabItemAnim()
        if tempComp then
          tempComp:SetActive(false)
        end
      else
        newCell:SetActive(false)
      end
    end)
  elseif tempComp then
    tempComp:SetActive(false)
  end
end

function LWSeasonMainView:TryAddWeekCard(first)
end

function LWSeasonMainView:OnWeekCardUpdate(cardId)
end

function LWSeasonMainView:ShowMask()
  self.showMaskTime = 3
  self.mask:SetActive(true)
end

function LWSeasonMainView:HideMask()
  self.showMaskTime = nil
  self.mask:SetActive(false)
end

function LWSeasonMainView:Update1000MS()
  if self.showMaskTime then
    self.showMaskTime = self.showMaskTime - 1
    if self.showMaskTime <= 0 then
      self:HideMask()
    end
  end
end

return LWSeasonMainView
