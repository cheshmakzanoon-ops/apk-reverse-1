local base = UIBaseContainer
local HSRProgressComponent = BaseClass("HSRProgressComponent", UIBaseContainer)

function HSRProgressComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UseSliderMoveMode(false)
  self:Refresh()
end

function HSRProgressComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HSRProgressComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBubble2 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textIndex2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textServer3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBubble1 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textServer1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textBubbleNum1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textIndex1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgBubble3 = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textBubbleTxt1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textBubbleNum3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgStation3 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgStation2 = self.viewSkin:AddComponent(self, UIImage, 12)
  self.textIndex3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compStations = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.imgStation1 = self.viewSkin:AddComponent(self, UIImage, 15)
  self.textBubbleTxt3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textBubbleTxt2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textServer2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textBubbleTxt1:SetLocalText("activity_1200044_tips83")
  self.textBubbleTxt2:SetLocalText("activity_1200044_tips84")
  self.textBubbleTxt3:SetLocalText("activity_1200044_tips85")
  self.slider = self:AddComponent(UIImage, "Bg/Slider")
  self.train = self:AddComponent(UIRawImage, "Train")
end

function HSRProgressComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgBubble2 = nil
  self.textIndex2 = nil
  self.textServer3 = nil
  self.imgBubble1 = nil
  self.textServer1 = nil
  self.textBubbleNum1 = nil
  self.textIndex1 = nil
  self.imgBubble3 = nil
  self.textBubbleTxt1 = nil
  self.textBubbleNum3 = nil
  self.imgStation3 = nil
  self.imgStation2 = nil
  self.textIndex3 = nil
  self.compStations = nil
  self.imgStation1 = nil
  self.textBubbleTxt3 = nil
  self.textBubbleTxt2 = nil
  self.textServer2 = nil
end

function HSRProgressComponent:UseSliderMoveMode(bool)
  self.sliderMoveMode = bool
  local width, height = self:GetSizeDeltaXY()
  local ratio = width / 640
  self.ratio = ratio
  if self.sliderMoveMode then
    self.compStations:SetAnchoredPositionXY(0, 0)
    self.imgStation1:SetAnchoredPositionXY(-193 * ratio, 0)
    self.imgStation2:SetAnchoredPositionXY(0, 0)
    self.imgStation3:SetAnchoredPositionXY(193 * ratio, 0)
    self.train:SetAnchoredPositionXY(-200 * ratio, 0)
  else
    self.slider:SetFillAmount(0.363)
    local x = -87 * ratio
    self.compStations:SetAnchoredPositionXY(x, 0)
    self.interval = 175 * ratio
  end
end

function HSRProgressComponent:Refresh()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if not activityData then
    return
  end
  if not DataCenter.HSRDataManager:GetHSRData() then
    return
  end
  local _, progress = DataCenter.HSRDataManager:GetDrivingProgress()
  local curStationIndex = math.ceil(progress) + 1
  local stationList = activityData.buyMaxNumList
  local curStation = stationList[curStationIndex]
  local totalStationCount = #stationList
  if progress <= 0 then
    self.imgStation1:SetActive(false)
    self.imgStation3:SetActive(true)
    self.textIndex3:SetText(2)
    self.textBubbleNum3:SetText(stationList[2].buyMaxNum)
    self.textServer3:SetText(UIUtil.FormatServerName(stationList[2].serverId))
  elseif progress >= totalStationCount - 2 then
    self.imgStation3:SetActive(false)
    self.imgStation1:SetActive(true)
    self.textIndex1:SetText(curStationIndex - 1)
    self.textBubbleNum1:SetText(stationList[curStationIndex - 1].maxPrice)
    self.textServer1:SetText(UIUtil.FormatServerName(stationList[curStationIndex - 1].serverId))
  else
    self.imgStation1:SetActive(true)
    self.imgStation3:SetActive(true)
    self.textIndex1:SetText(curStationIndex - 1)
    self.textBubbleNum1:SetText(stationList[curStationIndex - 1].maxPrice)
    self.textServer1:SetText(UIUtil.FormatServerName(stationList[curStationIndex - 1].serverId))
    self.textIndex3:SetText(curStationIndex + 1)
    self.textBubbleNum3:SetText(stationList[curStationIndex + 1].buyMaxNum)
    self.textServer3:SetText(UIUtil.FormatServerName(stationList[curStationIndex + 1].serverId))
  end
  self.textIndex2:SetText(curStationIndex)
  self.textServer2:SetText(UIUtil.FormatServerName(curStation.serverId))
  if self.sliderMoveMode then
    if progress <= 0 then
      self.slider:SetFillAmount(0.5)
    elseif progress >= DataCenter.HSRDataManager:GetStationCount() then
      self.slider:SetFillAmount(0.5)
    else
      local _, frac = math.modf(progress)
      self.slider:SetFillAmount(0.2 + 0.3 * frac)
    end
  elseif progress <= 0 then
    self.imgStation2:SetAnchoredPositionXY(0, 0)
    self.imgStation3:SetAnchoredPositionXY(self.interval, 0)
    self.train:SetAnchoredPositionXY(-100 * self.ratio, 0)
  elseif progress >= DataCenter.HSRDataManager:GetStationCount() then
    self.imgStation1:SetAnchoredPositionXY(-self.interval, 0)
    self.imgStation2:SetAnchoredPositionXY(0, 0)
    self.train:SetAnchoredPositionXY(-260 * self.ratio, 0)
  elseif progress >= DataCenter.HSRDataManager:GetStationCount() - 1 then
    local _, frac = math.modf(progress)
    self.imgStation1:SetAnchoredPositionXY(-self.interval * frac, 0)
    self.imgStation2:SetAnchoredPositionXY(self.interval - self.interval * frac, 0)
    self.train:SetAnchoredPositionXY((-100 - 160 * frac) * self.ratio, 0)
  else
    local _, frac = math.modf(progress)
    self.imgStation1:SetAnchoredPositionXY(-self.interval * frac, 0)
    self.imgStation2:SetAnchoredPositionXY(self.interval - self.interval * frac, 0)
    self.imgStation3:SetAnchoredPositionXY(2 * self.interval - self.interval * frac, 0)
    self.train:SetAnchoredPositionXY((-100 - 160 * frac) * self.ratio, 0)
  end
end

function HSRProgressComponent:Update1000MS()
  self:Refresh()
end

return HSRProgressComponent
