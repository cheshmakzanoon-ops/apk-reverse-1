local TriggerPointUnlockRewardType = require("DataCenter.CityTriggerPoint.TriggerPointUnlockRewardType")
local TriggerPointGameObject = BaseClass("TriggerPointGameObject")
local Resource = CS.GameEntry.Resource
local TypeOfSuperTextMesh = typeof(CS.SuperTextMesh)
local TypeOfSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
local Const = require("Scene.CityPioneer.Const")
local ResTypeCount = 5
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshPro)
local Data = CS.GameEntry.Data

function TriggerPointGameObject:__init()
end

function TriggerPointGameObject:__delete()
end

function TriggerPointGameObject:Create(data)
  self.data = data
  if data:IsWeaponType() then
    if self.inst == nil then
      self.inst = Resource:InstantiateAsync("Assets/Main/Prefabs/CityScene/CityTriggerWeapon.prefab")
      self.inst:completed("+", function()
        local transform = self.inst.gameObject.transform
        local showPos = self.data.pos or self.data:GetShowPos()
        if showPos then
          local p = SceneUtils.TileToWorld(showPos)
          transform:Set_position(p.x, p.y, p.z)
          local shanshan = transform:Find("VFX_gaotou_shanshan")
          if shanshan then
            self.shanParticle = shanshan:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
            self.shanParticle.gameObject:SetActive(false)
          end
        end
        local citySpaceManTrigger = transform:GetComponent(typeof(CS.CitySpaceManTrigger))
        citySpaceManTrigger.resType = Const.CityCutResType.Weapon
        citySpaceManTrigger.ObjectId = data:GetTemplateId()
        self:RefreshShow()
      end)
    end
  elseif self.textInst == nil then
    self.textInst = Resource:InstantiateAsync("Assets/Main/Prefabs/CityScene/CityTriggerText.prefab")
    self.textInst:completed("+", function(req)
      local transform = req.gameObject.transform
      local showPos = self.data:GetShowPos()
      if showPos then
        local p = SceneUtils.TileToWorld(showPos)
        transform:Set_position(p.x, p.y, p.z)
      else
        local t = 0
      end
      self.numItem = {}
      for i = 1, ResTypeCount do
        local lineNode = transform:Find("face_camera/Line" .. i)
        self.numItem[#self.numItem + 1] = {
          node = lineNode.gameObject,
          numText = lineNode:GetComponentInChildren(UnityTextMeshPro, true),
          iconSpr = lineNode:GetComponentInChildren(TypeOfSpriteRenderer, true)
        }
      end
      self.debugText = transform:Find("face_camera/debug"):GetComponent(TypeOfSuperTextMesh)
      self:RefreshText()
    end)
    self.triggerArea = Resource:InstantiateAsync("Assets/_Art/Models/Environment/Interactive/Place/prefab/O_env_place.prefab")
    self.triggerArea:completed("+", function(req)
      local transform = req.gameObject.transform
      local showPos = self.data.pos or self.data:GetShowPos()
      if showPos then
        local p = SceneUtils.TileToWorld(showPos)
        p.y = p.y + 0.1
        transform:Set_position(p.x, p.y, p.z)
      else
        print("no showpos!!!")
      end
      self.triggerAni = transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    end)
  end
  if self.data:IsNeedShowArrow() then
    local showPos = self.data.pos or self.data:GetShowPos()
    local p = SceneUtils.TileToWorld(showPos)
    DataCenter.CityPioneerYellowArrowManager:AddOneArrow(p)
  end
end

function TriggerPointGameObject:IsWeaponType()
  return self.data:IsWeaponType()
end

function TriggerPointGameObject:PlayParticle()
  if self.shanParticle then
    self.shanParticle.gameObject:SetActive(true)
    self.shanParticle:Simulate(0)
    self.shanParticle:Play()
  end
end

function TriggerPointGameObject:ShowDebugObj(show)
  if show then
    if self.debugObjs == nil then
      self.debugObjs = {}
      for i, v in ipairs(self.data:GetPointArray()) do
        local go = CS.UnityEngine.GameObject.CreatePrimitive(CS.UnityEngine.PrimitiveType.Cube)
        go.transform.position = SceneUtils.TileToWorld(v)
        go.transform.localScale = Vector3.New(1.7, 0.5, 1.7)
        self.debugObjs[#self.debugObjs + 1] = go
        CS.UnityEngine.GameObject.Destroy(go:GetComponent(typeof(CS.UnityEngine.BoxCollider)))
      end
    end
  elseif self.debugObjs ~= nil then
    for i, o in ipairs(self.debugObjs) do
      CS.UnityEngine.GameObject.Destroy(o)
    end
    self.debugObjs = nil
  end
end

function TriggerPointGameObject:GetTypePosition(type)
  local i = self:GetTypeIndex(type)
  if i and self.numItem[i] ~= nil then
    local item = self.numItem[i]
    if item.iconSpr then
      return Vector3.New(item.iconSpr.gameObject.transform:Get_position())
    end
  end
  return Vector3.New(self.textInst.gameObject.transform:Get_position())
end

function TriggerPointGameObject:PlayScaleUp()
  if self.triggerAni and not self.triggerAni:IsPlaying("xiaoshi") then
    self.triggerAni:Play("fangda")
  end
end

function TriggerPointGameObject:PlayScaleDown()
  if self.triggerAni and not self.triggerAni:IsPlaying("xiaoshi") then
    self.triggerAni:Play("suoxiao")
  end
end

function TriggerPointGameObject:PlayTextHideAni()
  if self.textInst == nil then
    return
  end
  local faceCameraNode = self.textInst.gameObject.transform:Find("face_camera")
  if faceCameraNode ~= nil then
    DOTween.Kill(faceCameraNode.transform)
    faceCameraNode.transform:DOScale(Vector3.zero, 0.5):OnComplete(function()
      self.textInst.gameObject:SetActive(false)
    end):SetEase(CS.DG.Tweening.Ease.InCubic)
  else
    self.textInst.gameObject:SetActive(false)
  end
end

function TriggerPointGameObject:TriggerOK()
  self:PlayTextHideAni()
  if self.triggerAni then
    self.triggerAni:Play("xiaoshi")
  end
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayTimer = nil
    if self.triggerArea then
      self.triggerArea.gameObject:SetActive(false)
    end
  end, 1)
  if self:IsWeaponType() then
    self.inst.gameObject:SetActive(false)
  end
  local showPos = self.data:GetShowPos()
  if showPos then
    local p = SceneUtils.TileToWorld(showPos)
    DataCenter.CityPioneerYellowArrowManager:RemoveOneArrowByPos(p)
  end
end

function TriggerPointGameObject:RefreshText(aniIndex)
  if self.textInst == nil or not self.textInst.isDone then
    return
  end
  for i = 1, ResTypeCount do
    if self.numItem[i] then
      self.numItem[i].node:SetActive(false)
    end
  end
  local i = 1
  for t, n in pairs(self.data:GetAllNeedRes()) do
    if self.numItem[i] ~= nil then
      local item = self.numItem[i]
      item.node:SetActive(true)
      local text = string.format("%d<size=50%%>/%d", self.data:GetGiveRes(t), n)
      item.numText:SetText(text)
      local pos = item.numText.transform.localPosition
      local imagePic = Const.ResTypeIconPath[Const.UnlockToResType[t]] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
      item.iconSpr:LoadSprite(imagePic)
    end
    i = i + 1
  end
end

function TriggerPointGameObject:GetTypeIndex(type)
  local i = 1
  for t, need in pairs(self.data:GetAllNeedRes()) do
    local resType = Const.UnlockToResType[t]
    if resType == type then
      return i
    end
    i = i + 1
  end
  return nil
end

function TriggerPointGameObject:AniItem(type)
  local aniIndex = self:GetTypeIndex(type)
  if aniIndex == nil then
    return
  end
  local aniTf = self.numItem[aniIndex].node.transform
  DOTween.Kill(aniTf)
  aniTf:Set_localScale(1, 1, 1)
  aniTf:DOScale(Vector3.New(1.15, 1.15, 1), 0.15):OnComplete(function()
    aniTf:DOScale(Vector3.one, 0.15)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

function TriggerPointGameObject:SetPositionForBuilding(transform, buildId)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
  if buildTemplate.tileX == 2 then
    pos = pos + Vector3.New(-1, 0, -1)
  elseif buildTemplate.tileX == 3 then
    pos = pos + Vector3.New(-2, 0, -2)
  end
  transform:Set_position(pos.x, pos.y, pos.z)
end

function TriggerPointGameObject:Destroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.inst ~= nil then
    self.inst:Destroy()
    self.inst = nil
  end
  if self.textInst ~= nil then
    self.textInst:Destroy()
    self.textInst = nil
  end
  if self.triggerArea ~= nil then
    self.triggerArea:Destroy()
    self.triggerArea = nil
  end
  if self.giveObj ~= nil then
    self.giveObj:Destroy()
    self.giveObj = nil
  end
  if self.debugObjs ~= nil then
    for i, o in ipairs(self.debugObjs) do
      CS.UnityEngine.GameObject.Destroy(o)
    end
    self.debugObjs = nil
  end
  self.shanParticle = nil
end

function TriggerPointGameObject:RefreshShow()
  if self.data:IsFull() or DataCenter.GuideManager:IsPrologueCanAttack() then
    self:PlayParticle()
  end
end

local CityTriggerPointManager = BaseClass("CityTriggerPointManager", Singleton)

function CityTriggerPointManager:__init()
  self.triggerObjs = {}
  self.collectTimer = nil
  self.cheatOk = false
  self.ok_triggers = {}
end

function CityTriggerPointManager:__delete()
  self:RemoveAll()
end

function CityTriggerPointManager:Startup()
end

function CityTriggerPointManager:ShowOneTrigger(data)
  if data ~= nil then
    local triggerId = data:GetTemplateId()
    local obj = self:GetTriggerObject(triggerId)
    if obj == nil then
      obj = TriggerPointGameObject.New()
      obj:Create(data)
      self.triggerObjs[triggerId] = obj
    else
      obj:RefreshShow()
    end
  end
end

function CityTriggerPointManager:GetTriggerObject(id)
  return self.triggerObjs[id]
end

function CityTriggerPointManager:UnLockNewArea(poineerId)
  local guideName = tostring(poineerId)
  DataCenter.GuideManager:SendLogToNet(guideName, StatTTType.Special)
  CityPioneerFog:GetInstance():UnlockAreaFog(poineerId)
  local pointDataMgr = DataCenter.CityTriggerPointDataManager
  local nextId = GetTableData(TableName.APS_SINGLEMAP_PIONEER, poineerId, "NextID")
  local tabNextId = string.split_ii_array(nextId, ";")
  for _, nextId in pairs(tabNextId) do
    pointDataMgr:AddOneTrigger(nextId)
  end
  local noviceboot = GetTableData(TableName.APS_SINGLEMAP_PIONEER, poineerId, "Noviceboot")
  if not string.IsNullOrEmpty(noviceboot) then
    if DataCenter.CityPioneerManager:IsBeforePrologue() then
      DataCenter.GuideManager:SetCurGuideId(noviceboot)
      DataCenter.GuideManager:DoGuide()
    end
  else
    DataCenter.GuideManager:SetCurGuideId(GuideEndId)
    DataCenter.GuideManager:DoGuide()
  end
end

function CityTriggerPointManager:DoTriggerAndSave(templateId)
  if not self:DoTriggerOK(templateId) then
    return
  end
  local triggerObj = self.triggerObjs[templateId]
  if triggerObj then
    triggerObj:TriggerOK()
  end
  DataCenter.CityTriggerPointDataManager:RemoveOneTrigger(templateId)
  if not table.hasvalue(self.ok_triggers) then
    self.ok_triggers[#self.ok_triggers + 1] = templateId
  end
  CityPioneerArchive:GetInstance():Save()
end

function CityTriggerPointManager:DoTriggerOK(templateId)
  local template = DataCenter.CityTriggerPointTemplateManager:GetTemplate(templateId)
  if not template then
    print("not found trigger!")
    return false
  end
  self:UnLockNewArea(templateId)
  if template.unlockRewardType == TriggerPointUnlockRewardType.Building then
    self:UnlockBuilding(template.unlockRewardPara)
  elseif template.unlockRewardType == TriggerPointUnlockRewardType.Fog then
    self:UnlockFog(template.unlockRewardPara)
  end
  return true
end

function CityTriggerPointManager:UnlockBuilding(buildItemId)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildItemId)
  if buildData == nil then
    Logger.LogError("UnlockBuilding not exist " .. tostring(buildItemId))
    return
  end
  local param = {}
  param.uuid = tostring(buildData.uuid)
  param.gold = BuildUpgradeUseGoldType.No
  param.upLevel = 1
  param.clientParam = ""
  param.truckId = 0
  param.pathTime = 0
  param.robotUuid = 0
  SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
end

function CityTriggerPointManager:UnlockFog(fogIds)
  CityPioneerFog:GetInstance():UnlockFog(fogIds)
end

function CityTriggerPointManager:ShowTriggerPoint(show)
  for id, o in pairs(self.triggerObjs) do
    o:ShowDebugObj(show)
  end
  if show then
    if self.debugGrid == nil then
      self.debugGrid = Resource:InstantiateAsync("Assets/Main/Prefabs/CityScene/DebugGrid.prefab")
    end
  elseif self.debugGrid ~= nil then
    self.debugGrid:Destroy()
    self.debugGrid = nil
  end
end

function CityTriggerPointManager:RemoveAll()
  for id, o in pairs(self.triggerObjs) do
    o:Destroy()
  end
  self.triggerObjs = {}
  if self.debugGrid ~= nil then
    self.debugGrid:Destroy()
    self.debugGrid = nil
  end
  if self.collectTimer ~= nil then
    self.collectTimer:Stop()
    self.collectTimer = nil
  end
  self.ok_triggers = {}
end

function CityTriggerPointManager:ToggleCheat()
  self.cheatOk = not self.cheatOk
end

function CityTriggerPointManager:IsCityCheatOk()
  return self.cheatOk
end

function CityTriggerPointManager:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  for id, data in pairs(self.triggersData) do
    archive:SetTrigger(id, data:GetAllGiveRes())
  end
end

function CityTriggerPointManager:Init()
  local archive = CityPioneerArchive:GetInstance()
  if archive.load_data ~= nil and archive.load_data.ok_triggers ~= nil then
    self.ok_triggers = archive.load_data.ok_triggers
  end
end

return CityTriggerPointManager
