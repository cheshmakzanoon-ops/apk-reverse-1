local PushSendGiftGroupRankMessage = BaseClass("PushSendGiftGroupRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSendGiftGroupRankMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSendGiftGroupRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local scope = ValentineSendGiftScope.ZoneServer
    local gender = GenderFilterType.All
    if t.type then
      gender = toInt(t.type)
    end
    local data = {}
    if t.rankArr then
      data = t.rankArr
    end
    local startIndex, endIndex
    if t.start then
      startIndex = t.start
    end
    if t["end"] then
      endIndex = t["end"]
    end
    DataCenter.ValentineDataManager:UpdateSendGiftListData(activityId, scope, gender, startIndex, endIndex, data)
  end
end

return PushSendGiftGroupRankMessage
