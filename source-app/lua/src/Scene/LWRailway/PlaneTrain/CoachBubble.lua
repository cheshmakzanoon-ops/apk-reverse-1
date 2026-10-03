local CoachBubble = BaseClass("CoachBubble")

function CoachBubble:__init(transform, index)
  self.transform = transform
  self.index = index
  self:ComponentDefine()
end

function CoachBubble:__delete()
  self:ComponentDestroy()
end

function CoachBubble:ComponentDefine()
  self.bubble = self.transform:Find("Bubble").gameObject
  self.head = self.transform:Find("Bubble/Bg/Head").gameObject
  self.uiPlayerHead = self.transform:Find("Bubble/Bg/Head/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
  self.trigger = self.transform:Find("Bubble/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
  
  self.name = self.transform:Find("Bubble/Bg/Head/Name"):GetComponent(typeof(CS.SuperTextMesh))
end

function CoachBubble:ComponentDestroy()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self.uiPlayerHead = nil
  self.transform = nil
  self.bubble = nil
  self.head = nil
  self.name = nil
end

function CoachBubble:Refresh()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.NoTrain then
    self.bubble:SetActive(false)
  elseif platformData.state == TrainPlatformState.TrainNoDriver then
    self.bubble:SetActive(false)
  elseif platformData.state == TrainPlatformState.TrainWithDriver then
    if platformData:MeInQueue() then
      self.bubble:SetActive(false)
    else
      local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
      if trainData:IsMyTrain() then
        self.bubble:SetActive(false)
      else
        self.bubble:SetActive(true)
        self.head:SetActive(false)
      end
    end
  elseif platformData.state == TrainPlatformState.TrainWithPassenger then
    self.bubble:SetActive(true)
    self.head:SetActive(true)
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    self:SetHead(trainData)
  end
end

function CoachBubble:SetHead(trainData)
  local player = trainData.carriages[self.index].passengerList[1]
  if not player then
    self.bubble:SetActive(false)
  elseif not player.headPic or not player.headPicVer then
    self.uiPlayerHead:UseSystemHead()
    self.name.text = player.name
  else
    self.uiPlayerHead:SetData(player.uid, player.headPic, tonumber(player.headPicVer), false)
    self.name.text = player.name
  end
end

function CoachBubble:OnClick()
  RailwayUtil.OpenUITrainPrepare(TrainPreparePage.Passenger)
end

return CoachBubble
