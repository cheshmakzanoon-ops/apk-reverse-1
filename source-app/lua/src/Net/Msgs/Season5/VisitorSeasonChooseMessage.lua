local VisitorSeasonChooseMessage = BaseClass("VisitorSeasonChooseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function VisitorSeasonChooseMessage:OnCreate(uid, chooseId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uid", uid)
  self.sfsObj:PutInt("chooseId", chooseId)
end

function VisitorSeasonChooseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.CityVisitorManager:FinishVisitorByUid(t.uid)
  if t.eventInfo then
    DataCenter.RadarCenterDataManager:UpdateOneDetectEventInfo(t.eventInfo)
    EventManager:GetInstance():Broadcast(EventId.DetectEventGetBatchRealPoint)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, t.eventInfo.uuid, true)
  end
end

function VisitorSeasonChooseMessage:GetTestData(uid, chooseId)
  local t = {}
  t.uid = uid
  t.chooseId = chooseId or 1
  t.eventInfo = {
    eventId = "601001",
    cost = 0,
    pointId = 365720,
    num = 0,
    startTime = 1754967897844,
    state = 3,
    endTime = 1754996697844,
    type = 44,
    isFrozen = false,
    uuid = tostring(math.random(100000, 10000000000))
  }
  return t
end

return VisitorSeasonChooseMessage
