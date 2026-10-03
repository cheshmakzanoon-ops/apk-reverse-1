local base = require("DataCenter.RadarCenterDataManager.RadarFakeUIMarch.UIMarchData.RadarFakeUIMarchData_Base")
local RadarFakeUIMarchData_SeasonVisitor = BaseClass("RadarFakeUIMarchData_SeasonVisitor", base)

function RadarFakeUIMarchData_SeasonVisitor:__init()
end

function RadarFakeUIMarchData_SeasonVisitor:__delete()
end

function RadarFakeUIMarchData_SeasonVisitor:SendStart()
  SFSNetwork.SendMessage(MsgDefines.StartPickGarbage, self.Uuid)
end

function RadarFakeUIMarchData_SeasonVisitor:SendEnd()
  SFSNetwork.SendMessage(MsgDefines.FinishSampling, self.Uuid)
  SFSNetwork.SendMessage(MsgDefines.FinishVisitor, self.Uuid)
end

return RadarFakeUIMarchData_SeasonVisitor
