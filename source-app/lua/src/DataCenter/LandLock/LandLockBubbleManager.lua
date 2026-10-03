local LandLockBubbleManager = BaseClass("LandLockBubbleManager")
local LandLockBubble = require("DataCenter.LandLock.LandLockBubble")
local Resource = CS.GameEntry.Resource
local BubblePrefabPath = "Assets/Main/Prefabs/World/LandLockBubble.prefab"

local function __init(self)
  self.bubbleDict = {}
  self.timer = nil
  self:AddListeners()
end

local function __delete(self)
  self.bubbleDict = nil
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.LandLockInView, self.OnLandLockInView)
  EventManager:GetInstance():AddListener(EventId.LandLockOutView, self.OnLandLockOutView)
  EventManager:GetInstance():AddListener(EventId.DestroyLandLockBubbleStateHide, self.OnClickWorld)
  EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.OnResOrItemUpdate)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.LandLockInView, self.OnLandLockInView)
  EventManager:GetInstance():RemoveListener(EventId.LandLockOutView, self.OnLandLockOutView)
  EventManager:GetInstance():RemoveListener(EventId.DestroyLandLockBubbleStateHide, self.OnClickWorld)
  EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.OnResOrItemUpdate)
end

local function Startup(self)
end

local function TimerAction(self)
end

local function CreateBubble(self, id)
  if self.bubbleDict[id] ~= nil then
    self:DestroyBubble(id)
  end
  if 4 < id then
    return
  end
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil then
    return
  end
  local bubble = LandLockBubble.New()
  local req = Resource:InstantiateAsync(BubblePrefabPath)
  req:completed("+", function()
    if req.isError then
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "LandLockBubble_" .. id
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    bubble:OnCreate()
    bubble:Init(id)
    bubble:SetOnClick(function()
      self:OnClickBubble(id)
    end)
    if not DataCenter.GuideManager:CanShowLandLockBubble() then
      self:SetBubbleActive(id, false)
    end
  end)
  bubble:SetReq(req)
  self.bubbleDict[id] = bubble
end

local function DestroyBubble(self, id)
  if self.bubbleDict[id] == nil then
    return
  end
  self.bubbleDict[id]:OnDestroy()
  self.bubbleDict[id] = nil
end

local function SetBubbleActive(self, id, active)
  if self.bubbleDict[id] == nil then
    return
  end
  self.bubbleDict[id]:ShowIcon(active)
end

local function OnClickBubble(self, id)
  if DataCenter.RecommendShowManager:IsHaveShowRecommend() then
    return
  end
  local param = {}
  param.landLockId = id
  WorldArrowManager:GetInstance():RemoveEffect()
  DataCenter.GuideManager:SetCompleteNeedParam(param)
  DataCenter.GuideManager:CheckGuideComplete()
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickLandLock, tostring(id))
  self:ResetAllBubble(id)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  EventManager:GetInstance():Broadcast(EventId.ResetQuestArrow)
  DataCenter.ArrowManager:RemoveFingerArrow(true)
  print("beef OnClickBubble id: " .. id)
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil then
    return
  end
  local bubble = self.bubbleDict[id]
  if bubble == nil then
    return
  end
  if bubble.state == LandLockBubbleState.Hide then
    if id < 5 then
      GoToUtil.GotoDabenPos()
    else
      local dataList = DataCenter.LandLockManager:GetLandLockDataListByState(LandLockState.Any)
      for _, v in ipairs(dataList) do
        if v.state == LandLockState.Unlocked or v.state == LandLockState.Locked then
          GoToUtil.GoLandLockById(v.id)
          break
        end
      end
    end
    if not self:CanShowBubbleStateHide(id) then
      self:DestroyBubble(id)
    end
  elseif bubble.state == LandLockBubbleState.Locked then
    if data:GetCurPve() ~= 0 then
      bubble:SetBubbleState(LandLockBubbleState.Pve)
    elseif data.needPay and not data.paid then
      bubble:SetBubbleState(LandLockBubbleState.Pay)
    else
      SFSNetwork.SendMessage(MsgDefines.UnlockUserLand, id)
    end
  elseif bubble.state == LandLockBubbleState.Unlocked then
    DataCenter.LandLockManager:ClickLandLockById(id)
  elseif bubble.state == LandLockBubbleState.Pay then
    DataCenter.LandLockManager:EnterLandLockById(id)
  elseif bubble.state == LandLockBubbleState.Pve then
    DataCenter.LandLockManager:EnterLandLockById(id)
  end
end

local function OnLandLockInView(id)
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil then
    return
  end
  local m = DataCenter.LandLockBubbleManager
  if data.state == LandLockState.Unlocked then
    m:DestroyBubble(id)
  elseif data.state ~= LandLockState.Hide or m:CanShowBubbleStateHide(id) then
    m:CreateBubble(id)
  else
    m:DestroyBubble(id)
  end
end

local function OnLandLockOutView(id)
  DataCenter.LandLockBubbleManager:DestroyBubble(id)
end

local function OnClickWorld()
  DataCenter.LandLockBubbleManager:ResetAllBubble()
end

local function ResetAllBubble(self, excludeId)
  local deleteIdList = {}
  for id, bubble in pairs(self.bubbleDict) do
    if id ~= excludeId then
      if bubble.state == LandLockBubbleState.Hide then
        if not self:CanShowBubbleStateHide(id) then
          table.insert(deleteIdList, id)
        end
      elseif bubble.state == LandLockBubbleState.Locked then
        bubble:SetBubbleState(LandLockBubbleState.Locked)
      elseif bubble.state == LandLockBubbleState.Pay then
        bubble:SetBubbleState(LandLockBubbleState.Locked)
      elseif bubble.state == LandLockBubbleState.Pve then
        bubble:SetBubbleState(LandLockBubbleState.Locked)
      end
    end
  end
  for _, id in ipairs(deleteIdList) do
    self:DestroyBubble(id)
  end
end

local function OnResOrItemUpdate()
  local m = DataCenter.LandLockBubbleManager
  for _, bubble in pairs(m.bubbleDict) do
    if bubble.state == LandLockBubbleState.Pay or bubble.state == LandLockBubbleState.Pve then
      bubble:RefreshCost()
    end
  end
end

local function OnBuildLevelUpOrMove(self, buildId)
  for id, bubble in pairs(self.bubbleDict) do
    if bubble.state == LandLockBubbleState.Hide then
      local template = DataCenter.LandLockManager:GetTemplate(id)
      local hasBuildId = false
      for _, v in ipairs(template.needBuild) do
        if v.buildId == buildId then
          hasBuildId = true
          break
        end
      end
      if hasBuildId then
        if not self:CanShowBubbleStateHide(id) then
          self:DestroyBubble(id)
        else
          self.OnLandLockInView(id)
        end
      end
    end
  end
  self:ResetAllBubble()
end

local function OnTaskUpdate(self)
  for id, bubble in pairs(self.bubbleDict) do
    if bubble.state == LandLockBubbleState.Hide then
      local template = DataCenter.LandLockManager:GetTemplate(id)
      if template.needChapter ~= 0 then
        if not self:CanShowBubbleStateHide(id) then
          self:DestroyBubble(id)
        else
          self.OnLandLockInView(id)
        end
      end
    end
  end
  self:ResetAllBubble()
end

local function GetLandLockBubble(self, id)
  if self.bubbleDict[id] then
    return self.bubbleDict[id]
  end
  return nil
end

local function CanShowBubbleStateHide(self, id)
  local needLv = LuaEntry.DataConfig:TryGetNum("land_unlock", "k4")
  if needLv >= DataCenter.BuildManager.MainLv then
    return false
  end
  local dataList = DataCenter.LandLockManager:GetLandLockDataListByState(LandLockState.Any)
  for _, data in ipairs(dataList) do
    if data.state == LandLockState.Locked or data.state == LandLockState.Unlocked then
      return false
    end
  end
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil or data.state ~= LandLockState.Hide then
    return false
  end
  for _, priorId in ipairs(data.priorList) do
    local priorData = DataCenter.LandLockManager:GetLandLockDataById(priorId)
    if priorData.state ~= LandLockState.Finished then
      return false
    end
  end
  return not data:CheckNeedBuild() or not data:CheckNeedChapter()
end

local function RefreshBubbleVisible(self)
  local visible = DataCenter.GuideManager:CanShowLandLockBubble()
  for k, v in pairs(self.bubbleDict) do
    if v ~= nil then
      v:ShowIcon(visible)
    end
  end
end

LandLockBubbleManager.__init = __init
LandLockBubbleManager.__delete = __delete
LandLockBubbleManager.AddListeners = AddListeners
LandLockBubbleManager.RemoveListeners = RemoveListeners
LandLockBubbleManager.Startup = Startup
LandLockBubbleManager.TimerAction = TimerAction
LandLockBubbleManager.CreateBubble = CreateBubble
LandLockBubbleManager.DestroyBubble = DestroyBubble
LandLockBubbleManager.SetBubbleActive = SetBubbleActive
LandLockBubbleManager.OnClickBubble = OnClickBubble
LandLockBubbleManager.OnLandLockInView = OnLandLockInView
LandLockBubbleManager.OnLandLockOutView = OnLandLockOutView
LandLockBubbleManager.OnClickWorld = OnClickWorld
LandLockBubbleManager.ResetAllBubble = ResetAllBubble
LandLockBubbleManager.OnResOrItemUpdate = OnResOrItemUpdate
LandLockBubbleManager.OnBuildLevelUpOrMove = OnBuildLevelUpOrMove
LandLockBubbleManager.OnTaskUpdate = OnTaskUpdate
LandLockBubbleManager.GetLandLockBubble = GetLandLockBubble
LandLockBubbleManager.CanShowBubbleStateHide = CanShowBubbleStateHide
LandLockBubbleManager.RefreshBubbleVisible = RefreshBubbleVisible
return LandLockBubbleManager
