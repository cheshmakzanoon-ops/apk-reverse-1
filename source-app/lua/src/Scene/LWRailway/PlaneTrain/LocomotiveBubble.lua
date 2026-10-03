local LocomotiveBubble = BaseClass("LocomotiveBubble")

function LocomotiveBubble:__init(transform, index)
  self.transform = transform
  self.index = index
  self:ComponentDefine()
end

function LocomotiveBubble:__delete()
  self:ComponentDestroy()
end

function LocomotiveBubble:ComponentDefine()
  self.bubble = self.transform:Find("Bubble").gameObject
  self.head = self.transform:Find("Bubble/Bg/Head").gameObject
  self.uiPlayerHead = self.transform:Find("Bubble/Bg/Head/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
  self.trigger = self.transform:Find("Bubble/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
  
  self.none = self.transform:Find("Bubble/Bg/None").gameObject
  self.gear = self.transform:Find("Bubble/Bg/Gear").gameObject
  self.red = self.transform:Find("Bubble/Bg/Gear/Red").gameObject
  self.time = self.transform:Find("Bubble/Bg/Time"):GetComponent(typeof(CS.SuperTextMesh))
  self.name = self.transform:Find("Bubble/Bg/Head/Name"):GetComponent(typeof(CS.SuperTextMesh))
  
  function self.timer_action()
    self:UpdatePerSecond()
  end
end

function LocomotiveBubble:ComponentDestroy()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self:RemoveTimer()
  self.uiPlayerHead = nil
  self.transform = nil
  self.bubble = nil
  self.head = nil
  self.none = nil
  self.gear = nil
  self.time = nil
  self.name = nil
end

function LocomotiveBubble:Refresh()
  self.bubble:SetActive(true)
  self.none:SetActive(true)
  self.gear:SetActive(false)
  self.head:SetActive(false)
  self.time.gameObject:SetActive(false)
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.NoTrain then
    self.bubble:SetActive(false)
  elseif platformData.state == TrainPlatformState.TrainNoDriver then
  else
    self.time.gameObject:SetActive(true)
    self.readyEndTime = platformData.readyEndTime
    self:AddTimer()
    self:UpdatePerSecond()
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    if platformData.state == TrainPlatformState.TrainWithDriver then
      if trainData.ownerId == LuaEntry.Player.uid then
        self.none:SetActive(false)
        self.gear:SetActive(true)
        local key = "TRAIN_DRIVER_HAVE_SEEN"
        local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
        self.red:SetActive(trainData.uuid ~= trainUuid)
      else
        self.head:SetActive(true)
        self:SetHead(trainData)
      end
    elseif platformData.state == TrainPlatformState.TrainWithPassenger then
      self.head:SetActive(true)
      self:SetHead(trainData)
    end
  end
end

function LocomotiveBubble:SetHead(trainData)
  local player = trainData.carriages[self.index].passengerList[1]
  if not player.headPic or not player.headPicVer then
    self.uiPlayerHead:UseSystemHead()
  else
    self.uiPlayerHead:SetData(player.uid, player.headPic, tonumber(player.headPicVer), false)
  end
  self.name.text = player.name
end

function LocomotiveBubble:UpdatePerSecond()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.readyEndTime and now < self.readyEndTime then
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.readyEndTime - now)
    self.time.text = str
  else
    self:RemoveTimer()
  end
end

function LocomotiveBubble:AddTimer()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function LocomotiveBubble:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LocomotiveBubble:OnClick()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.TrainNoDriver then
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if not isR4orR5 then
      UIUtil.ShowTipsId(458615)
      return
    end
  end
  RailwayUtil.OpenUITrainPrepare(TrainPreparePage.Driver)
end

return LocomotiveBubble
