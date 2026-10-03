local FetchUserCardBoxListMessage = BaseClass("FetchUserCardBoxListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchUserCardBoxListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchUserCardBoxListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.cardBoxList ~= nil then
    DataCenter.SeasonDataManager.cardBoxList = t.cardBoxList
    DataCenter.SeasonDataManager.dailyDropTimes = toInt(t.dailyDropTimes)
    EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  end
end

return FetchUserCardBoxListMessage
