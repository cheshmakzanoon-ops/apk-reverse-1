local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local SurfingBuffAllyObj = BaseClass("SurfingBuffAllyObj", base)
local Const = require("Scene.LWBattle.Const")
local dao_ju_guadian_path = "Hero_bubing_yundonghui_torch_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_R/Shoulder_R/Elbow_R/Wrist_R/DaoJu_guadian"
local BUFF_EFFECT_POS = {
  [Const.SurfingMonsterType.Magnet] = ResetPosition,
  [Const.SurfingMonsterType.JetPack] = ResetPosition,
  [Const.SurfingMonsterType.Double] = ResetPosition,
  [Const.SurfingMonsterType.Shield] = Vector3.up,
  [Const.SurfingMonsterType.Morph] = ResetPosition
}
local DEFAULT_EFFECT_PATH = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_shine.prefab"
local BUFF_EFFECT_PATH = {
  [Const.SurfingMonsterType.Magnet] = DEFAULT_EFFECT_PATH,
  [Const.SurfingMonsterType.JetPack] = DEFAULT_EFFECT_PATH,
  [Const.SurfingMonsterType.Double] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s4_running_goldX4_lizi.prefab",
  [Const.SurfingMonsterType.Shield] = DEFAULT_EFFECT_PATH,
  [Const.SurfingMonsterType.Morph] = DEFAULT_EFFECT_PATH
}

function SurfingBuffAllyObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
end

function SurfingBuffAllyObj:HandleCollide(target)
  if self.param then
    local monsterId = self.param.monsterId or 0
    local monsMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(monsterId)
    if monsMeta and monsMeta.monster_type == Const.SurfingMonsterType.JetPack then
      local buff_id = self:GetBuffId()
      if buff_id then
        local buff = self:AddSelfBuff(target, self:GetBuffId())
        if buff and self.logic then
          local duration = buff.meta and buff.meta.buff_time or 0
          self.logic:ShowSkyScores(self:GetDataZ(), duration)
          self:Death()
          return
        end
      end
    end
  end
  base.HandleCollide(self, target)
end

function SurfingBuffAllyObj:HandleExtra(target)
  if self.logic and self.param and self.param.playerInfo then
    local playerInfo = self.param.playerInfo
    self.logic:RecordPlayers(playerInfo.uid)
    DataCenter.LWSurfingDataManager:ShowInteractionPanel(playerInfo)
    local monsterId = self.param.monsterId or 0
    PostEventLog.Track(PostEventLog.Defines.SURFING_GAMING_ON_GET_ALLY_BUFF, {int_para1 = monsterId})
  end
end

function SurfingBuffAllyObj:DestroyView()
  base.DestroyView(self)
  if self.monsterHandle then
    self.monsterHandle:Destroy()
    self.monsterHandle = nil
  end
end

local function ShowBuffPrefab(self, monsterId)
  if monsterId == nil or monsterId == 0 then
    return
  end
  if self.monsterHandle then
    return
  end
  local monsterMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(monsterId)
  if monsterMeta == nil then
    return
  end
  self.buffMonsterType = monsterMeta.monster_type
  local monsterHandle = CS.GameEntry.Resource:InstantiateAsync(monsterMeta.asset)
  monsterHandle:completed("+", function(handle)
    local ok, msg = xpcall(function()
      local trans = handle.gameObject.transform
      local parent = self.transform:Find(dao_ju_guadian_path)
      trans:SetParent(parent)
      trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_localRotation(0, 0, 0, 1)
    end, debug.traceback)
    if not ok then
      Logger.LogError(msg)
      if handle and not IsNull(handle.gameObject) then
        handle.gameObject:SetActive(false)
      end
    end
  end)
  self.monsterHandle = monsterHandle
end

function SurfingBuffAllyObj:ShowStaticEffect()
  if self.logic.ignoreSpectacularEffect then
    return
  end
  if IsNotNull(self.transform) and self.buffMonsterType and self.monsterHandle then
    local trans = self.monsterHandle.gameObject.transform
    if trans then
      local path = BUFF_EFFECT_PATH[self.buffMonsterType]
      if not string.IsNullOrEmpty(path) and self.logic and self.staticEffectId == nil then
        local posOffset = BUFF_EFFECT_POS[self.buffMonsterType]
        posOffset = posOffset or ResetPosition
        local pos = self.logic.staticEffectCommonPos
        local parent
        if self.triggerLine > 0 and 0 < self.move_speed then
          parent = trans
          pos.x = posOffset.x
          pos.y = posOffset.y
          pos.z = posOffset.z
        else
          local pPos = trans.position
          pos.x = pPos.x + posOffset.x
          pos.y = pPos.y + posOffset.y
          pos.z = pPos.z + posOffset.z
        end
        self.staticEffectId = self.logic:ShowEffectObj(path, pos, nil, -1, parent)
      end
    end
  end
end

function SurfingBuffAllyObj:ResetEffectPosition()
  if self.staticEffectId == nil then
    return
  end
  if self.triggerLine > 0 and 0 < self.move_speed then
    return
  end
  if self.monsterHandle == nil then
    return
  end
  if IsNull(self.monsterHandle.gameObject) then
    return
  end
  if self.buffMonsterType == nil then
    return
  end
  local trans = self.monsterHandle.gameObject.transform
  local posOffset = BUFF_EFFECT_POS[self.buffMonsterType]
  local pPos = trans.position
  self.logic:ResetEffectPosition(self.staticEffectId, pPos.x + posOffset.x, pPos.y + posOffset.y, pPos.z + posOffset.z)
end

function SurfingBuffAllyObj:OnLoadComplete()
  base.OnLoadComplete(self)
  if self.param == nil then
    return
  end
  self:PlaySimpleAnim("cheer")
  ShowBuffPrefab(self, self.param.monsterId)
end

function SurfingBuffAllyObj:GetBuffId()
  if self.param == nil then
    return
  end
  if self.logic.isPlayback then
    if self.param.monsterId then
      local bMMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(self.param.monsterId)
      if bMMeta then
        local buffType = bMMeta:GetBuffType()
        local level = self.logic:GetBuffLevel(buffType) or 0
        if 0 < level then
          local buff_id = DataCenter.LWSurfingDataManager:GetBuffIdByBuffType(buffType, level)
          return buff_id
        end
      end
    end
  elseif self.param.monsterId then
    local bMMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(self.param.monsterId)
    if bMMeta then
      local unlock, buff_id = bMMeta:CheckBuffIsUnlock()
      if unlock then
        return buff_id
      end
    end
  end
  return 0
end

return SurfingBuffAllyObj
