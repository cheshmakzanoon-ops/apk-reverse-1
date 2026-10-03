local base = require("DataCenter.RadarCenterDataManager.RadarFakeUIMarch.UIMarchData.RadarFakeUIMarchData_Base")
local RadarFakeUIMarchData_Help = BaseClass("RadarFakeUIMarchData_Help", base)

function RadarFakeUIMarchData_Help:__init()
  base.__init(self)
  self:InitVars()
end

function RadarFakeUIMarchData_Help:__delete()
  base.__delete(self)
end

function RadarFakeUIMarchData_Help:InitVars()
end

function RadarFakeUIMarchData_Help:SendStart()
  SFSNetwork.SendMessage(MsgDefines.DetectEventHelpStart, self.Uuid, DetectEventType.HELPER)
end

function RadarFakeUIMarchData_Help:SendEnd()
  SFSNetwork.SendMessage(MsgDefines.DetectEventHelpEnd, self.Uuid, DetectEventType.HELPER)
end

return RadarFakeUIMarchData_Help
