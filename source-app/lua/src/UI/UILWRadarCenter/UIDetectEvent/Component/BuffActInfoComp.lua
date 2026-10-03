local base = UIBaseContainer
local BuffActInfoComp = BaseClass("BuffActInfoComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BuffActInfoComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BuffActInfoComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuffActInfoComp:ComponentDefine()
  self.objBuffDetail = self:AddComponent(UIBaseContainer, "buffDetail")
  self.imgBtnBuff = self:AddComponent(UIImage, "btnBuff")
  self.btnBuff = self:AddComponent(UIButton, "btnBuff")
  self.btnBuff:SetOnClick(function()
    self:OnBtnBuffClick()
  end)
  self.textBtnBuff = self:AddComponent(UITextMeshProUGUIEx, "btnBuff/Text")
  self.textBuffCountDown = self:AddComponent(UITextMeshProUGUIEx, "buffDetail/textBuffCountDown")
  self.textBuffDesc = self:AddComponent(UITextMeshProUGUIEx, "buffDetail/textBuffDesc")
  self.imgBg = self:AddComponent(UIRawImage, "buffDetail/buffBg")
  self.imgBuffIcon = self:AddComponent(UIImage, "buffDetail/imgBuff/imgBuff1")
  self.imgBuffIconBg = self:AddComponent(UIImage, "buffDetail/imgBuff")
  self.imgArrow = self:AddComponent(UIImage, "buffDetail/imgArrow")
  self.animator = self:AddComponent(UIAnimator, "buffDetail")
  self.canvasGroup = self:AddComponent(UICanvasGroup, "buffDetail")
  self.canvasGroup:SetAlpha(0)
  self.imgBg:SetRaycastTarget(false)
end

function BuffActInfoComp:ComponentDestroy()
end

function BuffActInfoComp:DataDefine()
  self.isNeedShowBuff = false
end

function BuffActInfoComp:DataDestroy()
  self.isNeedShowBuff = nil
  self.buffEndTime = nil
  self.clickBuffCallBack = nil
end

function BuffActInfoComp:OnAddListener()
  base.OnAddListener(self)
end

function BuffActInfoComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BuffActInfoComp:ReInit(activityType, clickBuffCallBack)
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(activityType)
  if dataList and dataList[1] then
    if DataCenter.ActivityListDataManager:CheckIsSend(dataList[1]) then
      self.isNeedShowBuff = true
      self.buffEndTime = dataList[1].endTime
      self.clickBuffCallBack = clickBuffCallBack
      local strParam = dataList[1].para_2
      local arrParam = string.split(strParam, "|")
      self.imgBtnBuff:LoadSpriteAuto(string.format(LoadPath.ActBuffSpritesPath, arrParam[1]))
      self.textBtnBuff:SetLocalText(arrParam[2])
      self.imgBg:LoadSpriteAuto(string.format(LoadPath.ActBuffTextureExPath, arrParam[3]))
      self.imgArrow:LoadSpriteAuto(string.format(LoadPath.ActBuffSpritesPath, arrParam[4]))
      self.imgBuffIconBg:LoadSpriteAuto(string.format(LoadPath.ActBuffSpritesPath, arrParam[5]))
      self.imgBuffIcon:LoadSpriteAuto(string.format(LoadPath.ActBuffSpritesPath, arrParam[6]))
      self.textBuffDesc:SetLocalText(arrParam[7])
    end
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, 0)
    else
      self.imgArrow.transform.localRotation = Quaternion.Euler(0, 180, 0)
    end
  end
  self:SetActive(self.isNeedShowBuff)
end

function BuffActInfoComp:Update1000MS()
  if not self.isNeedShowBuff or not self.buffEndTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.buffEndTime - curTime
  if leftTime <= 0 then
    self:SetActive(false)
    self.canvasGroup:SetAlpha(0)
    self.isNeedShowBuff = false
    return
  else
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textBuffCountDown:SetText(countDownTimeStr)
  end
end

function BuffActInfoComp:OnBtnBuffClick()
  local activeSelf = self.canvasGroup:GetAlpha() > 0
  if activeSelf then
    self.animator:Play("CommonPopup_moveout", 0, 0)
    self.imgBg:SetRaycastTarget(false)
  else
    self.animator:Play("CommonPopup_movein", 0, 0)
    self.imgBg:SetRaycastTarget(true)
  end
  if self.clickBuffCallBack then
    self.clickBuffCallBack()
  end
end

function BuffActInfoComp:HideBuffDetail()
  if self.canvasGroup and self.canvasGroup:GetAlpha() > 0.9 then
    self.animator:Play("CommonPopup_moveout", 0, 0)
    self.imgBg:SetRaycastTarget(false)
  end
end

return BuffActInfoComp
