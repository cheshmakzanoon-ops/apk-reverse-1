local base = UIBaseContainer
local HeroUniqueWeaponPreviewEffectComponent = BaseClass("HeroUniqueWeaponPreviewEffectComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local HeroUniqueWeaponPreviewDropComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewDropComponent")
local HeroUniqueWeaponPreviewEffectItemComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewEffectItemComponent")

function HeroUniqueWeaponPreviewEffectComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroUniqueWeaponPreviewEffectComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewEffectComponent:ReloadHeroSpine()
  if self.heroSpineLoadRequest ~= nil then
    return
  end
  if not self.heroData then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.heroData.modelId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  local request = ResourceManager:InstantiateAsync(spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  self.heroSpineLoadRequest = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.heroSpineLoadRequest = nil
      return
    end
    if not self.compHeroSpineContainer then
      return
    end
    request.gameObject:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(self.compHeroSpineContainer.transform)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0, 0)
    end
  end)
end

function HeroUniqueWeaponPreviewEffectComponent:ClearEffectItems()
  self.compEffectLayout:RemoveComponents(HeroUniqueWeaponPreviewEffectItemComponent)
  self.compEffectItem.gameObject:GameObjectRecycleAll()
  self.effectItems = nil
end

function HeroUniqueWeaponPreviewEffectComponent:RefreshEffects()
  if not self.heroData then
    return
  end
  local curSelectLv = self.view:GetSelectLv()
  local selectWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, curSelectLv)
  if selectWeaponTemplate == nil then
    return
  end
  local curWeaponTemplate = self.heroData:GetUniqueWeaponInfo()
  self.sortedAttrs = {}
  local weaponSortedAttrs = selectWeaponTemplate:GetSortedAttrs()
  for i = 1, #weaponSortedAttrs do
    if weaponSortedAttrs[i].key ~= HeroEffectDefine.HeroSkillMaxLevelAdd then
      local attr = weaponSortedAttrs[i]
      self.sortedAttrs[i] = {
        key = attr.key,
        value = self.heroData:ProcessEffectValue(attr.key, attr.value)
      }
    end
  end
  if curWeaponTemplate and curWeaponTemplate.lv ~= selectWeaponTemplate.lv then
    local curLvAttrs = {}
    local curLevelWeaponSortedAttrs = curWeaponTemplate:GetSortedAttrs()
    for i = 1, #curLevelWeaponSortedAttrs do
      if curLevelWeaponSortedAttrs[i].key ~= HeroEffectDefine.HeroSkillMaxLevelAdd then
        local attr = curLevelWeaponSortedAttrs[i]
        curLvAttrs[i] = {
          key = attr.key,
          value = self.heroData:ProcessEffectValue(attr.key, attr.value)
        }
      end
    end
    
    local function IsBiggerThenCurLv(key, value)
      if curLvAttrs then
        for k, v in pairs(curLvAttrs) do
          if v.key == key and value <= v.value then
            return false
          end
        end
        return true
      end
      return false
    end
    
    for i, v in pairs(self.sortedAttrs) do
      if IsBiggerThenCurLv(v.key, v.value) then
        v.showArrow = true
      end
    end
  end
  self:ClearEffectItems()
  self.effectItems = {}
  for i, v in pairs(self.sortedAttrs) do
    local item = self.compEffectItem.gameObject:GameObjectSpawn(self.compEffectLayout.transform)
    item.name = "item" .. i
    local obj = self.compEffectLayout:AddComponent(HeroUniqueWeaponPreviewEffectItemComponent, item.name)
    obj:SetActive(true)
    obj:ReInit(v)
    table.insert(self.effectItems, obj)
  end
  if selectWeaponTemplate.skill_level > 0 then
    local levelMax = self.heroData:ProcessEffectValue(HeroEffectDefine.HeroSkillMaxLevelAdd, selectWeaponTemplate.skill_level)
    self.textTips:SetLocalText("hero_weapon_preview_tips_1", tostring(levelMax))
    self.textTips:SetActive(true)
  else
    self.textTips:SetActive(false)
  end
end

function HeroUniqueWeaponPreviewEffectComponent:ReInit()
  self.compSelectLevelContent:ReInit()
  self.heroId = self.view:GetHeroId()
  self.heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.heroId)
  if self.heroData then
    self.textName:SetText(self.heroData:GetName())
    self.textNickname:SetText(self.heroData:GetNickName())
  end
  self:ReloadHeroSpine()
  self:RefreshEffects()
end

function HeroUniqueWeaponPreviewEffectComponent:ComponentDefine()
  self.compSelectLevelContent = self:AddComponent(HeroUniqueWeaponPreviewDropComponent, "SelectLevelContent")
  self.compHeroSpineContainer = self:AddComponent(UIBaseContainer, "HeroIcon/HeroIconMask/HeroSpineContainer")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "HeroInfo/NameText")
  self.textNickname = self:AddComponent(UITextMeshProUGUIEx, "HeroInfo/NicknameText")
  self.compEffectLayout = self:AddComponent(UIBaseContainer, "EffectLayout")
  self.compEffectItem = self:AddComponent(HeroUniqueWeaponPreviewEffectItemComponent, "EffectItem")
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "TipsText")
  self.compEffectItem.gameObject:GameObjectCreatePool()
end

function HeroUniqueWeaponPreviewEffectComponent:ComponentDestroy()
  self:ClearEffectItems()
  self.compSelectLevelContent = nil
  self.compHeroSpineContainer = nil
  self.textName = nil
  self.textNickname = nil
  self.compEffectLayout = nil
  self.compEffectItem = nil
  self.textTips = nil
end

function HeroUniqueWeaponPreviewEffectComponent:DataDefine()
end

function HeroUniqueWeaponPreviewEffectComponent:DataDestroy()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

function HeroUniqueWeaponPreviewEffectComponent:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewEffectComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return HeroUniqueWeaponPreviewEffectComponent
