local Messenger = require("Framework.Common.Messenger")
local UpdateManager = BaseClass("UpdateManager", Singleton)
local UpdateMsgName = "Update"
local SecondUpdateMsgName = "SecondUpdate"
local LateUpdateMsgName = "LateUpdate"

local function __init(self)
  self.ui_message_center = nil
  self.__update_handle = nil
  self.passTime = 1
  self.__lateUpdate_handle = nil
end

local function UpdateHandle(self)
  self.ui_message_center:Broadcast(UpdateMsgName)
  self.passTime = self.passTime - Time.unscaledDeltaTime
  if self.passTime <= 0 then
    self.ui_message_center:Broadcast(SecondUpdateMsgName)
    self.passTime = 1
  end
end

local function LateUpdateHandle(self)
  self.ui_message_center:Broadcast(LateUpdateMsgName)
end

local function Startup(self)
  self:Dispose()
  self.__update_handle = UpdateBeat:CreateListener(UpdateHandle, UpdateManager:GetInstance())
  UpdateBeat:AddListener(self.__update_handle)
  self.__lateUpdate_handle = LateUpdateBeat:CreateListener(LateUpdateHandle, UpdateManager:GetInstance())
  LateUpdateBeat:AddListener(self.__lateUpdate_handle)
  self.ui_message_center = Messenger.New()
end

local function Dispose(self)
  if self.__update_handle ~= nil then
    UpdateBeat:RemoveListener(self.__update_handle)
    self.__update_handle = nil
  end
  if self.__lateUpdate_handle ~= nil then
    LateUpdateBeat:RemoveListener(self.__lateUpdate_handle)
    self.__lateUpdate_handle = nil
  end
end

local function Cleanup(self)
end

local function AddUpdate(self, e_listener)
  self.ui_message_center:AddListener(UpdateMsgName, e_listener)
end

local function RemoveUpdate(self, e_listener)
  self.ui_message_center:RemoveListener(UpdateMsgName, e_listener)
end

local function AddSecondUpdate(self, e_listener)
  self.ui_message_center:AddListener(SecondUpdateMsgName, e_listener)
end

local function RemoveSecondUpdate(self, e_listener)
  self.ui_message_center:RemoveListener(SecondUpdateMsgName, e_listener)
end

function UpdateManager:AddLateUpdate(e_listener)
  self.ui_message_center:AddListener(LateUpdateMsgName, e_listener)
end

function UpdateManager:RemoveLateUpdate(e_listener)
  self.ui_message_center:RemoveListener(LateUpdateMsgName, e_listener)
end

local function __delete(self)
  self:Cleanup()
  self.ui_message_center = nil
end

UpdateManager.__init = __init
UpdateManager.Startup = Startup
UpdateManager.Dispose = Dispose
UpdateManager.Cleanup = Cleanup
UpdateManager.AddUpdate = AddUpdate
UpdateManager.RemoveUpdate = RemoveUpdate
UpdateManager.AddSecondUpdate = AddSecondUpdate
UpdateManager.RemoveSecondUpdate = RemoveSecondUpdate
UpdateManager.__delete = __delete
return UpdateManager
