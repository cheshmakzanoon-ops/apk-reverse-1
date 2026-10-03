local ValentineSendLocalRankMessage = BaseClass("ValentineSendLocalRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineSendLocalRankMessage:OnCreate(activityId, type, startIndex, endIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("start", startIndex)
  self.sfsObj:PutInt("end", endIndex)
  self.sfsObj:PutInt("type", type)
end

function ValentineSendLocalRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local scope = ValentineSendGiftScope.SelfServer
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
    local npcArr = {}
    if t.npcArr then
      npcArr = t.npcArr
    end
    DataCenter.ValentineDataManager:UpdateSendGiftListData(activityId, scope, gender, startIndex, endIndex, data, npcArr)
  end
end

return ValentineSendLocalRankMessage
