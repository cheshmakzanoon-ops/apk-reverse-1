local T11UpgradeConfirmView = BaseClass("T11UpgradeConfirmView", UIBaseView)
local base = UIBaseView
local T11PowerInfoComponent = require("UI.T11Common.T11PowerInfoComponent")
local BallFlyPlayerComponent = require("UI.T11Common.BallFlyPlayerComponent")
local Localization = CS.GameEntry.Localization
local T11ResearchProgressItemComponent = require("UI.T11Common.T11ResearchProgressItemComponent")
local CommonGroupCost = require("UI.UICommonCostGroup.CommonGroupCostComponent")
local T11EffAttrItemComponent = require("UI.T11.T11UpgradeConfirm.Component.T11EffAttrItemComponent")
local t11_eff_attr_item_path = "Root/ItemRoot/T11EffAttrItem"

function T11UpgradeConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateData()
  self:RefreshView()
end

function T11UpgradeConfirmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UpgradeConfirmView:OnEnable()
  base.OnEnable(self)
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
  self.closeFlag = false
  self:RefreshUpgradeCostInfo()
end

function T11UpgradeConfirmView:OnDisable()
  base.OnDisable(self)
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
  self.closeFlag = false
end

function T11UpgradeConfirmView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textResearchName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textExpFrom = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textExpTo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.sliderPreviewExpProgressArea = self.viewSkin:AddComponent(self, UISlider, 5)
  self.sliderCurExpProgressArea = self.viewSkin:AddComponent(self, UISlider, 6)
  self.btnPowerTip = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnPowerTip:SetOnClick(function()
    self:OnBtnPowerTipClick()
  end)
  self.btnUpgrade = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.compT11ResearchProgressItem = self.viewSkin:AddComponent(self, T11ResearchProgressItemComponent, 9)
  self.compCommonGroupCost = self.viewSkin:AddComponent(self, CommonGroupCost, 10)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.compEffAttrChangeArea = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.canvasGroupPreviewExpProgressArea = self.viewSkin:AddComponent(self, UICanvasGroup, 13)
  self.compT11PowerInfo = self.viewSkin:AddComponent(self, T11PowerInfoComponent, 14)
  self.compBallFlyPlayer = self.viewSkin:AddComponent(self, BallFlyPlayerComponent, 15)
  self.btnCloseBG = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnCloseBG:SetOnClick(function()
    self:OnBtnCloseBGClick()
  end)
  self.compRedDot = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.btnChangeAttrMode = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnChangeAttrMode:SetOnClick(function()
    self:OnBtnChangeAttrModeClick()
  end)
  self.textCurAttrTypeTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compItemRoot:SetActive(false)
  self.effAttrItemObj = self:AddComponent(UIBaseContainer, t11_eff_attr_item_path).gameObject
  self.effAttrItemObj:GameObjectCreatePool()
end

function T11UpgradeConfirmView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.textResearchName = nil
  self.textExpFrom = nil
  self.textExpTo = nil
  self.sliderPreviewExpProgressArea = nil
  self.sliderCurExpProgressArea = nil
  self.btnPowerTip = nil
  self.btnUpgrade = nil
  self.compT11ResearchProgressItem = nil
  self.compCommonGroupCost = nil
  self.compItemRoot = nil
  self.compEffAttrChangeArea = nil
  self.canvasGroupPreviewExpProgressArea = nil
  self.compT11PowerInfo = nil
  self.compBallFlyPlayer = nil
  self.btnCloseBG = nil
  self.compRedDot = nil
  self.btnChangeAttrMode = nil
  self.textCurAttrTypeTip = nil
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
  self.effAttrItemObj:GameObjectRecycleAll()
  if self.upgradeTween then
    self.upgradeTween:Kill()
    self.upgradeTween = nil
  end
  if self.previewExpShowDelayTimer then
    self.previewExpShowDelayTimer:Stop()
    self.previewExpShowDelayTimer = nil
  end
  if self.previewExpFadeTween then
    self.previewExpFadeTween:Kill()
    self.previewExpFadeTween = nil
  end
end

function T11UpgradeConfirmView:DataDefine()
  self.allAttrEffItemList = {}
  self.curAttrMode = T11PowerInfoGetType.ResultVal
end

function T11UpgradeConfirmView:DataDestroy()
  self.allAttrEffItemList = nil
  self.curAttrMode = nil
end

function T11UpgradeConfirmView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11ProgressUpgradeSuccess, self.OnProgressUpgradeSuccess)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshUpgradeCostInfo)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRedDot)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshRedDot)
end

function T11UpgradeConfirmView:OnRemoveListener()
  self:RemoveUIListener(EventId.T11ProgressUpgradeSuccess, self.OnProgressUpgradeSuccess)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshUpgradeCostInfo)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRedDot)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshRedDot)
  base.OnRemoveListener(self)
end

function T11UpgradeConfirmView:OnBtnPowerTipClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.T11PowerInfoView)
end

function T11UpgradeConfirmView:UpdateData()
  self.fromProgressId = T11Util.GetCurUpgradeProgressId()
  self.toProgressId = T11Util.GetNextUpgradeProgressId()
  self.fromProgressTmp = nil
  self.toProgressTmp = nil
  self.costInfo = nil
  if self.toProgressId > 0 then
    self.toProgressTmp = T11Util.GetUpgradeTmpByProgressId(self.toProgressId)
    self.costInfo = self.toProgressTmp:GetCostDataAfterParse()
  end
  if self.fromProgressId > 0 then
    self.fromProgressTmp = T11Util.GetUpgradeTmpByProgressId(self.fromProgressId)
  end
  local equipId
  if not self.fromProgressTmp then
    equipId = self.toProgressTmp.type
  else
    self.fromProgressTmp = T11Util.GetUpgradeTmpByProgressId(self.fromProgressId)
    equipId = self.fromProgressTmp.type
  end
  self.curEquipData = T11Util.GetCurEquipDataByEquipId(equipId)
end

function T11UpgradeConfirmView:RefreshView()
  self:RefreshBaseInfo()
  self:RefreshPowerValueTipInfo()
  self:RefreshEffAttrInfo()
  self:RefreshUpgradeCostInfo()
  self:RefreshRedDot()
end

function T11UpgradeConfirmView:RefreshBaseInfo()
  local isHideStageInfo = false
  local isHideProgressInfo = true
  self.compT11ResearchProgressItem:SetData(self.curEquipData, isHideStageInfo, isHideProgressInfo)
  local curResearchEquipNameStr = Localization:GetString(self.curEquipData:GetEquipNameKey())
  local curResearchEquipNameColor = T11Util.IsUnlockT11() and "#fdc839" or "#70e6f1"
  curResearchEquipNameStr = string.format("<color=%s>%s</color>", curResearchEquipNameColor, curResearchEquipNameStr)
  self.textResearchName:SetLocalText("soldier_eleven_equip", curResearchEquipNameStr)
  local fromProgressVal = self.fromProgressTmp and self.fromProgressTmp.progress or 0
  local toProgressVal = self.toProgressTmp.progress or 0
  self.textExpFrom:SetLocalText(320362, fromProgressVal)
  self.textExpTo:SetLocalText(320362, toProgressVal)
  local fromProgressPercentVal = fromProgressVal / 100
  local toProgressPercentVal = toProgressVal / 100
  self.sliderCurExpProgressArea:SetValue(fromProgressPercentVal)
  self.sliderPreviewExpProgressArea:SetValue(toProgressPercentVal)
end

function T11UpgradeConfirmView:RefreshEffAttrInfo(isUpgrade, isShowBallFly, isForceShowLightEff)
  for _, v in ipairs(self.allAttrEffItemList) do
    v:SetActive(false)
  end
  local allAttrDataList = self:GetCurShowEffAttrDataList()
  for index, v in ipairs(allAttrDataList) do
    local effAttrItem = self.allAttrEffItemList[index]
    if not effAttrItem then
      local effAttrObj = self.effAttrItemObj:GameObjectSpawn(self.compEffAttrChangeArea.transform)
      local name = tostring(NameCount)
      NameCount = NameCount + 1
      effAttrObj.name = name
      effAttrItem = self.compEffAttrChangeArea:AddComponent(T11EffAttrItemComponent, name)
      self.allAttrEffItemList[index] = effAttrItem
    end
    effAttrItem:SetActive(true)
    local title = v.title
    local fromValStr = v.fromVal
    local toValStr = v.toValue
    if isShowBallFly then
      effAttrItem:SetPlayUpgradeEffCallback(function(attrItemPos)
        self:OnAttrItemPlayUpgradeEff(attrItemPos)
      end)
    else
      effAttrItem:SetPlayUpgradeEffCallback(nil)
    end
    effAttrItem:SetData(title, fromValStr, toValStr, isUpgrade, isForceShowLightEff)
  end
  local titleKey = self.curAttrMode == T11PowerInfoGetType.ResultVal and "soldier_eleven_buff_hero" or "soldier_eleven_buff_soldier"
  self.textCurAttrTypeTip:SetLocalText(titleKey)
end

function T11UpgradeConfirmView:GetCurShowEffAttrDataList()
  if self.curAttrMode == T11PowerInfoGetType.ResultVal then
    return self:GetHeroAttrDataList()
  else
    return self:GetSoldierAttrDataList()
  end
end

function T11UpgradeConfirmView:GetSoldierAttrDataList()
  local attrDataList = {}
  if not self.toProgressTmp then
    return attrDataList
  end
  local fromAttrInfo = T11Util.GetCurAttrInfo()
  local toAttrInfo = self.toProgressTmp.attr_add
  local fromEffIdListOrdered = table.keys(fromAttrInfo)
  local toEffIdListOrdered = table.keys(toAttrInfo)
  local combineAttrNameKey, combineAttrEffId
  local combineAttrIdDic = {}
  local needCombineAttrStr = LuaEntry.DataConfig:TryGetStr("soldier_eleven_param", "k8")
  needCombineAttrStr = string.split(needCombineAttrStr, "|")
  if #needCombineAttrStr == 2 then
    local attrIdListStr = needCombineAttrStr[1]
    combineAttrNameKey = needCombineAttrStr[2]
    if attrIdListStr then
      attrIdListStr = string.split(attrIdListStr, ";")
      for _, v in ipairs(attrIdListStr) do
        local effectId = toInt(v)
        combineAttrIdDic[effectId] = true
        combineAttrEffId = combineAttrEffId or toInt(effectId)
      end
    end
  end
  local allAttrEffIdDic = {}
  local allAttrEffIdList = {}
  for _, effId in ipairs(fromEffIdListOrdered) do
    local isCombineAttr = combineAttrIdDic[effId]
    if not table.containsKey(allAttrEffIdDic, effId) and not isCombineAttr then
      table.insert(allAttrEffIdList, effId)
      allAttrEffIdDic[effId] = true
    end
  end
  for _, effId in ipairs(toEffIdListOrdered) do
    local isCombineAttr = combineAttrIdDic[effId]
    if not table.containsKey(allAttrEffIdDic, effId) and not isCombineAttr then
      table.insert(allAttrEffIdList, effId)
      allAttrEffIdDic[effId] = true
    end
  end
  if combineAttrEffId and (table.containsKey(fromAttrInfo, combineAttrEffId) or table.containsKey(toAttrInfo, combineAttrEffId)) then
    table.insert(allAttrEffIdList, combineAttrEffId)
  end
  table.sort(allAttrEffIdList, function(a, b)
    local effectATemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(a)
    local effectBTemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(b)
    return effectATemplate.sequence < effectBTemplate.sequence
  end)
  for _, effId in ipairs(allAttrEffIdList) do
    local fromVal = fromAttrInfo[effId] or 0
    local toVal = toAttrInfo[effId] or 0
    local fromDesc, fromValue = WorkerUtil.GetEffectText(effId, fromVal, true)
    local toDesc, toValue = WorkerUtil.GetEffectText(effId, toVal, true)
    local title = fromDesc
    if combineAttrIdDic[effId] then
      title = Localization:GetString(combineAttrNameKey)
    end
    table.insert(attrDataList, {
      title = title,
      fromVal = fromValue,
      toValue = toValue
    })
  end
  return attrDataList
end

function T11UpgradeConfirmView:GetHeroAttrDataList()
  local attrDataList = {}
  local fromResultPowerDataList = T11Util.GetT11PowerMap(T11PowerInfoGetType.ResultVal)
  local fromAttrInfo = T11Util.GetCurAttrInfo()
  local toAttrInfo = self.toProgressTmp and self.toProgressTmp.attr_add or {}
  local offsetAttrInfo = {}
  local offSetForeachDic = table.count(toAttrInfo) > table.count(fromAttrInfo) and toAttrInfo or fromAttrInfo
  for effId, v in pairs(offSetForeachDic) do
    local fromVal = fromAttrInfo[effId] or 0
    local toVal = toAttrInfo[effId] or 0
    offsetAttrInfo[effId] = toVal - fromVal
  end
  local toResultPowerDataList = T11Util.GetT11PowerMap(T11PowerInfoGetType.ResultVal, offsetAttrInfo)
  local foreachList = #fromResultPowerDataList > #toResultPowerDataList and fromResultPowerDataList or toResultPowerDataList
  for index, v in ipairs(foreachList) do
    local title = Localization:GetString(v.title)
    local fromVal = 0
    local toVal = 0
    if fromResultPowerDataList[index] then
      fromVal = fromResultPowerDataList[index].numVal or 0
      fromVal = math.floor(fromVal)
    end
    if toResultPowerDataList[index] then
      toVal = toResultPowerDataList[index].numVal or 0
      toVal = math.floor(toVal)
    end
    if fromVal ~= 0 or toVal ~= 0 then
      table.insert(attrDataList, {
        title = title,
        fromVal = fromVal,
        toValue = toVal
      })
    end
  end
  return attrDataList
end

function T11UpgradeConfirmView:RefreshUpgradeCostInfo()
  if not self.costInfo then
    return
  end
  self.compCommonGroupCost:ReInit(self.costInfo, true)
  self:RefreshRedDot()
end

function T11UpgradeConfirmView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function T11UpgradeConfirmView:OnBtnCloseBGClick()
  self.ctrl:CloseSelf()
end

function T11UpgradeConfirmView:OnBtnUpgradeClick()
  if self.closeFlag then
    return
  end
  local isExistLackRes = self.compCommonGroupCost:CheckIsLackRes(true)
  if isExistLackRes then
    return
  end
  if self.waitMsgTimer then
    return
  end
  self.waitMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.waitMsgTimer = nil
  end, 3)
  local nextUpgradeProgress = T11Util.GetNextUpgradeProgressId()
  SFSNetwork.SendMessage(MsgDefines.SoldierElevenUpgrade, nextUpgradeProgress)
end

function T11UpgradeConfirmView:OnProgressUpgradeSuccess()
  if not self.gameObject then
    return
  end
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
  local curUpgradeState = DataCenter.T11DataManager:GetCurT11UpgradeState()
  local curUpgradeEquipId, progress = T11Util.GetCurUpgradeEquipIdAndProgress()
  if curUpgradeState == T11UnlockState.SkillBreakable or curUpgradeState == T11UnlockState.T11Unlockable or progress == 0 then
    self.closeFlag = true
  end
  
  local function aniFinishFunc()
    if self.closeFlag then
      TimerManager:GetInstance():DelayFrameInvoke(function()
        self.ctrl:CloseSelf()
        self.closeFlag = false
      end, 1)
      return
    end
    self:RefreshBaseInfo()
  end
  
  self:UpdateData()
  self:RefreshEffAttrInfo(true, true)
  self:PlayUpgradeAni(aniFinishFunc)
  self:RefreshPowerValueTipInfo()
  self:RefreshUpgradeCostInfo()
  if GMUtils.GetBool(GMConst.EnableT11AutoUpgrade, false) then
    self:OnBtnUpgradeClick()
  end
end

function T11UpgradeConfirmView:PlayUpgradeAni(finishCallback)
  local fromVal = self.sliderCurExpProgressArea:GetValue()
  local toVal = (self.fromProgressTmp and self.fromProgressTmp.progress or 100) / 100
  
  local function Getter()
    return fromVal
  end
  
  local function Setter(value)
    self.sliderCurExpProgressArea:SetValue(value)
    self.textExpFrom:SetLocalText(320362, math.floor(value * 100))
  end
  
  if self.upgradeTween then
    self.upgradeTween:Kill(true)
    self.upgradeTween = nil
  end
  self.upgradeTween = DOTween.To(Getter, Setter, toVal, 0.3):OnComplete(function()
    self.upgradeTween = nil
    if finishCallback then
      finishCallback()
    end
    if self.canvasGroupPreviewExpProgressArea then
      self.canvasGroupPreviewExpProgressArea:SetAlpha(0)
    end
  end)
  if self.previewExpShowDelayTimer then
    self.previewExpShowDelayTimer:Stop()
    self.previewExpShowDelayTimer = nil
  end
  if self.previewExpFadeTween then
    self.previewExpFadeTween:Kill()
    self.previewExpFadeTween = nil
  end
  self.previewExpShowDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.canvasGroupPreviewExpProgressArea then
      self.previewExpFadeTween = self.canvasGroupPreviewExpProgressArea:FadeIn(0.5)
    end
    self.previewExpShowDelayTimer = nil
  end, 1)
end

function T11UpgradeConfirmView:RefreshPowerValueTipInfo()
  local curT11SearchPower = DataCenter.T11DataManager:GetT11SearchPower()
  self.compT11PowerInfo:SetPowerValue(curT11SearchPower)
end

function T11UpgradeConfirmView:OnAttrItemPlayUpgradeEff(attrItemPos)
  local startPos = attrItemPos + Vector3.New(math.random(-100, 100), math.random(-20, 20), 0)
  local endPos = self.compT11PowerInfo.transform.position + Vector3.New(0, 20, 0)
  self.compBallFlyPlayer:PlayOneBallFly(startPos, endPos, 0.7, function()
    self.compT11PowerInfo:PlayUpgradeEff()
  end)
end

function T11UpgradeConfirmView:RefreshRedDot()
  local isEnough = not self.compCommonGroupCost:CheckIsLackRes(false)
  self.compRedDot:SetActive(isEnough)
end

function T11UpgradeConfirmView:OnBtnChangeAttrModeClick()
  if self.curAttrMode == T11PowerInfoGetType.ResultVal then
    self.curAttrMode = T11PowerInfoGetType.BaseVal
  else
    self.curAttrMode = T11PowerInfoGetType.ResultVal
  end
  self:RefreshEffAttrInfo(true, false, true)
end

return T11UpgradeConfirmView
