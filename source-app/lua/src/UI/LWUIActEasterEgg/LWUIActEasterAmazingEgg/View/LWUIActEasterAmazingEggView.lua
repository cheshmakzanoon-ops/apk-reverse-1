local LWUIActEasterAmazingEggView = BaseClass("LWUIActEasterAmazingEggView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterAmazingEggView
local LWUIActEasterAmazingEggUpgradeItem = require("UI.LWUIActEasterEgg.LWUIActEasterAmazingEgg.Component.LWUIActEasterAmazingEggUpgradeItem")
local eggPrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/Model/Caidan.prefab"
local UIModelView = require("Framework.UI.Component.UIModelView")
local eggModelPath = "Model/O_env_caidan_0"
local RggGradeMap = {
  [1] = {
    Title = "activity_99144_ui_31",
    color = "#5fef87"
  },
  [2] = {
    Title = "activity_99144_ui_32",
    color = "#70e6f1"
  },
  [3] = {
    Title = "activity_99144_ui_33",
    color = "#eb86ff"
  },
  [4] = {
    Title = "activity_99144_ui_34",
    color = "#ffb644"
  },
  [5] = {
    Title = "activity_99144_ui_35",
    color = "#fb7156"
  }
}
local AMAZING_EGG_VIBRATION_INTENSITY = 0.5
local AMAZING_EGG_VIBRATION_SHARPNESS = 0.3
local AMAZING_EGG_VIBRATION_DURATION = 0.2
local ViewAnimation = {Double = "double", Success = "success"}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.eggInfo = param.eggInfo
  self.openType = param.openType
  self:InitView()
end

function M:OnDestroy()
  if self.openType == ActEasterAmazingEggOpenType.PickUpEgg then
    EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityRefreshMainEggAni)
  end
  self:StopDelayPlayUpgrade()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.textQuality = self:AddComponent(UITextMeshProUGUIEx, "Content/Quality")
  self.textRemain = self:AddComponent(UITextMeshProUGUIEx, "Content/RemainText")
  self.textExplain = self:AddComponent(UITextMeshProUGUIEx, "Content/ExplainText")
  self.compLWUIActEasterAmazingEggUpgradeItem2 = self:AddComponent(LWUIActEasterAmazingEggUpgradeItem, "UpgradeContent/LWUIActEasterAmazingEggUpgradeItem2")
  self.compLWUIActEasterAmazingEggUpgradeItem3 = self:AddComponent(LWUIActEasterAmazingEggUpgradeItem, "UpgradeContent/LWUIActEasterAmazingEggUpgradeItem3")
  self.compLWUIActEasterAmazingEggUpgradeItem4 = self:AddComponent(LWUIActEasterAmazingEggUpgradeItem, "UpgradeContent/LWUIActEasterAmazingEggUpgradeItem4")
  self.compLWUIActEasterAmazingEggUpgradeItem5 = self:AddComponent(LWUIActEasterAmazingEggUpgradeItem, "UpgradeContent/LWUIActEasterAmazingEggUpgradeItem5")
  self.btn = self:AddComponent(UIButton, "ClickBtn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.compLWUIActEasterAmazingEggUpgradeItem1 = self:AddComponent(LWUIActEasterAmazingEggUpgradeItem, "UpgradeContent/LWUIActEasterAmazingEggUpgradeItem1")
  self.textUpgradeResult = self:AddComponent(UITextMeshProUGUIEx, "Content/UpgradeResult")
  self.effectSimpleUpgrade1 = self:AddComponent(UIBaseContainer, "Eff_ui_fuhuojie_egg_back_simple")
  self.effectSimpleUpgrade2 = self:AddComponent(UIBaseContainer, "Eff_ui_fuhuojie_egg_front")
  self.effectFinalUpgrade1 = self:AddComponent(UIBaseContainer, "Eff_ui_fuhuojie_egg_explode_back")
  self.effectFinalUpgrade2 = self:AddComponent(UIBaseContainer, "Eff_ui_fuhuojie_egg_explode_front")
  self.effectLoopBg = self:AddComponent(UIBaseContainer, "Eff_ui_fuhuojie_egg_back_loop")
  self.animator = self:AddComponent(UIAnimator, "")
  self.rawImgRTSceneBg = self:AddComponent(UIModelView, "RTSceneBg")
  self.compDouble = self:AddComponent(UIBaseContainer, "Double")
end

function M:ComponentDestroy()
  self.textQuality = nil
  self.textRemain = nil
  self.textExplain = nil
  self.compLWUIActEasterAmazingEggUpgradeItem2 = nil
  self.compLWUIActEasterAmazingEggUpgradeItem3 = nil
  self.compLWUIActEasterAmazingEggUpgradeItem4 = nil
  self.compLWUIActEasterAmazingEggUpgradeItem5 = nil
  self.btn = nil
  self.compLWUIActEasterAmazingEggUpgradeItem1 = nil
  self.textUpgradeResult = nil
  self.effectSimpleUpgrade1 = nil
  self.effectSimpleUpgrade2 = nil
  self.effectFinalUpgrade1 = nil
  self.effectFinalUpgrade2 = nil
  self.effectLoopBg = nil
  self.animator = nil
  self.rawImgRTSceneBg = nil
  self.compDouble = nil
end

function M:DataDefine()
  self.upgradeItemList = {}
  self.eggInfo = nil
  self.curQuality = 0
  self.curUpgradeTime = 0
  self.openType = 0
  self.maxUpgradeTimes = 0
  self.eggModelList = {}
  self.reward = nil
  self.delayPlayUpgrade = nil
  self.isRequesting = false
end

function M:DataDestroy()
  self.upgradeItemList = nil
  self.eggInfo = nil
  self.curQuality = nil
  self.curUpgradeTime = nil
  self.openType = nil
  self.maxUpgradeTimes = nil
  self.eggModelList = nil
  self.reward = nil
  self.delayPlayUpgrade = nil
  self.isRequesting = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivityUpgradeAmazingEgg, self.RefreshAmazingEggByUpgradeInfo)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivityUpgradeAmazingEgg, self.RefreshAmazingEggByUpgradeInfo)
end

function M:OnBtnClick()
  if self.isRequesting then
    return
  end
  self.ctrl:RequestUpgrade(self.eggInfo.uuid)
  self.isRequesting = true
end

function M:InitEffect()
  self.effectSimpleUpgrade1:SetActive(false)
  self.effectSimpleUpgrade2:SetActive(false)
  self.effectFinalUpgrade1:SetActive(false)
  self.effectFinalUpgrade2:SetActive(false)
  self.effectLoopBg:SetActive(true)
end

function M:InitEggByInfo(eggInfo, openType)
  self.eggInfo = eggInfo
  self.openType = openType
  self.isRequesting = false
  self:InitView()
end

function M:InitView()
  local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
  if not configData then
    Logger.LogError("config is nil")
    return
  end
  self.curQuality = self.eggInfo.curQuality
  self.maxUpgradeTimes = configData.amazingUpgradeTimes
  self.curUpgradeTime = self:GetCurUpgradeTime(self.eggInfo:GetUpgradeItemInfo())
  self.textUpgradeResult:SetText("")
  self.textExplain:SetLocalText("activity_99144_ui_39")
  self:InitUpgradeItems()
  self:RefreshEgg()
  self:SetQuality()
  self:SetRemainText()
  self.compDouble:SetActive(false)
  self:InitEffect()
  self:RefreshRTSceneBg()
  self.reward = nil
end

function M:InitUpgradeItems()
  self.upgradeItemList = {
    self.compLWUIActEasterAmazingEggUpgradeItem1,
    self.compLWUIActEasterAmazingEggUpgradeItem2,
    self.compLWUIActEasterAmazingEggUpgradeItem3,
    self.compLWUIActEasterAmazingEggUpgradeItem4,
    self.compLWUIActEasterAmazingEggUpgradeItem5
  }
  local itemInfo = self.eggInfo:GetUpgradeItemInfo()
  for k, v in pairs(self.upgradeItemList) do
    if v then
      local state
      if itemInfo[k] == 0 then
        state = ActEasterAmazingEggState.ToUpgrade
      else
        state = ActEasterAmazingEggState.Upgraded
      end
      v:ReInit(k, state)
      v:SetCurIndex(self.curUpgradeTime + 1)
    end
  end
end

function M:RefreshAmazingEggByUpgradeInfo(eggInfo)
  if not eggInfo then
    return
  end
  self.curQuality = eggInfo:GetCurQuality()
  self:SetQuality()
  self:RefreshEgg()
  self.curUpgradeTime = self.curUpgradeTime + 1
  self:SetRemainText()
  self:RefreshUpgradeItems(eggInfo)
  local upgradeSuccess = eggInfo:IsUpgradeSuccess()
  if upgradeSuccess then
    self.textUpgradeResult:SetLocalText("activity_99144_ui_36")
    self.animator:Play(ViewAnimation.Success, 0, 0)
    self:EggPlayAni(self.curQuality, "Up")
    ShakeUtil.DoVibration(AMAZING_EGG_VIBRATION_INTENSITY, AMAZING_EGG_VIBRATION_SHARPNESS, AMAZING_EGG_VIBRATION_DURATION)
  else
    self.textUpgradeResult:SetText("")
  end
  local isDouble = eggInfo:IsDouble()
  self.compDouble:SetActive(isDouble)
  if isDouble then
    self.textUpgradeResult:SetLocalText("activity_99144_ui_37")
    self.animator:Play(ViewAnimation.Double, 0, 0)
    ShakeUtil.DoVibration(AMAZING_EGG_VIBRATION_INTENSITY, AMAZING_EGG_VIBRATION_SHARPNESS, AMAZING_EGG_VIBRATION_DURATION)
  end
  self:EggPlayAni(self.curQuality, "Up")
  if eggInfo and eggInfo.reward then
    self.reward = eggInfo.reward
  end
  if self.reward then
    self:StopDelayPlayUpgrade()
    self.delayPlayUpgrade = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayUpgradeEffect()
      self.delayPlayUpgrade:Stop()
      self.delayPlayUpgrade = nil
      self:EggPlayAni(self.curQuality, "Advanced")
      local open
      open = TimerManager:GetInstance():DelayInvoke(function()
        self:OpenReward(self.reward)
        open:Stop()
        open = nil
      end, 2)
      open:Start()
    end, 0.5)
    self.delayPlayUpgrade:Start()
  else
    if upgradeSuccess then
      self:PlayUpgradeEffect(upgradeSuccess)
    end
    self.isRequesting = false
  end
end

function M:PlayUpgradeEffect()
  if self.curUpgradeTime < self.maxUpgradeTimes then
    self.effectSimpleUpgrade1:SetActive(false)
    self.effectSimpleUpgrade1:SetActive(true)
    self.effectSimpleUpgrade2:SetActive(false)
    self.effectSimpleUpgrade2:SetActive(true)
  else
    self.effectLoopBg:SetActive(false)
    self.effectFinalUpgrade1:SetActive(false)
    self.effectFinalUpgrade2:SetActive(false)
    self.effectFinalUpgrade1:SetActive(true)
    self.effectFinalUpgrade2:SetActive(true)
  end
end

function M:OpenReward(reward)
  DataCenter.RewardManager:AddRewardsAndRes({reward = reward})
  DataCenter.RewardManager:ShowCommonReward({reward = reward}, nil, nil, nil, nil, nil, function()
    if self.openType == ActEasterAmazingEggOpenType.UnpackEggList then
      DataCenter.ActEasterEggManager:DeleteUnpackedAmazingEgg(self.eggInfo.uuid)
      DataCenter.ActEasterEggManager:HandleUnpackedAmazingEgg()
    elseif self.openType == ActEasterAmazingEggOpenType.PickUpEgg then
      self.ctrl:CloseSelf()
    end
  end)
end

function M:RefreshEgg()
  for k, v in pairs(self.eggModelList) do
    v:SetActive(k == self.curQuality)
  end
end

function M:RefreshUpgradeItems(upgradeInfo)
  local itemInfo = upgradeInfo:GetUpgradeItemInfo()
  if not itemInfo then
    Logger.LogError("itemInfo is nil")
    return
  end
  local itemInfoArr = ""
  for k, v in pairs(itemInfo) do
    itemInfoArr = itemInfoArr .. v .. " "
  end
  for k, v in pairs(self.upgradeItemList) do
    if v then
      v:SetCurIndex(self.curUpgradeTime + 1)
      if itemInfo and itemInfo[k] then
        local stateNum = itemInfo[k]
        if stateNum == 0 then
          v:SetState(ActEasterAmazingEggState.ToUpgrade, false)
        else
          v:SetState(ActEasterAmazingEggState.Upgraded, true)
        end
      end
    end
  end
end

function M:SetQuality()
  local qualityData = RggGradeMap[self.curQuality]
  if qualityData then
    self.textQuality:SetText(Localization:GetString(qualityData.Title))
    self.textQuality:SetColorHex(qualityData.color)
  end
end

function M:SetRemainText()
  local str = Localization:GetString("activity_99144_ui_38", self.maxUpgradeTimes - self.curUpgradeTime)
  self.textRemain:SetText(str)
end

function M:GetCurUpgradeTime(gradeArr)
  local index = 0
  for k, v in pairs(gradeArr) do
    if v == 0 then
      index = k
      break
    end
  end
  if 0 > index - 1 then
    return 0
  end
  return index - 1
end

function M:RefreshRTSceneBg()
  self.rawImgRTSceneBg:Clear()
  self.rawImgRTSceneBg:SetRTSize(810, nil)
  self.rawImgRTSceneBg:SetDefaultSceneTrans(Vector3.New(-500, 0, -500))
  self.rawImgRTSceneBg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGB32)
  self.rawImgRTSceneBg:ReInit(eggPrefabPath)
  self.rawImgRTSceneBg:SetActive(true)
  self.rawImgRTSceneBg:SetOnLoadSceneHandler(function()
    for i = 1, 5 do
      local eggPath = eggModelPath .. i
      local sceneNode = self.rawImgRTSceneBg:GetSceneNode(eggPath)
      if sceneNode then
        table.insert(self.eggModelList, sceneNode)
      end
    end
    self:RefreshEgg()
    self:EggPlayAni(self.curQuality, "Default")
  end)
end

function M:EggPlayAni(index, aniName)
  if self.eggModelList[index] then
    local curEgg = self.eggModelList[index]
    local simpleAni = curEgg:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if simpleAni:IsPlaying(aniName) then
      simpleAni:Rewind(aniName)
    else
      simpleAni:Play(aniName)
    end
  end
end

function M:StopDelayPlayUpgrade()
  if self.delayPlayUpgrade then
    self.delayPlayUpgrade:Stop()
    self.delayPlayUpgrade = nil
  end
end

return LWUIActEasterAmazingEggView
