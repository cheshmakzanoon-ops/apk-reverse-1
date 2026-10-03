local UILWSeasonCityTabLogic = BaseClass("UILWSeasonCityTabLogic")
local UISeasonCommonTabItem = require("UI.LWSeasonShared.UILWSeasonCityOccupyList.UISeasonCommonTabItem")
local UICampScienceDestroyTabLogic = require("UI.LWSeasonShared.UILWSeasonCityOccupyList.UICampScienceDestroyTabLogic")
local UICampScienceOccTabLogic = require("UI.LWSeasonShared.UILWSeasonCityOccupyList.UICampScienceOccTabLogic")
local UILWSeasonCityAltarListComp = require("UI.LWSeasonShared.UILWSeasonCityAltar.UILWSeasonCityAltarListComp")
local CityTabPrefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/UICityTabItem.prefab"
UILWSeasonCityTabLogic.TabListIndex = {
  CampScienceOcc = 4,
  CampScienceDestroy = 5,
  CityAltar = 6
}
local TabList = {
  [UILWSeasonCityTabLogic.TabListIndex.CampScienceOcc] = {
    name = "season_camp_science_ui_15_tab",
    order = 1,
    contentPrefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampScienceOcc.prefab",
    contentLogic = UICampScienceOccTabLogic,
    redHandle = function()
      return DataCenter.CampProduceDataManager:GetProduceRed()
    end,
    canShow = function()
      return DataCenter.CampScienceDataManager:IsOpenCampScience() and SeasonUtil.GetSeason() == 6
    end
  },
  [UILWSeasonCityTabLogic.TabListIndex.CampScienceDestroy] = {
    name = "season_camp_science_ui_16_tab",
    order = 2,
    contentPrefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CampScience/UICampScienceDestroy.prefab",
    contentLogic = UICampScienceDestroyTabLogic,
    redHandle = function()
      return DataCenter.CampProduceDataManager:GetDestroyRed()
    end,
    canShow = function()
      return DataCenter.CampScienceDataManager:IsOpenCampScience() and SeasonUtil.GetSeason() == 6
    end
  },
  [UILWSeasonCityTabLogic.TabListIndex.CityAltar] = {
    name = "season_s6_activity1200109_desc10",
    order = 3,
    contentPrefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/CityAltar/UICityAltarList.prefab",
    contentLogic = UILWSeasonCityAltarListComp,
    redHandle = function()
      return false
    end
  }
}

function UILWSeasonCityTabLogic:TryToAddTab(tabScroll, tabContent, toggleGroup, view, oldIndex)
  self.oldIndex = oldIndex
  self.tabContent = tabContent
  self.tabScroll = tabScroll
  self.toggleGroup = toggleGroup
  local showCount = 0
  for k, v in pairs(TabList) do
    local tabType = k
    local tabInfo = v
    local canShow = true
    if v.canShow then
      canShow = v.canShow()
    end
    if canShow then
      showCount = showCount + 1
      view:LoadComponentAsync(UISeasonCommonTabItem, CityTabPrefab, toggleGroup, function(holder, go, item, param)
        self.tabViews = self.tabViews or {}
        item:SetData(param)
        table.insert(self.tabViews, item)
        showCount = showCount - 1
        if showCount == 0 then
          table.sort(self.tabViews, function(a, b)
            return a.param.tabInfo.order < b.param.tabInfo.order
          end)
          for i = #self.tabViews, 1, -1 do
            self.tabViews[i].transform:SetAsFirstSibling()
          end
          for _, tabView in pairs(self.tabViews) do
            tabView:ReInit(toggleGroup, view)
          end
          self:ScrollToIndexTab(view.activeTabIndex)
        end
      end, {tabInfo = tabInfo, tabType = tabType})
    end
  end
end

function UILWSeasonCityTabLogic:OnDestroy(view)
  if self.tabViews ~= nil then
    for _, v in ipairs(self.tabViews) do
      v:SetToggleClose()
      view:RemoveAsyncComponent(v)
      CS.UnityEngine.Object.DestroyImmediate(v.gameObject)
    end
  end
  self.tabViews = nil
  self.tabLogics = nil
  self.tabLogicReqs = nil
  self.tabContent = nil
  self.tabScroll = nil
  self.toggleGroup = nil
end

function UILWSeasonCityTabLogic:CanShow(tabType)
  if (tabType == self.TabListIndex.CampScienceOcc or tabType == self.TabListIndex.CampScienceDestroy) and DataCenter.CampScienceDataManager:IsOpenCampScience() and SeasonUtil.GetSeason() == 6 then
    return true
  end
  if tabType == self.TabListIndex.CityAltar and SeasonUtil.GetSeason() == 6 then
    return true
  end
  return false
end

function UILWSeasonCityTabLogic:SelectTabLogic(view, tabIndex)
  self.tabLogics = self.tabLogics or {}
  local tabLogic = self.tabLogics[tabIndex]
  if tabLogic == nil then
    self:CreateTabLogic(view, tabIndex)
  else
    tabLogic:ReInit()
    tabLogic:SetActive(true)
  end
  if self.tabViews ~= nil then
    for _, tabView in pairs(self.tabViews) do
      tabView:RefreshRed()
    end
  end
end

function UILWSeasonCityTabLogic:HideAllTabLogic()
  if self.tabLogics ~= nil then
    for _, v in pairs(self.tabLogics) do
      v:SetActive(false)
    end
  end
end

function UILWSeasonCityTabLogic:CreateTabLogic(view, tabIndex)
  self.tabLogicReqs = self.tabLogicReqs or {}
  local req = self.tabLogicReqs[tabIndex]
  if req == nil then
    local tabInfo = TabList[tabIndex]
    self.tabLogicReqs[tabIndex] = view:GameObjectInstantiateAsync(tabInfo.contentPrefab, function()
      local obj = self.tabLogicReqs[tabIndex].gameObject
      if obj == nil then
        return
      end
      if view == nil then
        return
      end
      local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
      obj.transform:SetParent(view.dynamic_root.transform)
      obj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      rectTransform:Set_offsetMin(0, 0)
      rectTransform:Set_offsetMax(0, 0)
      local tabLogic = view.dynamic_root:AddComponent(tabInfo.contentLogic, obj.name)
      tabLogic:ReInit()
      if view.activeTabIndex == tabIndex then
        tabLogic:SetActive(true)
      else
        tabLogic:SetActive(false)
      end
      self.tabLogics[tabIndex] = tabLogic
    end)
  end
end

function UILWSeasonCityTabLogic:IsVailTabIndex(tabIndex)
  local tabInfo = TabList[tabIndex]
  if tabInfo == nil then
    return false
  end
  if not tabInfo.canShow then
    return true
  end
  return tabInfo.canShow()
end

function UILWSeasonCityTabLogic:ScrollToIndexTab(index)
  if self.tabViews == nil then
    self:ScrollToActiveTab()
    return
  end
  local tabItem
  for k, v in ipairs(self.tabViews) do
    if v.param.tabType == index then
      tabItem = v
      break
    end
  end
  if not tabItem then
    self:ScrollToActiveTab()
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tabContent.transform)
  local rootSizeDeltaX, _ = self.tabScroll:GetSizeDeltaXY()
  local contentSizeDeltaX, _ = self.tabContent:GetSizeDeltaXY()
  if rootSizeDeltaX >= contentSizeDeltaX then
    self.tabContent:SetAnchoredPositionXY(0, 0)
    return
  end
  local itemSizeDeltaX, _ = tabItem:GetSizeDeltaXY()
  local orderIndex = TabList[index].order
  local offset = (orderIndex - 1) * itemSizeDeltaX
  if offset > contentSizeDeltaX - rootSizeDeltaX then
    offset = contentSizeDeltaX - rootSizeDeltaX
  end
  self.tabContent:SetAnchoredPositionXY(-offset, 0)
end

function UILWSeasonCityTabLogic:ScrollToActiveTab()
  local theTransform = self.tabContent.transform
  if theTransform ~= nil then
    local UnityToggle = typeof(CS.UnityEngine.UI.Toggle)
    local childCnt = theTransform.childCount
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(theTransform)
    for i = 0, childCnt - 1 do
      local child = theTransform:GetChild(i)
      if child and child.gameObject then
        local go = child.gameObject
        if go.activeInHierarchy then
          local unity_toggle = go:GetComponent(UnityToggle)
          if unity_toggle and unity_toggle.isOn then
            local rootSizeDeltaX, _ = self.tabScroll:GetSizeDeltaXY()
            local contentSizeDeltaX, _ = self.tabContent:GetSizeDeltaXY()
            if rootSizeDeltaX >= contentSizeDeltaX then
              self.tabContent:SetAnchoredPositionXY(0, 0)
              break
            end
            local itemSizeDeltaX, _ = go.transform:Get_sizeDelta()
            local offset = i * itemSizeDeltaX
            if offset > contentSizeDeltaX - rootSizeDeltaX then
              offset = contentSizeDeltaX - rootSizeDeltaX
            end
            self.tabContent:SetAnchoredPositionXY(-offset, 0)
            break
          end
        end
      end
    end
  end
end

return UILWSeasonCityTabLogic
