local UIFarmIrrigateCtrl = BaseClass("UIFarmIrrigateCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFarmIrrigate)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self, data)
  local buildUuid = tonumber(data)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if buildData ~= nil then
    self.buildId = buildData.itemId
    self.pointId = buildData.pointId
  end
  local queueData = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(buildUuid)
  if queueData ~= nil then
    self.qUuid = queueData.uuid
  end
  self.isAllCareerEffectShow = false
  self.tempResource = {}
  self.productId = 0
  self.queueList = {}
  self.close = nil
end

local function GetItemList(self)
  return self:GetFarmItemListData()
end

local function GetFarmItemListData(self)
  local list = {}
  if self.qUuid ~= nil and self.buildId ~= nil then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.qUuid)
    local state = queueData:GetQueueState()
    if state == NewQueueState.Work then
      local data = {}
      data.icon = "Assets/Main/Sprites/pve/huasha"
      data.hasDes = true
      data.farmState = FarmStateType.Irrigate
      data.order = 0
      data.buildType = self.buildId
      data.sizeX = 150
      data.sizeY = 150
      local irrigateInfo = DataCenter.PlayerCareerManager:GetIrrigationInfo(IrrigationType.Farmland)
      data.needResourceIcon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Water)
      data.desNum = irrigateInfo.cost
      table.insert(list, data)
    end
  end
  return list
end

local function OnDragTrigger(self, curPos, itemData, queueData)
  if queueData ~= nil and not self.close and queueData.type == NewQueueType.Field and itemData.farmState == FarmStateType.Irrigate and self.queueList[queueData.uuid] == nil and queueData:GetQueueState() == NewQueueState.Work then
    local remainIrrigateNum, nextRecoverT = DataCenter.PlayerCareerManager:GetRemainIrrigationTimes(IrrigationType.Farmland)
    if not self.remainIrrigateTimes then
      self.remainIrrigateTimes = remainIrrigateNum
    end
    if self.remainIrrigateTimes > 0 then
      if not queueData:CheckIfIrrigated() then
        if not self:CheckIsResourceEnough(ResourceType.Water, itemData.desNum) then
          local lackTab = {}
          local param = {}
          param.type = ResLackType.Res
          param.resType = ResourceType.Water
          param.targetNum = itemData.desNum
          table.insert(lackTab, param)
          GoToResLack.GoToItemResLackList(lackTab)
          CS.SceneManager.World:QuitFocus(LookAtFocusTime)
          DataCenter.CareerEffectManager:RemoveAll()
        else
          self.queueList[queueData.uuid] = 1
          SFSNetwork.SendMessage(MsgDefines.FarmerIrrigate, queueData.uuid)
          self.remainIrrigateTimes = self.remainIrrigateTimes - 1
          DataCenter.DecResourceEffectManager:DecOneItemEffect(curPos, itemData.needResourceIcon, -itemData.desNum, queueData.funcUuid)
          EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideOnly)
          if self.tempResource[ResourceType.Water] ~= nil then
            self.tempResource[ResourceType.Water] = self.tempResource[ResourceType.Water] - itemData.desNum
          end
        end
      end
    else
      local strType = Localization:GetString("395184")
      local serverT = UITimeManager:GetInstance():GetServerTime()
      local needTime = nextRecoverT - serverT
      local strTime = UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(needTime)
      UIUtil.ShowTips(Localization:GetString("395399", strType, strTime))
      self:OnDragFinish()
    end
  end
end

local function OnDragFinish(self, itemData)
  self.productId = 0
  self.queueList = {}
  self.remainIrrigateTimes = nil
  self.close = true
  self:CloseSelf()
  CS.SceneManager.World:QuitFocus(LookAtFocusTime)
end

local function CheckIsStorageFull(self, farmState, qUuid)
  local isFull = false
  local addNum = 0
  table.walk(self.queueList, function(k, v)
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(k)
    if queueData ~= nil then
      local functionId = queueData.itemId
      if functionId == nil or functionId == "" then
        return
      end
      local farmTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(functionId)
      if farmTemplate ~= nil then
        local canGetNum = 0
        local itemId = 0
        if farmState == FarmStateType.Harvest then
          table.walk(farmTemplate.get_goods, function(m, n)
            itemId = m
            canGetNum = n
          end)
          if DataCenter.ResourceItemDataManager:CheckIsStorageFull(addNum + canGetNum) then
            isFull = true
          else
            addNum = canGetNum + addNum
          end
        end
      end
    end
  end)
  if isFull then
    self.queueList[qUuid] = nil
  end
  return isFull
end

local function RemoveGuidePointId(self, pointId)
  if self.guideLeftPointIds ~= nil then
    local removeId
    for k, v in ipairs(self.guideLeftPointIds) do
      if v == pointId then
        removeId = k
        break
      end
    end
    if removeId ~= nil then
      table.remove(self.guideLeftPointIds, removeId)
    end
  end
end

local function CheckIsResourceEnough(self, needResourceType, needResourceNum)
  if needResourceType == nil or needResourceNum == nil then
    return true
  else
    local totalNum = needResourceNum
    if self.tempResource[needResourceType] == nil then
      self.tempResource[needResourceType] = LuaEntry.Resource:GetCntByResType(needResourceType)
    end
    return totalNum <= self.tempResource[needResourceType]
  end
end

UIFarmIrrigateCtrl.CloseSelf = CloseSelf
UIFarmIrrigateCtrl.Close = Close
UIFarmIrrigateCtrl.InitData = InitData
UIFarmIrrigateCtrl.GetItemList = GetItemList
UIFarmIrrigateCtrl.GetFarmItemListData = GetFarmItemListData
UIFarmIrrigateCtrl.OnDragTrigger = OnDragTrigger
UIFarmIrrigateCtrl.OnDragFinish = OnDragFinish
UIFarmIrrigateCtrl.CheckIsStorageFull = CheckIsStorageFull
UIFarmIrrigateCtrl.RemoveGuidePointId = RemoveGuidePointId
UIFarmIrrigateCtrl.CheckIsResourceEnough = CheckIsResourceEnough
return UIFarmIrrigateCtrl
