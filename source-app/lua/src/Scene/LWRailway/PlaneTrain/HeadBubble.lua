local HeadBubble = BaseClass("HeadBubble")
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")

function HeadBubble:__init(transform, index)
  self.transform = transform
  self.index = index
  self:ComponentDefine()
end

function HeadBubble:__delete()
  self:ComponentDestroy()
end

function HeadBubble:ComponentDefine()
  self.bubble = self.transform:Find("Bubble").gameObject
  self.head = UIHead.New(nil, self.transform:Find("Bubble/Bg/Head").gameObject)
  self.head:OnCreate()
  self.button = self.transform:Find("Bubble/Button"):GetComponent(typeof(CS.UnityEngine.UI.Button))
  
  function self.onClick()
    self:OnClick()
  end
  
  self.button.onClick:AddListener(self.onClick)
  self.none = self.transform:Find("Bubble/Bg/None").gameObject
  self.cap = self.transform:Find("Bubble/Bg/Head/Cap").gameObject
  self.gear = self.transform:Find("Bubble/Bg/Gear").gameObject
  self.red = self.transform:Find("Bubble/Bg/Red").gameObject
  self.time = self.transform:Find("Bubble/Bg/Time"):GetComponent(typeof(CS.TextMeshProUGUIEx))
  self.name = self.transform:Find("Bubble/Bg/Head/black/Name"):GetComponent(typeof(CS.TextMeshProUGUIEx))
  
  function self.timer_action()
    self:UpdatePerSecond()
  end
end

function HeadBubble:ComponentDestroy()
  if not IsNull(self.button) then
    self.button.onClick:RemoveListener(self.onClick)
  end
  self.onClick = nil
  self.button = nil
  self:RemoveTimer()
  self.transform = nil
  self.bubble = nil
  self.head = nil
  self.none = nil
  self.gear = nil
  self.time = nil
  self.name = nil
  self.cap = nil
end

function HeadBubble:Refresh()
  self.bubble:SetActive(true)
  self.none:SetActive(true)
  self.cap:SetActive(true)
  self.gear:SetActive(false)
  self.head:SetActive(false)
  self.red:SetActive(false)
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
        self.head:SetActive(true)
        self:SetHead(trainData)
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

function HeadBubble:SetHead(trainData)
  local player = trainData.carriages[self.index].passengerList[1]
  if player then
    self.head:Refresh(player.uid, player.headPic, tonumber(player.headPicVer), player.headSkinId, player.headSkinET)
    self.name:Native_SetText(player.name)
  end
end

function HeadBubble:UpdatePerSecond()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.readyEndTime and now < self.readyEndTime then
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.readyEndTime - now)
    self.time:Native_SetText(str)
  else
    self:RemoveTimer()
  end
end

function HeadBubble:AddTimer()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function HeadBubble:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function HeadBubble:OnClick()
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

return HeadBubble
