local WorkerUpBuildBubbleDataManager = BaseClass("WorkerUpBuildBubbleDataManager")

local function __init(self)
  self.isWorkerDataDirty = true
  self.isItemCostDirty = true
  self.workerData = {}
  self.workFragData = nil
  self.isShowBubble = false
  self.timer = nil
  self:AddListener()
  self.isURQualityCanRankUp = true
  self.isURQualityCanRankUpDataDirty = true
  self.isSSRQualityCanRankUp = true
  self.isSSRQualityCanRankUpDataDirty = true
end

local function __delete(self)
  self.isWorkerDataDirty = nil
  self.isItemCostDirty = nil
  self.workerData = nil
  self.workFragData = nil
  self.isShowBubble = nil
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  EventManager:GetInstance():AddListener(EventId.AcquireWorker, self.GetWorkerInfoUpdateMsg)
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  EventManager:GetInstance():RemoveListener(EventId.AcquireWorker, self.GetWorkerInfoUpdateMsg)
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
end

local function GetRefreshItemsMsg()
  local self = DataCenter.WorkerUpBuildBubbleDataManager
  self.isItemCostDirty = true
  self:SetExtraDataDirty()
  self:TrySendMsg()
end

local function GetWorkerInfoUpdateMsg()
  local self = DataCenter.WorkerUpBuildBubbleDataManager
  self.isWorkerDataDirty = true
  self.isItemCostDirty = true
  self:SetExtraDataDirty()
  self:TrySendMsg()
end

local function GetIsShowBubble(self)
  if self.isWorkerDataDirty then
    self.isWorkerDataDirty = false
    if self.workFragData == nil then
      self.workFragData = {}
      local allFragData = DataCenter.WorkerDataManager:GetAllFragData()
      for k, v in pairs(allFragData) do
        if self.workFragData[k] == nil then
          self.workFragData[k] = {fragData = v}
        end
      end
    end
    local allWorkerData = DataCenter.WorkerDataManager:GetAllWorkerData()
    for uid, workerData in pairs(allWorkerData) do
      if self.workerData[uid] == nil then
        local rankBaseTemp = workerData.star > 0 and DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(workerData.cfgId, 1) or nil
        self.workerData[uid] = {
          workerData = workerData,
          star = workerData.star,
          rankBaseTemp = rankBaseTemp,
          curRank = -1
        }
      end
      local curWorkerData = self.workerData[uid]
      if curWorkerData.star > 0 and curWorkerData.curRank ~= curWorkerData.workerData.rank then
        curWorkerData.curRank = curWorkerData.workerData.rank
        local maxRank = curWorkerData.rankBaseTemp.max_rank
        curWorkerData.isMaxRank = maxRank <= curWorkerData.curRank
        if not curWorkerData.isMaxRank then
          local nextRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(curWorkerData.workerData.cfgId, curWorkerData.curRank + 1)
          if nextRankTemp then
            local goodsData = nextRankTemp.rank_goods_data
            curWorkerData.costData = goodsData
          end
        end
      end
      if self.workFragData[workerData.cfgId] then
        self.workFragData[workerData.cfgId].workerData = workerData
      end
    end
  end
  if self.isItemCostDirty then
    self.isItemCostDirty = false
    self.isShowBubble = false
    for k, v in pairs(self.workerData) do
      if v.star > 0 and not v.isMaxRank then
        local goodsData = v.costData
        if 0 < #goodsData then
          local isRankEnough = true
          for _, data in ipairs(goodsData) do
            local goodsId = data[1]
            local goodsNum = data[2] or 0
            local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
            if goodsNum > curNum then
              isRankEnough = false
              break
            end
          end
          if isRankEnough then
            self.isShowBubble = true
            break
          end
        end
      end
    end
    if self.isShowBubble == false then
      for k, v in pairs(self.workFragData) do
        if v.workerData == nil then
          local needNum = v.fragData.needNum
          local goodsId = v.fragData.itemCfg.id
          local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
          if needNum <= curNum then
            self.isShowBubble = true
            break
          end
        end
      end
    end
  end
  return self.isShowBubble
end

local function TrySendMsg(self)
  if self.timer ~= nil then
    return
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    EventManager:GetInstance():Broadcast(EventId.NeedRefreshWorkerUpBubble)
  end, 1)
end

local function CheckURWorkerCanRankUp(self)
  if self.isURQualityCanRankUpDataDirty then
    self.isURQualityCanRankUpDataDirty = false
    self.isURQualityCanRankUp = false
    local isBubbleShow = self:GetIsShowBubble()
    if not isBubbleShow then
    else
      local targetQuality = WorkerQualityType.Legendary
      for k, v in pairs(self.workerData) do
        if v.workerData.quality == targetQuality and v.star > 0 and not v.isMaxRank then
          local goodsData = v.costData
          if 0 < #goodsData then
            local isRankEnough = true
            for _, data in ipairs(goodsData) do
              local goodsId = data[1]
              local goodsNum = data[2] or 0
              local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
              if goodsNum > curNum then
                isRankEnough = false
                break
              end
            end
            if isRankEnough then
              self.isURQualityCanRankUp = true
              break
            end
          end
        end
      end
    end
  end
  return self.isURQualityCanRankUp
end

local function CheckSSRWorkerCanRankUp(self)
  if self.isSSRQualityCanRankUpDataDirty then
    self.isSSRQualityCanRankUpDataDirty = false
    self.isSSRQualityCanRankUp = false
    local isBubbleShow = self:GetIsShowBubble()
    if not isBubbleShow then
    else
      local targetQuality = WorkerQualityType.Genius
      for k, v in pairs(self.workerData) do
        if v.workerData.quality == targetQuality and v.star > 0 and not v.isMaxRank then
          local goodsData = v.costData
          if 0 < #goodsData then
            local isRankEnough = true
            for _, data in ipairs(goodsData) do
              local goodsId = data[1]
              local goodsNum = data[2] or 0
              local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
              if goodsNum > curNum then
                isRankEnough = false
                break
              end
            end
            if isRankEnough then
              self.isSSRQualityCanRankUp = true
              break
            end
          end
        end
      end
    end
  end
  return self.isSSRQualityCanRankUp
end

local function SetExtraDataDirty(self)
  self.isURQualityCanRankUpDataDirty = true
  self.isSSRQualityCanRankUpDataDirty = true
end

WorkerUpBuildBubbleDataManager.__init = __init
WorkerUpBuildBubbleDataManager.__delete = __delete
WorkerUpBuildBubbleDataManager.AddListener = AddListener
WorkerUpBuildBubbleDataManager.RemoveListener = RemoveListener
WorkerUpBuildBubbleDataManager.GetRefreshItemsMsg = GetRefreshItemsMsg
WorkerUpBuildBubbleDataManager.GetWorkerInfoUpdateMsg = GetWorkerInfoUpdateMsg
WorkerUpBuildBubbleDataManager.GetIsShowBubble = GetIsShowBubble
WorkerUpBuildBubbleDataManager.TrySendMsg = TrySendMsg
WorkerUpBuildBubbleDataManager.CheckURWorkerCanRankUp = CheckURWorkerCanRankUp
WorkerUpBuildBubbleDataManager.CheckSSRWorkerCanRankUp = CheckSSRWorkerCanRankUp
WorkerUpBuildBubbleDataManager.SetExtraDataDirty = SetExtraDataDirty
return WorkerUpBuildBubbleDataManager
