local TruckRobData = BaseClass("TruckRobData")

function TruckRobData:__init(msg)
  self.abbr = msg.abbr or ""
  self.battleReportUuid = msg.battleReportUuid or 0
  self.extraPlunderReward = msg.extraPlunderReward or {}
  self.plunderReward = msg.plunderReward or {}
  self.retakeReward = msg.retakeReward or {}
  self.headPic = msg.headPic or ""
  self.headPicVer = msg.headPicVer or 0
  self.headSkinET = msg.headSkinET or 0
  self.headSkinId = msg.headSkinId or 0
  self.isWin = msg.isWin or false
  self.name = msg.name or ""
  self.power = msg.power or 0
  self.serverId = msg.serverId or 0
  self.time = msg.time or 0
  self.uid = msg.uid or ""
end

function TruckRobData:__delete()
  self.abbr = nil
  self.battleReportUuid = nil
  self.extraPlunderReward = nil
  self.plunderReward = nil
  self.retakeReward = nil
  self.headPic = nil
  self.headPicVer = nil
  self.headSkinET = nil
  self.headSkinId = nil
  self.isWin = nil
  self.name = nil
  self.power = nil
  self.serverId = nil
  self.time = nil
  self.uid = nil
end

return TruckRobData
