local base = UIBaseContainer
local UIWorldLLCityPointThroneBattle = BaseClass("UIWorldLLCityPointThroneBattle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIWorldLLCityPointThroneBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointThroneBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointThroneBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textCurValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.sliderProgressBuild = self.viewSkin:AddComponent(self, UISlider, 4)
  self.imgAttackIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgDefendIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compTipParent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.imgProgress = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 9)
end

function UIWorldLLCityPointThroneBattle:ComponentDestroy()
  self.viewSkin = nil
  self.textCurValue = nil
  self.btnDetail = nil
  self.textProgress = nil
  self.sliderProgressBuild = nil
  self.imgAttackIcon = nil
  self.imgDefendIcon = nil
  self.compTipParent = nil
  self.imgProgress = nil
  self.imgBg = nil
end

function UIWorldLLCityPointThroneBattle:DataDefine()
  self.compSpeed = nil
end

function UIWorldLLCityPointThroneBattle:DataDestroy()
  self.compSpeed = nil
end

function UIWorldLLCityPointThroneBattle:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldLLCityPointThroneBattle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldLLCityPointThroneBattle:OnBtnDetailClick()
  if self.compSpeed == nil then
    self.compSpeed = self:LoadComponentAsync(LLConst.CLS_DETAIL_SPEED, LLConst.PREFAB_DETAIL_SPEED, self.holder, function(view)
      self:RefreshCompSpeed()
    end)
  end
  local worldPos = self.btnDetail:GetPosition()
  local targetP = self.holder.transform:InverseTransformPoint(worldPos)
  self.compSpeed:SetTargetPos(targetP, true, true)
end

function UIWorldLLCityPointThroneBattle:RefreshCompSpeed()
  if self.compSpeed and self.compSpeed:AsyncLoadDone() then
    local effectValue = self.data.effectValue
    local startOccupyTime = self.data.tmpOwnerCampId ~= LLConst.LandLordGroup.NONE and self.data.occupyStartTime
    self.compSpeed:SetExtraValue((effectValue or 0) + 1, startOccupyTime)
  end
end

function UIWorldLLCityPointThroneBattle:Refresh(data)
  if self.activeSelf then
    self.data = data
    local myCampId = DataCenter.LandlordMgr:GetMyGroup()
    if myCampId == LLConst.LandLordGroup.NONE then
      self.imgProgress:LoadSpriteAuto(LLConst.THRONE_CITY_FILL_IMG_RED)
      self.imgBg:LoadSpriteAuto(LLConst.THRONE_CITY_FILL_IMG_BLUE)
    else
      local isMeLord = myCampId == LLConst.LandLordGroup.LORD
      self.imgProgress:LoadSpriteAuto(isMeLord and LLConst.THRONE_CITY_FILL_IMG_RED or LLConst.THRONE_CITY_FILL_IMG_BLUE)
      self.imgBg:LoadSpriteAuto(isMeLord and LLConst.THRONE_CITY_FILL_IMG_BLUE or LLConst.THRONE_CITY_FILL_IMG_RED)
    end
    self:RefreshCompSpeed()
    self:Update1000MS()
  end
end

function UIWorldLLCityPointThroneBattle:Update1000MS()
  local maxProgress = self.data.progressMax
  local tmpOwnerCampId = self.data.tmpOwnerCampId
  local leftTime = 0
  if tmpOwnerCampId == LLConst.LandLordGroup.NONE then
    self.sliderProgressBuild:SetValue(self.data.progress / maxProgress)
    self.textCurValue:SetText(string.format("%s/%s[+%d/s]", string.GetFormattedSeparatorNum(toInt(self.data.progress)), string.GetFormattedSeparatorNum(toInt(maxProgress)), 0))
  else
    local curSpeed = DataCenter.LandlordMgr:CalculateOccupySpeed(self.data.occupyStartTime, self.data.effectValue, true)
    local progress = 0
    progress, leftTime = DataCenter.LandlordMgr:CalculateOccupyCurProgress(self.data.occupyStartTime, self.data.occupyStartProgress, maxProgress, self.data.tmpOwnerCampId, self.data.effectValue, true)
    leftTime = leftTime * 1000
    self.sliderProgressBuild:SetValue(progress / maxProgress)
    self.textCurValue:SetText(string.format("%s/%s[+%d/s]", string.GetFormattedSeparatorNum(toInt(progress)), string.GetFormattedSeparatorNum(toInt(maxProgress)), toInt(curSpeed)))
  end
  if 0 < leftTime then
    self.textProgress:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.textProgress:SetText("")
  end
end

return UIWorldLLCityPointThroneBattle
