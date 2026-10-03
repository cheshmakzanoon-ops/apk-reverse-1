local base = require("RedPoint.Core.RedPointNode")
local RedPointGroup = BaseClass("RedPointGroup", base)
local require = _ENV.require
local required = {}

function RedPointGroup:__init(nodeName)
  self.children = {}
end

function RedPointGroup:__delete()
  for _, child in pairs(self.children) do
    child:Delete()
  end
  self.children = nil
end

function RedPointGroup:SetCount(count)
  Logger.LogError("RedPointGroup:SetCount: Cannot set count directly on a group node '" .. self.name .. "'")
end

function RedPointGroup:UpdateCount()
  self.newCount = 0
  if self.children then
    for _, child in pairs(self.children) do
      self.newCount = self.newCount + child:GetCount()
    end
  end
  base.UpdateCount(self)
end

function RedPointGroup:GetChild(nodeName)
  return self.children[nodeName]
end

function RedPointGroup:GetAllChildren()
  return self.children
end

function RedPointGroup:GetOrAddChild(redPointDefine, nodeName, ...)
  nodeName = nodeName or redPointDefine
  local node = self.children[nodeName]
  if not node then
    node = self:AddChild(redPointDefine, nodeName, ...)
  else
    node:SetData(...)
  end
  return node
end

function RedPointGroup:GetOrAddOnlyChild(redPointDefine, ...)
  return self:GetOrAddChild(redPointDefine, redPointDefine, ...)
end

function RedPointGroup:ResetChild(nodeName, ...)
  local node = self.children[nodeName]
  if node then
    node:Reset()
  end
end

function RedPointGroup:Reset()
  if table.IsNullOrEmpty(self.children) then
    return
  end
  for _, child in pairs(self.children) do
    child:Reset()
  end
end

function RedPointGroup:ResetAllChild()
  self:Reset()
end

function RedPointGroup:RemoveChild(nodeName)
  local node = self.children[nodeName]
  if not node then
    Logger.LogError("Child node with name '" .. nodeName .. "' does not exist in group '" .. self.name .. "'")
    return
  end
  node:Delete()
  self.children[nodeName] = nil
  self:SetDirty()
end

function RedPointGroup:RemoveAllChild()
  if table.IsNullOrEmpty(self.children) then
    return
  end
  for _, child in pairs(self.children) do
    child:Delete()
  end
  self.children = {}
  self:SetDirty()
end

function RedPointGroup:AddOnlyChild(redPointDefine, ...)
  return self:AddChild(redPointDefine, redPointDefine, ...)
end

function RedPointGroup:AddChild(redPointDefine, nodeName, ...)
  nodeName = nodeName or redPointDefine
  local class = required[redPointDefine]
  if not class then
    local classPath = RedRequire[redPointDefine]
    if type(classPath) == "string" then
      class = require(classPath)
    elseif type(classPath) == "table" then
      class = classPath
    end
    class = class or RedPointNode
    required[redPointDefine] = class
  end
  local node = self:AddChildByNode(class.New(nodeName))
  node:SetData(...)
  return node
end

function RedPointGroup:AddChildByNode(node)
  if self.children[node.name] then
    node:Delete()
    Logger.LogError("Child node with name '" .. node.name .. "' already exists in group '" .. self.name .. "'")
    return
  end
  self.children[node.name] = node
  node:OnBindParent(self)
  self:SetDirty()
  return node
end

return RedPointGroup
