local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local AllianceSkillReinforcementHudLogic = BaseClass("AllianceSkillReinforcementHudLogic", base)

function AllianceSkillReinforcementHudLogic:ComponentDefine()
end

function AllianceSkillReinforcementHudLogic:ComponentDestroy()
end

function AllianceSkillReinforcementHudLogic:DataDefine()
end

function AllianceSkillReinforcementHudLogic:DataDestroy()
end

function AllianceSkillReinforcementHudLogic:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceSkillReinforcementHudLogic:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceSkillReinforcementHudLogic:__init(gameObject)
  base.__init(self, gameObject)
  self.compHud = nil
  self.skillRequest = nil
  self.skillEndRequest = nil
  self.goEffects = nil
  self.startEffected = nil
end

function AllianceSkillReinforcementHudLogic:__delete()
  if self.compHud then
    self.compHud:Delete()
    self.compHud = nil
  end
  self:ReleaseSkillEff()
  self.startEffected = nil
  base.__delete(self)
end

function AllianceSkillReinforcementHudLogic:OnKingOccupyProgressRefresh()
end

function AllianceSkillReinforcementHudLogic:OnProtectTimeUpdate()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function AllianceSkillReinforcementHudLogic:OnPointDateUpdate()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function AllianceSkillReinforcementHudLogic:OnWorldAllianceCityDetail()
  if self:IsTypeValid() then
    base.UpdateCityInfo(self)
    self:UpdateUi()
  end
end

function AllianceSkillReinforcementHudLogic:SetLod(lod)
  base.SetLod(self, lod)
  if self:IsTypeValid() and self.compHud then
    self.compHud:SetLod(lod)
  end
end

function AllianceSkillReinforcementHudLogic:CheckLod(lod)
  base.CheckLod(self, lod)
  if self:IsTypeValid() then
    if self.compHud then
      self.compHud:SetLod(lod)
    end
    self.lodCache = lod
    if self.goEffects then
      local toShowEffect = self.lodCache ~= 0 and self.lodCache <= 4
      for _, go in pairs(self.goEffects) do
        if not IsNull(go) then
          go:SetActive(toShowEffect)
        end
      end
    end
  end
end

function AllianceSkillReinforcementHudLogic:ReInit(data)
  base.ReInit(self, data)
  self:UpdateCityInfo()
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function AllianceSkillReinforcementHudLogic:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function AllianceSkillReinforcementHudLogic:InitUi()
end

function AllianceSkillReinforcementHudLogic:UpdateData()
  return true
end

function AllianceSkillReinforcementHudLogic:BelongNobody()
  if self.compHud then
    self.compHud:Delete()
    self.compHud = nil
  end
end

function AllianceSkillReinforcementHudLogic:UpdateUi()
  if not self:IsTypeValid() then
    self:BelongNobody()
    return
  end
  if self.theExtraInfo == nil or self.theExtraInfo.shieldInfo == nil then
    self:BelongNobody()
    return
  end
  local shieldInfo = self.theExtraInfo.shieldInfo
  local now = UITimeManager:GetInstance():GetServerTime()
  local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local skillId = shieldInfo.allianceCity.skillId
  local unitySkillConfig = DataCenter.AllianceSkillManager:GetAllianceUnityConfigBySkillId(skillId)
  if unitySkillConfig then
    if shieldInfo.expireTime > 0 and shieldInfo.expireTime - now < 2000 then
      self:ReleaseSkillEff()
      local endEffect = unitySkillConfig:GetSkillEffectByTags("end")
      if self.skillEndRequest == nil then
        self.skillEndRequest = self:PlaySkillEff(self.thePointInfo.mainIndex, endEffect.Path, endEffect.Duration)
      end
    elseif shieldInfo.expireTime == 0 or curTimeSeconds < shieldInfo.expireTime then
      if self.compHud == nil then
        local theWarTimeBuildingHud = require("DataCenter.AllianceCityTip.Season.AllianceSkillReinforcementHud")
        self.compHud = theWarTimeBuildingHud.New(self.transform, self.serverId)
      end
      self.compHud:ReInit(self.data, self.theExtraInfo)
      self.compHud:UpdateUi()
      if self.skillRequest == nil then
        local loopEffect = unitySkillConfig:GetSkillEffectByTags("loop")
        self.skillRequest = self:PlaySkillEff(self.thePointInfo.mainIndex, loopEffect.Path, IntMaxValue)
      end
      if self.lastAllianceCity ~= nil and self.lastAllianceCity ~= shieldInfo.allianceCity.startTime then
        self.startEffected = false
      end
      self.lastAllianceCity = shieldInfo.allianceCity.startTime
      if now - shieldInfo.allianceCity.startTime < 1000 and not self.startEffected then
        local soleEffect = unitySkillConfig:GetSkillEffectByTags("sole")
        self:PlaySkillEff(self.thePointInfo.mainIndex, soleEffect.Path, soleEffect.Duration)
        self.startEffected = true
      end
    else
      self:BelongNobody()
    end
  else
    self:BelongNobody()
  end
end

function AllianceSkillReinforcementHudLogic:IsTypeValid()
  if self.cityType == nil then
    return false
  end
  return self.cityType == WorldAllianceCityType.City
end

function AllianceSkillReinforcementHudLogic:PlaySkillEff(pointId, prefab, time, parent)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if IsNull(parent) then
    parent = CS.SceneManager.World.DynamicObjNode
  end
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  local theWorld = CS.SceneManager.World
  if theWorld then
    return theWorld:CreateVFX(prefab, pos, time, 0, function(go)
      if self.goEffects == nil then
        self.goEffects = {}
      end
      local toShowEffect = self.lodCache ~= 0 and self.lodCache <= 4
      go:SetActive(toShowEffect)
      go.transform:SetParent(parent)
      go.transform:Set_localScale(1, 1, 1)
      go.transform.position = pos
      if 10 < time then
        table.insert(self.goEffects, go)
      end
    end)
  end
end

function AllianceSkillReinforcementHudLogic:ReleaseSkillEff()
  local theWorld = CS.SceneManager.World
  if self.skillRequest ~= nil and theWorld then
    theWorld:RemoveVFX(self.skillRequest)
    self.skillRequest = nil
  end
  if self.skillEndRequest ~= nil and theWorld then
    theWorld:RemoveVFX(self.skillEndRequest)
    self.skillEndRequest = nil
  end
  self.goEffects = nil
end

function AllianceSkillReinforcementHudLogic:GetPointModelParent()
  local effectParentNode
  local obj = CS.SceneManager.World:GetObjectByPoint(self.thePointInfo.mainIndex)
  if obj then
    local rootObj = obj:GetGameObject()
    if rootObj then
      effectParentNode = rootObj.transform:Find("Model")
    end
  end
  return effectParentNode
end

return AllianceSkillReinforcementHudLogic
