local RedPointManager = BaseClass("RedPointManager", CEventable)
require("RedPoint.RedDef")

function RedPointManager:__init()
  self.dirtyNodes = {}
  self.depthMap = {}
  self.rootNode = nil
  self.timer = TimerManager:GetInstance():GetTimer(0, self.__UpdateDirtyNodes, self, false, true, false)
end

function RedPointManager:Clear(isReset)
  if self.rootNode then
    if isReset then
      self.rootNode:Reset()
    else
      self.rootNode:Delete()
      self.rootNode = nil
    end
  end
  self.dirtyNodes = {}
  self.depthMap = {}
end

function RedPointManager:InitData(t)
  self:Clear(true)
  if not self.rootNode then
    self.rootNode = RedPointGroup.New("Root")
  end
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
end

function RedPointManager:AfterInit(t)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.rootNode:GetOrAddOnlyChild(RedDef.Season, t)
end

function RedPointManager:GetChild(pathList)
  local currentNode = self.rootNode
  for _, name in ipairs(pathList) do
    if not currentNode then
      break
    end
    if currentNode.GetChild == nil then
      Logger.LogError("RedPointManager:GetChild error, currentNode has no GetChild method, name: " .. tostring(currentNode.name))
      return nil
    end
    currentNode = currentNode:GetChild(name)
  end
  return currentNode
end

function RedPointManager:GetCount(pathList)
  local node = self:GetChild(pathList)
  if not node then
    return 0
  end
  return node:GetCount()
end

function RedPointManager:HasCount(pathList)
  local node = self:GetChild(pathList)
  if not node then
    return false
  end
  return node:GetCount() > 0
end

function RedPointManager:Bind(target, callback, pathList)
  local node = self:GetChild(pathList)
  if not node then
    return
  end
  node:Bind(target, callback)
  return node
end

function RedPointManager:UnBind(target, callback, pathList)
  local node = self:GetChild(pathList)
  if not node then
    return
  end
  node:UnBind(target, callback)
end

function RedPointManager:MarkDirty(node)
  if not self.dirtyNodes[node] then
    self.dirtyNodes[node] = true
    local depth = node.depth
    if not self.depthMap[depth] then
      self.depthMap[depth] = {}
    end
    table.insert(self.depthMap[depth], node)
    self.timer:Resume()
  end
end

function RedPointManager:__UpdateDirtyNodes()
  local sortedDepths = {}
  for depth in pairs(self.depthMap) do
    table.insert(sortedDepths, depth)
  end
  table.sort(sortedDepths, function(a, b)
    return b < a
  end)
  for _, depth in ipairs(sortedDepths) do
    for _, node in ipairs(self.depthMap[depth]) do
      node:UpdateCount()
    end
  end
  self.dirtyNodes = {}
  self.depthMap = {}
  self.timer:Pause()
end

return RedPointManager
