local ActInfiniteGiftDataManager = BaseClass("ActInfiniteGiftDataManager")
local Localization = CS.GameEntry.Localization

function ActInfiniteGiftDataManager:__init()
  self.actIds = {}
  self.actDetailInfos = {}
end

function ActInfiniteGiftDataManager:__delete()
  self.actIds = nil
  self.actDetailInfos = nil
end

function ActInfiniteGiftDataManager:ParseActDetailInfo(msg)
  if not msg then
    return
  end
  local detailInfo = self.actDetailInfos[tostring(msg.id)]
  if not detailInfo then
    detailInfo = {}
    self.actDetailInfos[tostring(msg.id)] = detailInfo
  end
  detailInfo.aid = msg.id
  local extraData = msg.extra
  if extraData then
    detailInfo.gid = extraData.gid
    detailInfo.lastRefreshTime = extraData.rt * 1000
    detailInfo.firstState = extraData.exst
    detailInfo.secondState = extraData.fst
    detailInfo.thirdState = extraData.fst2
    detailInfo.ngid = extraData.ngid
    detailInfo.curGroupFirstFreeRewards = extraData.fsw or {}
    detailInfo.curGroupFirstFreeRewards = DataCenter.RewardManager:ReturnRewardParamForView(detailInfo.curGroupFirstFreeRewards)
    detailInfo.curGroupSecondFreeRewards = extraData.fsw2 or {}
    detailInfo.curGroupSecondFreeRewards = DataCenter.RewardManager:ReturnRewardParamForView(detailInfo.curGroupSecondFreeRewards)
    detailInfo.nextGroupFirstFreeRewards = extraData.nfsw or {}
    detailInfo.nextGroupFirstFreeRewards = DataCenter.RewardManager:ReturnRewardParamForView(detailInfo.nextGroupFirstFreeRewards)
    detailInfo.nextGroupSecondFreeRewards = extraData.nfsw2 or {}
    detailInfo.nextGroupSecondFreeRewards = DataCenter.RewardManager:ReturnRewardParamForView(detailInfo.nextGroupSecondFreeRewards)
  end
  EventManager:GetInstance():Broadcast(EventId.InfiniteGiftUpdate)
end

function ActInfiniteGiftDataManager:GetActDetailInfo(aid)
  return self.actDetailInfos[tostring(aid)]
end

function ActInfiniteGiftDataManager:ClaimReward(aid, gid, index)
  SFSNetwork.SendMessage(MsgDefines.ActInfiniteGiftGetReward, aid, gid, index)
end

function ActInfiniteGiftDataManager:IsActAcitve(aid)
  local detailInfo = self:GetActDetailInfo(aid)
  if detailInfo and detailInfo.gid and detailInfo.gid > 0 then
    return true
  end
  return false
end

function ActInfiniteGiftDataManager:GetNextRefreshTime(aid)
  local detailInfo = self:GetActDetailInfo(aid)
  if detailInfo and detailInfo.lastRefreshTime > 0 then
    local cdTime = 0
    local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(aid)
    if actBaseInfo then
      cdTime = tonumber(actBaseInfo.para_1) or 0
    end
    return detailInfo.lastRefreshTime + cdTime
  end
  return 0
end

function ActInfiniteGiftDataManager:RefreshActDetailInfo(aid, gid)
  if not aid or not gid then
    return
  end
  local curGroupTemplate = DataCenter.ActInfiniteGiftTemplateDataManager:GetTemplate(gid)
  if not curGroupTemplate then
    return
  end
  if curGroupTemplate.can_refresh ~= 1 then
    return
  end
  local nextRefreshTime = self:GetNextRefreshTime(aid)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if nextRefreshTime > curTime then
    UIUtil.ShowTipsId(100381)
    return
  end
  local actDetailInfo = self:GetActDetailInfo(aid)
  if actDetailInfo and gid ~= actDetailInfo.gid then
    return
  end
  UIUtil.TryShowConfirm(TodayNoSecondConfirmType.InfiniteGiftRefresh, Localization:GetString("2010809"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.ActInfiniteGiftRefresh, aid, gid)
  end, function()
  end, nil, nil, false, nil, nil)
end

return ActInfiniteGiftDataManager
