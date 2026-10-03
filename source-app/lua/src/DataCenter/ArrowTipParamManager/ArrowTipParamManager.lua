local ArrowTipParamManager = BaseClass("ArrowTipParamManager")

local function __init(self)
  self.paramPool = {}
end

local function __delete(self)
  self.paramPool = nil
end

local function Get(self, paramType)
  if self.paramPool[paramType] and #self.paramPool[paramType] > 0 then
    local param = self.paramPool[paramType][#self.paramPool[paramType]]
    param:Reset()
    table.remove(self.paramPool[paramType], #self.paramPool[paramType])
    return param
  end
  local class = ArrowTipEnumtype.ParamClass[paramType]
  if class then
    if not self.requireClasses then
      self.requireClasses = {}
    end
    if not self.requireClasses[paramType] then
      self.requireClasses[paramType] = require(class)
    end
    return self.requireClasses[paramType].New()
  end
  return nil
end

local function Recycle(self, param)
  if not param then
    return
  end
  if param.type then
    if not self.paramPool[param.type] then
      self.paramPool[param.type] = {}
    end
    self.paramPool[param.type][#self.paramPool[param.type] + 1] = param
  end
end

ArrowTipParamManager.__init = __init
ArrowTipParamManager.__delete = __delete
ArrowTipParamManager.Get = Get
ArrowTipParamManager.Recycle = Recycle
return ArrowTipParamManager
