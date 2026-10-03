local DetectEventDigGameOpenBlockMessage = BaseClass("DetectEventDigGameOpenBlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DetectEventDigGameOpenBlockMessage:OnCreate(eventUuid, pos)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", eventUuid)
  self.sfsObj:PutInt("pos", pos)
end

function DetectEventDigGameOpenBlockMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local nEventUuid = t.eventUuid
    local tDetectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(nEventUuid)
    if not tDetectData then
      return
    end
    local tMapData = tDetectData.digGameInfo
    if not tMapData or tMapData.uuid ~= t.uuid then
      return
    end
    local brickInfo = {
      pos = t.pos,
      blockInfo = t.openBlockInfo
    }
    tMapData.brickDic[t.pos] = brickInfo
    if t.openBlockInfo then
      local blockInfo = DataCenter.DiggingDataManager:GetBlock(t.openBlockInfo.bid, tMapData.blockInfo)
      local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(tMapData.mapConfigId)
      local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(t.openBlockInfo.bid)
      if levelConfig and config then
        local get = DataCenter.DiggingDataManager:CheckBlockGet(t.openBlockInfo.pos, tMapData.brickDic, levelConfig.num_width, config.size_width, config.size_height)
        t.openBlockInfo.get = get
        if blockInfo then
          blockInfo.get = get
        else
          table.insert(tMapData.blockInfo, t.openBlockInfo)
        end
      end
    end
    DataCenter.DetectDigTreasureManager:OnOpenBrick(t)
    if t.rewardState == DigRewardState.CanGet then
      EventManager:GetInstance():Broadcast(EventId.DetectDigGameCanGetReward, t)
    end
  end
end

return DetectEventDigGameOpenBlockMessage
