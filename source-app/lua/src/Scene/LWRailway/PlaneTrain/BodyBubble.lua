local BodyBubble = BaseClass("BodyBubble")
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")

function BodyBubble:__init(transform, index)
  self.transform = transform
  self.index = index
  self.isVip = nil
  self:ComponentDefine()
end

function BodyBubble:__delete()
  self:ComponentDestroy()
end

function BodyBubble:ComponentDefine()
  self.bubble = self.transform:Find("Bubble").gameObject
  self.head = UIHead.New(nil, self.transform:Find("Bubble/Bg/Head").gameObject)
  self.head:OnCreate()
  self.button = self.transform:Find("Bubble/Button"):GetComponent(typeof(CS.UnityEngine.UI.Button))
  
  function self.onClick()
    self:OnClick()
  end
  
  self.button.onClick:AddListener(self.onClick)
  self.name = self.transform:Find("Bubble/Bg/Head/black/Name"):GetComponent(typeof(CS.TextMeshProUGUIEx))
end

function BodyBubble:ComponentDestroy()
  if not IsNull(self.button) then
    self.button.onClick:RemoveListener(self.onClick)
  end
  self:ClearTween()
  self.onClick = nil
  self.button = nil
  self.head = nil
  self.transform = nil
  self.bubble = nil
  self.name = nil
  self.isVip = nil
end

function BodyBubble:Refresh(isVip)
  if isVip ~= nil then
    self.isVip = isVip
  end
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.NoTrain then
    self.bubble:SetActive(false)
  elseif platformData.state == TrainPlatformState.TrainNoDriver then
    self.bubble:SetActive(false)
  elseif platformData.state == TrainPlatformState.TrainWithDriver then
    if self.isVip then
      local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
      if trainData:HaveVip() then
        self.bubble:SetActive(true)
        self.head:SetActive(true)
        self:SetHead(trainData, self.isVip)
      else
        self.bubble:SetActive(false)
      end
    elseif platformData:MeInQueue() then
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
    local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
    self.bubble:SetActive(true)
    self.head:SetActive(true)
    if self.isVip then
      if trainData:HaveVip() then
        self:SetHead(trainData, self.isVip)
      else
        self.bubble:SetActive(false)
      end
    else
      self:SetHead(trainData)
    end
  end
end

function BodyBubble:SetHead(trainData, isVip)
  self:ClearTween()
  if isVip and trainData and trainData.vipInfo then
    self.head:Refresh(trainData.vipInfo.vipId, trainData.vipInfo.headPic, tonumber(trainData.vipInfo.headPicVer), trainData.vipInfo.headSkinId, trainData.vipInfo.headSkinET)
    self.name:Native_SetText(trainData.vipInfo.name)
  elseif isVip then
    self.bubble:SetActive(false)
    return
  end
  if self.index > #trainData.carriages then
    return
  end
  local passengers = trainData.carriages[self.index].passengerList
  if passengers == nil then
    self.bubble:SetActive(false)
    return
  end
  local count = #passengers
  if count < 1 then
    self.bubble:SetActive(false)
    return
  end
  if count == 1 then
    local player = passengers[1]
    if not player then
      self.bubble:SetActive(false)
    else
      self.head:Refresh(player.uid, player.headPic, tonumber(player.headPicVer), player.headSkinId, player.headSkinET)
      self.name:Native_SetText(player.name)
    end
    return
  end
  self.seq = CS.DG.Tweening.DOTween.Sequence()
  for i = 1, count do
    local player = passengers[i]
    if player then
      self.seq:AppendInterval(0.25)
      self.seq:AppendCallback(function()
        self.head:Refresh(player.uid, player.headPic, tonumber(player.headPicVer), player.headSkinId, player.headSkinET)
        self.name:Native_SetText(player.name)
      end)
      self.seq:AppendInterval(2)
    end
  end
  self.seq:SetLoops(-1)
end

function BodyBubble:ClearTween()
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

function BodyBubble:OnClick()
  RailwayUtil.OpenUITrainPrepare(TrainPreparePage.Passenger)
end

return BodyBubble
