local UIBaseRecordModel = BaseClass("UIBaseRecordModel", UIBaseModel)
local base = UIBaseModel

local function OnCreate(self)
  base.OnCreate(self)
  self.__window_stack = {}
  self.__enable_record = false
  UIManager:GetInstance():SetKeepModel(self.__ui_name, true)
end

local function OnEnable(self, ...)
  base.OnEnable(self, ...)
  table.walk(self.__window_stack, function(index, ui_name)
    UIManager:GetInstance():OpenWindow(ui_name)
  end)
  self.__enable_record = true
end

local function GetWindowStack(self)
  return self.__window_stack
end

local function ClearWindowStack(self)
  self.__window_stack = {}
end

local function OnWindowOpen(self, window)
  if not self.__enable_record or window.Layer:GetName() ~= UILayer.Normal.Name then
    return
  end
  table.insert(self.__window_stack, window.Name)
  UIManager:GetInstance():SetKeepModel(window.Name, true)
end

local function OnWindowClose(self, window)
  if not self.__enable_record or window.Layer:GetName() ~= UILayer.Normal.Name then
    return
  end
  local index
  for i, v in pairs(self.__window_stack) do
    if v == window.Name then
      index = i
      break
    end
  end
  if index then
    local length = table.length(self.__window_stack)
    for i = 0, length - index do
      local ui_name = table.remove(self.__window_stack, length - i)
      UIManager:GetInstance():SetKeepModel(ui_name, false)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.__enable_record = false
end

local function OnDestroy(self)
  self.__window_stack = nil
  base.OnDestroy(self)
end

UIBaseRecordModel.OnCreate = OnCreate
UIBaseRecordModel.OnEnable = OnEnable
UIBaseRecordModel.GetWindowStack = GetWindowStack
UIBaseRecordModel.ClearWindowStack = ClearWindowStack
UIBaseRecordModel.OnAddListener = OnAddListener
UIBaseRecordModel.OnRemoveListener = OnRemoveListener
UIBaseRecordModel.OnDisable = OnDisable
UIBaseRecordModel.OnDestroy = OnDestroy
return UIBaseRecordModel
