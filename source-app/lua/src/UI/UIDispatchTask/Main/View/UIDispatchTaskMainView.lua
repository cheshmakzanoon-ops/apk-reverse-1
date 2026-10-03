local UIDispatchTaskMainView = BaseClass("UIDispatchTaskMainView", UIBaseView)
local base = UIBaseView
local TabGroup = require("UI.UIDispatchTask.Main.Component.UIDispatchTaskMainTabGroup")
local tabGroupPath = "Assets/Main/Prefabs/UI/DispatchTask/UIDispatchTaskMainGroupCell.prefab"
local close_btn_path = "Root/BottomBar/BtnBack"
local white_close_btn_path = "Root/BottomBar/BtnBackWhite"
local tabScrollView_path = "Root/ContentContainer/LeftScrollView"
local content_path = "Root/ContentContainer/LeftScrollView/Viewport/Content"
local centerContent_path = "Root/ContentContainer/CenterView"
local titleText_path = "Root/TopBar/TextTitle"
local leftPointer_path = "Root/ContentContainer/LeftScrollView/LeftPointer"
local rightPointer_path = "Root/ContentContainer/LeftScrollView/RightPointer"

function UIDispatchTaskMainView:OnCreate()
  base.OnCreate(self)
  self.ctrl:InitData()
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.whiteCloseBtn = self:AddComponent(UIButton, white_close_btn_path)
  self.whiteCloseBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
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
  self.goID = nil
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.titleText:SetLocalText("dispatch_des029")
  self.titleOriginalSizeDeltaX = self.titleText.rectTransform.sizeDelta.x
  self.leftPointer = self:AddComponent(UIImage, leftPointer_path)
  self.rightPointer = self:AddComponent(UIImage, rightPointer_path)
  self.leftPointer:SetActive(false)
  self.rightPointer:SetActive(false)
  self:ReInit()
end

function UIDispatchTaskMainView:OnDestroy()
  CS.DynamicFPSConfig.FreeHighFPSLockerForChildrenScrollComponents(self.centerContent.gameObject)
  DataCenter.ArrowManager:RemoveArrow()
  self:DestroyAllTabGroup()
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
  self:ClearDelay()
  base.OnDestroy(self)
end

function UIDispatchTaskMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UIDispatchTaskMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function UIDispatchTaskMainView:ReInit()
  if self.goID == nil then
    self.goID = self:GetUserData()
    if self.goID then
      self.goID = tonumber(self.goID)
    end
  end
  self:OnRefreshGroupList()
end

function UIDispatchTaskMainView:OnRefreshGroupList()
  self:DestroyAllTabGroup()
  self.loadedGroupNum = 0
  self.groupDataList = self.ctrl:GetGroupList()
  self.panelList = {}
  self.panelComponentList = {}
  self.modelGroup = self:GameObjectInstantiateAsync(tabGroupPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local cell = self.content:AddComponent(TabGroup, go.name, v)
    cell:RefreshGroup(self.groupDataList, function(act)
      if ActivityContentHandler[act.type] == nil then
        return false
      end
      return true
    end)
    self.groupItem = cell
  end)
end

function UIDispatchTaskMainView:SelectDefaultTab()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  local focusId, actIndex = self.ctrl:GetDefaultFocusActivity(self.groupDataList, self.goID)
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self:LocateTab(actIndex, focusId)
  end, 0.1)
end

function UIDispatchTaskMainView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UIDispatchTaskMainView:OnGroupCellLoadFinish()
  self:SelectDefaultTab()
end

function UIDispatchTaskMainView:DestroyAllTabGroup()
  if self.content == nil then
    return
  end
  self.content:RemoveComponents(TabGroup)
  if self.modelGroup ~= nil then
    self:GameObjectDestroy(self.modelGroup)
  end
  self.modelGroup = nil
  if self.centerContent == nil then
    return
  end
  self.centerContent:RemoveAllComponentes()
  if self.panelList then
    for k, v in pairs(self.panelList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.panelList = nil
  self.panelComponentList = nil
end

function UIDispatchTaskMainView:LocateTab(tabIndex, actId)
  if not self then
    return
  end
  if not actId then
    return
  end
  self.groupItem:SelectTab(actId)
end

function UIDispatchTaskMainView:RefreshContent()
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
  self.closeBtn:SetActive(true)
  self.whiteCloseBtn:SetActive(false)
  if handlerData ~= nil and handlerData.assetPath ~= nil and handlerData.cls ~= nil then
    if CommonUtil.IsArabic() then
      self.titleText.rectTransform.sizeDelta = Vector2.New(self.titleOriginalSizeDeltaX, self.titleText.rectTransform.sizeDelta.y)
    end
    DataCenter.ActivityTipsManager:RecordSeenUI(currentActivity.activityId, currentActivity.type)
    local cell = self.panelComponentList[currentActivity.activityId]
    if self.panelList[currentActivity.activityId] then
      if cell ~= nil then
        cell:SetData(currentActivity.activityId, currentActivity.id)
        if cell.ContentShow then
          cell:ContentShow()
        else
          cell:SetActive(true)
        end
        if tempComp then
          if tempComp.ContentHide then
            tempComp:ContentHide()
          else
            tempComp:SetActive(false)
          end
        end
      end
      return
    end
    self.panelList[currentActivity.activityId] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        self.panelList[currentActivity.activityId] = nil
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.centerContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = currentActivity.activityId
      local newCell = self.centerContent:AddComponent(handlerData.cls, go.name)
      self.panelComponentList[currentActivity.activityId] = newCell
      newCell:SetData(currentActivity.activityId, currentActivity.id)
      newCell:SetActive(true)
      if tempComp then
        if tempComp.ContentHide then
          tempComp:ContentHide()
        else
          tempComp:SetActive(false)
        end
      end
      local curActId = self.ctrl:GetCurrentActivityId()
      if curActId ~= currentActivity.activityId then
        if newCell.ContentHide then
          newCell:ContentHide()
        else
          newCell:SetActive(false)
        end
      else
        EventManager:GetInstance():Broadcast(EventId.GF_window_opened_UIDispatchTaskMain, tonumber(currentActivity.type))
      end
      CS.DynamicFPSConfig.AcquireHighFPSLockerForChildrenScrollComponents(go)
    end)
    return
  end
end

function UIDispatchTaskMainView:OnTabItemClick(id)
  local oldId = self.ctrl:GetCurrentActivityId()
  oldId = tonumber(oldId) or 0
  if oldId ~= tonumber(id) then
    if 0 < oldId then
      self.groupItem:SetUnSelect(oldId)
    end
    self.groupItem:SetSelect(id)
    self.ctrl:SetCurrentActivityId(id)
    self:RefreshContent()
  end
end

function UIDispatchTaskMainView:RefreshPointer()
end

function UIDispatchTaskMainView:OnPassDay()
  local needReInit = false
  if self.groupDataList then
    local newGroupList = self.ctrl:GetGroupList()
    if #newGroupList ~= #self.groupDataList then
      needReInit = true
    else
      for index, value in ipairs(self.groupDataList) do
        if value.id ~= newGroupList[index].id then
          needReInit = true
          break
        end
      end
    end
  else
    needReInit = true
  end
  if needReInit then
    self.goID = self.lastActivityId
    self.lastActivityId = nil
    self.ctrl:InitData()
    self:ReInit()
  end
end

return UIDispatchTaskMainView
