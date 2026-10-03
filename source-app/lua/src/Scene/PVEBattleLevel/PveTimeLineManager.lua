local PveTimeLineManager = BaseClass("PveTimeLineManager")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local SaveBobScene = require("Scene.SaveBobScene.SaveBobScene")
local PirateShowScene = require("Scene.PirateShowScene.PirateShowScene")
local PvePirateBoomScene = require("Scene.PvePirateBoomScene.PvePirateBoomScene")
local GuideTimeline2Scene = require("Scene.GuideTimeline1Scene.GuideTimeline2Scene")
local GuideTimeline3Scene = require("Scene.GuideTimeline1Scene.GuideTimeline3Scene")

function PveTimeLineManager:__init()
  self.allScene = {}
  self:AddListener()
end

function PveTimeLineManager:__delete()
  self:RemoveListener()
  self.allScene = nil
end

function PveTimeLineManager:AddListener()
  function self.OnTimelineMarker(id)
    self:OnTimelineMarkerSignal(id)
  end
  
  EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
  
  function self.GotoTimeSignal(time)
    self:GotoTime(time)
  end
  
  EventManager:GetInstance():AddListener(EventId.GotoTime, self.GotoTimeSignal)
end

function PveTimeLineManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
  EventManager:GetInstance():RemoveListener(EventId.GotoTime, self.GotoTimeSignal)
end

function PveTimeLineManager:DestroyOneScene(id)
  if self.allScene[id] ~= nil then
    if self.allScene[id].model ~= nil then
      self.allScene[id].model:OnDestroy()
    end
    if self.allScene[id].inst then
      self.allScene[id].inst:Destroy()
    end
    if self.allScene[id].timer then
      self.allScene[id].timer:Stop()
    end
    self.allScene[id] = nil
  end
end

function PveTimeLineManager:RemoveAll()
  if self.allScene then
    for k, v in pairs(self.allScene) do
      self:DestroyOneScene(k)
    end
    self.allScene = {}
  end
end

function PveTimeLineManager:LoadSaveBobScene(pos, state)
  if state == SaveBobSceneState.PlayTimeLine then
    self.useGuideTimelineMarker = true
  else
    DataCenter.GuideManager:DoNext()
  end
  local param = {}
  param.state = state
  param.pos = pos
  if self.allScene[GuideAnimObjectType.SaveBobScene] == nil then
    self.allScene[GuideAnimObjectType.SaveBobScene] = {}
    self.allScene[GuideAnimObjectType.SaveBobScene].param = param
    local request = Resource:InstantiateAsync(UIAssets.SaveBobScene)
    self.allScene[GuideAnimObjectType.SaveBobScene].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = SaveBobScene.New()
      effect:OnCreate(request)
      self.allScene[GuideAnimObjectType.SaveBobScene].model = effect
      effect:ReInit(self.allScene[GuideAnimObjectType.SaveBobScene].param)
    end)
  elseif self.allScene[GuideAnimObjectType.SaveBobScene].model == nil then
    self.allScene[GuideAnimObjectType.SaveBobScene].param = param
  else
    self.allScene[GuideAnimObjectType.SaveBobScene].model:ChangeParam(param)
  end
end

function PveTimeLineManager:RemoveSaveBobScene()
  self:DestroyOneScene(GuideAnimObjectType.SaveBobScene)
end

function PveTimeLineManager:OnTimelineMarkerSignal(id)
  if self:IsUseGuideTimelineMarker() then
    if id == GuideTimeLineShowMarkerType.End then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false})
      self.useGuideTimelineMarker = false
      if self.allScene[GuideAnimObjectType.PirateShowScene] ~= nil then
        self:RemovePirateShowScene()
      end
      if self.allScene[GuideAnimObjectType.GuideTimeline3Scene] ~= nil then
        self:RemoveGuideTimeline3Scene()
      end
      self:CheckDoNext()
    else
      local template = DataCenter.GuideManager:GetCurTemplate()
      if template ~= nil then
        if template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete then
          local para2 = template.para2
          if para2 ~= nil then
            DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
            DataCenter.GuideManager:DoGuide()
          end
        else
          for k, v in ipairs(template.jumptype) do
            if v == GuideJumpType.TimelineJump and template.jumpid ~= 0 then
              DataCenter.GuideManager:SetNoGotoTime(true)
              DataCenter.GuideManager:SetCurGuideId(template.jumpid)
              DataCenter.GuideManager:DoGuide()
            end
          end
        end
      end
    end
  end
end

function PveTimeLineManager:CheckDoNext()
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
    DataCenter.GuideManager:DoNext()
  end
end

function PveTimeLineManager:GotoTime(time)
  for k, v in pairs(self.allScene) do
    if v.model ~= nil and v.model.GotoTime ~= nil then
      v.model:GotoTime(time)
    end
  end
end

function PveTimeLineManager:IsUseGuideTimelineMarker()
  return self.useGuideTimelineMarker
end

function PveTimeLineManager:GetTimeLineModelByType(sceneType)
  if self.allScene[sceneType] ~= nil then
    return self.allScene[sceneType].model
  end
end

function PveTimeLineManager:LoadPirateShowScene()
  self.useGuideTimelineMarker = true
  local param = {}
  param.nameDes = Localization:GetString(GameDialogDefine.SHOW_PIRATE_NAME)
  if self.allScene[GuideAnimObjectType.PirateShowScene] == nil then
    self.allScene[GuideAnimObjectType.PirateShowScene] = {}
    self.allScene[GuideAnimObjectType.PirateShowScene].param = param
    local request = Resource:InstantiateAsync(UIAssets.PirateShowScene)
    self.allScene[GuideAnimObjectType.PirateShowScene].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      self:SetLayerActive(false)
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = PirateShowScene.New()
      effect:OnCreate(request)
      self.allScene[GuideAnimObjectType.PirateShowScene].model = effect
      effect:ReInit(self.allScene[GuideAnimObjectType.PirateShowScene].param)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Pirate_Show, false)
      DataCenter.BattleLevel:SetFogVisible(false)
    end)
  elseif self.allScene[GuideAnimObjectType.PirateShowScene].model == nil then
    self.allScene[GuideAnimObjectType.PirateShowScene].param = param
  else
    self.allScene[GuideAnimObjectType.PirateShowScene].model:ChangeParam(param)
  end
end

function PveTimeLineManager:RemovePirateShowScene()
  DataCenter.BattleLevel:SetFogVisible(true)
  self:SetLayerActive(true)
  self:DestroyOneScene(GuideAnimObjectType.PirateShowScene)
end

function PveTimeLineManager:SetLayerActive(active)
  UIManager:GetInstance():SetLayerActive(UILayer.Scene.Name, active)
  UIManager:GetInstance():SetLayerActive(UILayer.Background.Name, active)
  UIManager:GetInstance():SetLayerActive(UILayer.Normal.Name, active)
end

function PveTimeLineManager:LoadPvePirateBoomScene()
  local param = {}
  local sceneType = GuideAnimObjectType.PvePirateBoomScene
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    self.allScene[sceneType].param = param
    local request = Resource:InstantiateAsync(UIAssets.PvePirateBoomScene)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = ResetPosition
      local effect = PvePirateBoomScene.New()
      effect:OnCreate(request)
      self.allScene[sceneType].model = effect
      effect:ReInit(self.allScene[sceneType].param)
    end)
  elseif self.allScene[sceneType].model == nil then
    self.allScene[sceneType].param = param
  else
    self.allScene[sceneType].model:ChangeParam(param)
  end
end

function PveTimeLineManager:RemovePvePirateBoomScene()
  self:DestroyOneScene(GuideAnimObjectType.PvePirateBoomScene)
end

function PveTimeLineManager:LoadPveThreeBombsScene()
  local sceneType = GuideAnimObjectType.PveThreeBombs
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    local request = Resource:InstantiateAsync(UIAssets.PveThreeBombsScene)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform.position = ResetPosition
    end)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    self:DestroyOneScene(GuideAnimObjectType.PveThreeBombs)
  end, 5)
end

function PveTimeLineManager:LoadPveDestroyHdc1Scene()
  local sceneType = GuideAnimObjectType.PveDestroyHdc1
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    local request = Resource:InstantiateAsync(UIAssets.PveDestroyHdc1Scene)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform.position = ResetPosition
      DataCenter.BattleLevel:SetSceneGameObjectActive("Special/PveShowModelHdc1", false)
    end)
  end
end

function PveTimeLineManager:LoadPveDestroyHdc2Scene()
  local sceneType = GuideAnimObjectType.PveDestroyHdc2
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    self.allScene[sceneType].inst = nil
  end
  local attackGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelTurret/A_build@pt_skin_01/To_unity/Root/main/up/attack/VFX_dapao_attack/attack")
  local targetGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelHdc2")
  if attackGo ~= nil and targetGo ~= nil then
    local attackParticle = attackGo:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    if attackParticle ~= nil then
      attackParticle:Play()
      self.allScene[sceneType].inst = Resource:InstantiateAsync(UIAssets.PveTurretMissile)
      self.allScene[sceneType].inst:completed("+", function(req1)
        if req1.isError then
          return
        end
        local missileGo = req1.gameObject
        local missilePos = attackGo.transform.position
        local targetPos = targetGo.transform.position
        local dir = targetPos - missilePos
        local dirVec = Vector3.New(dir.x, dir.y, dir.z)
        local pos = Vector3.New(targetPos.x, missilePos.y, targetPos.z)
        missileGo:SetActive(true)
        missileGo.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        missileGo.transform.position = missilePos
        missileGo.transform.rotation = Quaternion.LookRotation(dirVec, Vector3.up)
        missileGo.transform:DOMove(pos, 0.2):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
          if self.allScene[sceneType].inst ~= nil then
            self.allScene[sceneType].inst:Destroy()
          end
          self.allScene[sceneType].inst = Resource:InstantiateAsync(UIAssets.PveDestroyHdc2Scene)
          self.allScene[sceneType].inst:completed("+", function(req2)
            if req2.isError then
              return
            end
            local go = req2.gameObject
            go:SetActive(true)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform.position = ResetPosition
            DataCenter.BattleLevel:SetSceneGameObjectActive("Special/PveShowModelHdc2", false)
          end)
        end)
      end)
    end
  end
end

function PveTimeLineManager:LoadPveDestroyHdc3Scene()
  local sceneType = GuideAnimObjectType.PveDestroyHdc3
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    local request = Resource:InstantiateAsync(UIAssets.PveDestroyHdc3Scene)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = ResetPosition
    end)
  end
end

function PveTimeLineManager:LoadPveMissileAttackMainScene()
  local mainGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelMain")
  if mainGo ~= nil then
    local attackGo = mainGo.transform:Find("VFX_daodan_yanshi_timeline").gameObject
    local smokeGo = mainGo.transform:Find("VFX_daodan_yanshi_smoke").gameObject
    attackGo:SetActive(true)
    smokeGo:SetActive(false)
    TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(mainGo) then
        attackGo:SetActive(false)
        smokeGo:SetActive(true)
      end
    end, 6.5)
  end
end

function PveTimeLineManager:LoadPveHdc1AttackScene()
  local attackGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelHdc1/VFX_hdc_gongji")
  if attackGo ~= nil then
    local attackParticle = attackGo:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    if attackParticle ~= nil then
      attackParticle:Play()
    end
  end
end

function PveTimeLineManager:LoadPveHdc2AttackScene()
  local attackGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelHdc2/VFX_hdc_gongji")
  if attackGo ~= nil then
    local attackParticle = attackGo:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    if attackParticle ~= nil then
      attackParticle:Play()
    end
  end
end

function PveTimeLineManager:LoadPveHdc3AttackScene()
  local attackGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelHdc3/VFX_hdc_gongji")
  if attackGo ~= nil then
    local attackParticle = attackGo:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    if attackParticle ~= nil then
      attackParticle:Play()
    end
  end
end

function PveTimeLineManager:LoadPveTurretTurnScene()
  local turnGo = DataCenter.BattleLevel:GetSceneGameObject("Special/PveShowModelTurret/A_build@pt_skin_01/To_unity/Root/main/up/attack")
  if turnGo ~= nil then
    turnGo.transform:DOLocalRotate(Vector3.New(0, 150, 10), 1)
  end
end

function PveTimeLineManager:LoadPveDestroyMountainScene()
  local x = 20
  local y = 8
  local z = 0
  local scale = 0.5
  local duration = 0.5
  local sceneType = GuideAnimObjectType.PveDestroyMountain
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    local req1 = Resource:InstantiateAsync(UIAssets.PveDestroyMountainScene)
    self.allScene[sceneType].inst = req1
    req1:completed("+", function()
      if req1.isError then
        return
      end
      local go = req1.gameObject
      go:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform.position = ResetPosition
      local rockTf = go.transform:Find("VFX_xinshou_tuohuang_shitouposui_zhayao")
      local anim = rockTf:Find("V_xinshou_tuohuang_shitouposui02"):GetComponent(typeof(CS.UnityEngine.Animator))
      local particle1 = rockTf:Find("VFX_posui"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
      local particle2 = rockTf:Find("VFX_dapao_shitou_hit"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
      local req2 = Resource:InstantiateAsync(UIAssets.PveSkyMissile)
      req2:completed("+", function()
        if req2.isError then
          return
        end
        local startPos = rockTf.position + Vector3.New(x, y, z)
        local endPos = rockTf.position
        local dir = endPos - startPos
        local dirVec = Vector3.New(dir.x, dir.y, dir.z)
        local missileGo = req2.gameObject
        missileGo:SetActive(true)
        missileGo.name = "Missile"
        missileGo.transform:Set_localScale(scale, scale, scale)
        missileGo.transform.position = startPos
        missileGo.transform.rotation = Quaternion.LookRotation(dirVec, Vector3.up)
        missileGo.transform:DOMove(endPos, duration):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
          if not IsNull(req1.gameObject) then
            anim:Play("V_xinshou_tuohuang_shitouposui_anim_zhayao", 0, 0)
            particle1:Play()
            particle2:Play()
          end
          if not IsNull(req2.gameObject) then
            req2:Destroy()
          end
        end)
      end)
    end)
  end
end

function PveTimeLineManager:LoadPveMissileInSkyScene(para2)
  local strs = string.split(para2, "|")
  local interval = tonumber(strs[1])
  local duration = tonumber(strs[2])
  local scale = tonumber(strs[3])
  local x = tonumber(strs[4])
  local xRange = {
    -x,
    x
  }
  local ys = string.split(strs[5], ";")
  local yRange = {
    tonumber(ys[1]),
    tonumber(ys[2])
  }
  local zs = string.split(strs[6], ";")
  local zRange = {
    tonumber(zs[1]),
    tonumber(zs[2]),
    tonumber(zs[3]),
    tonumber(zs[4])
  }
  local sceneType = GuideAnimObjectType.PveMissileInSky
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
  end
  local sc = self.allScene[sceneType]
  if sc.timer then
    sc.timer:Stop()
  end
  sc.index = 1
  sc.reqDict = {}
  sc.timer = TimerManager:GetInstance():GetTimer(interval, function()
    local player = DataCenter.BattleLevel:GetPlayer()
    if player == nil then
      return
    end
    local request = Resource:InstantiateAsync(UIAssets.PveSkyMissile)
    request:completed("+", function()
      if request.isError then
        return
      end
      local startPos = player:GetPosition() + Vector3.New(xRange[2], math.random(yRange[1], yRange[2]), math.random(zRange[1], zRange[2]))
      local endPos = player:GetPosition() + Vector3.New(xRange[1], math.random(yRange[1], yRange[2]), math.random(zRange[3], zRange[4]))
      local dir = endPos - startPos
      local go = request.gameObject
      go:SetActive(true)
      go.transform:Set_localScale(scale, scale, scale)
      go.transform.position = startPos
      go.transform.rotation = Quaternion.LookRotation(dir, Vector3.up)
      go.transform:DOMove(endPos, duration):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
        if not IsNull(request.gameObject) then
          request:Destroy()
        end
      end)
    end)
    sc.reqDict[sc.index] = request
    sc.index = sc.index + 1
  end, nil, false, false, false)
  sc.timer:Start()
  sc.inst = {}
  
  function sc.inst.Destroy()
    for _, req in pairs(sc.reqDict) do
      req:Destroy()
    end
  end
end

function PveTimeLineManager:LoadGuideTimeline2Scene(pos, hideTriggerList)
  self.useGuideTimelineMarker = true
  local param = {}
  param.pos = pos
  param.hideTriggerList = hideTriggerList
  if self.allScene[GuideAnimObjectType.GuideTimeline2Scene] == nil then
    self.allScene[GuideAnimObjectType.GuideTimeline2Scene] = {}
    self.allScene[GuideAnimObjectType.GuideTimeline2Scene].param = param
    local request = Resource:InstantiateAsync(UIAssets.GuideTimeline2Scene)
    self.allScene[GuideAnimObjectType.GuideTimeline2Scene].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = GuideTimeline2Scene.New()
      effect:OnCreate(request)
      self.allScene[GuideAnimObjectType.GuideTimeline2Scene].model = effect
      effect:ReInit(self.allScene[GuideAnimObjectType.GuideTimeline2Scene].param)
    end)
  elseif self.allScene[GuideAnimObjectType.GuideTimeline2Scene].model == nil then
    self.allScene[GuideAnimObjectType.GuideTimeline2Scene].param = param
  else
    self.allScene[GuideAnimObjectType.GuideTimeline2Scene].model:ChangeParam(param)
  end
end

function PveTimeLineManager:RemoveGuideTimeline2Scene()
  self.useGuideTimelineMarker = false
  self:DestroyOneScene(GuideAnimObjectType.GuideTimeline2Scene)
end

function PveTimeLineManager:LoadPveMorganAttackScene()
end

function PveTimeLineManager:LoadPveHdcEscapeScene()
  local sceneType = GuideAnimObjectType.PveHdcEscape
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    local request = Resource:InstantiateAsync(UIAssets.PveHdcEscapeScene)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = ResetPosition
      DataCenter.BattleLevel:SetSceneGameObjectActive("Special/PveShowModelHdc3", false)
      self:DestroyOneScene(GuideAnimObjectType.PveDestroyHdc3)
    end)
  end
end

function PveTimeLineManager:LoadGuideTimeline3Scene(pos)
  self.useGuideTimelineMarker = true
  local param = {}
  param.pos = pos
  local sceneType = GuideAnimObjectType.GuideTimeline3Scene
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    self.allScene[sceneType].param = param
    local request = Resource:InstantiateAsync(UIAssets.GuideTimeline3Scene)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = GuideTimeline3Scene.New()
      effect:OnCreate(request)
      self.allScene[sceneType].model = effect
      effect:ReInit(self.allScene[sceneType].param)
    end)
  elseif self.allScene[sceneType].model == nil then
    self.allScene[sceneType].param = param
  else
    self.allScene[sceneType].model:ChangeParam(param)
  end
end

function PveTimeLineManager:RemoveGuideTimeline3Scene()
  self:DestroyOneScene(GuideAnimObjectType.GuideTimeline3Scene)
end

function PveTimeLineManager:LoadPveHdcEscape31014Scene()
  local sceneType = GuideAnimObjectType.PveHdcEscape31014
  if self.allScene[sceneType] == nil then
    self.allScene[sceneType] = {}
    local request = Resource:InstantiateAsync(UIAssets.PveHdcEscapeScene31014)
    self.allScene[sceneType].inst = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = ResetPosition
      DataCenter.BattleLevel:SetSceneGameObjectActive("Special/PveShowModelHdc", false)
    end)
  end
end

return PveTimeLineManager
