local UIBaseModel = BaseClass("UIBaseModel")

local function __init(self, ui_name)
  self.__ui_callback = {}
  self.__data_callback = {}
  self.__ui_name = ui_name
  self:OnCreate()
end

local function __delete(self)
  self:OnDestroy()
  for k, v in pairs(self.__ui_callback) do
    self:RemoveUIListener(k, v)
  end
  for k, v in pairs(self.__data_callback) do
    self:RemoveDataListener(k, v)
  end
  self.__ui_callback = nil
  self.__data_callback = nil
  self.__ui_name = nil
end

local function OnCreate(self)
end

local function OnEnable(self, ...)
end

local function OnDisable(self)
end

local function OnDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Activate(self, ...)
  self:OnAddListener()
  self:OnEnable(...)
end

local function Deactivate(self)
  self:OnRemoveListener()
  self:OnDisable()
end

local function AddCallback(keeper, msg_name, callback)
  assert(callback ~= nil)
  keeper[msg_name] = callback
end

local function GetCallback(keeper, msg_name)
  return keeper[msg_name]
end

local function RemoveCallback(keeper, msg_name, callback)
  assert(callback ~= nil)
  keeper[msg_name] = nil
end

local function AddUIListener(self, msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  AddCallback(self.__ui_callback, msg_name, bindFunc)
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

local function UIBroadcast(self, msg_name, ...)
  EventManager:GetInstance():Broadcast(msg_name, bindFunc)
end

local function RemoveUIListener(self, msg_name, callback)
  local bindFunc = GetCallback(self.__ui_callback, msg_name)
  RemoveCallback(self.__ui_callback, msg_name, bindFunc)
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

local function AddDataListener(self, msg_name, callback)
  assert(callback ~= nil, "Error func is nil")
  assert(type(callback) == "function", "Error func is not function")
  
  local function bindFunc(...)
    callback(self, ...)
  end
  
  AddCallback(self.__data_callback, msg_name, bindFunc)
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

local function RemoveDataListener(self, msg_name, callback)
  local bindFunc = GetCallback(self.__data_callback, msg_name)
  RemoveCallback(self.__data_callback, msg_name, bindFunc)
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

UIBaseModel.__init = __init
UIBaseModel.__delete = __delete
UIBaseModel.OnCreate = OnCreate
UIBaseModel.OnEnable = OnEnable
UIBaseModel.OnDisable = OnDisable
UIBaseModel.OnDestroy = OnDestroy
UIBaseModel.OnAddListener = OnAddListener
UIBaseModel.OnRemoveListener = OnRemoveListener
UIBaseModel.Activate = Activate
UIBaseModel.Deactivate = Deactivate
UIBaseModel.AddUIListener = AddUIListener
UIBaseModel.UIBroadcast = UIBroadcast
UIBaseModel.RemoveUIListener = RemoveUIListener
UIBaseModel.AddDataListener = AddDataListener
UIBaseModel.RemoveDataListener = RemoveDataListener
return UIBaseModel
