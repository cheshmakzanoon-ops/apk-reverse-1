local TriggerPointMonsterWithHp = BaseClass("TriggerPointMonsterWithHp")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local PveLineup = require("Scene.BattlePveModule.PveLineup")
local hp_back_path = "HpBar/HpBack"
local hp_front_path = "HpBar/HpFront"
local val_path = "HpBar/Val"
local level_path = "HpBar/Info/Level"
local name_path = "HpBar/Info/Name"
local icon_path = "HpBar/Icon"
local Animator = typeof(CS.UnityEngine.Animator)
local HP_WIDTH = 1.125
local HP_HEIGHT = 0.145
local HP_BACK_SPEED = 0.2

local function Create(self, gameObject, heroGameObject, triggerPoint)
  self.gameObject = gameObject
  self.heroGameObject = heroGameObject
  self.triggerPoint = triggerPoint
  self.heroGameObject.transform.localRotation = Quaternion.identity
end

local function __init(self)
  self.cur = 0
  self.max = 0
  self.materialPropertyBlock = CS.UnityEngine.MaterialPropertyBlock()
  self.heroSignPropertyId = CS.UnityEngine.Shader.PropertyToID("_Color")
end

local function __delete(self)
  self.gameObject = nil
  self.hp_back_sprite = nil
  self.hp_front_sprite = nil
  self.val_text = nil
  self.cur = nil
  self.max = nil
end

local function Destroy(self)
  if self.hpInstance ~= nil then
    self.hpInstance:Destroy()
    self.hpInstance = nil
  end
  if self.rarityInstance ~= nil then
    self.rarityInstance:Destroy()
    self.rarityInstance = nil
  end
  if self.inst ~= nil then
    self.inst:Destroy()
    self.inst = nil
  end
  if self.weapon ~= nil then
    self.weapon:Destroy()
    self.weapon = nil
  end
end

local function SetActive(self, active)
  self.gameObject:SetActive(active)
end

local function SetInfo(self)
  if string.IsNullOrEmpty(self.triggerPoint.config.monsterLevel) then
    self.level_text.text = ""
  else
    self.level_text.text = "Lv." .. self.triggerPoint.config.monsterLevel
  end
  if string.IsNullOrEmpty(self.triggerPoint.config.monsterName) then
    self.name_text.text = ""
  else
    self.name_text.text = Localization:GetString(self.triggerPoint.config.monsterName)
  end
end

local function SetRarity(self, rarityIcon, rarity)
  if rarity and 0 < rarity then
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

local function SetVal(self, cur, max)
  self.cur = cur or self.cur
  self.max = max or self.max
  if self.val_text == nil then
    self:LoadPrefab()
    return
  end
  local percent = 0
  if self.max ~= 0 then
    percent = Mathf.Clamp(self.cur / self.max, 0, 1)
  end
  self.hp_front_sprite.size = Vector2.New(HP_WIDTH * percent, HP_HEIGHT)
  local percentValue = toInt(100 * percent)
  percentValue = Mathf.Clamp(percentValue, 1, 100)
  self.val_text.text = percentValue .. "%"
end

local function LoadPrefab(self)
  if self.hpInstance == nil then
    local prefabPath = string.format(UIAssets.UIPveMonsterHpBar)
    self.hpInstance = Resource:InstantiateAsync(prefabPath)
    self.hpInstance:completed("+", function()
      self.hpInstance.gameObject.transform:SetParent(self.heroGameObject.transform:Find("enemy").gameObject.transform)
      self.hpInstance.gameObject.transform.localPosition = Vector3.New(0, 2, 1.6)
      self.hpInstance.gameObject.transform.localRotation = Quaternion.Euler(33, -self.triggerPoint:GetRotation(), 0)
      self.hpInstance.gameObject:SetActive(true)
      self.hp_back_sprite = self.hpInstance.gameObject.transform:Find(hp_back_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      self.hp_back_sprite.size = Vector2.New(0, HP_HEIGHT)
      self.hp_front_sprite = self.hpInstance.gameObject.transform:Find(hp_front_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      self.hp_front_sprite.size = Vector2.New(0, HP_HEIGHT)
      self.val_text = self.hpInstance.gameObject.transform:Find(val_path):GetComponent((typeof(CS.SuperTextMesh)))
      self.level_text = self.hpInstance.gameObject.transform:Find(level_path):GetComponent((typeof(CS.SuperTextMesh)))
      self.name_text = self.hpInstance.gameObject.transform:Find(name_path):GetComponent((typeof(CS.SuperTextMesh)))
      self:SetInfo()
      self:SetVal(self.cur, self.max)
    end)
  end
  local armyId = self.triggerPoint:GetMonsterId()
  local pve_power = GetTableData(TableName.Army, armyId, "pve_power")
  local tab_pve_power = string.split(pve_power, "|")
  local heroInfo = GetTableData(TableName.Army, armyId, "hero1")
  if not string.IsNullOrEmpty(heroInfo) then
    local t = string.split(heroInfo, ";")
    if table.count(t) >= 2 then
      local power = tab_pve_power[1] or 0
      self:CreateHero(tonumber(t[1]))
    end
  end
end

local function GetModelResPath(self, heroId)
  local model = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "prefab_low")
  local str_side = ""
  return "Assets/Main/Prefabs/PVE/DyHeroes/" .. model .. str_side .. ".prefab"
end

local function CreateHero(self, heroId)
  self.inst = Resource:InstantiateAsync(self:GetModelResPath(heroId))
  self.inst:completed("+", function()
    local gameObject = self.inst.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.heroGameObject.transform:Find("enemy").gameObject.transform)
    transform:Set_localPosition(0, 0, 1.4)
    transform.localRotation = Quaternion.Euler(0, 180, 0)
    local animator = gameObject:GetComponentInChildren(Animator, true)
    if animator ~= nil then
      animator:SetTrigger("ready")
    end
    self.weapon = Resource:InstantiateAsync("Assets/Main/Prefabs/PVE/Obj_A_Weapons_th_spear.prefab")
    self.weapon:completed("+", function()
      local weaponParent = self:GetWeaponParent(gameObject)
      if weaponParent then
        self.weapon.gameObject.transform.parent = weaponParent
        self.weapon.gameObject.transform.localPosition = ResetPosition
        self.weapon.gameObject.transform.rotation = ResetEulerAngles
      end
    end)
  end)
  self.rarityInstance = Resource:InstantiateAsync(UIAssets.UIHeroRaritySquare)
  self.rarityInstance:completed("+", function()
    local gameObject = self.rarityInstance.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.heroGameObject.transform:Find("enemy").gameObject.transform)
    transform:Set_localPosition(0, 0, 1.4)
    transform.localRotation = Quaternion.Euler(-90, 0, 0)
    local rarityIcon = {
      go = transform.gameObject,
      render1 = transform:GetComponent(typeof(CS.UnityEngine.Renderer)),
      render2 = transform:Find("V_plane"):GetComponent(typeof(CS.UnityEngine.Renderer))
    }
    self:SetRarity(rarityIcon, self.triggerPoint.config.monsterRarity)
  end)
end

local function GetWeaponParent(self, gameObject)
  local childrenObj = gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Transform), true)
  if childrenObj.Length > 0 then
    for i = 0, childrenObj.Length - 1 do
      if childrenObj[i].name == "guadian" then
        return childrenObj[i].gameObject.transform
      end
    end
  end
  return nil
end

local function SetIcon(self, iconPath)
  self.hp_front_sprite:LoadSprite(iconPath)
end

local function OnUpdate(self)
  local targetX = self.hp_front_sprite.size.x
  local curX = self.hp_back_sprite.size.x
  if targetX > curX then
    self.hp_back_sprite.size = Vector2.New(targetX, HP_HEIGHT)
  elseif targetX < curX then
    self.hp_back_sprite.size = Vector2.New(targetX * HP_BACK_SPEED + curX * (1 - HP_BACK_SPEED), HP_HEIGHT)
  end
end

TriggerPointMonsterWithHp.__init = __init
TriggerPointMonsterWithHp.__delete = __delete
TriggerPointMonsterWithHp.SetActive = SetActive
TriggerPointMonsterWithHp.SetInfo = SetInfo
TriggerPointMonsterWithHp.SetRarity = SetRarity
TriggerPointMonsterWithHp.SetVal = SetVal
TriggerPointMonsterWithHp.SetIcon = SetIcon
TriggerPointMonsterWithHp.OnUpdate = OnUpdate
TriggerPointMonsterWithHp.Destroy = Destroy
TriggerPointMonsterWithHp.LoadPrefab = LoadPrefab
TriggerPointMonsterWithHp.Create = Create
TriggerPointMonsterWithHp.CreateHero = CreateHero
TriggerPointMonsterWithHp.GetModelResPath = GetModelResPath
TriggerPointMonsterWithHp.GetWeaponParent = GetWeaponParent
return TriggerPointMonsterWithHp
