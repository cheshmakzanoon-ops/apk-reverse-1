local MailDamagePage = BaseClass("MailDamagePage", UIBaseContainer)
local base = UIBaseContainer
local MailDamageItem = require("UI.UILWMail.UILWMailMain.Component.MailDamageItem")
local TacticalDamageItem = require("UI.UILWMail.UILWMailMain.Component.MailTacticalDamageItem")
local Localization = CS.GameEntry.Localization
local SOLDIER_PAGE_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/SoldierPage.prefab"
local SOLDIER_PAGE_CLASS_PATH = "UI.UILWMail.UILWMailMain.Component.MailSoldierPage"
local TACTICAL_DAMAGE_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/TacticalDamageCell.prefab"
local tactical_damage_content_path = "DamageView/TacticalDamageContent"
local tactical_hurt_content_path = "DamageView/TacticalHurtContent"

function MailDamagePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailDamagePage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDamagePage:DataDefine()
end

function MailDamagePage:DataDestroy()
end

function MailDamagePage:OnEnable()
  base.OnEnable(self)
end

function MailDamagePage:OnDisable()
  base.OnDisable(self)
end

function MailDamagePage:OnAddListener()
  base.OnAddListener(self)
end

function MailDamagePage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailDamagePage:ComponentDefine()
  self.damageCell = self.transform:Find("DamageView/DamageContent/DamageCell").gameObject
  self.damageCell:GameObjectCreatePool()
  self.damageCell:SetActive(false)
  self.damageContent = self:AddComponent(UIBaseContainer, "DamageView/DamageContent")
  self.hurtCell = self.transform:Find("DamageView/HurtContent/HurtCell").gameObject
  self.hurtCell:GameObjectCreatePool()
  self.hurtCell:SetActive(false)
  self.hurtContent = self:AddComponent(UIBaseContainer, "DamageView/HurtContent")
  self.DamageTitleText = self:AddComponent(UIText, "DamageView/DamageTitle/DamageTitleText")
  self.HurtTitleText = self:AddComponent(UIText, "DamageView/HurtTitle/HurtTitleText")
  self.DamageTitleText:SetLocalText(GameDialogDefine.DEAL_DAMAGE)
  self.HurtTitleText:SetLocalText(GameDialogDefine.TAKE_DAMAGE)
  self.tacticalDamageRoot = self:AddComponent(UIBaseContainer, tactical_damage_content_path)
  self.tacticalHurtRoot = self:AddComponent(UIBaseContainer, tactical_hurt_content_path)
end

function MailDamagePage:ComponentDestroy()
  self:RemoveSoldierPage()
  self:RemoveCells()
  self:RemoveTacticalContent()
end

function MailDamagePage:Refresh(extData)
  self.extData = extData
  self.maxDamage = self.extData.maxDamage
  self.maxInjured = self.extData.maxInjured
  self:ReCalMaxDamageAndMaxInjured()
  self:RefreshView()
  self:RefreshSoldierPage()
  self:RefreshTacticalContent()
end

function MailDamagePage:RemoveCells()
  self.damageContent:RemoveComponents(MailDamageItem)
  self.hurtContent:RemoveComponents(MailDamageItem)
  self.damageCell.gameObject:GameObjectRecycleAll()
  self.hurtCell.gameObject:GameObjectRecycleAll()
end

function MailDamagePage:RefreshView()
  self:RemoveCells()
  local damageCount = 0
  for i = 1, 5 do
    if self.extData.hero[i] or self.extData.hero[i + 5] then
      damageCount = damageCount + 1
      local item = self.damageCell:GameObjectSpawn(self.damageContent.transform)
      item.name = "DamageCell" .. damageCount
      local obj = self.damageContent:AddComponent(MailDamageItem, item.name)
      obj:SetData(self.extData, self.extData.hero[i], self.extData.hero[i + 5], true, self.maxDamage, self.maxInjured, self.extData.player[1], self.extData.player[2])
    end
  end
  if self.extData.hero[PVPBattleSlot.SelfDominator] or self.extData.hero[PVPBattleSlot.EnemyDominator] then
    damageCount = damageCount + 1
    local item = self.damageCell:GameObjectSpawn(self.damageContent.transform)
    item.name = "DamageCell" .. damageCount
    local obj = self.damageContent:AddComponent(MailDamageItem, item.name)
    local heroId1 = 0
    local heroId2 = 0
    local player1 = self.extData.player[1] or {}
    local player2 = self.extData.player[2] or {}
    if self.extData.hero[PVPBattleSlot.SelfDominator] then
      heroId1 = self.extData.hero[PVPBattleSlot.SelfDominator].heroId
      player1 = self:GetDominatorPlayerData(heroId1) or self.extData.player[1]
    end
    if self.extData.hero[PVPBattleSlot.EnemyDominator] then
      heroId2 = self.extData.hero[PVPBattleSlot.EnemyDominator].heroId
      player2 = self:GetDominatorPlayerData(heroId2) or self.extData.player[2]
    end
    obj:SetData(self.extData, self.extData.hero[PVPBattleSlot.SelfDominator], self.extData.hero[PVPBattleSlot.EnemyDominator], true, self.maxDamage, self.maxInjured, player1, player2)
  end
  for i = 1, 5 do
    if self.extData.hero[i] or self.extData.hero[i + 5] then
      damageCount = damageCount + 1
      local item = self.hurtCell:GameObjectSpawn(self.hurtContent.transform)
      item.name = "HurtCell" .. damageCount
      local obj = self.hurtContent:AddComponent(MailDamageItem, item.name)
      obj:SetData(self.extData, self.extData.hero[i], self.extData.hero[i + 5], false, self.maxDamage, self.maxInjured, self.extData.player[1], self.extData.player[2])
    end
  end
  if self.extData.hero[PVPBattleSlot.SelfDominator] or self.extData.hero[PVPBattleSlot.EnemyDominator] then
    damageCount = damageCount + 1
    local item = self.hurtCell:GameObjectSpawn(self.hurtContent.transform)
    item.name = "HurtCell" .. damageCount
    local obj = self.hurtContent:AddComponent(MailDamageItem, item.name)
    local heroId1 = 0
    local heroId2 = 0
    local player1 = self.extData.player[1] or {}
    local player2 = self.extData.player[2] or {}
    if self.extData.hero[PVPBattleSlot.SelfDominator] then
      heroId1 = self.extData.hero[PVPBattleSlot.SelfDominator].heroId
      player1 = self:GetDominatorPlayerData(heroId1) or self.extData.player[1]
    end
    if self.extData.hero[PVPBattleSlot.EnemyDominator] then
      heroId2 = self.extData.hero[PVPBattleSlot.EnemyDominator].heroId
      player2 = self:GetDominatorPlayerData(heroId2) or self.extData.player[2]
    end
    obj:SetData(self.extData, self.extData.hero[PVPBattleSlot.SelfDominator], self.extData.hero[PVPBattleSlot.EnemyDominator], false, self.maxDamage, self.maxInjured, player1, player2)
  end
end

function MailDamagePage:GetDominatorPlayerData(heroId)
  local type = LocalController:instance():getValue("lw_hero", heroId, "type")
  for i = 1, #self.extData.player do
    local playerData = self.extData.player[i] or {}
    if type ~= HeroTemplateType.Dominator then
      local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(playerData.contentId)
      if armyCfg then
        return self.extData.player[i] or {}
      end
    else
      local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(playerData.contentId)
      if not armyCfg then
        return self.extData.player[i] or {}
      end
    end
  end
end

function MailDamagePage:RefreshSoldierPage()
  if self.soldierPage then
    self.soldierPage:Refresh(self.extData)
  elseif not self.soldierPageRequest then
    self.soldierPageRequest = self:GameObjectInstantiateAsync(SOLDIER_PAGE_PREFAB_PATH, function(request)
      if IsNull(request.gameObject) then
        return
      end
      if not self.soldierPageCompCls then
        self.soldierPageCompCls = require(SOLDIER_PAGE_CLASS_PATH)
      end
      local obj = request.gameObject
      local transform = obj.transform
      transform:SetParent(self.transform)
      transform:Set_localScale(1, 1, 1)
      transform:SetAsFirstSibling()
      self.soldierPage = self:AddComponent(self.soldierPageCompCls, obj.name)
      self.soldierPage:Refresh(self.extData)
    end)
  end
end

function MailDamagePage:RemoveSoldierPage()
  if self.soldierPage and self.soldierPageCompCls then
    self:RemoveComponents(self.soldierPageCompCls)
  end
  if self.soldierPageRequest then
    self:GameObjectDestroy(self.soldierPageRequest.gameObject)
    self.soldierPageRequest = nil
  end
end

function MailDamagePage:RefreshTacticalContent()
  if self.tacticalDamageCell then
    local hero2 = self.extData.weapon[12]
    if self.extData.player[2].armyType == MailTargetType.Army then
      hero2 = nil
    end
    self.tacticalDamageCell:SetData(self.extData, self.extData.weapon[11], hero2, true, self.maxDamage, self.maxInjured)
  elseif not self.tacticalDamageCellReq then
    self.tacticalDamageCellReq = self:GameObjectInstantiateAsync(TACTICAL_DAMAGE_PREFAB_PATH, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local obj = request.gameObject
      local transform = obj.transform
      transform:SetParent(self.tacticalDamageRoot.transform)
      transform:Set_localScale(1, 1, 1)
      transform.localPosition = Vector3.New(0, 0, 0)
      self.tacticalDamageCell = self.tacticalDamageRoot:AddComponent(TacticalDamageItem, obj.name)
      local hero2 = self.extData.weapon[12]
      if self.extData.player[2].armyType == MailTargetType.Army then
        hero2 = nil
      end
      self.tacticalDamageCell:SetData(self.extData, self.extData.weapon[11], hero2, true, self.maxDamage, self.maxInjured)
    end)
  end
  if self.tacticalHurtCell then
    local hero2 = self.extData.weapon[12]
    if self.extData.player[2].armyType == MailTargetType.Army then
      hero2 = nil
    end
    self.tacticalHurtCell:SetData(self.extData, self.extData.weapon[11], hero2, false, self.maxDamage, self.maxInjured)
  elseif not self.tacticalHurtCellReq then
    self.tacticalHurtCellReq = self:GameObjectInstantiateAsync(TACTICAL_DAMAGE_PREFAB_PATH, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local obj = request.gameObject
      local transform = obj.transform
      transform:SetParent(self.tacticalHurtRoot.transform)
      transform:Set_localScale(1, 1, 1)
      transform.localPosition = Vector3.New(0, 0, 0)
      self.tacticalHurtCell = self.tacticalHurtRoot:AddComponent(TacticalDamageItem, obj.name)
      local hero2 = self.extData.weapon[12]
      if self.extData.player[2].armyType == MailTargetType.Army then
        hero2 = nil
      end
      self.tacticalHurtCell:SetData(self.extData, self.extData.weapon[11], hero2, false, self.maxDamage, self.maxInjured)
    end)
  end
end

function MailDamagePage:RemoveTacticalContent()
  if self.tacticalDamageCell then
    self.tacticalDamageRoot:RemoveComponent(TacticalDamageItem)
    self.tacticalDamageCell = nil
  end
  if self.tacticalDamageCellReq then
    self:GameObjectDestroy(self.tacticalDamageCellReq.gameObject)
    self.tacticalDamageCellReq = nil
  end
  if self.tacticalHurtCell then
    self.tacticalHurtRoot:RemoveComponent(TacticalDamageItem)
    self.tacticalHurtCell = nil
  end
  if self.tacticalHurtCellReq then
    self:GameObjectDestroy(self.tacticalHurtCellReq.gameObject)
    self.tacticalHurtCellReq = nil
  end
end

function MailDamagePage:ReCalMaxDamageAndMaxInjured()
  if self.extData.weapon[11] and self.extData.weapon[11].stat then
    local weaponDamage = self.extData.weapon[11].stat.damage or 0
    local weaponInjured = self.extData.weapon[11].stat.injured or 0
    self.maxDamage = math.max(self.maxDamage, weaponDamage)
    self.maxInjured = math.max(self.maxInjured, weaponInjured)
  end
  if self.extData.weapon[12] and self.extData.weapon[12].stat then
    local weaponDamage = self.extData.weapon[12].stat.damage or 0
    local weaponInjured = self.extData.weapon[12].stat.injured or 0
    self.maxDamage = math.max(self.maxDamage, weaponDamage)
    self.maxInjured = math.max(self.maxInjured, weaponInjured)
  end
end

return MailDamagePage
