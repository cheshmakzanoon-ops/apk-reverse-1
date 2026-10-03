local TrainItemBase = BaseClass("TrainItemBase", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TrainItemBase:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainItemBase:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TrainItemBase:ComponentDefine()
  self.qualityImage = self:AddComponent(UIImage, "qualityImage")
  self.title = self:AddComponent(UIText, "title")
  self.time = self:AddComponent(UIText, "title/time")
  self.desc1 = self:AddComponent(UIText, "desc1")
  self.desc2 = self:AddComponent(UIText, "desc2")
  self.desc3 = self:AddComponent(UIText, "desc3")
  self.desc4 = self:AddComponent(UIText, "desc4")
  self.head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.goBtn = self:AddComponent(UIButton, "GoBtn")
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.goBtnText = self:AddComponent(UIText, "GoBtn/GoBtnText")
  self.goBtnImg = self:AddComponent(UIImage, "GoBtn")
end

function TrainItemBase:ComponentDestroy()
  self:RemoveTimer()
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
  self.goBtnImg = nil
end

function TrainItemBase:DataDefine()
  self.timer_action = BindCallback(self, self.RefreshEverySec)
end

function TrainItemBase:DataDestroy()
  self.trainData = nil
  self.timer_action = nil
end

function TrainItemBase:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function TrainItemBase:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function TrainItemBase:OnAddListener()
  base.OnAddListener(self)
end

function TrainItemBase:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TrainItemBase:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function TrainItemBase:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function TrainItemBase:RefreshEverySec()
  if not self.trainData then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local trainState, nextKeyTime, lastName, nextName = self.trainData:CalculateDescription(now)
  if trainState and trainState == TrainState.ArrivedFinal then
    self.time:SetLocalText(457520)
  else
    self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(nextKeyTime - now))
  end
  self.title:SetText(string.format("%s--%s", lastName, nextName))
end

function TrainItemBase:SetData(trainData)
  self.trainData = trainData
  self:RefreshEverySec()
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(trainData.headSkinId, trainData.headSkinET)
  self.head:SetHead(trainData.ownerId, trainData.pic, trainData.picVer, false, headBgImg)
  self.desc1:SetText(trainData:GetAbbrAndName())
  local completeness = Localization:GetString("457581", math.floor(trainData.completeness * 100))
  self.desc2:SetText(completeness)
  self.desc3:SetLocalText(457586, string.GetFormattedSeperatorNum(math.floor(trainData.power)))
  if self.view.ctrl:GetCurrentTab() == TrainTab.Enemy then
    self.goBtnText:SetLocalText("457514")
    self.goBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_4.png")
  else
    self.goBtnText:SetLocalText("457518")
    self.goBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png")
  end
end

function TrainItemBase:OnGoClick()
  RailwayUtil.JumpToTrainByTrainData(self.trainData)
end

return TrainItemBase
