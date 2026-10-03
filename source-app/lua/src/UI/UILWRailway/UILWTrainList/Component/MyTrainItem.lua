local MyTrainItem = BaseClass("MyTrainItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")

function MyTrainItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MyTrainItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MyTrainItem:ComponentDefine()
  self.have = self:AddComponent(UIBaseComponent, "Have")
  self.bg = self:AddComponent(UIRawImage, "Have/bg")
  self.title = self:AddComponent(UIText, "Have/title")
  self.title:SetLocalText(457506)
  self.time = self:AddComponent(UIText, "Have/title/time")
  self.desc3 = self:AddComponent(UIText, "Have/desc3")
  self.goBtn = self:AddComponent(UIButton, "Have/GoBtn")
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.goBtnText = self:AddComponent(UIText, "Have/GoBtn/GoBtnText")
  self.heroItems = {}
  for i = 1, 5 do
    self.heroItems[i] = self:AddComponent(FormationHeroItem, "Have/Layout/FormationSelectHeroItem" .. i)
  end
  self.addBtn = self:AddComponent(UIButton, "Ready")
  self.addBtn:SetOnClick(function()
    self:OnAddClick()
  end)
  self.lock = self:AddComponent(UIBaseComponent, "Lock")
  self.desc4 = self:AddComponent(UIText, "Lock/desc4")
  self.desc4:SetLocalText(457563)
  self.exhausted = self:AddComponent(UIBaseComponent, "Exhausted")
  self.desc5 = self:AddComponent(UIText, "Exhausted/desc5")
  self.anim = self:AddComponent(UISimpleAnimation, "")
end

function MyTrainItem:ComponentDestroy()
  self.heroItems = {}
  self.bg = nil
  self.qualityImage = nil
  self.head = nil
  self.title = nil
  self.time = nil
  self.desc1 = nil
  self.desc2 = nil
  self.desc3 = nil
  self.desc4 = nil
  self.goBtnText = nil
  self.goBtn = nil
  self.lock = nil
  self.desc4 = nil
  self.exhausted = nil
  self.desc5 = nil
  self.anim = nil
  self.addBtn = nil
end

function MyTrainItem:DataDefine()
end

function MyTrainItem:DataDestroy()
  self.trainData = nil
end

function MyTrainItem:OnEnable()
  base.OnEnable(self)
end

function MyTrainItem:OnDisable()
  base.OnDisable(self)
end

function MyTrainItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshOneMyTruck, self.OnRefreshOneMyTruck)
end

function MyTrainItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshOneMyTruck, self.OnRefreshOneMyTruck)
end

function MyTrainItem:OnRefreshOneMyTruck(trainData)
  if trainData.index == self.index then
    self:SetData(self.index)
  end
end

function MyTrainItem:SetData(index)
  self.index = index
  self.trainData = DataCenter.LWMyStationDataManager:GetMyTrainByIndex(index)
  self.have:SetActive(false)
  self.addBtn:SetActive(false)
  self.lock:SetActive(false)
  self.exhausted:SetActive(false)
  local state = DataCenter.LWMyStationDataManager:GetTruckStationStateByTrainData(self.trainData)
  if state == TruckStationState.Lock then
    self:ShowLock()
  elseif state == TruckStationState.Ready then
    self:ShowAdd()
  elseif state == TruckStationState.Exhausted then
    self:ShowExhausted()
  elseif state == TruckStationState.Travelling then
    self:ShowTravelling()
    self.goBtnText:SetLocalText("457518")
  else
    self:ShowTravelling()
    self.goBtnText:SetLocalText("2000075")
  end
  self.state = state
  if self.view.ctrl.openParam and self.trainData and self.trainData.buildUuid == self.view.ctrl.openParam then
    self.view.ctrl.openParam = nil
    self.anim:Play("Select")
  end
end

function MyTrainItem:ShowLock()
  self.lock:SetActive(true)
end

function MyTrainItem:ShowAdd()
  self.addBtn:SetActive(true)
end

function MyTrainItem:ShowExhausted()
  self.exhausted:SetActive(true)
  self.desc5:SetLocalText(457576 + self.trainData.index)
end

function MyTrainItem:ShowTravelling()
  self.have:SetActive(true)
  self:ShowTravellingEverySec()
  local trainData = self.trainData
  self.bg:LoadSprite(string.format("Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_pinzhi_%s.png", trainData.quality))
  local plunderRecords = trainData.plunderRecord
  if plunderRecords and 0 < #plunderRecords then
    local record = plunderRecords[#plunderRecords]
    local robberName = UIUtil.FormatAllianceAndName(record.abbr, record.name)
    if record.isWin then
      self.desc3:SetLocalText(457582, robberName)
    else
      self.desc3:SetLocalText(457583, robberName)
    end
  else
    self.desc3:SetLocalText(457584)
  end
  local heroInfo = trainData.heroInfo
  for i = 1, 5 do
    if heroInfo[i] then
      self.heroItems[i]:InitWithConfigId(heroInfo[i].id, nil, heroInfo[i].level, heroInfo[i].rankLv, heroInfo[i].weaponLevel, heroInfo[i].awakenLv, heroInfo[i].heroSkinId)
    else
      self.heroItems[i]:InitWithConfigId(nil)
    end
  end
end

function MyTrainItem:ShowTravellingEverySec()
  local trainData = self.trainData
  local now = UITimeManager:GetInstance():GetServerTime()
  local trainState, nextKeyTime, lastName, nextName = trainData:CalculateDescription(now)
  if trainState and trainState == TrainState.ArrivedFinal then
    self.time:SetLocalText(457520)
  else
    self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(trainData.arriveTs - now))
  end
end

function MyTrainItem:RefreshEverySec()
  if self.state and self.state == TruckStationState.Travelling then
    self:ShowTravellingEverySec()
  end
end

function MyTrainItem:OnGoClick()
  RailwayUtil.ApplyArriveReward(self.trainData)
end

function MyTrainItem:OnAddClick()
  RailwayUtil.OpenUITruckDeparture(self.trainData.buildUuid)
end

return MyTrainItem
