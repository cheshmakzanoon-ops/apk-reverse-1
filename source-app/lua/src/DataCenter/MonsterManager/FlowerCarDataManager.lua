local FlowerCarDataManager = BaseClass("FlowerCarDataManager")

function FlowerCarDataManager:__init()
  self.rankData = {}
end

function FlowerCarDataManager:__delete()
  self.rankData = {}
end

function FlowerCarDataManager:HandleRankMessage(msg)
  self.rankData[msg.uuid] = msg
  EventManager:GetInstance():Broadcast(EventId.FlowerCarRankRefresh)
end

function FlowerCarDataManager:GetRankData(uuid)
  if not self.rankData[uuid] then
    return nil
  end
  return self.rankData[uuid].rankList, self.rankData[uuid].selfRank
end

function FlowerCarDataManager:FetchRankData(uuid)
  SFSNetwork.SendMessage(MsgDefines.MonsterDamageRank, uuid)
end

return FlowerCarDataManager
