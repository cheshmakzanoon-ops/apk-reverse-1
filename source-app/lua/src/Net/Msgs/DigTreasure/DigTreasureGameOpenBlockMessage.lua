local DigTreasureGameOpenBlockMessage = BaseClass("DigTreasureGameOpenBlockMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DigTreasureGameOpenBlockMessage:OnCreate(uuid, pos, needCheck)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("pos", pos)
  if needCheck then
    self.sfsObj:PutInt("checkOpenAll", 1)
  else
    self.sfsObj:PutInt("checkOpenAll", 0)
  end
end

function DigTreasureGameOpenBlockMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.checkOpenAll then
      Logger.LogError("\233\135\141\231\189\174\233\154\144\231\167\152\229\174\157\229\186\147\230\149\176\230\141\174")
      UIUtil.ShowTipsId("dig_game_tips_01")
      SFSNetwork.SendMessage(MsgDefines.DigTreasureGameInfo)
      return
    end
    local tMapData = DataCenter.DigTreasureManager:GetCurMapData()
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
        blockInfo.getReward = t.openBlockInfo.getReward
        local get = DataCenter.DiggingDataManager:CheckBlockGet(t.openBlockInfo.pos, tMapData.brickDic, levelConfig.num_width, config.size_width, config.size_height)
        t.openBlockInfo.get = get
        if blockInfo then
          blockInfo.get = get
        else
          table.insert(tMapData.blockInfo, t.openBlockInfo)
        end
      end
    end
    local bCanGetReward = false
    if t.rewardState then
      if tMapData.rewardState ~= t.rewardState and t.rewardState == DigRewardState.CanGet then
        bCanGetReward = true
      end
      tMapData.rewardState = t.rewardState
      local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
      for i, v in ipairs(tRewardData) do
        if v.mapConfigId == t.mapConfigId then
          if v.rewardState ~= t.rewardState then
            v.rewardState = t.rewardState
            EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateRewardData)
          end
          break
        end
      end
    end
    DataCenter.DigTreasureManager:OnOpenBrick(t)
    local bHaveNewMap = false
    if t.newTimeLimitMap then
      bHaveNewMap = true
      DataCenter.DigTreasureManager:SetIsShowFailReward(false)
      DataCenter.DigTreasureManager:UpdateTimeLimitMap(t.newTimeLimitMap)
      DataCenter.DigTreasureManager:DelayShowBeginTimeLimitMapWindow()
    end
    if t.newLevelMap then
      bHaveNewMap = true
      DataCenter.DigTreasureManager:UpdateNormalMapData(t.newLevelMap)
    end
    if bHaveNewMap then
      EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateMapData)
    end
    if bCanGetReward then
      EventManager:GetInstance():Broadcast(EventId.DigTreasureCanGetReward)
    end
    if t.reward then
      if bCanGetReward then
        DataCenter.RewardManager:AddRewardsAndRes(t)
        TimerManager:GetInstance():DelayInvoke(function()
          EventManager:GetInstance():Broadcast(EventId.DigTreasureGetReward)
        end, 1)
        TimerManager:GetInstance():DelayInvoke(function()
          local tAllReward = DataCenter.DigTreasureManager:GetAllTimeLimitMapReward(false)
          local str = Localization:GetString("treasure_map_reward_show_05")
          DataCenter.RewardManager:ShowCommonReward(tAllReward, nil, nil, nil, nil, nil, nil, str)
        end, 1.3)
      elseif t.openBlockInfo and t.openBlockInfo.pos then
        local param = {}
        param.pos = t.openBlockInfo.pos
        param.reward = t.reward
        EventManager:GetInstance():Broadcast(EventId.DigTreasureOpenRewardBlock, param)
      end
    end
  end
end

function DigTreasureGameOpenBlockMessage:ShowGetHammerWindow(nNum)
  if nNum and nNum <= 0 then
    return
  end
  local message = Localization:GetString("treasure_map_special_level_08", nNum)
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM)
end

return DigTreasureGameOpenBlockMessage
