local TacticalLevelDisplayLevelItem = BaseClass("TacticalLevelDisplayLevelItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalLevelDisplayAirItem = require("UI.UILWTacticalWeapon.UITacticalWeaponLevelDisplay.Component.TacticalLevelDisplayAirItem")
local TacticalLevelDisplaySkillItem = require("UI.UILWTacticalWeapon.UITacticalWeaponLevelDisplay.Component.TacticalLevelDisplaySkillItem")
local level_path = "level"
local skill_item_root_path = "skillItemRoot"
local air_item_root_path = "airItemRoot"

function TacticalLevelDisplayLevelItem:OnCreate()
  base.OnCreate(self)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.skill_item_root = self:AddComponent(UIBaseContainer, skill_item_root_path)
  self.air_item_root = self:AddComponent(UIBaseContainer, air_item_root_path)
  self.bg = self:AddComponent(UIImage, "bg")
end

function TacticalLevelDisplayLevelItem:OnDestroy()
  self.level = nil
  self.skill_item_root = nil
  self.air_item_root = nil
  if self.skillItemReq then
    self.skillItemReq:Destroy()
    self.skillItemReq = nil
  end
  if self.airItemReq then
    self.airItemReq:Destroy()
    self.airItemReq = nil
  end
  self.skillItem = nil
  self.airItem = nil
  base.OnDestroy(self)
end

function TacticalLevelDisplayLevelItem:OnEnable()
  base.OnEnable(self)
end

function TacticalLevelDisplayLevelItem:OnDisable()
  base.OnDisable(self)
end

function TacticalLevelDisplayLevelItem:SetData(template, weaponLevel)
  if template == nil then
    return
  end
  local isUnlock = weaponLevel >= template.display_level
  self.level:SetText(template.display_level)
  if template.skill_level > 0 then
    self:CreateSkillItem(template)
  end
  if not string.IsNullOrEmpty(template.display_drone_text) then
    self:CreateAirItem(template)
    if isUnlock then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_wurenji_dengji01.png")
    else
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_wurenji_dengji02.png")
    end
  end
  self.bg:SetNativeSize()
  self.template = template
  self.weaponLevel = weaponLevel
end

function TacticalLevelDisplayLevelItem:CreateSkillItem(template)
  self.skillItemReq = self:GameObjectInstantiateAsync(UIAssets.TacticalLevelDisplaySkillItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    go.transform:SetParent(self.skill_item_root.transform)
    rectTransform.anchoredPosition = Vector2.New(0, 0)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.skillItem = self.skill_item_root:AddComponent(TacticalLevelDisplaySkillItem, go.name)
    self.skillItem:SetData(template.skill_level, self.weaponLevel >= template.display_level)
  end)
end

function TacticalLevelDisplayLevelItem:CreateAirItem(template)
  self.airItemReq = self:GameObjectInstantiateAsync(UIAssets.TacticalLevelDisplayAirItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    go.transform:SetParent(self.air_item_root.transform)
    rectTransform.anchoredPosition = Vector2.New(0, 0)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.airItem = self.air_item_root:AddComponent(TacticalLevelDisplayAirItem, go.name)
    local param = {}
    param.posterFullName = template.display_drone_icon
    param.title = template.airDescTitle
    param.desc = template.airDesc
    param.level = template.display_level
    param.weaponLevel = self.weaponLevel
    self.airItem:SetData(param)
  end)
end

return TacticalLevelDisplayLevelItem
