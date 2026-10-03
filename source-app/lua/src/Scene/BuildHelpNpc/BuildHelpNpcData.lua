local base = require("Scene.LWCityPerformNpc.DataBase.PerformData")
local BuildHelpNpcData = BaseClass("BuildHelpNpcData", base)

local function __init(self)
  self.playerHead = nil
  self.helperSysName = nil
  self.helpName = nil
end

local function __delete(self)
  self.playerHead = nil
  self.helperSysName = nil
  self.helpName = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function InitData(self, birthPos, endPos, modelPatch, playerHead, helperSysName, helpName)
  base.InitData(self, birthPos, endPos, modelPatch)
  self.playerHead = playerHead
  self.helperSysName = helperSysName
  self.helpName = helpName
end

BuildHelpNpcData.__init = __init
BuildHelpNpcData.__delete = __delete
BuildHelpNpcData.InitData = InitData
return BuildHelpNpcData
