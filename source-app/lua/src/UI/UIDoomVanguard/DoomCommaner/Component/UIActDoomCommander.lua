local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActDoomCommander = BaseClass("UIActDoomCommander", base)
local UIActDoomCommanderCell = require("UI.UIDoomVanguard.DoomCommaner.Component.UIActDoomCommanderCell")
local ResourceManager = CS.GameEntry.Resource
local TitleText_path = "RightView/Rect_Top/TitleText"
local TimeText_path = "RightView/Rect_Top/TimeText"
local InfoText_path = "RightView/Rect_Top/InfoText"
local TipText_path = "RightView/Rect_Bottom/TipText"
local ScrollView_path = "RightView/Rect_Bottom/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
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

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UITextMeshProUGUIEx, TitleText_path)
  self.TimeText = self:AddComponent(UITextMeshProUGUIEx, TimeText_path)
  self.InfoText = self:AddComponent(UITextMeshProUGUIEx, InfoText_path)
  self.TipText = self:AddComponent(UITextMeshProUGUIEx, TipText_path)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, "HeroSpineContainer")
  self.heroBtn = self:AddComponent(UIButton, "HeroSpineContainer/HeroBtn")
  self.heroBtn:SetOnClick(function()
    GoToUtil.GoHeroDetails(40020, HeroDetailGuideArrowType.Upgrade)
  end)
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.TimeText = nil
  self.InfoText = nil
  self.TipText = nil
  self.ScrollView = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.timer_action = nil
  self.lastSpinePath = nil
  self.heroSpineLoadRequest = nil
  self:DeleteTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DoomCommanderRefresh, self.RefreshUI)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DoomCommanderRefresh, self.RefreshUI)
  base.OnAddListener(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.actListData.endTime then
    self.TimeText:SetText("")
    self:DeleteTimer()
  else
    self.TimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.actListData.endTime - curTime))
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIActDoomCommanderCell, itemObj)
  local id = DataCenter.ActDoomCommanderDataManager:GetTaskIdByOrder(index)
  cellItem:SetItem(id, self.actListData)
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIActDoomCommanderCell)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  SFSNetwork.SendMessage(MsgDefines.GetSevenDayActTaskInfoMessage)
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
  if self.actListData then
    self:ReloadHeroSpine(self.actListData.activity_hero)
  end
  self.TitleText:SetLocalText(self.actListData.name)
  self.InfoText:SetLocalText(self.actListData.desc_info)
  self:RefreshTime()
  self:AddTimer()
end

local function RefreshUI(self)
  self.ScrollView:SetTotalCount(5)
  self.ScrollView:RefillCells()
end

local function ReloadHeroSpine(self, spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      self:ResetSpineTransform(request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.heroSpineLoadRequest then
    self:ResetSpineTransform(self.heroSpineLoadRequest.gameObject)
  end
end

local function ResetSpineTransform(self, obj)
  if not obj then
    return
  end
  local parent = self.heroSpineContainer
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil and self.actListData then
    local spinePos = {139, 270}
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(-1.3, 1.3, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

UIActDoomCommander.OnCreate = OnCreate
UIActDoomCommander.OnDestroy = OnDestroy
UIActDoomCommander.OnEnable = OnEnable
UIActDoomCommander.OnDisable = OnDisable
UIActDoomCommander.ComponentDefine = ComponentDefine
UIActDoomCommander.ComponentDestroy = ComponentDestroy
UIActDoomCommander.DataDefine = DataDefine
UIActDoomCommander.DataDestroy = DataDestroy
UIActDoomCommander.OnItemMoveIn = OnItemMoveIn
UIActDoomCommander.OnItemMoveOut = OnItemMoveOut
UIActDoomCommander.SetData = SetData
UIActDoomCommander.AddTimer = AddTimer
UIActDoomCommander.DeleteTimer = DeleteTimer
UIActDoomCommander.RefreshUI = RefreshUI
UIActDoomCommander.RefreshTime = RefreshTime
UIActDoomCommander.ReloadHeroSpine = ReloadHeroSpine
UIActDoomCommander.ResetSpineTransform = ResetSpineTransform
UIActDoomCommander.OnAddListener = OnAddListener
UIActDoomCommander.OnRemoveListener = OnRemoveListener
return UIActDoomCommander
