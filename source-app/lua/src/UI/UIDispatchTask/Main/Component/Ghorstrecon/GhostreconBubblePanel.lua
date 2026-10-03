local GhostreconBubblePanel = BaseClass("GhostreconBubblePanel", UIBaseContainer)
local base = UIBaseContainer
local GhostreconBubbleGrid = require("UI.UIDispatchTask.Main.Component.Ghorstrecon.GhostreconBubbleGrid")
local bubblePath = "Assets/Main/Prefabs/UI/ActivityCenter/Ghostrecon/UIActivityGhostreconBubbleGrid.prefab"
local bubble_target_content_path = "BubbleTargetContent"
local bubble_content_path = "BubbleContent"
local SpawnAnimTime = 3
local BubbleAnimTime = 0.5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.bubble_content:SetActive(true)
  local showSpawn = DataCenter.ActGhostreconManager:GetDayFirstIn()
  if showSpawn or DataCenter.ActGhostreconManager.isTriggerGuide then
    self:ShowSpawnAnim()
  else
    self.animtor:SetTrigger("idle")
  end
end

local function OnDisable(self)
  if self:IsShowSpawmAnim() then
    self.bubble_content:SetActive(true)
    self.spawnDeltaTime = nil
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bubble_target_content = self:AddComponent(UIBaseContainer, bubble_target_content_path)
  self.bubble_content = self:AddComponent(UIBaseContainer, bubble_content_path)
  self.allPoolPos = {}
  local poolNum = self.bubble_target_content.transform.childCount
  for poolIndex = 0, poolNum - 1 do
    local poolTrans = self.bubble_target_content.transform:GetChild(poolIndex)
    local pool = {}
    for bubbleIndex = 0, poolTrans.childCount - 1 do
      local bubbleTrans = poolTrans:GetChild(bubbleIndex)
      local x, y, z = bubbleTrans:Get_position()
      bubbleTrans.gameObject:SetActive(false)
      table.insert(pool, Vector3.New(x, y, z))
    end
    table.insert(self.allPoolPos, pool)
  end
  self.animtor = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self:ClearAllBubble()
  self.allRequest = nil
  self.allBubbleComp = nil
  self.bubble_target_content = nil
  self.bubble_content = nil
end

local function DataDefine(self)
  self.allRequest = {}
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GhostreconRefreshOneTask, self.RefreshOneBubble)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GhostreconRefreshOneTask, self.RefreshOneBubble)
end

local function Refresh(self)
  self:ClearAllBubble()
  for poolIndex, pool in ipairs(DataCenter.ActGhostreconBubblePosManager.allBubble) do
    for bubbleIndex, bubble in ipairs(pool) do
      if bubble.uuid then
        if self.allBubbleComp[poolIndex] == nil then
          self.allBubbleComp[poolIndex] = {}
        end
        local comp = self.allBubbleComp[poolIndex][bubbleIndex]
        if comp == nil then
          self:AddOneBubble(poolIndex, bubbleIndex, bubble.uuid)
        else
          comp:SetData(bubble.uuid)
        end
      end
    end
  end
end

local function AddOneBubble(self, poolIndex, bubbleIndex, uuid)
  if self.allRequest[poolIndex] and self.allRequest[poolIndex][bubbleIndex] then
    self.allRequest[poolIndex][bubbleIndex].uuid = uuid
    return
  end
  local request = self:GameObjectInstantiateAsync(bubblePath, function(request)
    if self.allPoolPos == nil then
      return
    end
    if request.isError or request.gameObject == nil then
      if self.allRequest and self.allRequest[poolIndex] and self.allRequest[poolIndex][bubbleIndex] then
        self.allRequest[poolIndex][bubbleIndex] = nil
      end
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.bubble_content.transform)
    go.transform:Set_localScale(1, 1, 1)
    local pos = self.allPoolPos[poolIndex][bubbleIndex]
    if pos then
      go.transform:Set_position(pos.x, pos.y, pos.z)
    else
      local randomX = 200
      local randomY = 200
      go.transform:Set_localPosition(math.random(-randomX, randomX), math.random(-randomY, randomY), 0)
    end
    go.name = poolIndex .. "_" .. bubbleIndex
    local comp = self.bubble_content:AddComponent(GhostreconBubbleGrid, go.name)
    if self.allRequest and self.allRequest[poolIndex] and self.allRequest[poolIndex][bubbleIndex].uuid and self.allRequest[poolIndex][bubbleIndex].uuid then
      comp:SetData(self.allRequest[poolIndex][bubbleIndex].uuid)
    else
      comp:SetData(uuid)
    end
    self.allBubbleComp[poolIndex][bubbleIndex] = comp
  end)
  if self.allRequest[poolIndex] == nil then
    self.allRequest[poolIndex] = {}
  end
  if self.allRequest[poolIndex][bubbleIndex] == nil then
    self.allRequest[poolIndex][bubbleIndex] = {}
  end
  self.allRequest[poolIndex][bubbleIndex].request = request
  self.allRequest[poolIndex][bubbleIndex].uuid = uuid
end

local function RefreshOneBubble(self, param)
  local poolIndex = param.poolIndex
  local bubbleIndex = param.bubbleIndex
  if poolIndex == nil or bubbleIndex == nil then
    return
  end
  if self.allBubbleComp[poolIndex] == nil then
    self.allBubbleComp[poolIndex] = {}
  end
  local comp = self.allBubbleComp[poolIndex][bubbleIndex]
  if param.type == 1 or param.type == 2 then
    if comp == nil then
      self:AddOneBubble(poolIndex, bubbleIndex, param.uuid)
    else
      comp:SetData(param.uuid)
    end
  elseif param.type == 3 and comp then
    comp:SetActive(false)
  end
end

local function ClearAllBubble(self)
  self.bubble_content:RemoveComponents(GhostreconBubbleGrid)
  for _, v1 in pairs(self.allRequest) do
    for _, v2 in pairs(v1) do
      if v2.request then
        self:GameObjectDestroy(v2.request)
      end
    end
  end
  self.allRequest = {}
  self.allBubbleComp = {}
end

local function ShowSpawnAnim(self)
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.NoClickGhostreconEnterTip, false)
  EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshRedPoint)
  self.animtor:SetTrigger("spawn")
  self.bubble_content:SetActive(false)
  self.spawnDeltaTime = 0
end

local function OnSpawnAnimDone(self)
  if DataCenter.ActGhostreconManager.isTriggerGuide then
    self.bubble_content:SetActive(true)
    if self.allBubbleComp then
      local position
      for poolIndex, pool in pairs(self.allBubbleComp) do
        for bubbleIndex, bubble in pairs(pool) do
          position = bubble:IsGuideGrid()
          if position then
            break
          end
        end
        if position then
          break
        end
      end
      if position then
        local param = {}
        param.positionType = PositionType.Screen
        param.position = position + Vector3.New(50, 0, 0)
        param.isAutoClose = 3
        DataCenter.ArrowManager:ShowFingerArrow(param)
      end
    end
  end
end

local function Update100MS(self)
  if not self.view.ctrl:GetGhostMainShow() then
    return
  end
  if self.spawnDeltaTime then
    self.spawnDeltaTime = self.spawnDeltaTime + 0.1
    if self.spawnDeltaTime >= SpawnAnimTime + BubbleAnimTime and self.spawnDeltaTime - 0.1 < SpawnAnimTime + BubbleAnimTime then
      self.spawnDeltaTime = nil
      self:OnSpawnAnimDone()
    elseif self.spawnDeltaTime >= SpawnAnimTime and not self.bubble_content:GetActive() then
      self.bubble_content:SetActive(true)
      if self.allBubbleComp then
        for poolIndex, pool in pairs(self.allBubbleComp) do
          for bubbleIndex, bubble in pairs(pool) do
            bubble:ShowSpawnAnim()
          end
        end
      end
    end
  end
end

local function IsShowSpawmAnim(self)
  return self.spawnDeltaTime == nil
end

GhostreconBubblePanel.OnCreate = OnCreate
GhostreconBubblePanel.OnDestroy = OnDestroy
GhostreconBubblePanel.OnEnable = OnEnable
GhostreconBubblePanel.OnDisable = OnDisable
GhostreconBubblePanel.ComponentDefine = ComponentDefine
GhostreconBubblePanel.ComponentDestroy = ComponentDestroy
GhostreconBubblePanel.DataDefine = DataDefine
GhostreconBubblePanel.DataDestroy = DataDestroy
GhostreconBubblePanel.OnAddListener = OnAddListener
GhostreconBubblePanel.OnRemoveListener = OnRemoveListener
GhostreconBubblePanel.Refresh = Refresh
GhostreconBubblePanel.RefreshOneBubble = RefreshOneBubble
GhostreconBubblePanel.AddOneBubble = AddOneBubble
GhostreconBubblePanel.ClearAllBubble = ClearAllBubble
GhostreconBubblePanel.ShowSpawnAnim = ShowSpawnAnim
GhostreconBubblePanel.OnSpawnAnimDone = OnSpawnAnimDone
GhostreconBubblePanel.Update100MS = Update100MS
GhostreconBubblePanel.IsShowSpawmAnim = IsShowSpawmAnim
return GhostreconBubblePanel
