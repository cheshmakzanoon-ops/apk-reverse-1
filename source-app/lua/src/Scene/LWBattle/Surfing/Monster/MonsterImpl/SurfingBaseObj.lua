local base = require("Scene.LWBattle.Surfing.SurfingUnit")
local SurfingBaseObj = BaseClass("SurfingBaseObj", base)
local Const = require("Scene.LWBattle.Const")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local VIEW_INVALID_HANDLE = -1
local LoadEffectOffset = 60

function SurfingBaseObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic)
  self.mgr = mgr
  self.logic = mgr.logic
  self.x = x
  self.y = y
  self.metaZ = z
  self.z = z + logic.renderOffsetZ
  self.dataZ = z
  self.curWorldPos = Vector3.New(x, self.y, self.z)
  self.monsterMeta = monsterMeta
  self.bornId = bornId
  self.monsterId = monsterMeta.id
  self.oriId = oriId
  self.param = param
  self.unitType = self.monsterMeta.monster_type == Const.SurfingMonsterType.Static and UnitType.Junk or UnitType.Zombie
  self.eulerY = 0
  self.layer = -1
  self.loadEffectOffset = LoadEffectOffset
end

function SurfingBaseObj:SetLocalPositionData(localPos)
  localPos.z = localPos.z + self.logic.renderOffsetZ
  self:SetLocalPosition(localPos)
end

function SurfingBaseObj:SetLocalPosition(localPos)
  if not self.viewLoaded then
    self.x = localPos.x
    self.y = localPos.y
    self.z = localPos.z
    if self.curWorldPos and self.curWorldPos.z then
      self.curWorldPos.x = localPos.x
      self.curWorldPos.y = localPos.y
      self.curWorldPos.z = localPos.z
    end
    if self.viewHandle then
      UnitViewFacade.SetLocalPosition(self.viewHandle, localPos.x, localPos.y, localPos.z)
    end
  end
  base.SetLocalPosition(self, localPos)
  self.z = self.curWorldPos.z
end

function SurfingBaseObj:Load()
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = ResetScale.x
  if self.monsterMeta.model_size then
    scale = self.monsterMeta.model_size
  end
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, self.monsterMeta.asset, nil, scale, self.x, self.y, self.z, ResetPosition.x, self.eulerY, ResetPosition.z, self.layer)
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function SurfingBaseObj:OnViewLoaded(force, objHandle)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  if CS.CommonUtils.IsDebug() and self.gameObject then
    self.gameObject.name = self.bornId
  end
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self:ComponentDefineWithoutView()
  self:OnLoadComplete()
end

function SurfingBaseObj:ComponentDefine()
  base.ComponentDefine(self)
end

function SurfingBaseObj:OnLoadComplete()
end

function SurfingBaseObj:OnUpdate(deltaTime, viewY)
  base.OnUpdate(self, deltaTime)
end

function SurfingBaseObj:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
end

function SurfingBaseObj:DestroyView()
  base.DestroyView(self)
  self.collider = nil
  if self.viewHandle and self.viewHandle > VIEW_INVALID_HANDLE then
    self.viewHandle = UnitViewFacade.DestroyUnitView(self.viewHandle)
  end
  self.gameObject = nil
  self.transform = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
  end
end

function SurfingBaseObj:DestroyData()
  self.mgr = nil
  self.logic = nil
  self.x = nil
  self.metaZ = nil
  self.y = nil
  self.z = nil
  self.monsterMeta = nil
  self.bornId = nil
  self.monsterId = nil
  self.oriId = nil
  self.param = nil
  self.unitType = nil
  self.forceUpdateReversePos = nil
  self.airDropping = nil
  base.DestroyData(self)
end

function SurfingBaseObj:Death()
  self.mgr:RemoveMonster(self.guid)
end

function SurfingBaseObj:ResetRenderPosition()
  self.z = self.dataZ + self.logic.renderOffsetZ
  self:SetLocalPosition(Vector3.New(self.x, self.y, self.z))
end

function SurfingBaseObj:GetDataZ()
  return self.z - self.logic.renderOffsetZ
end

return SurfingBaseObj
