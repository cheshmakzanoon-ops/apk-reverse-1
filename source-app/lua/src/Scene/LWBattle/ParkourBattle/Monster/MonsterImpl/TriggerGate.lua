local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase")
local TriggerGate = BaseClass("TriggerGate", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")

function TriggerGate:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.deathEvent = self:RandomGetDeathEvent()
  self.triggerMeta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(self.deathEvent)
  self:PreSelectHeroUuid()
end

function TriggerGate:DestroyData()
  self.preSelectHeroUuid = nil
  self.triggerType = nil
  base.DestroyData(self)
end

function TriggerGate:PreSelectHeroUuid()
  if self.preSelectHeroUuid then
    return
  end
  if not self.triggerMeta then
    return
  end
  local triggerType = self.triggerMeta.type
  self.triggerType = triggerType
  if triggerType == TriggerEnum.EventType.AddSingleHeroSkill or triggerType == TriggerEnum.EventType.AddSingleHeroBuff or triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then
    if DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetRandomInitUuid()
    end
  elseif triggerType == TriggerEnum.EventType.AddSingleHeroIdBuff then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttack or triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttackWithoutInterrupt or triggerType == TriggerEnum.EventType.ReplaceHeroIdActiveAttackWithoutInterrupt then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearance or triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearanceSaveLv then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddEnergy then
    local para = self.triggerMeta.para
    local index = tonumber(para) or 0
    if 0 < index and DataCenter.LWBattleManager.logic.GetInitUuidAuto then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidAuto(index)
    end
  elseif triggerType == TriggerEnum.EventType.ThreeChoices then
    local triggerCount = self.triggerMeta.paraArray and #self.triggerMeta.paraArray or 0
    if 0 < triggerCount and DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      self.preSelectHeroUuid = {}
      for i = 1, triggerCount do
        table.insert(self.preSelectHeroUuid, DataCenter.LWBattleManager.logic:GetRandomInitUuid())
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddHero then
    self.preSelectHeroUuid = tonumber(self.monsterMeta.trigger_para) or 1
  elseif triggerType == TriggerEnum.EventType.AddHeroIdEnergy then
    local para = self.triggerMeta.para
    local heroId, index
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      heroId = tonumber(paraList[1])
      index = tonumber(paraList[2])
      if heroId and index == nil then
        index = 1
      end
    end
    if heroId and index and DataCenter.LWBattleManager.logic.GetInitUuidByHeroIdOrIndex then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidByHeroIdOrIndex(heroId, index)
    end
  elseif triggerType == TriggerEnum.EventType.AddSingleHeroIdSkill then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  end
end

function TriggerGate:InitView()
  self.gameObject.name = "TriggerGate" .. self.guid
  local iconAsset = self.triggerMeta.icon
  local headIcon
  if self.triggerType == TriggerEnum.EventType.AddSingleHeroSkill or self.triggerType == TriggerEnum.EventType.AddSingleHeroBuff or self.triggerType == TriggerEnum.EventType.AddEnergy or self.triggerType == TriggerEnum.EventType.AddHeroIdEnergy or self.triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then
    if self.preSelectHeroUuid then
      local heroData = DataCenter.BattleLevel:GetPveHeroData(self.preSelectHeroUuid)
      assert(heroData ~= nil, "TriggerGate.InitView heroData is nil ! heroUuid : " .. self.preSelectHeroUuid)
      headIcon = HeroUtils.GetHeroIconPath(heroData.modelId)
    end
  elseif self.triggerType == TriggerEnum.EventType.AddSingleHeroIdBuff and self.preSelectHeroUuid then
    local meta = DataCenter.HeroTemplateManager:GetTemplate(self.preSelectHeroUuid)
    if meta ~= nil then
      headIcon = HeroUtils.GetHeroIconPath(meta.appearance)
    end
  end
  local text = self.triggerMeta.text
  local trans1 = self.transform:Find("tubiao/txt")
  if not IsNull(trans1) then
    local txt = trans1:GetComponent(typeof(SuperTextMesh))
    txt.text = text
  end
  local trans2 = self.transform:Find("tubiao/tubiao")
  if not IsNull(trans2) then
    local sr = trans2:GetComponent(typeof(SpriteRenderer))
    sr:LoadSprite(iconAsset)
  end
  local head = self.transform:Find("tubiao/headIcon")
  if not IsNull(head) then
    local sr = head:GetComponent(typeof(SpriteRenderer))
    if not string.IsNullOrEmpty(headIcon) then
      UIUtil.LoadSpriteRenderAuto(sr, headIcon)
      head.gameObject:SetActive(true)
    else
      head.gameObject:SetActive(false)
    end
  end
end

function TriggerGate:Trigger(colliderComponentCnt, colliderComponentArray)
  if self.battleMgr.lastTriggerZ == self.metaY then
    return
  end
  for i = 0, colliderComponentCnt - 1 do
    local otherObj = colliderComponentArray[i]
    local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
    if trigger ~= nil and trigger.ObjectId ~= 0 then
      local obj = DataCenter.LWBattleManager.logic:GetUnit(trigger.ObjectId)
      if obj and obj.guid ~= self.guid then
        self.battleMgr.lastTriggerZ = self.metaY
        self:TriggerEvent(self.deathEvent, self.preSelectHeroUuid)
        self:Death()
        self:ShowDissolveEffect()
        break
      end
    end
  end
end

return TriggerGate
