local PlatformData = BaseClass("PlatformData")

function PlatformData:__init(msg)
  self:Refresh(msg)
end

function PlatformData:__delete()
  self:Destroy()
end

function PlatformData:Refresh(msg)
  self.lineUp = {}
  if msg.lineUp then
    for i = 1, #msg.lineUp do
      local index = msg.lineUp[i].carriageId + 1
      self.lineUp[index] = msg.lineUp[i].userList
    end
  end
  self.freeTrainTime = msg.freeTrainTime
  self.readyEndTime = msg.readyEndTime
  self.platformId = msg.platformId
  self.trainUuid = msg.trainUuid
  self.state = msg.state
  self.meInQueue = false
  if self.state == TrainPlatformState.TrainWithDriver then
    for _, userList in pairs(self.lineUp) do
      for j = 1, #userList do
        if LuaEntry.Player.uid == userList[j].uid then
          self.meInQueue = true
        end
      end
    end
  end
  self.vipInvite = msg.vipInvite
end

function PlatformData:Destroy()
  self.lineUp = {}
end

function PlatformData:MeInQueue()
  return self.meInQueue
end

return PlatformData
