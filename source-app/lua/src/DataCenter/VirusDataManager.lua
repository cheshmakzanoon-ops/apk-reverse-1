local VirusDataManager = BaseClass("VirusDataManager")

function VirusDataManager:__init()
end

function VirusDataManager:__delete()
end

function VirusDataManager:SetVirusHistory(list)
  self.tempHistoryList = list
  EventManager:GetInstance():Broadcast(EventId.MyBaseVirusChangeHistory)
end

function VirusDataManager:GetVirusHistory()
  return self.tempHistoryList or {}
end

return VirusDataManager
