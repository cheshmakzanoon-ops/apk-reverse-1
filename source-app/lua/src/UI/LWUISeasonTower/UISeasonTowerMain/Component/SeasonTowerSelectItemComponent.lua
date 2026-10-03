local base = UIBaseContainer
local SeasonTowerSelectItemComponent = BaseClass("SeasonTowerSelectItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonTowerSelectItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonTowerSelectItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonTowerSelectItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgSelectBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textSelectTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgCheckMark = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgNews = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnSelect = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.imgLock = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textOpenTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function SeasonTowerSelectItemComponent:ComponentDestroy()
  self:RemoveCountDownTimer()
  self.viewSkin = nil
  self.imgSelectBg = nil
  self.textSelectTxt = nil
  self.imgCheckMark = nil
  self.imgNews = nil
  self.btnSelect = nil
  self.imgLock = nil
  self.textOpenTime = nil
end

function SeasonTowerSelectItemComponent:DataDefine()
end

function SeasonTowerSelectItemComponent:DataDestroy()
end

function SeasonTowerSelectItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SeasonTowerSelectItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonTowerSelectItemComponent:SetData(param)
  local data = param.data
  self.index = param.index
  self.selectFunc = param.selectFunc
  local selectIndex = param.selectIndex
  self.parentType = param.parentType
  local selected = self.index == selectIndex
  self.imgSelectBg:SetActive(selected)
  local template = data:GetTemplate()
  self.textSelectTxt:SetLocalText(template.name)
  self.textSelectTxt:SetColorHex(selected and "2A2830" or "7D7A8A")
  self:RefreshUI()
  self:RemoveCountDownTimer()
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(self.index)
  if not stageData:IsStageOpen() then
    self:AddCountDownTimer(self.OnRefreshOpenTime)
    self:OnRefreshOpenTime()
  end
end

function SeasonTowerSelectItemComponent:RefreshUI()
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(self.index)
  if self.parentType == SeasonTowerConfig.SelectItemUI.Reward then
    self.imgNews:SetActive(false)
  else
    self.imgNews:SetActive(stageData:IsStageOpen() and stageData:IsStageUnChallenge())
  end
  if stageData:IsStageOpen() then
    self.imgLock:SetActive(false)
    self.textOpenTime:SetActive(false)
  else
    self.imgLock:SetActive(true)
    self.textOpenTime:SetActive(true)
  end
end

function SeasonTowerSelectItemComponent:OnBtnSelectClick()
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(self.index)
  if stageData and not stageData:IsStageOpen() then
    return
  end
  if self.selectFunc then
    self.selectFunc(self.index)
  end
end

function SeasonTowerSelectItemComponent:AddCountDownTimer(func)
  self:RemoveCountDownTimer()
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, func, self, false, false, false)
    self.countDownTimer:Start()
  end
end

function SeasonTowerSelectItemComponent:RemoveCountDownTimer()
  if self.countDownTimer then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function SeasonTowerSelectItemComponent:OnRefreshOpenTime()
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(self.index)
  if stageData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = stageData.openTime
  local leftTime = math.max(endTime - curTime, 0)
  local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textOpenTime:SetText(leftTimeStr)
  if stageData:IsStageOpen() then
    self:RemoveCountDownTimer()
    self:RefreshUI()
  end
end

return SeasonTowerSelectItemComponent
