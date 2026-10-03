local MonopolyPerBase = BaseClass("MonopolyPerBase")
local MonopolyBehaviourBase = require("Scene.Monopoly.Performance.Behaviours.MonopolyBehaviourBase")
MonopolyPerBase.State = {
  Init = 0,
  Begin = 1,
  Playing = 3,
  End = 4,
  Destroy = 5
}
local BehaviourType = {
  Begin = 1,
  Loaded = 2,
  End = 3
}

function MonopolyPerBase:__init(mgr, id, lineData)
  self.mgr = mgr
  self.id = id
  self.lineData = lineData
  self.gameObject = nil
  self.goIsActive = nil
  self.state = MonopolyPerBase.State.Init
  self.beginBehaviours = {}
  self.loadedBehaviours = {}
  self.endBehaviours = {}
end

function MonopolyPerBase:TryRunBehaviours(behaviourType)
  local lineKey, behaviours
  if behaviourType == BehaviourType.Begin then
    lineKey = "begin_behaviours"
    behaviours = self.beginBehaviours
  elseif behaviourType == BehaviourType.Loaded then
    lineKey = "loaded_behaviours"
    behaviours = self.loadedBehaviours
  elseif behaviourType == BehaviourType.End then
    lineKey = "end_behaviours"
    behaviours = self.endBehaviours
  end
  if table.IsEmpty(behaviours) and lineKey ~= nil then
    local config = self.lineData:getValue(lineKey)
    if not string.IsNullOrEmpty(config) then
      local behavioursStrArr = string.split(config, "|")
      for _, behavioursStr in ipairs(behavioursStrArr) do
        local behaviourStrArr = string.split(behavioursStr, ":")
        local behaviour = MonopolyBehaviourBase.Instantiate(behaviourStrArr[1], self, behaviourStrArr[2])
        if behaviour then
          table.insert(behaviours, behaviour)
        end
      end
    end
  end
  if behaviours then
    for _, behaviour in ipairs(behaviours) do
      behaviour:Begin()
    end
  end
end

function MonopolyPerBase:__delete()
  self:OnDestroy()
end

function MonopolyPerBase:OnDestroy()
  if self.beginBehaviours then
    for i, v in ipairs(self.beginBehaviours) do
      v:OnDestroy()
    end
  end
  if self.loadedBehaviours then
    for i, v in ipairs(self.loadedBehaviours) do
      v:OnDestroy()
    end
  end
  if self.endBehaviours then
    for i, v in ipairs(self.endBehaviours) do
      v:OnDestroy()
    end
  end
  if self.req then
    self.req:RealDestroy()
    self.req = nil
  end
  self.mgr = nil
  self.id = nil
  self.lineData = nil
  self.gameObject = nil
  self.goIsActive = nil
  self.state = MonopolyPerBase.State.Destroy
end

function MonopolyPerBase:Begin()
  if self.state ~= MonopolyPerBase.State.Init then
    return
  end
  self.state = MonopolyPerBase.State.Begin
  self:TryRunBehaviours(BehaviourType.Begin)
  local resPath = self.lineData:getValue("per_path")
  if not string.IsNullOrEmpty(resPath) then
    local req = CS.GameEntry.Resource:InstantiateAsync(resPath)
    if req then
      req:completed("+", function(handle)
        self:OnResLoaded(handle)
      end)
      self.req = req
    end
  else
    self:OnResLoaded(nil, true)
  end
end

function MonopolyPerBase:OnResLoaded(handle, noRes)
  self.state = MonopolyPerBase.State.Playing
  if not noRes then
    if handle == nil or handle.isError then
      self.mgr:TryTriggerPerformanceEnd(self.id)
      return
    end
    self.gameObject = handle.gameObject
    self.gameObject:SetActive(self.goIsActive == nil or self.goIsActive == true)
  end
  self:TryRunBehaviours(BehaviourType.Loaded)
end

function MonopolyPerBase:End()
  if self.state == MonopolyPerBase.State.Destroy or self.state == MonopolyPerBase.State.End then
    return
  end
  self.state = MonopolyPerBase.State.End
  self:TryRunBehaviours(BehaviourType.End)
  self:OnDestroy()
end

function MonopolyPerBase:SetActive(active)
  self.goIsActive = active
  if self.gameObject then
    self.gameObject:SetActive(active)
  end
end

return MonopolyPerBase
