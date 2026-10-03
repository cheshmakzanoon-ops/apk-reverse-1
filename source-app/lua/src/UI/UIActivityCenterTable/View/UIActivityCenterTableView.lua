local UIActivityCenterTableView = BaseClass("UIActivityCenterTableView", UIBaseView)
local base = UIBaseView
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local ActivityTabGroupCell = require("UI.UIActivityCenterTable.Component.ActivityTabGroupCell")
local close_btn_path = "Root/BottomBar/BtnBack"
local white_close_btn_path = "Root/BottomBar/BtnBackWhite"
local tabScrollView_path = "Root/ContentContainer/LeftScrollView"
local content_path = "Root/ContentContainer/LeftScrollView/Viewport/Content"
local centerContent_path = "Root/ContentContainer/CenterView"
local titleText_path = "Root/TopBar/TextTitle"
local leftPointer_path = "Root/ContentContainer/LeftScrollView/LeftPointer"
local rightPointer_path = "Root/ContentContainer/LeftScrollView/RightPointer"

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:InitData()
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.whiteCloseBtn = self:AddComponent(UIButton, white_close_btn_path)
  self.whiteCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.whiteCloseBtn:SetActive(false)
  self.tabScrollViewN = self:AddComponent(UIScrollRect, tabScrollView_path)
  self.tabScrollViewN:AddValueChangeListener(function()
    self:RefreshPointer()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.centerContent = self:AddComponent(UIBaseContainer, centerContent_path)
  self.lastCurType = 0
  self.goID = 0
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.titleText:SetLocalText(2000046)
  self.titleOriginalSizeDeltaX = self.titleText.rectTransform.sizeDelta.x
  self.leftPointer = self:AddComponent(UIImage, leftPointer_path)
  self.rightPointer = self:AddComponent(UIImage, rightPointer_path)
  self.leftPointer:SetActive(false)
  self.rightPointer:SetActive(false)
  self:ReInit()
end

local function OnDestroy(self)
  if self.delayLocate then
    self.delayLocate:Stop()
    self.delayLocate = nil
  end
  CS.DynamicFPSConfig.FreeHighFPSLockerForChildrenScrollComponents(self.centerContent.gameObject)
  DataCenter.ArrowManager:RemoveArrow()
  self:SetAllTabGroupDestory()
  self.content = nil
  self.centerContent = nil
  self.closeBtn = nil
  self.whiteCloseBtn = nil
  self.lastCurType = 0
  self.goID = nil
  self.titleText = nil
  self.modelGroups = nil
  self.groupItems = nil
  self.groupDataList = nil
  self.loadedGroupNum = nil
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  base.OnDestroy(self)
end

local function ReInit(self)
  self.goID, self.preLoadAssets = self:GetUserData()
  if self.goID then
    self.goID = tonumber(self.goID)
  end
  self:OnLeftRefreshNew()
end

local function OnLeftRefreshNew(self)
  self:SetAllTabGroupDestory()
  self.loadedGroupNum = 0
  self.lastActivityId = 0
  self.groupDataList = self.ctrl:GetActivityGroupList(self.goID)
  for _, act in ipairs(self.groupDataList) do
    if act.activityList then
      act.activityList = self.ctrl:DelEndActivity(act.activityList)
    end
  end
  self.panelList = {}
  self.panelComponentList = {}
  self.groupItems = {}
  self.modelGroups = {}
  local property = self:GetAssetLoadProperty(UIAssets.ActivityTabGroupItem)
  for i, v in ipairs(self.groupDataList) do
    self.modelGroups[v.tabGroup] = self:GameObjectInstantiateAsync(UIAssets.ActivityTabGroupItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = v.tabGroup
      local cell = self.content:AddComponent(ActivityTabGroupCell, go.name, v)
      cell:RefreshGroup(v, function(act)
        if act == nil or act.tabGroup == nil then
          return false
        end
        if SubTypeActivities[act.type] ~= nil and SubTypeActivities[act.type][act.subViewType] == nil then
          return false
        end
        if ActivityContentHandler[act.type] == nil then
          return false
        end
        return true
      end)
      self.groupItems[v.tabGroup] = cell
    end, property)
  end
end

local function GotoActivityByExternal(self, tempActId)
  if not tempActId then
    return
  end
  local curAct = self.ctrl:GetCurrentActivity()
  if curAct and curAct.id == tempActId then
    return
  end
  self.goID = tempActId
  self:SelectDefaultTab()
end

local function SelectDefaultTab(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  local focusId, groupIndex, actIndex = self.ctrl:GetDefaultFocusActivity(self.groupDataList, self.goID)
  local tempInfo = self.ctrl:GetActivityDataById(focusId)
  if self.delayLocate then
    self.delayLocate:Stop()
    self.delayLocate = nil
  end
  self.delayLocate = TimerManager:GetInstance():DelayInvoke(function()
    self:LocateTab(groupIndex, actIndex, tempInfo.tabGroup, focusId)
  end, 0.1)
end

local function SelectWorldBossTab(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  local type = DataCenter.ActBossDataManager:GetCurrentType()
  if type and tonumber(type) == ActivityEnum.ActivityType.WorldBoss then
    local data = self.ctrl:GetActivityDataByType(ActivityEnum.ActivityType.WorldBoss)
    if data then
      self.goID = data.id
    else
      self.goID = nil
    end
    local focusId, groupIndex, actIndex = self.ctrl:GetDefaultFocusActivity(self.groupDataList, self.goID)
    local tempInfo = self.ctrl:GetActivityDataById(focusId)
    if self.delayLocate then
      self.delayLocate:Stop()
      self.delayLocate = nil
    end
    self.delayLocate = TimerManager:GetInstance():DelayInvoke(function()
      self:LocateTab(groupIndex, actIndex, tempInfo.tabGroup, focusId)
    end, 0.1)
  elseif tonumber(type) == EnumActivity.SurfingBattleAct.Type then
    local data = self.ctrl:GetActivityDataByType(EnumActivity.SurfingBattleAct.Type)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if data.endTime and curTime > data.endTime then
      self:SelectDefaultTab()
    end
  elseif tonumber(type) == EnumActivity.PersonalArmsNew.Type then
    local curPersonalArmsNewId = self.ctrl:GetCurrentActivityId()
    local data = self.ctrl:GetActivityDataByType(EnumActivity.PersonalArmsNew.Type)
    if data ~= nil and data.id ~= curPersonalArmsNewId then
      self.goID = data.id
      self:SelectDefaultTab()
    end
  end
end

local function OnGroupCellLoadFinish(self)
  self.loadedGroupNum = self.loadedGroupNum + 1
  if self.loadedGroupNum == #self.groupDataList then
    self:SelectDefaultTab()
  end
end

local function SetAllTabGroupDestory(self)
  if self.content == nil then
    return
  end
  self.content:RemoveComponents(ActivityTabGroupCell)
  self.centerContent:RemoveAllComponentes()
  if self.modelGroups ~= nil then
    for k, v in pairs(self.modelGroups) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    for k, v in pairs(self.panelList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function LocateTab(self, groupIndex, tabIndex, groupId, actId)
  if not self then
    return
  end
  if not groupId or not actId then
    return
  end
  local prog = 0
  local groupData = self.groupDataList[groupIndex]
  if groupData then
    prog = (tabIndex - 1) / (#groupData.activityList - 1)
  end
  self.tabScrollViewN:SetHorizontalNormalizedPosition(prog)
  if not self.groupItems[groupId] then
    return
  end
  self.groupItems[groupId]:SelectTab(actId)
end

local function RefreshRightContent(self)
  local currentActivity = self.ctrl:GetCurrentActivity()
  if currentActivity.type == self.lastCurType and currentActivity.activityId == self.lastActivityId then
    return
  end
  local tempComp
  local handlerData = DataCenter.ActivityListDataManager:GetActivityShowData(currentActivity.id)
  if self.lastCurType ~= 0 and currentActivity.activityId ~= self.lastActivityId then
    tempComp = self.panelComponentList[self.lastActivityId]
  end
  self.lastCurType = currentActivity.type
  self.lastActivityId = currentActivity.activityId
  if currentActivity.type == EnumActivity.ActDragon.Type then
    self.closeBtn:SetActive(false)
    self.whiteCloseBtn:SetActive(true)
  else
    self.closeBtn:SetActive(true)
    self.whiteCloseBtn:SetActive(false)
  end
  if handlerData ~= nil and handlerData.assetPath ~= nil and handlerData.cls ~= nil then
    if CommonUtil.IsArabic() then
      self.titleText.rectTransform.sizeDelta = Vector2.New(self.titleOriginalSizeDeltaX, self.titleText.rectTransform.sizeDelta.y)
    end
    DataCenter.ActivityTipsManager:RecordSeenUI(currentActivity.activityId, currentActivity.type)
    local cell = self.panelComponentList[currentActivity.activityId]
    if cell ~= nil and self.panelList[currentActivity.activityId] then
      cell:SetActive(true)
      cell:SetData(currentActivity.activityId, currentActivity.id)
      if self.panelComponentList then
        for k, v in pairs(self.panelComponentList) do
          if k ~= currentActivity.activityId then
            v:SetActive(false)
          end
        end
      end
      return
    end
    if self.panelList[currentActivity.activityId] then
      return
    end
    self.panelList[currentActivity.activityId] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.centerContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = tostring(currentActivity.activityId)
      local newCell = self.centerContent:AddComponent(handlerData.cls, go.name)
      self.panelComponentList[currentActivity.activityId] = newCell
      newCell:SetActive(true)
      newCell:SetData(currentActivity.activityId, currentActivity.id)
      if self.panelComponentList then
        for k, v in pairs(self.panelComponentList) do
          if k ~= currentActivity.activityId then
            v:SetActive(false)
          end
        end
      end
      local curActId = self.ctrl:GetCurrentActivityId()
      if curActId ~= currentActivity.activityId then
        newCell:SetActive(false)
      end
      CS.DynamicFPSConfig.AcquireHighFPSLockerForChildrenScrollComponents(go)
    end, self:GetAssetLoadProperty(handlerData.assetPath))
    return
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnActivityItemClick(self, id)
  local oldId = self.ctrl:GetCurrentActivityId()
  local oldGroup, newGroup
  if tonumber(oldId) ~= tonumber(id) then
    for i, v in ipairs(self.groupDataList) do
      for m, n in ipairs(v.activityList) do
        if n.id == oldId then
          oldGroup = v.tabGroup
        end
        if n.id == id then
          newGroup = v.tabGroup
        end
      end
      if oldGroup and newGroup then
        break
      end
    end
    if oldGroup then
      self.groupItems[oldGroup]:SetUnSelect(oldId)
    end
    self.groupItems[newGroup]:SetSelect(id)
    self.ctrl:SetCurrentActivityId(id)
    local type = self.ctrl:GetActivityDataById(id).type
    DataCenter.ActBossDataManager:SetCurrentType(type)
    Logger.Log("select activity id : " .. id .. "TYPE:" .. tostring(type))
  end
  self:RefreshRightContent()
  DataCenter.ActivityListDataManager:SetLastVisitedActivityId(id)
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OpenActivityPanel, tostring(id))
end

local function RefreshPointer(self)
  if not table.IsNullOrEmpty(self.groupItems) and self.content then
    local leftNum = 0
    local rightNum = 0
    local scrollPos = self.content:GetAnchoredPositionX()
    local scrollSize = self.tabScrollViewN.rectTransform.rect.width
    for i, v in pairs(self.groupItems) do
      local childLeftNum, childRightNum = v:OnScrollChanged(scrollPos, scrollSize)
      leftNum = leftNum + childLeftNum
      rightNum = rightNum + childRightNum
    end
    if 0 < leftNum then
      self.leftPointer:SetActive(true)
    else
      self.leftPointer:SetActive(false)
    end
    if 0 < rightNum then
      self.rightPointer:SetActive(true)
    else
      self.rightPointer:SetActive(false)
    end
  else
    if self.leftPointer then
      self.leftPointer:SetActive(false)
    end
    if self.rightPointer then
      self.rightPointer:SetActive(false)
    end
  end
end

local function OnOneUITopItemEnabled(self)
  if CommonUtil.IsArabic() then
    local oldSizeDeltaX = self.titleText.rectTransform.sizeDelta.x
    local oldSizeDeltaY = self.titleText.rectTransform.sizeDelta.y
    self.titleText.rectTransform.sizeDelta = Vector2.New(oldSizeDeltaX - 200, oldSizeDeltaY)
  end
end

local function CheckActivityOnPassDay(self)
  local newTabs = self.ctrl:GetActivityGroupList(self.goID)
  for _, act in ipairs(newTabs) do
    if act.activityList then
      act.activityList = self.ctrl:DelEndActivity(act.activityList)
    end
  end
  local oldTabs = self.groupDataList
  local isHaveChange = false
  if #newTabs == #oldTabs then
    for i, group in ipairs(newTabs) do
      local newGroup = group
      local oldGroup = oldTabs[i]
      local newActList = newGroup.activityList
      local oldActList = oldGroup.activityList
      if #newActList ~= #oldActList then
        isHaveChange = true
        break
      end
      for j, act in ipairs(newActList) do
        local newId = act.id
        local oldId = oldActList[j].id
        if newId ~= oldId then
          isHaveChange = true
          goto lbl_54
        end
      end
    end
  end
  ::lbl_54::
  if not isHaveChange then
    return
  end
  self.goID = nil
  self:OnLeftRefreshNew()
  self:SelectWorldBossTab()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CommonActivityGotoPage, self.GotoActivityByExternal)
  self:AddUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:AddUIListener(EventId.OnPassDay, self.CheckActivityOnPassDay)
  self:AddUIListener(EventId.ActivityPersonalArmsReplaceActivity, self.CheckActivityOnPassDay)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CommonActivityGotoPage, self.GotoActivityByExternal)
  self:RemoveUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:RemoveUIListener(EventId.OnPassDay, self.CheckActivityOnPassDay)
  self:RemoveUIListener(EventId.ActivityPersonalArmsReplaceActivity, self.CheckActivityOnPassDay)
  base.OnRemoveListener(self)
end

function UIActivityCenterTableView:GetAssetLoadProperty(assetName)
  if self.preLoadAssets and self.preLoadAssets[assetName] then
    return AssetLoadPriority.UltraHigh
  end
  return nil
end

UIActivityCenterTableView.OnCreate = OnCreate
UIActivityCenterTableView.OnDestroy = OnDestroy
UIActivityCenterTableView.OnLeftRefresh = OnLeftRefresh
UIActivityCenterTableView.RefreshRightContent = RefreshRightContent
UIActivityCenterTableView.OnEnable = OnEnable
UIActivityCenterTableView.OnDisable = OnDisable
UIActivityCenterTableView.ReInit = ReInit
UIActivityCenterTableView.OnLeftRefreshNew = OnLeftRefreshNew
UIActivityCenterTableView.GotoActivityByExternal = GotoActivityByExternal
UIActivityCenterTableView.SelectDefaultTab = SelectDefaultTab
UIActivityCenterTableView.OnGroupCellLoadFinish = OnGroupCellLoadFinish
UIActivityCenterTableView.SetAllTabGroupDestory = SetAllTabGroupDestory
UIActivityCenterTableView.OnActivityItemClick = OnActivityItemClick
UIActivityCenterTableView.SetAllCellDestroy = SetAllCellDestroy
UIActivityCenterTableView.LocateTab = LocateTab
UIActivityCenterTableView.RefreshPointer = RefreshPointer
UIActivityCenterTableView.OnAddListener = OnAddListener
UIActivityCenterTableView.OnRemoveListener = OnRemoveListener
UIActivityCenterTableView.OnOneUITopItemEnabled = OnOneUITopItemEnabled
UIActivityCenterTableView.CheckActivityOnPassDay = CheckActivityOnPassDay
UIActivityCenterTableView.SelectWorldBossTab = SelectWorldBossTab
return UIActivityCenterTableView
