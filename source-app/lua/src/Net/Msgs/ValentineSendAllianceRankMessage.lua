local ValentineSendAllianceRankMessage = BaseClass("ValentineSendAllianceRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ValentineSendAllianceRankMessage:OnCreate(activityId, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("type", type)
end

function ValentineSendAllianceRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local scope = ValentineSendGiftScope.Alliance
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
      endIndex = #data
    end
    table.sort(data, function(a, b)
      return a.shareInfo.thumbsUpCount > b.shareInfo.thumbsUpCount
    end)
    DataCenter.ValentineDataManager:UpdateSendGiftListData(activityId, scope, gender, startIndex, endIndex, data)
  end
end

return ValentineSendAllianceRankMessage
