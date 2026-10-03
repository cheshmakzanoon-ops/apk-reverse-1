local Updatable = BaseClass("Updatable")

local function AddUpdate(self)
  if self.Update ~= nil then
    function self.__update_handle()
      self:Update()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  end
end

local function RemoveUpdate(self)
  if self.__update_handle ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
end

local function __init(self)
  self:EnableUpdate(true)
end

local function __delete(self)
  self:EnableUpdate(false)
end

local function EnableUpdate(self, enable)
  RemoveUpdate(self)
  if enable then
    AddUpdate(self)
  end
end

Updatable.__init = __init
Updatable.__delete = __delete
Updatable.EnableUpdate = EnableUpdate
return Updatable
