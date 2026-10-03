local LWArmedUpgradeCityModelView = BaseClass("LWArmedUpgradeCityModelView")
local Hero = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeCityHero")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local BUBBLE_ANCHOR = Vector3.New(0, 5, 0)
local EffectPath = "Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_beizengmen_shengji.prefab"
local model_container_path = "ModelContainer"
local effect_container_path = "EffectContainer"
local bubble_container_path = "BubbleContainer"
local bubble_content_path = "BubbleContainer/BubbleContent"
local normal_bg_path = "BubbleContainer/BubbleContent/NormalBg"
local can_upgrade_bg_path = "BubbleContainer/BubbleContent/CanUpgradeBg"
local bubble_trigger_path = "BubbleContainer/BubbleTrigger"
local bubble_icon_path = "BubbleContainer/BubbleContent/BubbleIcon"
local bubble_icon_j_p_path = "BubbleContainer/BubbleContent/BubbleIconJP"

function LWArmedUpgradeCityModelView:__init()
end

function LWArmedUpgradeCityModelView:OnCreate(go)
  if not IsNull(go) then
    self.gameObject = go
    self.transform = self.gameObject.transform
    self:ComponentDefine()
    self:DataDefine()
  end
end

function LWArmedUpgradeCityModelView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function LWArmedUpgradeCityModelView:DataDefine()
  self.armedUpgradeLevel = 0
  self.curShowMonicaModelAppearanceId = nil
  self.hero = nil
end

function LWArmedUpgradeCityModelView:DataDestroy()
  self.armedUpgradeLevel = nil
  self.curShowMonicaModelAppearanceId = nil
  self.hero = nil
end

function LWArmedUpgradeCityModelView:ComponentDefine()
  self.modelContainer = self.transform:Find(model_container_path)
  self.effectContainer = self.transform:Find(effect_container_path)
  self.bubbleContainer = self.transform:Find(bubble_container_path)
  self.bubble_content = self.transform:Find(bubble_content_path)
  self.normalBg = self.transform:Find(normal_bg_path).gameObject
  self.canUpgradeBg = self.transform:Find(can_upgrade_bg_path).gameObject
  self.bubbleTrigger = self.transform:Find(bubble_trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  self.bubbleIcon = self.transform:Find(bubble_icon_path).gameObject
  self.bubbleIconJP = self.transform:Find(bubble_icon_j_p_path).gameObject
  
  function self.bubbleTrigger.onPointerClick()
    self:OnTriggerClick()
    CommonUtil.FeatureExplorationTrack(FeatureExplorationType.MonicaModel)
  end
end

function LWArmedUpgradeCityModelView:ComponentDestroy()
  self.modelContainer = nil
  self.effectContainer = nil
  self.bubbleContainer = nil
  self.bubble_content = nil
  self.normalBg = nil
  self.canUpgradeBg = nil
  self.bubbleTrigger.onPointerClick = nil
  self.bubbleTrigger = nil
  self.bubbleIcon = nil
  self.bubbleIconJP = nil
  self:RemoveMonicaModel()
  self:ClearEffect()
  self:StopShakeAnim()
end

function LWArmedUpgradeCityModelView:OnUpdate(dt)
  if not self.modelIsLoaded then
    return
  end
  if IsNull(self.monicaModelTrans) then
    return
  end
  if self.hero ~= nil then
    self.hero:Update(dt)
  end
end

function LWArmedUpgradeCityModelView:ReInit(level)
  self.armedUpgradeLevel = level
  if self.bubbleIcon then
    self.bubbleIcon:SetActive(not LuaEntry.Player.JPUser)
  end
  if self.bubbleIconJP then
    self.bubbleIconJP:SetActive(LuaEntry.Player.JPUser)
  end
  self:SpawnMonicaModel()
  self:RefreshModelBubbleShowState()
end

function LWArmedUpgradeCityModelView:SetActive(active)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(active)
  end
end

function LWArmedUpgradeCityModelView:SpawnMonicaModel()
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.armedUpgradeLevel)
  if template then
    if self.curShowMonicaModelAppearanceId == nil or self.curShowMonicaModelAppearanceId ~= template.appearance then
      self.curShowMonicaModelAppearanceId = template.appearance
      self:RemoveMonicaModel()
      local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(self.curShowMonicaModelAppearanceId)
      if appearanceMeta == nil then
        return
      end
      self.monicaModelReq = Resource:InstantiateAsync(appearanceMeta.city_model_path)
      self.monicaModelReq:completed("+", function(req)
        if req.isError then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        self.monicaModelTrans = transform
        self.monicaModelTrans:SetParent(self.modelContainer)
        local size = template.mod_scale
        self.monicaModelTrans:Set_localScale(size, size, size)
        self.monicaModelTrans:Set_localRotation(0, 0, 0)
        self.monicaModelTrans:Set_localPosition(0, 0, 0)
        self.modelTrigger = go:GetComponent(typeof(CS.TouchObjectEventTrigger))
        if not IsNull(self.modelTrigger) then
          function self.modelTrigger.onPointerClick()
            self:OnTriggerClick()
            
            CommonUtil.FeatureExplorationTrack(FeatureExplorationType.MonicaModel)
          end
        end
        self.modelIsLoaded = true
        local heroId = DataCenter.LWArmedUpgradeManager.monicaHeroId
        local gameObject = go
        self.hero = Hero.New({heroId, gameObject})
        local needPlayEffect = self.needPlayEffect
        self.needPlayEffect = false
        if needPlayEffect then
          self:ShowEffect()
        end
      end)
    end
    self:RefreshBubbleContainerPos(template)
  end
end

function LWArmedUpgradeCityModelView:RemoveMonicaModel()
  if self.monicaModelReq then
    self.monicaModelReq:Destroy()
    self.monicaModelReq = nil
  end
  self.monicaModelTrans = nil
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
    self.modelTrigger = nil
  end
  self.modelIsLoaded = false
  if self.hero then
    self.hero:Delete()
    self.hero = nil
  end
end

function LWArmedUpgradeCityModelView:RefreshBubbleContainerPos(template)
  if self.bubbleContainer and table.count(template.bubble_position) == 3 then
    local x = tonumber(template.bubble_position[1])
    local y = tonumber(template.bubble_position[2])
    local z = tonumber(template.bubble_position[3])
    self.bubbleContainer:Set_localPosition(x, y, z)
  end
end

function LWArmedUpgradeCityModelView:RefreshModelBubbleShowState()
  if not SceneUtils.GetIsInCity() then
    return
  end
  local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
  self.normalBg:SetActive(not canLevelUp)
  self.canUpgradeBg:SetActive(canLevelUp)
  if canLevelUp then
    self:PlayShakeAnim()
  else
    self:StopShakeAnim()
    self.bubble_content:Set_localRotation(0, 0, 0, 1)
  end
end

function LWArmedUpgradeCityModelView:PlayShakeAnim()
  self:StopShakeAnim()
  self.shakeTweenSeq = CS.DG.Tweening.DOTween.Sequence()
  self.shakeTweenSeq:Append(self.bubble_content:DOLocalRotate(Vector3.New(0, 0, -8), 0.04):SetEase(CS.DG.Tweening.Ease.InQuad))
  self.shakeTweenSeq:Append(self.bubble_content:DOLocalRotate(Vector3.New(0, 0, 8), 0.08):SetEase(CS.DG.Tweening.Ease.Linear))
  self.shakeTweenSeq:Append(self.bubble_content:DOLocalRotate(Vector3.New(0, 0, -3), 0.08):SetEase(CS.DG.Tweening.Ease.Linear))
  self.shakeTweenSeq:Append(self.bubble_content:DOLocalRotate(Vector3.New(0, 0, 3), 0.08):SetEase(CS.DG.Tweening.Ease.Linear))
  self.shakeTweenSeq:Append(self.bubble_content:DOLocalRotate(Vector3.New(0, 0, 0), 0.04):SetEase(CS.DG.Tweening.Ease.OutQuad))
  self.shakeTweenSeq:AppendInterval(2)
  self.shakeTweenSeq:SetLoops(-1)
end

function LWArmedUpgradeCityModelView:StopShakeAnim()
  if self.shakeTweenSeq then
    self.shakeTweenSeq:Kill()
    self.shakeTweenSeq = nil
  end
end

function LWArmedUpgradeCityModelView:ShowEffect()
  if self.effectReq == nil then
    self.effectReq = Resource:InstantiateAsync(EffectPath)
    self.effectReq:completed("+", function(request)
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
      if self.effectContainer then
        effectTransform:SetParent(self.effectContainer.transform)
        effectTransform:Set_localPosition(0, 0, 0)
        effectTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      end
    end)
  elseif not IsNull(self.levelUpEffectObj) then
    self.levelUpEffectObj:SetActive(false)
    self.levelUpEffectObj:SetActive(true)
  end
end

function LWArmedUpgradeCityModelView:ClearEffect()
  if self.effectReq then
    self.effectReq:Destroy()
    self.effectReq = nil
    self.levelUpEffectObj = nil
  end
end

function LWArmedUpgradeCityModelView:AfterCloseArmedUpgradePanelExcuteLogic(isLevelUp)
  local plotId = 0
  if isLevelUp then
    plotId = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCityModelLevelUpDialogue()
  else
    plotId = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCityModelNoLevelUpDialogue()
  end
  if 0 < plotId then
    local bubbleParams = {}
    bubbleParams.plotId = plotId
    bubbleParams.anchor = BUBBLE_ANCHOR
    bubbleParams.mode = "3DFollow"
    bubbleParams.followTarget = self.modelContainer
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleOnlyId, bubbleParams)
  end
  if isLevelUp then
    if self.modelIsLoaded then
      self:ShowEffect()
    else
      self.needPlayEffect = true
    end
  end
end

function LWArmedUpgradeCityModelView:OnTriggerClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeMain)
end

return LWArmedUpgradeCityModelView
