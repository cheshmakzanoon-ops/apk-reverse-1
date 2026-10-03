local LandLockChooseBubbleManager = BaseClass("LandLockChooseBubbleManager")
local LandLockChooseBubble = require("DataCenter.LandLock.LandLockChooseBubble")
local Resource = CS.GameEntry.Resource
local BubblePrefabPath = "Assets/Main/Prefabs/World/LandLockChooseBubble.prefab"

local function __init(self)
  self.bubbleDict = {}
  self:AddListeners()
end

local function __delete(self)
  self:ResetAllBubble()
  self.bubbleDict = nil
  self:RemoveListeners()
end

local function Startup(self)
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.LandLockInView, self.OnLandLockInView)
  EventManager:GetInstance():AddListener(EventId.LandLockOutView, self.OnLandLockOutView)
  EventManager:GetInstance():AddListener(EventId.DestroyLandLockBubbleStateHide, self.OnClickWorld)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.LandLockInView, self.OnLandLockInView)
  EventManager:GetInstance():RemoveListener(EventId.LandLockOutView, self.OnLandLockOutView)
  EventManager:GetInstance():RemoveListener(EventId.DestroyLandLockBubbleStateHide, self.OnClickWorld)
end

local function CreateBubble(self, id, pointId)
  if self.bubbleDict[id] ~= nil then
    self:DestroyBubble(id)
  end
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil then
    return
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  local bubble = LandLockChooseBubble.New()
  local req = Resource:InstantiateAsync(BubblePrefabPath)
  req:completed("+", function()
    if req.isError then
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "LandLockChooseBubble_" .. id
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    bubble:OnCreate()
    bubble:Init(id, pointId)
    bubble:SetOnClickR(function()
      self:OnClickBubbleR(id)
    end)
    bubble:SetOnClickL(function()
      self:OnClickBubbleL(id, pointId)
    end)
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

local function OnClickBubbleL(self, id, pointId)
  self:DestroyBubble(id)
  UIUtil.OnClickWorld(pointId, ClickWorldType.Collider)
end

local function OnClickBubbleR(self, id)
  self:DestroyBubble(id)
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  if data == nil then
    return
  end
  DataCenter.LandLockManager:ClickLandLockById(id)
end

local function OnLandLockInView(id)
  DataCenter.LandLockChooseBubbleManager:DestroyBubble(id)
end

local function OnLandLockOutView(id)
  DataCenter.LandLockChooseBubbleManager:DestroyBubble(id)
end

local function OnClickWorld()
  DataCenter.LandLockChooseBubbleManager:ResetAllBubble()
end

local function ResetAllBubble(self)
  local deleteIdList = {}
  for id, bubble in pairs(self.bubbleDict) do
    table.insert(deleteIdList, id)
  end
  for _, id in ipairs(deleteIdList) do
    self:DestroyBubble(id)
  end
end

LandLockChooseBubbleManager.__init = __init
LandLockChooseBubbleManager.__delete = __delete
LandLockChooseBubbleManager.AddListeners = AddListeners
LandLockChooseBubbleManager.RemoveListeners = RemoveListeners
LandLockChooseBubbleManager.CreateBubble = CreateBubble
LandLockChooseBubbleManager.DestroyBubble = DestroyBubble
LandLockChooseBubbleManager.OnClickBubbleL = OnClickBubbleL
LandLockChooseBubbleManager.OnClickBubbleR = OnClickBubbleR
LandLockChooseBubbleManager.OnLandLockInView = OnLandLockInView
LandLockChooseBubbleManager.OnLandLockOutView = OnLandLockOutView
LandLockChooseBubbleManager.OnClickWorld = OnClickWorld
LandLockChooseBubbleManager.ResetAllBubble = ResetAllBubble
LandLockChooseBubbleManager.Startup = Startup
return LandLockChooseBubbleManager
