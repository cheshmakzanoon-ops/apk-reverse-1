local MonopolyDigTreasureManager = BaseClass("MonopolyDigTreasureManager", CEventable)
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")

function MonopolyDigTreasureManager:CreateMap(nMapId, nMonopolyLevelId)
  local tConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(nMapId)
  if not tConfig or not tConfig.posList then
    return
  end
  self.nLeftHammerNum = tConfig.hammer_num
  self.nMonopolyId = nMonopolyLevelId
  local nRandomIndex = math.random(1, #tConfig.posList)
  local tPosList = tConfig.posList[nRandomIndex]
  local tMapData = {}
  tMapData.mapConfigId = nMapId
  tMapData.rewardState = DigRewardState.CanNotGet
  tMapData.openInfo = {}
  tMapData.blockInfo = {}
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nLimitTime = tConfig.level_limit_time or 30
  tMapData.endTime = nCurTime + nLimitTime * 1000
  for i, v in ipairs(tConfig.block) do
    local tBlockInfo = {}
    tBlockInfo.bid = v
    tBlockInfo.pos = tPosList[i]
    table.insert(tMapData.blockInfo, tBlockInfo)
  end
  local data = DiggingMapData.New()
  data:UpdateData(tMapData)
  self.tMapData = data
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMonopolyDigTreasure, {anim = true}, self.tMapData)
end

function MonopolyDigTreasureManager:UnlockMonopoly()
  local curMonoPolyData = DataCenter.MonopolyManager:GetCurData()
  if self.nMonopolyId and curMonoPolyData and curMonoPolyData.id == self.nMonopolyId then
    DataCenter.MonopolyManager:UnLockCurMonopolyAndSave()
  end
end

function MonopolyDigTreasureManager:OpenBrick(nPos)
  local nCount = self:GetUseItemNum()
  if nCount <= 0 then
    UIUtil.ShowTipsId("treasure_map_hummer_tips_01")
    return false
  end
  self.nLeftHammerNum = self.nLeftHammerNum - 1
  local tOpenResult = {}
  tOpenResult.pos = nPos
  tOpenResult.openBlockInfo = self:GetDigPosBlockInfo(nPos)
  self.tMapData.brickDic[nPos] = {
    pos = nPos,
    blockInfo = tOpenResult.openBlockInfo
  }
  if tOpenResult.openBlockInfo then
    local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(self.tMapData.mapConfigId)
    local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(tOpenResult.openBlockInfo.bid)
    local blockInfo = DataCenter.DiggingDataManager:GetBlock(tOpenResult.openBlockInfo.bid, self.tMapData.blockInfo)
    if levelConfig and config then
      local get = DataCenter.DiggingDataManager:CheckBlockGet(blockInfo.pos, self.tMapData.brickDic, levelConfig.num_width, config.size_width, config.size_height)
      blockInfo.get = get
      tOpenResult.openBlockInfo.get = get
    end
  end
  local bIsAllGet = true
  for i, v in ipairs(self.tMapData.blockInfo) do
    if not v.get then
      bIsAllGet = false
      break
    end
  end
  if bIsAllGet then
    tOpenResult.rewardState = DigRewardState.CanGet
    self.tMapData.rewardState = DigRewardState.CanGet
    EventManager:GetInstance():Broadcast(EventId.DigTreasureCanGetReward)
  elseif 0 >= self.nLeftHammerNum then
    EventManager:GetInstance():Broadcast(EventId.MonopolyDigGameFail)
  end
  self:OnOpenBrick(tOpenResult)
end

function MonopolyDigTreasureManager:GetDigPosBlockInfo(nPos)
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(self.tMapData.mapConfigId)
  for i, v in ipairs(self.tMapData.blockInfo) do
    local blockConfig = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
    if DataCenter.DiggingDataManager:CheckDigPosIsBlock(v.pos, self.tMapData.brickDic, levelConfig.num_width, blockConfig.size_width, blockConfig.size_height, nPos) then
      local t = {}
      t.pos = v.pos
      t.bid = v.bid
      return t
    end
  end
end

function MonopolyDigTreasureManager:GetUseItemNum()
  return self.nLeftHammerNum or 0
end

function MonopolyDigTreasureManager:OnOpenBrick(t)
  EventManager:GetInstance():Broadcast(EventId.DiggingGameOpen, t)
end

return MonopolyDigTreasureManager
