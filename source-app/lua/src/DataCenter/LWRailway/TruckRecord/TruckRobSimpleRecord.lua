local TruckRobSimpleRecord = BaseClass("TruckRobSimpleRecord")

function TruckRobSimpleRecord:__init(msg)
  self.headPic = msg.headPic or ""
  self.headPicVer = msg.headPicVer or 0
  self.isWin = msg.win or false
  self.name = msg.name or ""
  self.record_time = msg.record_time or 0
  self.record_uuid = msg.record_uuid or 0
  self.serverId = msg.serverId or 0
  self.train_owner = msg.train_owner or ""
end

function TruckRobSimpleRecord:__delete()
  self.headPic = nil
  self.headPicVer = nil
  self.isWin = nil
  self.name = nil
  self.record_time = nil
  self.record_uuid = nil
  self.serverId = nil
  self.train_owner = nil
end

return TruckRobSimpleRecord
