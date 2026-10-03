local UILWArmedUpgradeMainView = BaseClass("UILWArmedUpgradeMainView", UIBaseView)
local UIModelView = require("Framework.UI.Component.UIModelView")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local ModelContainerPath = "char"
local LevelUpEffectPath = "Assets/Main/Prefabs/ArmedUpgrade/Eff_Monica_Up/Eff_Monica_zhanshi_common_shengji.prefab"

function UILWArmedUpgradeMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWArmedUpgradeMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWArmedUpgradeMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRTSceneBg = self.viewSkin:AddComponent(self, UIModelView, 1)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgLevelProgressBg = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.imgItemIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textItemCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textItemTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnUse = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.textBtnUse = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.imgLevelProgressFill = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textTips:SetLocalText("armed_upgrade_progress")
  self.textItemTip:SetLocalText("armed_upgrade_intro")
  local w, h = self.imgLevelProgressBg:GetSizeDeltaXY()
  self.maxLevelProgressWidth = w
end

function UILWArmedUpgradeMainView:ComponentDestroy()
  self.viewSkin = nil
  self.compRTSceneBg = nil
  self.textTips = nil
  self.imgLevelProgressBg = nil
  self.compItemContent = nil
  self.imgItemIcon = nil
  self.textItemCount = nil
  self.textItemTip = nil
  self.btnUse = nil
  self.textBtnUse = nil
  self.btnBack = nil
  self.imgLevelProgressFill = nil
end

function UILWArmedUpgradeMainView:DataDefine()
  self.canLevelUp = false
  self.curArmedUpgradeLevel = nil
  self.isLevelUpIng = false
  self.modelAni = nil
  self.heroModelObj = nil
  self.levelUpEffectContainer = nil
  self.levelUpEffectReq = nil
  self.effectReqList = nil
  self.cacheNodePointList = {}
  self.ctrl:SetView(self)
  self.ctrl:ResetIsUpdateFlag()
end

function UILWArmedUpgradeMainView:DataDestroy()
  self.canLevelUp = nil
  self.curArmedUpgradeLevel = nil
  self.isLevelUpIng = nil
  self.modelAni = nil
  self.heroModelObj = nil
  self.levelUpEffectContainer = nil
  self:ResetSceneSomeNodesShowState()
  self:StopProgressAnim()
  self:ClearDelay()
  self:ClearLevelUpEffect()
  self:ClearHeroBodyPartEffect()
end

function UILWArmedUpgradeMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshCostView)
  self:AddUIListener(EventId.ArmedUpgradeLevelChanged, self.OnArmedUpgradeLevelChanged)
end

function UILWArmedUpgradeMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshCostView)
  self:RemoveUIListener(EventId.ArmedUpgradeLevelChanged, self.OnArmedUpgradeLevelChanged)
  base.OnRemoveListener(self)
end

function UILWArmedUpgradeMainView:OnArmedUpgradeLevelChanged(isMaxLevel)
  local oldLevel = self.curArmedUpgradeLevel
  self.curArmedUpgradeLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
  self:RefreshProgressView(true)
  self:RefreshCostView()
  self:PlayLevelUpAnim(oldLevel)
  self:ShowLevelUpEffect()
  self:RefreshSceneSomeNodesShowState()
  self:ShowHeroBodyPartEffect()
  self:TryPlayUpgradeGuide()
  self:TryPlayUpgradeSound()
end

function UILWArmedUpgradeMainView:ReInit()
  local playerUid = LuaEntry.Player.uid
  PostEventLog.Track(PostEventLog.Defines.OpenArmedUpgradePanel, {uid = playerUid})
  self:ClearDelay()
  self.curArmedUpgradeLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
  self:RefreshRTSceneBg()
  self:RefreshCostView()
  self:RefreshProgressView()
end

function UILWArmedUpgradeMainView:RefreshCostView()
  local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
  self.canLevelUp = canLevelUp
  if levelUpCondition ~= nil then
    local needItemId = levelUpCondition[1]
    local needItemCount = levelUpCondition[2]
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(needItemId)
    local curItemCount = DataCenter.ItemData:GetItemCount(needItemId)
    self.imgItemIcon:LoadSpriteAuto(iconPath)
    local costStr = ""
    local btnStr = ""
    if needItemCount <= curItemCount then
      costStr = string.format("<color=#FFFFFF>%s</color>/<color=#FFFFFF>%s</color>", curItemCount, needItemCount)
      btnStr = "armed_upgrade_use"
    else
      costStr = string.format("<color=#F97077>%s</color>/<color=#FFFFFF>%s</color>", curItemCount, needItemCount)
      btnStr = "armed_upgrade_goto"
    end
    self.textItemCount:SetText(costStr)
    self.textBtnUse:SetLocalText(btnStr)
  else
    self:ReachMaxLevel()
  end
end

function UILWArmedUpgradeMainView:ReachMaxLevel()
  self.compItemContent:SetActive(false)
  self.btnUse:SetActive(false)
  self.textItemTip:SetLocalText("armed_upgrade_max")
end

function UILWArmedUpgradeMainView:RefreshProgressView(anim)
  self:StopProgressAnim()
  if anim then
    self:PlayProgressAnim()
  else
    local curLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
    local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
    local value = Mathf.Clamp01(curLevel / maxLevel)
    local targetValueX = self.maxLevelProgressWidth * value
    local sizeDelta = self.imgLevelProgressFill:GetSizeDelta()
    sizeDelta.x = targetValueX
    self.imgLevelProgressFill:SetSizeDelta(sizeDelta)
  end
end

function UILWArmedUpgradeMainView:PlayProgressAnim()
  local curLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
  local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
  local curValueX, curValueY = self.imgLevelProgressFill:GetSizeDeltaXY()
  local targetValueX = self.maxLevelProgressWidth * Mathf.Clamp01(curLevel / maxLevel)
  self.progressSeq = DOTween.To(function(x)
    local sizeDelta = self.imgLevelProgressFill:GetSizeDelta()
    sizeDelta.x = x
    self.imgLevelProgressFill:SetSizeDelta(sizeDelta)
  end, curValueX, targetValueX, 0.3):SetEase(CS.DG.Tweening.Ease.OutCubic)
end

function UILWArmedUpgradeMainView:StopProgressAnim()
  if self.progressSeq then
    self.progressSeq:Kill()
    self.progressSeq = nil
  end
end

function UILWArmedUpgradeMainView:RefreshRTSceneBg()
  self.compRTSceneBg:SetEnable(false)
  self.compRTSceneBg:Clear()
  self.compRTSceneBg:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.compRTSceneBg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.compRTSceneBg:SetQuality(true, 25)
  self.compRTSceneBg:ReInit(UIAssets.ArmedUpgradeScenePath)
  self.compRTSceneBg:SetOnLoadSceneHandler(function()
    self.levelUpEffectContainer = self.compRTSceneBg:GetSceneNode(ModelContainerPath)
    if self.levelUpEffectContainer and not IsNull(self.levelUpEffectObj) then
      local effectTransform = self.levelUpEffectObj.transform
      effectTransform:SetParent(self.levelUpEffectContainer.transform)
      effectTransform:Set_localPosition(0, 0, 0)
    end
    self:RefreshModelShow()
  end)
end

function UILWArmedUpgradeMainView:RefreshModelShow()
  local modelPath = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k7")
  if LuaEntry.Player.JPUser then
    modelPath = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k10")
  end
  if not string.IsNullOrEmpty(modelPath) then
    self.compRTSceneBg:ChangeNodeChild(ModelContainerPath, modelPath, function(success, gameObj)
      if success then
        self.heroModelObj = gameObj
        self.modelAni = self.compRTSceneBg:GetAniCpt(ModelContainerPath)
        if not IsNull(self.modelAni) then
          local aniName = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeAnimationName()
          self.modelAni:Play(aniName)
        end
      end
    end)
    self:RefreshSceneSomeNodesShowState()
  end
end

function UILWArmedUpgradeMainView:RefreshSceneSomeNodesShowState()
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.curArmedUpgradeLevel)
  if template ~= nil then
    local count = table.count(template.delet_scene_model)
    for i = 1, count do
      local nodePath = template.delet_scene_model[i]
      local targetNode = self.compRTSceneBg:GetSceneNode(nodePath)
      if not IsNull(targetNode) then
        targetNode:SetActive(false)
        table.insert(self.cacheNodePointList, targetNode)
      end
    end
  end
end

function UILWArmedUpgradeMainView:ResetSceneSomeNodesShowState()
  for i, node in ipairs(self.cacheNodePointList) do
    if not IsNull(node) then
      node:SetActive(true)
    end
  end
  self.cacheNodePointList = nil
end

function UILWArmedUpgradeMainView:PlayLevelUpAnim(level)
  if self.modelAni then
    local levelAniName = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeAnimationName(level, false)
    self.modelAni:Play(levelAniName)
    local needTime = self.modelAni:GetClipLength(levelAniName)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.modelAni then
        self.isLevelUpIng = false
        local idleAniName = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeAnimationName()
        self.modelAni:Play(idleAniName)
      end
    end, needTime)
  else
    self.isLevelUpIng = false
  end
end

function UILWArmedUpgradeMainView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILWArmedUpgradeMainView:ShowLevelUpEffect()
  if self.levelUpEffectReq == nil then
    self.levelUpEffectReq = Resource:InstantiateAsync(LevelUpEffectPath)
    self.levelUpEffectReq:completed("+", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go:SetActive(true)
      local effectTransform = go.transform
      self.levelUpEffectObj = go
      if self.levelUpEffectContainer then
        effectTransform:SetParent(self.levelUpEffectContainer.transform)
        effectTransform:Set_localPosition(0, 0, 0)
      end
    end)
  elseif not IsNull(self.levelUpEffectObj) then
    self.levelUpEffectObj:SetActive(false)
    self.levelUpEffectObj:SetActive(true)
  end
end

function UILWArmedUpgradeMainView:ClearLevelUpEffect()
  if self.levelUpEffectReq then
    self.levelUpEffectReq:Destroy()
    self.levelUpEffectReq = nil
    self.levelUpEffectObj = nil
  end
end

function UILWArmedUpgradeMainView:ShowHeroBodyPartEffect()
  self:ClearHeroBodyPartEffect()
  if IsNull(self.heroModelObj) then
    return
  end
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.curArmedUpgradeLevel)
  if template then
    local effectPathCount = table.count(template.upgrade_vfx_path)
    local effectNodeCount = table.count(template.upgrade_vfx_point)
    if effectNodeCount == 0 or effectPathCount == 0 or effectPathCount ~= effectNodeCount then
      return
    end
    if self.effectReqList == nil then
      self.effectReqList = {}
    end
    for i = 1, effectPathCount do
      local effectPath = template.upgrade_vfx_path[i]
      local effectNodePath = template.upgrade_vfx_point[i]
      local effectTargetNodeTransform = self.heroModelObj.transform:Find(effectNodePath)
      if not IsNull(effectTargetNodeTransform) then
        self.effectReqList[i] = Resource:InstantiateAsync(effectPath)
        self.effectReqList[i]:completed("+", function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          if IsNull(go) then
            return
          end
          go:SetActive(true)
          local effectTransform = go.transform
          effectTransform:SetParent(effectTargetNodeTransform)
          effectTransform:Set_localPosition(0, 0, 0)
          effectTransform:Set_localScale(1, 1, 1)
          effectTransform:Set_localRotation(0, 0, 0, 1)
        end)
      end
    end
  end
end

function UILWArmedUpgradeMainView:ClearHeroBodyPartEffect()
  if self.effectReqList then
    for _, req in pairs(self.effectReqList) do
      req:Destroy()
    end
  end
  self.effectReqList = nil
end

function UILWArmedUpgradeMainView:TryPlayUpgradeGuide()
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.curArmedUpgradeLevel)
  if template and template.upgrade_guide > 0 then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(template.upgrade_guide)
  end
end

function UILWArmedUpgradeMainView:TryPlayUpgradeSound()
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.curArmedUpgradeLevel)
  if template and template.upgrade_sound > 0 then
    DataCenter.LWSoundManager:PlaySound(template.upgrade_sound, false)
  end
end

function UILWArmedUpgradeMainView:OnBtnUseClick()
  if self.isLevelUpIng then
    return
  end
  if self.canLevelUp then
    self.isLevelUpIng = true
    self.ctrl:SetIsUpdateFlag()
    local targetLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel + 1
    SFSNetwork.SendMessage(MsgDefines.ArmedUpgradeLevelUp, targetLevel)
    local monopolyStageId = 0
    if DataCenter.MonopolyManager.player then
      monopolyStageId = DataCenter.MonopolyManager.player.curId
    end
    local playerUid = LuaEntry.Player.uid
    PostEventLog.Track(PostEventLog.Defines.ArmedUpgradeBtnClick, {
      uid = playerUid,
      stageid = tostring(monopolyStageId),
      level = targetLevel
    })
  else
    if CS.SceneManager:IsInPVE() then
      self.ctrl:CloseSelf()
      return
    end
    if DataCenter.LWCivilizationSparkExtend:UILWArmedUpgradeMainView_needTryOpenWarning() then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArmedUpgradeMain, {anim = false})
      GoToUtil.CloseAllWindows()
      self:TryOpenWarning(true)
      return
    end
    local data = DataCenter.MonopolyManager:GetCurData()
    if data ~= nil then
      GoToUtil.GotoCityPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, 0.5, nil)
    end
    self.ctrl:CloseSelf()
  end
end

function UILWArmedUpgradeMainView:TryOpenWarning(guide)
  local canShowWarningPop, isFirstShow = DataCenter.LWArmedUpgradeManager:CheckShowArmedUpgradePop()
  if not isFirstShow then
    if guide then
      DataCenter.LWCivilizationSparkExtend:UILWArmedUpgradeMainView_tryOpenWarningNotIsFirstShow()
    end
    return
  end
  if canShowWarningPop then
    if DataCenter.LWBeginnerDirectorManager:GetCurCityEventID() ~= -1 then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.MainUIBottomHide)
    if LuaEntry.Player.JPUser then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeBannerWarningView_JP, {anim = false}, {guide = guide})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeBannerWarning, {anim = false}, {guide = guide})
    end
  end
end

function UILWArmedUpgradeMainView:OnBtnBackClick()
  if CS.SceneManager:IsInPVE() then
    self.ctrl:CloseSelf()
    return
  end
  local isUpdate = self.ctrl.isUpgraded
  self.ctrl:CloseSelf()
  DataCenter.LWArmedUpgradeManager:AfterCloseArmedUpgradePanelExcuteLogic(isUpdate)
  self:TryOpenWarning()
end

return UILWArmedUpgradeMainView
