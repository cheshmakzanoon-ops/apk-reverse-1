local AllianceScienceCell = BaseClass("AllianceScienceCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "ScienceBg/ScienceIcon"
local name_path = "ScienceBg/ScienceName"
local btn_path = "ScienceBg"
local slider_path = "ScienceBg/Slider"
local slider_text_path = "ScienceBg/Slider/SliderText"
local level_text_path = "ScienceBg/LevelText"
local lock_path = "ScienceBg/Lock"
local leader_recommend_path = "ScienceBg/leaderRecommend"
local upgradeTip_path = "ScienceBg/upgrade"
local SliderLength = 110

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.bg_icon = self:AddComponent(UIImage, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.leader_recommend = self:AddComponent(UIBaseContainer, leader_recommend_path)
  self.needUpdate = false
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.upgradeTipN = self:AddComponent(UIBaseContainer, upgradeTip_path)
  self.slider_text:SetText("")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.name = nil
  self.slider = nil
  self.slider_text = nil
  self.level_text = nil
  self.bg_icon = nil
  self.lock = nil
  self.leader_recommend = nil
  self.needUpdate = nil
  self.isUpdate = nil
  self.lastChangeTextDeltaTime = nil
  self.lastChangeImageDeltaTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAlScienceRecommendChange, self.OnUpdateRecommendId)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAlScienceRecommendChange, self.OnUpdateRecommendId)
  base.OnRemoveListener(self)
end

local function RefreshData(self, data)
  self.upgradeTipN:SetActive(false)
  self.scienceData = data
  if self.scienceData ~= nil then
    self.icon:LoadSprite(self.scienceData.icon)
    self.name:SetLocalText(self.scienceData.name)
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    self.needUpdate = serverTime < self.scienceData.finishTime
    local upgradeShow = false
    if self.needUpdate then
      self.slider:SetActive(true)
      self.slider_text:SetActive(true)
    else
      self.slider:SetActive(false)
      self.slider_text:SetActive(false)
      if DataCenter.AllianceBaseDataManager:IsR4orR5() and self.scienceData.currentPro > 0 and self.scienceData.curLevel ~= self.scienceData.maxLevel and not self.view.ctrl:GetHasUpdate() then
        upgradeShow = self.scienceData.currentPro >= self.scienceData.needPro
        self.upgradeTipN:SetActive(upgradeShow)
      end
    end
    local isLock = self.scienceData.isLock
    if isLock then
      self.level_text:SetText("")
      self.lock:SetActive(true)
      CS.UIGray.SetGray(self.icon.transform, true, false)
    else
      CS.UIGray.SetGray(self.icon.transform, false, true)
      self.lock:SetActive(false)
      if self.scienceData.curLevel >= self.scienceData.maxLevel then
        self.level_text:SetLocalText(400013)
        self.level_text:SetColor(Color.New(0.9647058823529412, 0.5725490196078431, 0.01568627450980392, 1))
      else
        self.level_text:SetColor(Color.New(1, 1, 1, 1))
        self.level_text:SetText(self.scienceData.curLevel .. "/" .. self.scienceData.maxLevel)
      end
    end
    self.leader_recommend:SetActive(not upgradeShow and self.scienceData.state == 1)
  end
  self:Update1000MS()
end

local function OnUpdateRecommendId(self, scienceId)
  self.leader_recommend:SetActive(scienceId and self.scienceData.scienceId == scienceId)
end

local function CheckIfShowRedPoint(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime < self.scienceData.finishTime then
    return false
  end
  if self.scienceData.isLock then
    return false
  end
  local userNum = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
  local maxNum = DataCenter.AllianceScienceDataManager:GetResDonateMaxCount()
  if userNum >= maxNum / 2 then
    if self.scienceData.curLevel >= self.scienceData.maxLevel then
      return false
    end
    local redScienceTb = DataCenter.AllianceScienceDataManager:GetShowRedScienceId(self.view.tab)
    if redScienceTb and table.hasvalue(redScienceTb, self.scienceData.scienceId) then
      return true
    else
      return false
    end
  end
end

local function OnBtnClick(self)
  SFSNetwork.SendMessage(MsgDefines.AllScienceRefresh, self.view.ctrl:OnScienceInfoClick(self.scienceData, self.view.tab))
end

local function Update1000MS(self)
  if self.needUpdate then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = 0
    local maxTime = 0
    if curTime < self.scienceData.finishTime then
      self.isUpdate = true
      deltaTime = self.scienceData.finishTime - curTime
      maxTime = self.scienceData.finishTime - self.scienceData.startTime
    else
      self.isUpdate = false
    end
    if self.isUpdate then
      if TimeBarUtil.CheckIsNeedChangeBar(deltaTime, self.lastChangeImageDeltaTime, maxTime, SliderLength) then
        self.lastChangeImageDeltaTime = deltaTime
        local tempValue = 1 - deltaTime / maxTime
        self.slider:SetValue(tempValue)
      end
      if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
        self.lastChangeTextDeltaTime = deltaTime
        self.slider_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      end
    else
      self.lastChangeTextDeltaTime = 0
      self.lastChangeImageDeltaTime = 0
      self.slider:SetValue(1)
      self.slider_text:SetLocalText(170008)
    end
  end
end

AllianceScienceCell.OnCreate = OnCreate
AllianceScienceCell.OnDestroy = OnDestroy
AllianceScienceCell.OnEnable = OnEnable
AllianceScienceCell.OnDisable = OnDisable
AllianceScienceCell.ComponentDefine = ComponentDefine
AllianceScienceCell.ComponentDestroy = ComponentDestroy
AllianceScienceCell.OnAddListener = OnAddListener
AllianceScienceCell.OnRemoveListener = OnRemoveListener
AllianceScienceCell.RefreshData = RefreshData
AllianceScienceCell.OnBtnClick = OnBtnClick
AllianceScienceCell.Update1000MS = Update1000MS
AllianceScienceCell.CheckIfShowRedPoint = CheckIfShowRedPoint
AllianceScienceCell.OnUpdateRecommendId = OnUpdateRecommendId
return AllianceScienceCell
