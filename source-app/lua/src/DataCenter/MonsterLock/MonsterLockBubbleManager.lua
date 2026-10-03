local MonsterLockBubbleManager = BaseClass("MonsterLockBubbleManager")
local MonsterLockBubble = require("DataCenter.MonsterLock.MonsterLockBubble")
local Resource = CS.GameEntry.Resource
local BubblePrefabPath = "Assets/Main/Prefabs/World/MonsterLockBubble.prefab"

local function __init(self)
  self.bubbleDict = {}
  self.OnCreateDict = {}
  self:AddListeners()
end

local function __delete(self)
  self.bubbleDict = nil
  self.OnCreateDict = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.ClearAllBubble)
  EventManager:GetInstance():AddListener(EventId.MonsterLockInView, self.OnMonsterLockInView)
  EventManager:GetInstance():AddListener(EventId.MonsterLockOutView, self.OnMonsterLockOutView)
  EventManager:GetInstance():AddListener(EventId.DestroyMonsterLockBubbleStateHide, self.OnClickWorld)
  EventManager:GetInstance():AddListener(EventId.MonsterLockStateUpdate, self.OnMonsterUpdate)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.ClearAllBubble)
  EventManager:GetInstance():RemoveListener(EventId.MonsterLockInView, self.OnMonsterLockInView)
  EventManager:GetInstance():RemoveListener(EventId.MonsterLockOutView, self.OnMonsterLockOutView)
  EventManager:GetInstance():RemoveListener(EventId.DestroyMonsterLockBubbleStateHide, self.OnClickWorld)
  EventManager:GetInstance():RemoveListener(EventId.MonsterLockStateUpdate, self.OnMonsterUpdate)
end

local function Startup(self)
end

local function CreateBubble(self, id)
  if self.bubbleDict[id] ~= nil then
    self:DestroyBubble(id)
  end
  local data = DataCenter.MonsterLockDataManager:GetMonsterData(id)
  if data == nil then
    return
  end
  if self.OnCreateDict[id] ~= nil then
    return
  end
  local req = Resource:InstantiateAsync(BubblePrefabPath)
  self.OnCreateDict[id] = req
  req:completed("+", function()
    self.OnCreateDict[id] = nil
    if req.isError then
      return
    end
    if CS.SceneManager.World.DynamicObjNode == nil then
      req:Destroy()
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "MonsterLockBubble_" .. id
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local bubble = MonsterLockBubble.New()
    bubble:SetReq(req)
    self.bubbleDict[id] = bubble
    bubble:OnCreate()
    bubble:Init(id)
    bubble:SetOnClick(function()
      self:OnClickBubble(id)
    end)
  end)
end

local function DestroyBubble(self, id)
  if self.bubbleDict[id] ~= nil then
    self.bubbleDict[id]:OnDestroy()
    self.bubbleDict[id] = nil
  end
  if self.OnCreateDict[id] ~= nil then
    self.OnCreateDict[id]:Destroy()
    self.OnCreateDict[id] = nil
  end
end

local function ClearAllBubble(data)
  DataCenter.MonsterLockBubbleManager:DestroyAllBubble()
end

local function DestroyAllBubble(self)
  if self.bubbleDict ~= nil then
    for k, v in pairs(self.bubbleDict) do
      v:OnDestroy()
    end
  end
  if self.OnCreateDict ~= nil then
    for k, v in pairs(self.OnCreateDict) do
      v:Destroy()
    end
  end
  self.bubbleDict = {}
  self.OnCreateDict = {}
end

local function SetBubbleActive(self, id, active)
  if self.bubbleDict[id] == nil then
    return
  end
  self.bubbleDict[id]:SetActive(active)
end

local function OnClickBubble(self, id)
  local param = {}
  param.monsterLockId = id
  self:ResetAllBubble(id)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  local data = DataCenter.MonsterLockDataManager:GetMonsterData(id)
  if data == nil then
    return
  end
  local bubble = self:GetMonsterLockBubble(id)
  if bubble ~= nil then
    bubble:SetActive(false)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorldPoint) then
    local str = "" .. ";" .. data.pointId .. ";" .. "" .. ";" .. WorldPointUIType.MonsterLock .. ";" .. "0" .. ";" .. "0"
    EventManager:GetInstance():Broadcast(EventId.RefreshUIWorldPointView, str)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, 0, data.pointId, "", WorldPointUIType.MonsterLock, 0, 0)
  end
end

local function OnMonsterLockInView(id)
  local data = DataCenter.MonsterLockDataManager:GetMonsterData(id)
  if data == nil then
    return
  end
  local m = DataCenter.MonsterLockBubbleManager
  if data.state == 2 then
    m:DestroyBubble(id)
  else
    m:CreateBubble(id)
  end
end

local function OnMonsterLockOutView(id)
  DataCenter.MonsterLockBubbleManager:DestroyBubble(id)
end

local function OnClickWorld()
end

local function ResetAllBubble(self, excludeId)
  local deleteIdList = {}
  for id, bubble in pairs(self.bubbleDict) do
    bubble:SetActive(true)
    if id ~= excludeId then
      if bubble.state == MonsterLockBubbleState.Pay then
        bubble:SetBubbleState(MonsterLockBubbleState.Unlocked)
      elseif bubble.state == MonsterLockBubbleState.Pve then
        bubble:SetBubbleState(MonsterLockBubbleState.Unlocked)
      end
    end
  end
  for _, id in ipairs(deleteIdList) do
    self:DestroyBubble(id)
  end
end

local function OnMonsterUpdate(id)
  DataCenter.MonsterLockBubbleManager:CreateBubble(id)
end

local function GetMonsterLockBubble(self, id)
  if self.bubbleDict[id] then
    return self.bubbleDict[id]
  end
  return nil
end

local function CanShowBubbleStateHide(self, id)
  return true
end

local function RefreshBubbleVisible(self)
  local visible = true
  for _, v in pairs(self.bubbleDict) do
    if v ~= nil then
      v:SetActive(visible)
    end
  end
end

MonsterLockBubbleManager.__init = __init
MonsterLockBubbleManager.__delete = __delete
MonsterLockBubbleManager.AddListeners = AddListeners
MonsterLockBubbleManager.RemoveListeners = RemoveListeners
MonsterLockBubbleManager.Startup = Startup
MonsterLockBubbleManager.CreateBubble = CreateBubble
MonsterLockBubbleManager.DestroyBubble = DestroyBubble
MonsterLockBubbleManager.SetBubbleActive = SetBubbleActive
MonsterLockBubbleManager.OnClickBubble = OnClickBubble
MonsterLockBubbleManager.OnMonsterLockInView = OnMonsterLockInView
MonsterLockBubbleManager.OnMonsterLockOutView = OnMonsterLockOutView
MonsterLockBubbleManager.OnClickWorld = OnClickWorld
MonsterLockBubbleManager.ResetAllBubble = ResetAllBubble
MonsterLockBubbleManager.GetMonsterLockBubble = GetMonsterLockBubble
MonsterLockBubbleManager.CanShowBubbleStateHide = CanShowBubbleStateHide
MonsterLockBubbleManager.RefreshBubbleVisible = RefreshBubbleVisible
MonsterLockBubbleManager.OnMonsterUpdate = OnMonsterUpdate
MonsterLockBubbleManager.ClearAllBubble = ClearAllBubble
MonsterLockBubbleManager.DestroyAllBubble = DestroyAllBubble
return MonsterLockBubbleManager
