local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local Animator = typeof(CS.UnityEngine.Animator)
local TriggerPointMonster = BaseClass("TriggerPointMonster")
local Hero = BaseClass("Hero")
local PveLineup = require("Scene.BattlePveModule.PveLineup")
local ArmyTableHeroes = {
  "hero1",
  "hero2",
  "hero3",
  "hero4",
  "hero5"
}

function TriggerPointMonster:__init()
  self.gameObject = nil
  self.monsterId = nil
  self.heroes = {}
  self.materialPropertyBlock = CS.UnityEngine.MaterialPropertyBlock()
  self.heroSignPropertyId = CS.UnityEngine.Shader.PropertyToID("_Color")
  self.__event_handlers = {}
  self:AddListener(EventId.HeroLevelUpgrade, self.OnHeroLevelUp)
end

function TriggerPointMonster:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function TriggerPointMonster:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    Logger.LogError(msg_name, " not register")
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function TriggerPointMonster:__delete()
  self:RemoveListener(EventId.HeroLevelUpgrade, self.OnHeroLevelUp)
end

function TriggerPointMonster:Create(gameObject, monsterId, rotation)
  local transform = gameObject.transform
  self.gameObject = gameObject
  self.monsterId = monsterId
  gameObject.transform.localRotation = Quaternion.identity
  local standPosObj = {}
  local rarityIcon = {}
  local a, b, c
  if 180 < rotation then
    a, b, c = 5, 1, -1
  else
    a, b, c = 1, 5, 1
  end
  for i = a, b, c do
    standPosObj[#standPosObj + 1] = transform:Find(string.format("enemy0%d", i))
    rarityIcon[#rarityIcon + 1] = {
      go = transform:Find(string.format("enemy0%d/VFX_Quality", i)).gameObject,
      render1 = transform:Find(string.format("enemy0%d/VFX_Quality", i)):GetComponent(typeof(CS.UnityEngine.Renderer)),
      render2 = transform:Find(string.format("enemy0%d/VFX_Quality/V_plane", i)):GetComponent(typeof(CS.UnityEngine.Renderer))
    }
  end
  local armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "army")
  armyId = armyId[1] or ""
  if string.IsNullOrEmpty(armyId) then
    armyId = monsterId
  end
  local pve_power = GetTableData(TableName.Army, armyId, "pve_power")
  local tab_pve_power = string.split(pve_power, "|")
  local enemyHeros = {}
  for k, v in ipairs(ArmyTableHeroes) do
    local heroInfo = GetTableData(TableName.Army, armyId, v)
    if not string.IsNullOrEmpty(heroInfo) then
      local t = string.split(heroInfo, ";")
      if table.count(t) >= 2 then
        local oneData = {}
        oneData.heroId = t[1]
        oneData.heroLv = t[2]
        enemyHeros[#enemyHeros + 1] = oneData
      end
    end
  end
  local maxLevelHero = DataCenter.HeroDataManager.maxLevel
  for i, heroData in pairs(enemyHeros) do
    local power = tab_pve_power[i] or 0
    local standObj = standPosObj[i]
    self:CreateHero(tonumber(heroData.heroId), tonumber(power), standObj, tonumber(heroData.heroLv), maxLevelHero)
    local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroData.heroId), "rarity")
    self:SetRarity(rarityIcon[i], rarity)
  end
end

function TriggerPointMonster:CreateHero(heroId, power, standObj, heroLv, targetMaxLevel)
  local hero = Hero.New()
  hero:Create(heroId, power, standObj, heroLv, targetMaxLevel)
  self.heroes[#self.heroes + 1] = hero
end

function TriggerPointMonster:Destroy()
  if self.heroes then
    for _, v in pairs(self.heroes) do
      v:Destroy()
    end
    self.heroes = nil
  end
end

function TriggerPointMonster:HideHeroLevel()
  for _, hero in pairs(self.heroes) do
    hero:HideLevel()
  end
end

function TriggerPointMonster:SetVisible(visible)
  self.visible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
  if self.heroes then
    for _, v in pairs(self.heroes) do
      v:SetVisible(visible)
    end
  end
end

function TriggerPointMonster:SetLevelVisible(visible)
  if self.heroes then
    for _, v in pairs(self.heroes) do
      v:SetLevelVisible(visible)
    end
  end
end

function TriggerPointMonster:OnUpdate()
end

function TriggerPointMonster:OnHeroLevelUp()
  local maxLevelHero = DataCenter.HeroDataManager.maxLevel
  if self.heroes ~= nil then
    for _, v in pairs(self.heroes) do
      v:OnHeroLevelUpRefresh(maxLevelHero)
    end
  end
end

function TriggerPointMonster:SetRarity(rarityIcon, rarity)
  if self.monsterId == ADVENTURE_DEFAULT_MONSTER then
    local vector1 = PveLineup.SignColors[0].Center
    local vector2 = PveLineup.SignColors[0].Border
    rarityIcon.go:SetActive(true)
    self.materialPropertyBlock:SetVector(self.heroSignPropertyId, vector1)
    rarityIcon.render1:SetPropertyBlock(self.materialPropertyBlock)
    self.materialPropertyBlock:SetVector(self.heroSignPropertyId, vector2)
    rarityIcon.render2:SetPropertyBlock(self.materialPropertyBlock)
  elseif rarity and 0 < rarity then
    local vector1 = PveLineup.SignColors[rarity].Center
    vector1.w = 1
    local vector2 = PveLineup.SignColors[rarity].Border
    vector2.w = 1
    rarityIcon.go:SetActive(true)
    self.materialPropertyBlock:SetVector(self.heroSignPropertyId, vector1)
    rarityIcon.render1:SetPropertyBlock(self.materialPropertyBlock)
    self.materialPropertyBlock:SetVector(self.heroSignPropertyId, vector2)
    rarityIcon.render2:SetPropertyBlock(self.materialPropertyBlock)
  else
    rarityIcon.go:SetActive(false)
  end
end

function Hero:__init()
  self.visible = true
  self.inst = nil
  self.weapon = nil
  self.bloodBar = nil
  self.objLevel = nil
  self.levelVisible = true
end

function Hero:__delete()
end

function Hero:Create(heroId, power, standObj, heroLv, targetMaxLevel)
  self.heroId = heroId
  self.heroLv = heroLv
  self.inst = Resource:InstantiateAsync(self:GetModelResPath())
  self.inst:completed("+", function()
    self.gameObject = self.inst.gameObject
    local transform = self.gameObject.transform
    transform:SetParent(standObj)
    transform:Set_localPosition(0, 0, 0)
    transform.localRotation = Quaternion.Euler(0, 180, 0)
    self.transform = transform
    self.animator = self.gameObject:GetComponentInChildren(Animator, true)
    if self.animator ~= nil then
      self.animator:SetTrigger("ready")
    end
    self.weapon = Resource:InstantiateAsync("Assets/Main/Prefabs/PVE/Obj_A_Weapons_th_spear.prefab")
    self.weapon:completed("+", function()
      local weaponParent = self:GetWeaponParent()
      if weaponParent then
        self.weapon.gameObject.transform.parent = weaponParent
        self.weapon.gameObject.transform.localPosition = ResetPosition
        self.weapon.gameObject.transform.rotation = ResetEulerAngles
      end
    end)
    self.bloodBar = Resource:InstantiateAsync("Assets/Main/Prefabs/PVE/PveHero_blood.prefab")
    self.bloodBar:completed("+", function()
      local transformBar = self.bloodBar.gameObject.transform
      transformBar:SetParent(self.gameObject.transform)
      local _modelPos = self.transform.position + Vector3.New(0, 2, 0)
      self.bloodBar.gameObject.transform.position = _modelPos
      self.bloodBar.gameObject.transform.rotation = Quaternion.Euler(33, 0, 0)
      local objLevel = transformBar:Find("objLevel")
      self.txtLevel = transformBar:Find("objLevel/txtLevel"):GetComponent(typeof(CS.SuperTextMesh))
      self.txtName = transformBar:Find("objLevel/txtName"):GetComponent(typeof(CS.SuperTextMesh))
      objLevel.gameObject:SetActive(self.levelVisible)
      self.objLevel = objLevel.gameObject
      if self.hideLevel then
        self:HideLevel()
      else
        self.txtLevel.text = "Lv." .. heroLv
        if targetMaxLevel ~= nil and heroLv > targetMaxLevel then
          self.txtLevel.color32 = Color32.New(234, 66, 66, 255)
        else
          self.txtLevel.color32 = WorldWhiteColor32
        end
      end
      local name = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "name")
      self.txtName.text = Localization:GetString(tostring(name))
      self.bloodBar.gameObject:SetActive(self.visible)
    end)
    self.gameObject:SetActive(self.visible)
  end)
end

function Hero:HideLevel()
  self.hideLevel = true
  if self.txtLevel then
    self.txtLevel.text = "???"
    self.txtLevel.color32 = WorldWhiteColor32
  end
  if self.txtName then
    self.txtName.gameObject:SetActive(false)
  end
end

function Hero:GetWeaponParent()
  local childrenObj = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Transform), true)
  if childrenObj.Length > 0 then
    for i = 0, childrenObj.Length - 1 do
      if childrenObj[i].name == "guadian" then
        return childrenObj[i].gameObject.transform
      end
    end
  end
  return nil
end

function Hero:Destroy()
  if self.inst then
    self.inst:Destroy()
    self.inst = nil
  end
  if self.weapon then
    self.weapon:Destroy()
    self.weapon = nil
  end
  if self.bloodBar then
    self.bloodBar:Destroy()
    self.bloodBar = nil
  end
  self.transform = nil
  self.animator = nil
end

function Hero:GetModelResPath()
  local model = GetTableData(HeroUtils.GetHeroXmlName(), self.heroId, "prefab_low")
  local str_side = ""
  return "Assets/Main/Prefabs/PVE/DyHeroes/" .. model .. str_side .. ".prefab"
end

function Hero:SetVisible(visible)
  self.visible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
  if self.bloodBar and self.bloodBar.gameObject then
    self.bloodBar.gameObject:SetActive(visible)
  end
  if visible == true and self.animator ~= nil then
    self.animator:SetTrigger("ready")
  end
end

function Hero:SetLevelVisible(visible)
  self.levelVisible = visible
  if self.objLevel then
    self.objLevel:SetActive(visible)
  end
end

function Hero:OnHeroLevelUpRefresh(maxLevelHero)
  if self.txtLevel then
    if maxLevelHero ~= nil and maxLevelHero < self.heroLv then
      self.txtLevel.color32 = Color32.New(234, 66, 66, 255)
    else
      self.txtLevel.color32 = WorldWhiteColor32
    end
  end
end

return TriggerPointMonster
