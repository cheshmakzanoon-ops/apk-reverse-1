local base = UIBaseContainer
local BuildingExpComponent = BaseClass("BuildingExpComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local PREVIOUS_EXP_SAVE_KEY = "PREVIOUS_EXP_SAVE_KEY"
local PROGRESS_ANI_DURATION = 2
local EXP_ITEM_NUM_ROLL_DURATION = 1
local EXP_PROGRESS_ANI_MAX_COUNT = 3
local LESS_EXP_ANI_PERCENT = 0.05

function BuildingExpComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BuildingExpComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuildingExpComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBuildingExpInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBuildingExpInfo:SetOnClick(function()
    self:OnBtnBuildingExpInfoClick()
  end)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 3)
  self.textBuildingProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textExpNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textDialogBubble = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.simpleAnimationBuildingExp = self.viewSkin:AddComponent(self, UISimpleAnimation, 7)
  self.compDialogBubble = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.btnPigImg = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnPigImg:SetOnClick(function()
  end)
  self.compDialogBubble:SetActive(true)
end

function BuildingExpComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnBuildingExpInfo = nil
  self.slider = nil
  self.textBuildingProgress = nil
  self.textExpNum = nil
  self.textDialogBubble = nil
  self.simpleAnimationBuildingExp = nil
  self.compDialogBubble = nil
  self.btnPigImg = nil
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

function BuildingExpComponent:DataDefine()
end

function BuildingExpComponent:DataDestroy()
end

function BuildingExpComponent:OnAddListener()
  base.OnAddListener(self)
end

function BuildingExpComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BuildingExpComponent:OnBtnBuildingExpInfoClick()
  local param = {}
  param.alignObject = self.btnBuildingExpInfo.transform
  param.width = 495
  param.showArrow = true
  param.addPosY = 80
  UIManager:GetInstance():OpenWindow(UIWindowNames.FirstPayGetExpHistoryTipsView, {anim = true}, param)
end

function BuildingExpComponent:RefreshView()
  self.curBuildExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
  if not self.curBuildExpData then
    return
  end
  self.singleProgressExpLimit = self.curBuildExpData.singleProgressExpLimit or 1
  self.expMaxLimit = self.curBuildExpData.expMaxLimit
  self.lastExpValue = CommonUtil.PlayerPrefsGetLong(PREVIOUS_EXP_SAVE_KEY, 0)
  self.curRemainStashExp = self.curBuildExpData:GetCurRemainStashExp()
  self.isFullExp = self.curBuildExpData:IsExpPoolMax()
  self:PlayProgressAni()
  CommonUtil.PlayerPrefsSetLong(PREVIOUS_EXP_SAVE_KEY, self.curRemainStashExp)
end

function BuildingExpComponent:PlayProgressAni()
  local changeExp = Mathf.Max(self.curRemainStashExp - self.lastExpValue, 0)
  self:RefreshImmediate(self.lastExpValue)
  if changeExp <= 0 then
    return
  end
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
  local curChangeExpPercent = changeExp / self.expMaxLimit
  local isAlotOfExp = curChangeExpPercent > LESS_EXP_ANI_PERCENT
  local aniName = isAlotOfExp and "ExpAni1" or "ExpAni2"
  local fromExpItemNum = toInt(self.lastExpValue // self.singleProgressExpLimit)
  local fromExpEndValue = self.lastExpValue % self.singleProgressExpLimit
  local targetExpItemNum = toInt(self.curRemainStashExp // self.singleProgressExpLimit)
  local targetExpEndValue = self.curRemainStashExp % self.singleProgressExpLimit
  local rollNum = Mathf.Clamp(targetExpItemNum - fromExpItemNum, 0, EXP_PROGRESS_ANI_MAX_COUNT)
  local progressStartValue = fromExpEndValue / self.singleProgressExpLimit
  local progressEndValue = rollNum + targetExpEndValue / self.singleProgressExpLimit
  self.textBuildingProgress:SetLocalText(135225, fromExpEndValue + changeExp, self.singleProgressExpLimit)
  self.seq = CS.DG.Tweening.DOTween.Sequence()
  self.seq:AppendInterval(1)
  self.seq:AppendCallback(function()
    self.simpleAnimationBuildingExp:Play(aniName)
  end)
  self.seq:Append(CS.DG.Tweening.DOTween.To(function()
    return progressStartValue
  end, function(v)
    self.slider:SetValue(v % 1)
  end, progressEndValue, PROGRESS_ANI_DURATION):SetEase(CS.DG.Tweening.Ease.OutCubic))
  self.seq:Join(CS.DG.Tweening.DOTween.To(function()
    return fromExpEndValue + changeExp
  end, function(v)
    local s = math.floor(v + 0.5)
    self.textBuildingProgress:SetLocalText(135225, s, self.singleProgressExpLimit)
  end, targetExpEndValue, PROGRESS_ANI_DURATION):SetEase(CS.DG.Tweening.Ease.OutCubic))
  self.seq:Join(CS.DG.Tweening.DOTween.To(function()
    return fromExpItemNum
  end, function(v)
    local iv = math.floor(v + 0.5)
    self.textExpNum:SetLocalText(390902, iv)
  end, targetExpItemNum, EXP_ITEM_NUM_ROLL_DURATION):SetEase(CS.DG.Tweening.Ease.OutCubic):SetDelay(1))
  self.seq:Join(CS.DG.Tweening.DOTween.To(function()
    return self.lastExpValue
  end, function(v)
    local iv = math.floor(v + 0.5)
    self.textDialogBubble:SetText(iv)
  end, self.curRemainStashExp, EXP_ITEM_NUM_ROLL_DURATION):SetEase(CS.DG.Tweening.Ease.OutCubic))
  self.seq:OnComplete(function()
    self:RefreshImmediate(self.curRemainStashExp)
  end)
end

function BuildingExpComponent:RefreshImmediate(expValue)
  self:RefreshProgressInfo(expValue)
  self:RefreshPigNum(expValue)
end

function BuildingExpComponent:RefreshProgressInfo(expValue)
  local curExpProgressExpValue = expValue % self.singleProgressExpLimit
  local progressValue = not self.isFullExp and curExpProgressExpValue / self.singleProgressExpLimit or 1
  self.slider:SetValue(progressValue)
  if self.isFullExp then
    self.textBuildingProgress:SetLocalText("building_center_desc10")
  else
    self.textBuildingProgress:SetLocalText(135225, curExpProgressExpValue, self.singleProgressExpLimit)
  end
end

function BuildingExpComponent:RefreshPigNum(expValue)
  local stashExpItemNum = expValue // self.singleProgressExpLimit
  self.textExpNum:SetLocalText(390902, stashExpItemNum)
  self.textDialogBubble:SetText(expValue)
end

function BuildingExpComponent:OnBtnPigImgClick()
  if not self.compDialogBubble then
    return
  end
  self.compDialogBubble:SetActive(not self.compDialogBubble.gameObject.activeSelf)
end

return BuildingExpComponent
