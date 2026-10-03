local UpdatableSingleton = BaseClass("UpdatableSingleton", Updatable)

local function __init(self)
  assert(rawget(self._class_type, "Instance") == nil, self._class_type.__cname .. " to create UpdatableSingleton twice!")
  rawset(self._class_type, "Instance", self)
end

local function __delete(self)
  rawset(self._class_type, "Instance", nil)
end

local function Startup(self)
end

local function GetInstance(self)
  if rawget(self, "Instance") == nil then
    rawset(self, "Instance", self.New())
  end
  assert(self.Instance ~= nil)
  return self.Instance
end

local function Delete(self)
  self.Instance = nil
end

UpdatableSingleton.__init = __init
UpdatableSingleton.__delete = __delete
UpdatableSingleton.Startup = Startup
UpdatableSingleton.GetInstance = GetInstance
UpdatableSingleton.Destory = Destory
return UpdatableSingleton
