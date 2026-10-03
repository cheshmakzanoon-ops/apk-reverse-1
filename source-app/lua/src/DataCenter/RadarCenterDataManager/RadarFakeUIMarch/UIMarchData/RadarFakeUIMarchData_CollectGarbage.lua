local base = require("DataCenter.RadarCenterDataManager.RadarFakeUIMarch.UIMarchData.RadarFakeUIMarchData_Base")
local RadarFakeUIMarchData_CollectGarbage = BaseClass("RadarFakeUIMarchData_CollectGarbage", base)

function RadarFakeUIMarchData_CollectGarbage:__init()
  base.__init(self)
  self:InitVars()
end

function RadarFakeUIMarchData_CollectGarbage:__delete()
  base.__delete(self)
end

function RadarFakeUIMarchData_CollectGarbage:InitVars()
end

function RadarFakeUIMarchData_CollectGarbage:SendStart()
  SFSNetwork.SendMessage(MsgDefines.StartPickGarbage, self.Uuid)
end

function RadarFakeUIMarchData_CollectGarbage:SendEnd()
  SFSNetwork.SendMessage(MsgDefines.FinishSampling, self.Uuid)
end

return RadarFakeUIMarchData_CollectGarbage
