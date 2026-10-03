local UIPersonalArmsDailyTipView = BaseClass("UIPersonalArmsDailyTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.param = self:GetUserData()
  self.content.transform.position = self.param.pos
  local offset
  if CommonUtil.IsArabicAutoMirrorOpen() then
    offset = Vector2.New(-70, 44)
  else
    offset = Vector2.New(70, 44)
  end
  self.content.transform.anchoredPosition = self.content.transform.anchoredPosition + offset
  self.showData = self.param.showData
  self.animator:Play("V_ui_UIPersonalArmsDailyTip_in")
  self:RefreshDailyView(true)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, "Panel")
  self.panel:SetOnClick(function()
    self:CloseBtn()
  end)
  self.animator = self.gameObject.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  self.content = self:AddComponent(UIBaseContainer, "dailyContent")
  self.dailyProgressVal = self:AddComponent(UIBaseContainer, "dailyContent/dailyProgressBg/dailyProgressVal")
  self.dailyScoreNum = self:AddComponent(UITextMeshProUGUIEx, "dailyContent/dailyProgressBg/dailyScoreBg/numBg/dailyScoreNum")
  self.numBg = self:AddComponent(UIImage, "dailyContent/dailyProgressBg/dailyScoreBg/numBg")
  self.dailyBoxList = {}
  for i = 1, 3 do
    local boxRoot = self:AddComponent(UIButton, "dailyContent/dailyProgressBg/dailyBoxContent/dailyBoxItem" .. i)
    self.dailyBoxList[i] = {
      root = boxRoot,
      dailyBoxIcon = boxRoot:AddComponent(UIImage, "dailyBoxIcon"),
      dailyBoxNum = boxRoot:AddComponent(UIText, "dailyBoxNum"),
      effect = boxRoot:AddComponent(UIBaseContainer, "effect"),
      doubleMark = boxRoot:AddComponent(UIBaseContainer, "doubleMark")
    }
    boxRoot:SetOnClick(function()
      self:OnDailyBoxClick(i)
    end)
  end
end

local function ComponentDestroy(self)
  self.content = nil
  self.dailyProgressVal = nil
  self.dailyScoreNum = nil
  self.numBg = nil
  self.animator = nil
end

local function DataDefine(self)
  self.dailyBoxShowData = {}
  self.dailyBoxShowData.sliderLen = 400
  self.dailyBoxShowData.boxListData = {
    [1] = {
      pos = {x = 130, y = 2.7},
      perPos = 0,
      valPos = 90,
      closeImg = "wxy_junbei_baoxiang1_01",
      openImg = "wxy_junbei_baoxiang1_02"
    },
    [2] = {
      pos = {x = 285, y = 2.7},
      perPos = 130,
      valPos = 245,
      closeImg = "wxy_junbei_baoxiang2_01",
      openImg = "wxy_junbei_baoxiang2_02"
    },
    [3] = {
      pos = {x = 440, y = 2.7},
      perPos = 285,
      valPos = 400,
      closeImg = "wxy_junbei_baoxiang3_01",
      openImg = "wxy_junbei_baoxiang3_02"
    }
  }
end

local function DataDestroy(self)
  self:StopTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshUIPersonalArmsDailyTip, self.UpdateDataFromMsg)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshUIPersonalArmsDailyTip, self.UpdateDataFromMsg)
  base.OnRemoveListener(self)
end

local function RefreshDailyView(self, showAnim)
  if self.progressTween then
    self.progressTween:Kill()
    self.progressTween = nil
  end
  self.numBg:SetActive(tonumber(self.showData.resourceItemNum) > 0)
  self.dailyScoreNum:SetText(self.showData.resourceItemNum)
  local progressNum = self.showData.resourceItemNum
  if progressNum > self.showData.day_rewards_max then
    progressNum = self.showData.day_rewards_max
  end
  local progressLen = 0
  local isProgressSet = false
  if self.stateValues == nil then
    self.stateValues = {}
  else
    table.clear(self.stateValues)
  end
  for i = 1, #self.dailyBoxList do
    local boxItem = self.dailyBoxList[i]
    local boxItemData = self.dailyBoxShowData.boxListData[i]
    local boxItemServerData = self.showData.day_rewards[i]
    if not showAnim then
      self:SetBoxItemStatus(i)
    end
    boxItem.root:SetAnchoredPositionXY(boxItemData.pos.x, boxItemData.pos.y)
    local boxNum = boxItemServerData.resourceNum
    boxItem.dailyBoxNum:SetText(boxNum)
    if not isProgressSet and progressNum <= boxNum then
      isProgressSet = true
      progressLen = boxItemData.perPos + 1.0 * progressNum / boxNum * (boxItemData.valPos - boxItemData.perPos)
    end
    self.stateValues[i] = boxItemData.valPos
    local curMultiRewardVal = MultiRewardDropUtils.GetCurPersonalArmsCanEnjoyMaxMultiValue()
    if curMultiRewardVal then
      boxItem.doubleMark:SetActive(1 < curMultiRewardVal)
    else
      boxItem.doubleMark:SetActive(false)
    end
  end
  if not showAnim then
    self.dailyProgressVal:SetSizeDeltaX(progressLen)
    return
  end
  self.progressBoxCurIndex = 1
  
  local function getCallback()
    return self.dailyProgressVal:GetSizeDelta().x
  end
  
  local function setCallback(value)
    self.dailyProgressVal:SetSizeDeltaX(value)
    if value >= self.stateValues[self.progressBoxCurIndex] then
      self:SetBoxItemStatus(self.progressBoxCurIndex)
      self.progressBoxCurIndex = self.progressBoxCurIndex + 1
    end
  end
  
  self.progressTween = CS.DG.Tweening.DOTween.To(getCallback, setCallback, progressLen, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

local function SetBoxItemStatus(self, index)
  if index > table.count(self.dailyBoxList) then
    return
  end
  local boxItem = self.dailyBoxList[index]
  local boxItemData = self.dailyBoxShowData.boxListData[index]
  local boxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, index)
  if boxState == ActivityBoxState.Close then
    local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.closeImg)
    boxItem.dailyBoxIcon:LoadSprite(iconPath)
    boxItem.effect:SetActive(false)
  elseif boxState == ActivityBoxState.CanOpen then
    local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.closeImg)
    boxItem.dailyBoxIcon:LoadSprite(iconPath)
    boxItem.effect:SetActive(true)
  elseif boxState == ActivityBoxState.Open then
    local iconPath = string.format(LoadPath.UIPersonalArms, boxItemData.openImg)
    boxItem.dailyBoxIcon:LoadSprite(iconPath)
    boxItem.effect:SetActive(false)
  end
end

local function OnDailyBoxClick(self, index)
  local boxState = DataCenter.ActivityPersonalArmsDataManager:GetDailyBoxState(self.showData, index)
  if boxState == ActivityBoxState.CanOpen then
  else
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.dailyBoxList[index].root:GetPosition()
    param.deltaX = -30
    if CommonUtil.IsArabicAutoMirrorOpen() then
      param.dir = UIPersonalArmsRewardTipView.Direction.LEFT
    else
      param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    end
    param.rewardList = self.showData.day_rewards[index].reward
    param.rewardMultiVal = MultiRewardDropUtils.GetCurPersonalArmsCanEnjoyMaxMultiValue()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

function UIPersonalArmsDailyTipView:UpdateDataFromMsg(data)
  if not data then
    return
  end
  self.showData = data
  self:RefreshDailyView(true)
end

function UIPersonalArmsDailyTipView:CloseBtn()
  self.animator:Play("V_ui_UIPersonalArmsDailyTip_out")
  self:StopTimer()
  self.boxVxTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl.CloseSelf(self.ctrl)
  end, 0.5)
end

function UIPersonalArmsDailyTipView:StopTimer()
  if self.boxVxTimer ~= nil then
    self.boxVxTimer:Stop()
    self.boxVxTimer = nil
  end
end

UIPersonalArmsDailyTipView.OnCreate = OnCreate
UIPersonalArmsDailyTipView.OnDestroy = OnDestroy
UIPersonalArmsDailyTipView.OnEnable = OnEnable
UIPersonalArmsDailyTipView.OnDisable = OnDisable
UIPersonalArmsDailyTipView.ComponentDefine = ComponentDefine
UIPersonalArmsDailyTipView.ComponentDestroy = ComponentDestroy
UIPersonalArmsDailyTipView.DataDefine = DataDefine
UIPersonalArmsDailyTipView.DataDestroy = DataDestroy
UIPersonalArmsDailyTipView.OnAddListener = OnAddListener
UIPersonalArmsDailyTipView.OnRemoveListener = OnRemoveListener
UIPersonalArmsDailyTipView.RefreshDailyView = RefreshDailyView
UIPersonalArmsDailyTipView.SetBoxItemStatus = SetBoxItemStatus
UIPersonalArmsDailyTipView.OnDailyBoxClick = OnDailyBoxClick
return UIPersonalArmsDailyTipView
