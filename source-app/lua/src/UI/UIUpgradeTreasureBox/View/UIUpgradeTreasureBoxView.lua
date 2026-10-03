local UIUpgradeTreasureBoxView = BaseClass("UIUpgradeTreasureBoxView", UIBaseView)
local upgradeBoxItemPath = "Assets/Main/ActivityFestival/ActUpgradeTreasureBox/Prefab/UIUpgradeTreasureBoxItem.prefab"
local SCENE_PREFAB_PATH_DEFAULT = "Assets/Main/Prefabs/UpgradeTreasureBox/2025halloween/A_build_Halloween_baoxiang_timeline_Variant.prefab"
local UIUpgradeTreasureBoxItemComponent = require("UI.UIUpgradeTreasureBox.Component.UIUpgradeTreasureBoxItemComponent")
local UIModelView = require("Framework.UI.Component.UIModelView")
local UpgradeTreasureBoxSceneCtrl = require("UI.UIUpgradeTreasureBox.SceneView.UpgradeTreasureBoxSceneCtrl")
local upgradeTime = 0.2
local UpgradeOrangeTime = 0.2
local UpgradeOrangeManualTime = 0.75
local UpgradeRedTime = 1.6
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = UIUpgradeTreasureBoxView
local QualityColorDic = {
  [UpgradeTreasureBoxQuality.Green] = "#5fef87",
  [UpgradeTreasureBoxQuality.Blue] = "#70e6f1",
  [UpgradeTreasureBoxQuality.Purple] = "#ff7ffd",
  [UpgradeTreasureBoxQuality.Orange] = "#ffb644",
  [UpgradeTreasureBoxQuality.Red] = "#f53c3d"
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.boxInfo = self:GetUserData()
  self.curBoxInfoUuid = self.boxInfo and self.boxInfo:GetUuid() or ""
  self.curBoxInfoAuto = self.boxInfo and self.boxInfo:IsAuto() or false
  self:InitView()
end

function M:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.UpgradeTreasureBoxOnClose, self.curBoxInfoAuto)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  if self.sceneViewCtrl then
    self.sceneViewCtrl:Destroy()
    self.sceneViewCtrl = nil
  end
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.btnSkip = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.btnUpgrade = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.compUpgradeContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textClick = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textRemain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textQuality = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textSkipBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textUpgradeBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compRTSceneBg = self.viewSkin:AddComponent(self, UIModelView, 12)
  self.simpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 13)
  self.compEffectUpgradeFail = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.compEffectUpgradeSuccess = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.compIncreaseNode3 = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.compOrangeEffectNode = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.compRedEffectNode = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.compOpenBox = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 20)
  self.imgPumpkinMove = self.viewSkin:AddComponent(self, UIImage, 21)
  self.rawImgBox = self.viewSkin:AddComponent(self, UIRawImage, 22)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.textNextBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textLeftBoxNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.btnConfirm:SetSafeClickMode(true)
  self.btnConfirm:SetSafeClickModeTime(1)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.btnClick = nil
  self.btnSkip = nil
  self.btnUpgrade = nil
  self.compUpgradeContent = nil
  self.textClick = nil
  self.textRemain = nil
  self.textQuality = nil
  self.textSkipBtn = nil
  self.textUpgradeBtn = nil
  self.btnConfirm = nil
  self.textBtn = nil
  self.compRTSceneBg = nil
  self.simpleAnimation = nil
  self.compEffectUpgradeFail = nil
  self.compEffectUpgradeSuccess = nil
  self.compIncreaseNode3 = nil
  self.compOrangeEffectNode = nil
  self.compRedEffectNode = nil
  self.compOpenBox = nil
  self.rawImgBg = nil
  self.imgPumpkinMove = nil
  self.rawImgBox = nil
  self.btnNext = nil
  self.textNextBtn = nil
  self.btnBack = nil
  self.textLeftBoxNum = nil
end

function M:DataDefine()
  self.boxInfo = nil
  self.upgradeBoxList = {}
  self.upgradeBoxRequestList = {}
  self.isSkipping = false
  self.requestRewardTimer = nil
  self.clickUpgradeCount = 0
  self.clickSkipCount = 0
  self.clickUpgradeItemCount = 0
  self.requestReward = false
  self.viewSkinConfig = {}
  self.soundHandleList = {}
  self.curBoxInfoUuid = ""
end

function M:DataDestroy()
  EventManager:GetInstance():Broadcast(EventId.OnRecAutoUpgradeTreasureBoxClose)
  self.boxInfo = nil
  self.upgradeBoxList = nil
  self.upgradeBoxRequestList = nil
  self.isSkipping = nil
  if self.requestRewardTimer then
    self.requestRewardTimer:Stop()
    self.requestRewardTimer = nil
  end
  self.clickUpgradeCount = nil
  self.clickSkipCount = nil
  self.clickUpgradeItemCount = nil
  self.requestReward = nil
  if self.orangeUpgradeDelay then
    self.orangeUpgradeDelay:Stop()
    self.orangeUpgradeDelay = nil
  end
  if self.redUpgradeDelay then
    self.redUpgradeDelay:Stop()
    self.redUpgradeDelay = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.viewSkinConfig = nil
  if self.openSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.openSoundHandle)
    self.openSoundHandle = nil
  end
  if self.soundHandleList then
    for i = 1, #self.soundHandleList do
      DataCenter.LWSoundManager:StopSound(self.soundHandleList[i])
    end
    self.soundHandleList = nil
  end
  self.curBoxInfoUuid = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpgradeTreasureBoxClickCell, self.OnRecClickCell)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnRecRewardPanelClose)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnRecFinishHandleInitMsg)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.UpgradeTreasureBoxClickCell, self.OnRecClickCell)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnRecRewardPanelClose)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnRecFinishHandleInitMsg)
  base.OnRemoveListener(self)
end

function M:OnBtnClickClick()
end

function M:OnBtnSkipClick()
  if self.isSkipping then
    return
  end
  local canUpgradeIndexList = self:GetAllCanUpgradeIndex()
  if not canUpgradeIndexList then
    return
  end
  self.isSkipping = true
  self.clickSkipCount = self.clickSkipCount + 1
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():GetTimer(0.5, function()
    if #canUpgradeIndexList == 0 then
      self.isSkipping = false
      if self.timer then
        self.timer:Stop()
        self.timer = nil
      end
      return
    end
    self.ctrl:OnClick()
    if self:CheckIfTopReward() then
      self.ctrl:JumpToLast(self.curBoxInfoUuid, self.curBoxInfoAuto)
      local indexList = self:GetAllCanUpgradeIndex()
      for _, v in ipairs(indexList) do
        self:UpgradeCells(v)
      end
      canUpgradeIndexList = {}
    else
      local index = table.remove(canUpgradeIndexList, 1)
      self:UpgradeCells(index)
    end
    self:RefreshView()
  end, self, false, false, false)
  self.timer:Start()
end

function M:GetFirstCanUpgradeIndex()
  for i, v in ipairs(self.upgradeBoxList) do
    if v:CanUpgrade() then
      return i
    end
  end
end

function M:GetAllCanUpgradeIndex()
  local result = {}
  for i, v in ipairs(self.upgradeBoxList) do
    if v:CanUpgrade() then
      table.insert(result, i)
    end
  end
  return result
end

function M:OnBtnUpgradeClick()
  local remainTimes = self.ctrl:GetRemainUpgradeTimes(self.curBoxInfoUuid, self.curBoxInfoAuto)
  if remainTimes <= 0 then
    return
  end
  if self.isSkipping then
    return
  end
  local upgradeIndex = self:GetFirstCanUpgradeIndex()
  if not upgradeIndex or upgradeIndex <= 0 then
    return
  end
  self.ctrl:OnClick()
  self.clickUpgradeCount = self.clickUpgradeCount + 1
  if self:CheckIfTopReward() then
    self.ctrl:JumpToLast(self.curBoxInfoUuid, self.curBoxInfoAuto)
    local indexList = self:GetAllCanUpgradeIndex()
    for _, v in ipairs(indexList) do
      self:UpgradeCells(v)
    end
  else
    self:UpgradeCells(upgradeIndex)
  end
  self:RefreshView()
end

function M:RefreshView()
  self:RefreshTitleQuality(false)
  self:RefreshBtn()
  self:RefreshSceneBox()
  self:RefreshRemainText()
  self:PlayUpgradeEffect()
end

function M:OnBtnConfirmClick()
  if self.requestReward then
    return
  end
  self:PlayOpenBoxAni()
end

function M:InitView(reset)
  self.textClick:SetLocalText("2025halloween_upgradebox_get_tips1")
  self.textRemain:SetLocalText("2025halloween_upgradebox_get_tips2", self.ctrl:GetRemainUpgradeTimes(self.curBoxInfoUuid, self.curBoxInfoAuto))
  self:RefreshTitleQuality(true)
  self:InitViewByConfig()
  self:InitUpgradeContent()
  self:InitBtn()
  self:InitRTSceneBg(reset)
  self:InitEffect()
  self:PostEventLogOnInit()
end

function M:InitBtn()
  self.textSkipBtn:SetLocalText("2025halloween_upgradebox_desc3")
  self.textUpgradeBtn:SetLocalText("2025halloween_upgradebox_desc4")
  self.textBtn:SetLocalText("2025halloween_upgradebox_desc5")
  self.btnConfirm:SetActive(false)
  self.btnUpgrade:SetActive(true)
  self.btnSkip:SetActive(true)
  self.btnNext:SetActive(false)
  self.textLeftBoxNum:SetActive(false)
  self.btnBack:SetActive(self.curBoxInfoAuto)
end

function M:InitUpgradeContent()
  self:ClearScroll()
  local remainTimes = self.ctrl:GetRemainUpgradeTimes(self.curBoxInfoUuid, self.curBoxInfoAuto)
  for i = 1, remainTimes do
    self.upgradeBoxRequestList[i] = self:GameObjectInstantiateAsync(upgradeBoxItemPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compUpgradeContent.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "upgradeTreasureCell" .. i
      local cell = self.compUpgradeContent:AddComponent(UIUpgradeTreasureBoxItemComponent, go.name)
      cell:Init(i, self.viewSkinConfig)
      table.insert(self.upgradeBoxList, cell)
    end)
  end
end

function M:InitViewByConfig()
  if not self.boxInfo or not self.boxInfo.group then
    Logger.LogError("UIUpgradeTreasureBoxView:InitViewByConfig boxInfo or boxInfo.group is nil")
    return
  end
  local config = self.ctrl:GetViewSKinConfig(self.boxInfo.group)
  if not config or table.count(config) == 0 then
    return
  end
  self.viewSkinConfig = config
  local bgTexturePath = config.Bg
  self.rawImgBg:LoadSpriteAsync(bgTexturePath)
end

function M:RefreshTitleQuality(isFirstTime)
  if not self.boxInfo then
    Logger.LogError("UIUpgradeTreasureBoxView:RefreshRemainTimes boxInfo is nil")
    return
  end
  local quality = 0
  if isFirstTime then
    quality = self.boxInfo.initQuality
  else
    local index = self.ctrl:GetCurProgressIndex()
    quality = self.boxInfo.progress[index]
  end
  local group = self.boxInfo.group
  local name = DataCenter.UpgradeTreasureBoxManager:GetBoxName(group, quality)
  self.textQuality:SetLocalText(name)
  local color = QualityColorDic[quality] or "#FFFFFF"
  self.textQuality:SetColorHex(color)
end

function M:GetCurBoxUpgradeResult()
  local curIndex = self.ctrl:GetCurProgressIndex()
  local lastProgress = 0
  if curIndex == 1 then
    lastProgress = self.boxInfo.initQuality
  else
    lastProgress = self.boxInfo.progress[curIndex - 1]
  end
  local curProgress = self.boxInfo.progress[curIndex]
  if curProgress == UpgradeTreasureBoxQuality.Red and lastProgress == UpgradeTreasureBoxQuality.Red then
    return UpgradeTreasureBoxResult.Success, curProgress
  end
  if lastProgress < curProgress then
    return UpgradeTreasureBoxResult.Success, curProgress
  else
    return UpgradeTreasureBoxResult.Fail, curProgress
  end
end

function M:UpgradeCells(index)
  local result = self:GetCurBoxUpgradeResult()
  local curItem = self.upgradeBoxList[index]
  if curItem then
    curItem:Refresh(result)
  end
end

function M:PlayUpgradeEffect()
  local result, curProgress = self:GetCurBoxUpgradeResult()
  self:PlayUIAnimation("shake")
  if curProgress <= UpgradeTreasureBoxQuality.Purple then
    self.compEffectUpgradeFail:SetActive(false)
    self.compEffectUpgradeFail:SetActive(true)
    local handle = DataCenter.LWSoundManager:PlaySound(91112, false)
    table.insert(self.soundHandleList, handle)
  elseif curProgress == UpgradeTreasureBoxQuality.Orange then
    if self.isSkipping then
      self.compEffectUpgradeFail:SetActive(false)
      self.compEffectUpgradeFail:SetActive(true)
    else
      self.compIncreaseNode3:SetActive(false)
      self.compIncreaseNode3:SetActive(true)
      self.compEffectUpgradeSuccess:SetActive(false)
      self.orangeUpgradeDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.compEffectUpgradeSuccess:SetActive(true)
      end, 0.5)
    end
    local handle = DataCenter.LWSoundManager:PlaySound(91113, false)
    table.insert(self.soundHandleList, handle)
  elseif curProgress == UpgradeTreasureBoxQuality.Red then
    self.compOpenBox:SetActive(false)
    self.compOpenBox:SetActive(true)
    self.compEffectUpgradeSuccess:SetActive(false)
    self.redUpgradeDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.compEffectUpgradeSuccess:SetActive(true)
    end, 1.3)
    local handle = DataCenter.LWSoundManager:PlaySound(91131, false)
    table.insert(self.soundHandleList, handle)
  end
end

function M:RefreshBtn()
  local remainTimes = self.ctrl:GetRemainUpgradeTimes(self.curBoxInfoUuid, self.curBoxInfoAuto)
  local ifRemain = 0 < remainTimes
  self.btnConfirm:SetActive(not ifRemain)
  self.btnUpgrade:SetActive(ifRemain)
  self.btnSkip:SetActive(ifRemain)
end

function M:ClearScroll()
  self.compUpgradeContent:RemoveComponents(UIUpgradeTreasureBoxItemComponent)
  if self.upgradeBoxRequestList ~= nil then
    for _, v in pairs(self.upgradeBoxRequestList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.upgradeBoxRequestList = {}
  self.upgradeBoxList = {}
end

function M:InitRTSceneBg(reset)
  if reset then
    self.compRTSceneBg:SetActive(true)
    self.sceneViewCtrl:Init(self.compRTSceneBg, self.boxInfo.group, self.boxInfo.initQuality)
    return
  end
  self.compRTSceneBg:Clear()
  self.compRTSceneBg:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.compRTSceneBg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  local scenePath = SCENE_PREFAB_PATH_DEFAULT
  if self.viewSkinConfig and not string.IsNullOrEmpty(self.viewSkinConfig.scenePath) then
    scenePath = self.viewSkinConfig.scenePath
  end
  self.compRTSceneBg:ReInit(scenePath)
  self.compRTSceneBg:SetActive(false)
  self.compRTSceneBg:SetOnLoadSceneHandler(function()
    if not self.sceneViewCtrl then
      self.sceneViewCtrl = UpgradeTreasureBoxSceneCtrl.New()
    end
    self.compRTSceneBg:SetActive(true)
    self.sceneViewCtrl:Init(self.compRTSceneBg, self.boxInfo.group, self.boxInfo.initQuality)
  end)
end

function M:InitEffect()
  self.compEffectUpgradeFail:SetActive(false)
  self.compEffectUpgradeSuccess:SetActive(false)
  self.compOrangeEffectNode:SetActive(false)
  self.compRedEffectNode:SetActive(false)
  self.compIncreaseNode3:SetActive(false)
  self.compOpenBox:SetActive(false)
end

function M:RefreshSceneBox()
  if self.sceneViewCtrl and self.boxInfo then
    local delayTime = 0
    local aniName = "idle"
    local curIndex = self.ctrl:GetCurProgressIndex()
    local curQuality = self.boxInfo.progress[curIndex]
    if curQuality <= UpgradeTreasureBoxQuality.Purple then
      aniName = "up"
      delayTime = upgradeTime
    end
    if curQuality == UpgradeTreasureBoxQuality.Orange then
      aniName = "up1"
      delayTime = self.isSkipping and UpgradeOrangeTime or UpgradeOrangeManualTime
    end
    if curQuality == UpgradeTreasureBoxQuality.Red then
      aniName = "up2"
      delayTime = UpgradeRedTime
    end
    local lastQuality = 0
    if 1 < curIndex then
      if curQuality ~= UpgradeTreasureBoxQuality.Red then
        lastQuality = self.boxInfo.progress[curIndex - 1]
      else
        lastQuality = DataCenter.UpgradeTreasureBoxManager:GetLastNotRedProgress(self.curBoxInfoUuid, self.curBoxInfoAuto)
      end
    else
      lastQuality = self.boxInfo.initQuality
    end
    self.sceneViewCtrl:PlayBoxAni(curQuality, aniName, delayTime, lastQuality)
  end
end

function M:PlayOpenBoxAni()
  if self.sceneViewCtrl then
    local curIndex = self.ctrl:GetCurProgressIndex()
    local curQuality = self.boxInfo.progress[curIndex]
    self.compOrangeEffectNode:SetActive(false)
    self.compRedEffectNode:SetActive(false)
    self.compEffectUpgradeSuccess:SetActive(false)
    self.compEffectUpgradeFail:SetActive(false)
    self.compOpenBox:SetActive(false)
    if curQuality < UpgradeTreasureBoxQuality.Red then
      self.sceneViewCtrl:PlayBoxAni(curQuality, "open")
      self.compOrangeEffectNode:SetActive(true)
      self.openSoundHandle = DataCenter.LWSoundManager:PlaySound(91114, false)
    else
      self.sceneViewCtrl:PlayBoxAni(curQuality, "open2")
      self.compRedEffectNode:SetActive(true)
      self.openSoundHandle = DataCenter.LWSoundManager:PlaySound(91132, false)
    end
    self.requestReward = true
    self.requestRewardTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:RequestGetReward(self.boxInfo.uuid)
    end, 1.5)
  end
end

function M:RefreshRemainText()
  self.textRemain:SetLocalText("2025halloween_upgradebox_get_tips2", self.ctrl:GetRemainUpgradeTimes(self.curBoxInfoUuid, self.curBoxInfoAuto))
end

function M:PlayUIAnimation(aniName)
  if self.simpleAnimation then
    if self.simpleAnimation:IsPlaying(aniName) then
      self.simpleAnimation:Rewind(aniName)
    else
      self.simpleAnimation:Play(aniName)
    end
  end
end

function M:OnRecClickCell(index)
  if not index or index <= 0 then
    Logger.LogError("OnRecClickCell index is nil or invalid")
    return
  end
  if self.isSkipping then
    return
  end
  self.ctrl:OnClick()
  self.clickUpgradeItemCount = self.clickUpgradeItemCount + 1
  if self:CheckIfTopReward() then
    self.ctrl:JumpToLast(self.curBoxInfoUuid, self.curBoxInfoAuto)
    local indexList = self:GetAllCanUpgradeIndex()
    for _, v in ipairs(indexList) do
      self:UpgradeCells(v)
    end
  else
    self:UpgradeCells(index)
  end
  self:RefreshView()
end

function M:CheckIfTopReward()
  if not self.boxInfo then
    return false
  end
  local curIndex = self.ctrl:GetCurProgressIndex()
  if curIndex < 1 then
    return false
  end
  local curQuality = self.boxInfo.progress[curIndex]
  if curQuality == UpgradeTreasureBoxQuality.Red then
    return true
  end
  return false
end

function M:OnRecRewardPanelClose()
  PostEventLog.Track(PostEventLog.Defines.UpgradeTreasureBoxComplete, {
    clickSkipCount = self.clickSkipCount,
    clickUpgradeCount = self.clickUpgradeCount,
    clickUpgradeItemCount = self.clickUpgradeItemCount
  })
  DataCenter.UpgradeTreasureBoxManager:RemoveTreasureBoxByUuid(self.curBoxInfoUuid, self.curBoxInfoAuto)
  local treasureBoxInfo = DataCenter.UpgradeTreasureBoxManager:GetFirstAutoBoxData()
  local ifClose = not self.curBoxInfoAuto or self.curBoxInfoAuto and not treasureBoxInfo
  if ifClose then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshNextBtn()
  local reward = DataCenter.UpgradeTreasureBoxManager:GetCacheRewardData()
  if not table.IsNullOrEmpty(reward) then
    for _, v in ipairs(reward) do
      if v.type == RewardType.GOODS and v.value and not string.IsNullOrEmpty(v.value.itemId) then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.value.itemId)
        if itemTemplate and itemTemplate.type == GOODS_TYPE.GOODS_TYPE_181 then
          local param = {
            itemId = v.value.itemId,
            isBagUse = false
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIUseFlowerTrain, {anim = true}, param)
          break
        end
      end
    end
  end
  DataCenter.UpgradeTreasureBoxManager:CacheRewardData()
end

function M:OnRecFinishHandleInitMsg()
  Logger.LogWarning("OnRecFinishHandleInitMsg\230\150\173\231\186\191")
  self.requestReward = false
end

function M:RefreshNextBtn()
  self.btnConfirm:SetActive(false)
  self.btnNext:SetActive(true)
  local treasureBoxInfo = DataCenter.UpgradeTreasureBoxManager:GetFirstAutoBoxData()
  if treasureBoxInfo then
    self.textNextBtn:SetLocalText("Valentine_send_bp_btn_07")
  else
    self.textNextBtn:SetLocalText("2025halloween_upgradebox_desc5")
  end
  self.textLeftBoxNum:SetActive(true)
  local leftNum = DataCenter.UpgradeTreasureBoxManager:GetAutoBoxNum()
  self.textLeftBoxNum:SetLocalText("activity_98600_desc9", leftNum)
end

function M:OnBtnNextClick()
  local treasureBoxInfo = DataCenter.UpgradeTreasureBoxManager:GetFirstAutoBoxData()
  if treasureBoxInfo then
    self:ResetData(treasureBoxInfo)
    self.ctrl:ResetProgress()
    self:InitView(true)
    self:PlayUIAnimation("in_next")
  else
    self.ctrl:CloseSelf()
  end
end

function M:ResetData(treasureBoxInfo)
  self.boxInfo = treasureBoxInfo
  self.curBoxInfoUuid = self.boxInfo:GetUuid()
  self.curBoxInfoAuto = self.boxInfo:IsAuto()
  self.isSkipping = false
  self.requestReward = false
end

function M:PostEventLogOnInit()
  local auto = self.boxInfo and self.boxInfo:IsAuto() and 1 or 0
  local confId = self.boxInfo and self.boxInfo.confId or 0
  local activityId = self.boxInfo and self.boxInfo.activityId or 0
  local uuid = self.boxInfo and self.boxInfo.uuid or ""
  PostEventLog.Track(PostEventLog.Defines.OpenUpgradeTreasureBox, {
    confId = confId,
    activityId = activityId,
    uuid = uuid,
    auto = auto
  })
end

function M:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

return UIUpgradeTreasureBoxView
