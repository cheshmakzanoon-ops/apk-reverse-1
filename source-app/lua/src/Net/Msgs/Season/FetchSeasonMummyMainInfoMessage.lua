local FetchSeasonMummyMainInfoMessage = BaseClass("FetchSeasonMummyMainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonMummyMainInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonMummyMainInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local now = UITimeManager:GetInstance():GetServerTime()
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.list then
    DataCenter.SeasonMummyDataManager.waitConvertArmyTime = now
    DataCenter.SeasonMummyDataManager.waitConvertArmyList = t.list
  end
  if t.recList then
    DataCenter.SeasonMummyDataManager:UpdateRecArmy(t.recList)
  end
  if t.maxMummyNum then
    DataCenter.SeasonMummyDataManager.maxMummyNum = t.maxMummyNum
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateSeasonDeathSoldierInfo)
end

return FetchSeasonMummyMainInfoMessage
