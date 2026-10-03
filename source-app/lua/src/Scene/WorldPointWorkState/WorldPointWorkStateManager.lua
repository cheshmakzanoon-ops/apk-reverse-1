local WorldPointWorkStateManager = BaseClass("WorldPointWorkStateManager")
local WorldPointWorkState = require("Scene.WorldPointWorkState.WorldPointWorkState")

local function __init(self)
  self.allPoints = nil
  self:AddListeners()
end

local function __delete(self)
  self:RemoveListeners()
  self:Clear()
end

local function Clear(self)
  if self.allPoints then
    for _, value in pairs(self.allPoints) do
      if value then
        value:Delete()
        ObjectPool:GetInstance():Save(value)
      end
    end
    self.allPoints = nil
  end
end

local function StartUp(self)
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.EnterWorld)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.ExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.EnterWorld)
end

local function Create(self, uuid, transform)
  if self.allPoints == nil then
    self.allPoints = {}
  end
  if CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if info then
      local point = self.allPoints[uuid]
      if point == nil then
        point = ObjectPool:GetInstance():Load(WorldPointWorkState)
        self.allPoints[uuid] = point
      end
      point:Refresh(info, transform)
    else
      self:Remove(uuid)
    end
  else
    self:Remove(uuid)
  end
end

local function Remove(self, uuid)
  if self.allPoints then
    local point = self.allPoints[uuid]
    if point then
      point:Delete()
      self.allPoints[uuid] = nil
      ObjectPool:GetInstance():Save(point)
    end
  end
end

local function EnterWorld()
end

local function ExitWorld()
  DataCenter.WorldPointWorkStateManager:Clear()
end

WorldPointWorkStateManager.__init = __init
WorldPointWorkStateManager.__delete = __delete
WorldPointWorkStateManager.Clear = Clear
WorldPointWorkStateManager.StartUp = StartUp
WorldPointWorkStateManager.AddListeners = AddListeners
WorldPointWorkStateManager.RemoveListeners = RemoveListeners
WorldPointWorkStateManager.Create = Create
WorldPointWorkStateManager.Remove = Remove
WorldPointWorkStateManager.EnterWorld = EnterWorld
WorldPointWorkStateManager.ExitWorld = ExitWorld
return WorldPointWorkStateManager
