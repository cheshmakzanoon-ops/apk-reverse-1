local FishingDataManager = BaseClass("FishingDataManager")
local Localization = CS.GameEntry.Localization

function FishingDataManager:__init()
  self.myFishList = {}
  self.myFishDict = {}
  self.rank = {}
  self.masterRank = {}
  self.fishPondList = {}
  self.confiscateRecords = {}
end

function FishingDataManager:__delete()
  self:Destroy()
end

function FishingDataManager:Destroy()
end

function FishingDataManager:HandleMyFishList(msg)
  self.myFishList = msg.fishArr or {}
  self.myFishDict = {}
  for _, fish in ipairs(self.myFishList) do
    self.myFishDict[fish.id] = fish
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMyFishList)
end

function FishingDataManager:HandleUseItem(msg)
  local addArr = msg.fishArr or {}
  if table.IsNullOrEmpty(addArr) then
    return
  end
  self.myFishList = self.myFishList or {}
  self.myFishDict = self.myFishDict or {}
  local fishRewards = {}
  for _, addInfo in pairs(addArr) do
    self.myFishDict[addInfo.id] = self.myFishDict[addInfo.id] or {
      id = addInfo.id,
      num = 0,
      hisMaxWeight = 0,
      rank = 0
    }
    self.myFishDict[addInfo.id].num = checknumber(self.myFishDict[addInfo.id].num) + checknumber(addInfo.count)
    local has = false
    for _, fishInfo in pairs(self.myFishList) do
      if fishInfo.id == addInfo.id then
        fishInfo.num = checknumber(fishInfo.num) + checknumber(addInfo.count)
        has = true
        break
      end
    end
    if not has then
      table.insert(self.myFishList, {
        id = addInfo.id,
        num = checknumber(addInfo.count),
        hisMaxWeight = 0,
        rank = 0
      })
    end
    table.insert(fishRewards, {
      rewardType = RewardType.FISH,
      itemId = addInfo.id,
      count = addInfo.count,
      isFish = true,
      isConfiscate = false
    })
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMyFishList)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishingReward, {
    anim = true,
    playEffect = false,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  }, {
    rewardList = fishRewards,
    title = CS.GameEntry.Localization:GetString("128027")
  })
end

function FishingDataManager:FetchUseOneFish(id)
  SFSNetwork.SendMessage(MsgDefines.SeasonFishUseFish, id, 1, 1)
  CommonUtil.PlayerPrefsSetInt(SettingKeys.S6_FISH_USE, id)
end

function FishingDataManager:GetLastUseFishId()
  return CommonUtil.PlayerPrefsGetInt(SettingKeys.S6_FISH_USE, 0)
end

function FishingDataManager:HasAnyActiveStatus()
  local has = false
  LocalController:instance():visitTable(TableName.Fish, function(id, cell)
    if cell.use_goods == 1 and cell.status > 0 and LuaEntry.Effect:HasStatus(cell.status) then
      has = true
      return true
    end
  end)
  return has
end

function FishingDataManager:CanShowEatFishBubble()
  return true
end

function FishingDataManager:SuggestEat()
  if self:HasAnyActiveStatus() then
    return false
  end
  local fishes = self:GetMyFishList(true)
  if not table.IsNullOrEmpty(fishes) then
    for _, fish in pairs(fishes) do
      local fishCell = DataCenter.FishMetaManager:GetMeta(fish.id)
      if fishCell ~= nil and fishCell.use_goods == 1 and checknumber(fishCell.status) > 0 then
        return true
      end
    end
  end
  return false
end

function FishingDataManager:HandleUseOneFish(msg)
  for k, v in pairs(self.myFishList) do
    if v.id == msg.id then
      v.num = msg.num
      v.hisMaxWeight = msg.hisMaxWeight
      break
    end
  end
  if self.myFishDict[msg.id] then
    self.myFishDict[msg.id].num = msg.num
    self.myFishDict[msg.id].hisMaxWeight = msg.hisMaxWeight
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMyFishList)
  local fishMeta = DataCenter.FishMetaManager:GetMeta(msg.id)
  if not string.IsNullOrEmpty(fishMeta.status) then
    local statusMeta = DataCenter.StatusManager:GetTemplate(tonumber(fishMeta.status))
    if statusMeta then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBuff, {anim = true}, statusMeta)
      DataCenter.LWSoundManager:PlaySound(6100061, false)
    end
  end
end

function FishingDataManager:UpdateFish(msg)
  if self.myFishList == nil then
    return
  end
  local indexToId = {}
  for index, fish in ipairs(self.myFishList) do
    indexToId[fish.id] = index
  end
  for _, fish in ipairs(msg) do
    self.myFishDict[fish.id] = fish
    local idx = indexToId[fish.id]
    if idx then
      self.myFishList[idx] = fish
    else
      table.insert(self.myFishList, fish)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMyFishList)
end

function FishingDataManager:GetMyFishList(inBag)
  if inBag then
    local ret = {}
    for _, fish in pairs(self.myFishDict) do
      if fish.num > 0 then
        table.insert(ret, fish)
      end
    end
    return ret
  end
  return self.myFishList
end

function FishingDataManager:GetMyFish(id)
  return self.myFishDict[id]
end

function FishingDataManager:GetMyFishNum(id)
  local fishData = self.myFishDict[id]
  return fishData ~= nil and checknumber(fishData.num) or 0
end

function FishingDataManager:TryEnterFishPond(serverId, cityId)
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
    return
  end
  if not SeasonUtil.IsInSeasonNineNationRainforestMode() then
    UIUtil.ShowTipsId(361026)
    return
  end
  if serverId ~= LuaEntry.Player:GetSourceServerId() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local dayLimit = LuaEntry.DataConfig:TryGetNum("season_pond", "k17", 8)
    local seasonStart = DataCenter.SeasonDataManager:GetSeasonStartTime()
    local unlockTime = seasonStart + (dayLimit - 1) * 24 * 60 * 60 * 1000
    if now < unlockTime then
      local leftTime = UITimeManager:GetInstance():MilliSecondToFmtString(unlockTime - now)
      UIUtil.ShowTipsLocalization("season_other_server_fish_tips", leftTime)
      return
    end
  end
  self.enterPondFinished = false
  
  local function holdFunc()
    return self.enterPondFinished
  end
  
  if self:GetIsLoadVideoTimeout() then
    holdFunc = nil
  end
  
  local function timeoutFunc()
    self.loadVideoTimeout = true
    EventManager:GetInstance():Broadcast(EventId.OnLoadFishingVideoTimeout)
  end
  
  UIUtil.PlayCutSceneAnim(function()
    SFSNetwork.SendMessage(MsgDefines.SeasonFishEnterFishPond, serverId, cityId)
  end, holdFunc, nil, 7, timeoutFunc)
end

function FishingDataManager:SetEnterPondFinished()
  self.enterPondFinished = true
end

function FishingDataManager:GetIsLoadVideoTimeout()
  return self.loadVideoTimeout
end

function FishingDataManager:HandleEnterFishPond(msg)
  self.curPondId = msg.pondId
  self.curPondServerId = msg.serverId
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFishingMain) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishingMain, {anim = true})
  end
end

function FishingDataManager:LeavePond()
  if self.curPondServerId and self.curPondId then
    SFSNetwork.SendMessage(MsgDefines.SeasonFishLeaveFishPond, self.curPondServerId, self.curPondId)
  end
end

function FishingDataManager:GetCurPondIdAndServerId()
  return self.curPondId, self.curPondServerId
end

function FishingDataManager:HandleLeaveFishPond()
  self.curPondId = nil
  self.curPondServerId = nil
end

function FishingDataManager:FishingCast(baitLevel, multiThread)
  if self.curPondServerId and self.curPondId then
    SFSNetwork.SendMessage(MsgDefines.SeasonFishFishing, self.curPondServerId, self.curPondId, baitLevel, multiThread)
  end
end

function FishingDataManager:HandleFishingCast(msg)
  EventManager:GetInstance():Broadcast(EventId.FishAppear, msg)
end

function FishingDataManager:FishingReelIn(color)
  if self.curPondServerId and self.curPondId then
    SFSNetwork.SendMessage(MsgDefines.SeasonFishFinishFishing, self.curPondServerId, self.curPondId, color)
  end
end

function FishingDataManager:HandleFishingReelIn(msg)
  EventManager:GetInstance():Broadcast(EventId.FishingEnd, msg)
end

function FishingDataManager:FetchPondList(onlyOur)
  local type = onlyOur and 1 or 0
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.fishPondList[type] == nil or self.lastFetchPondListTime == nil or now - self.lastFetchPondListTime >= 60000 then
    self.lastFetchPondListTime = now
    SFSNetwork.SendMessage(MsgDefines.SeasonFishGetFishPondList, type)
  end
end

function FishingDataManager:HandlePondList(msg)
  self.fishPondList[msg.type] = msg.fishPondArray or {}
  EventManager:GetInstance():Broadcast(EventId.RefreshFishPondList, msg.type == 1)
end

function FishingDataManager:GetPondList(onlyOur)
  return self.fishPondList[onlyOur and 1 or 0] or {}
end

function FishingDataManager:HandleFishRank(msg)
  msg.rankList = msg.rankArr
  msg.myRank = msg.owner
  self.rank[msg.fishId] = msg
  EventManager:GetInstance():Broadcast(EventId.FishRankRefresh)
end

function FishingDataManager:GetRankList(fishId)
  return self.rank[fishId] or {}
end

function FishingDataManager:HandleFishingMasterRewardList(msg)
  self.masterReward = msg
  EventManager:GetInstance():Broadcast(EventId.OnGetFishingMasterRankReward)
end

function FishingDataManager:GetFishingMasterRewardList()
  return self.masterReward or {}
end

function FishingDataManager:HandleFishingMasterRank(msg)
  msg.rankList = msg.rankArr
  msg.myRank = msg.owner
  if msg.rankList then
    for _, v in pairs(msg.rankList) do
      local weight = tonumber(v.score)
      if 1000 <= weight then
        v.scoreTextString = string.format("%.2fkg", weight * 0.001)
      else
        v.scoreTextString = string.format("%.2fg", weight)
      end
      if v.maxWeightFish then
        local fishMeta = DataCenter.FishMetaManager:GetMeta(v.maxWeightFish)
        if fishMeta then
          local fishName = Localization:GetString(fishMeta.name)
          v.scoreTextString = string.format([[
%s
%s]], fishName, v.scoreTextString)
        end
      end
    end
  end
  if msg.myRank then
    local weight = tonumber(msg.myRank.score)
    if 1000 <= weight then
      msg.myRank.scoreTextString = string.format("%.2fkg", weight * 0.001)
    else
      msg.myRank.scoreTextString = string.format("%.2fg", weight)
    end
    if msg.myRank.maxWeightFish then
      local fishMeta = DataCenter.FishMetaManager:GetMeta(msg.myRank.maxWeightFish)
      if fishMeta then
        local fishName = Localization:GetString(fishMeta.name)
        msg.myRank.scoreTextString = string.format([[
%s
%s]], fishName, msg.myRank.scoreTextString)
      end
    end
  end
  self.masterRank = msg
  EventManager:GetInstance():Broadcast(EventId.FishingMasterRankRefresh)
end

function FishingDataManager:GetFishingMasterRankList()
  return self.masterRank or {}
end

function FishingDataManager:FetchConfiscateRecords()
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetConfiscateRecords)
end

function FishingDataManager:HandleConfiscateRecords(msg)
  self.confiscateRecords = msg.records or {}
  EventManager:GetInstance():Broadcast(EventId.RefreshConfiscateHistory)
end

function FishingDataManager:GetConfiscateRecords()
  return self.confiscateRecords or {}
end

function FishingDataManager:JumpToCrocodile(msg)
  if msg.monsterId and msg.pointId and msg.server and msg.uuid then
    self:LeavePond()
    GoToUtil.CloseAllWindows()
    TimerManager:GetInstance():DelayInvoke(function()
      GoToUtil.JumpToWorldPoint(msg.pointId, msg.uuid, msg.server, nil, 1)
    end, 0.5)
  end
end

return FishingDataManager
