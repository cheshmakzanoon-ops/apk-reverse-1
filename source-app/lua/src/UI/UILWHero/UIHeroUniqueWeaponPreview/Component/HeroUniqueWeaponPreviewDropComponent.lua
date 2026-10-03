local base = UIBaseContainer
local HeroUniqueWeaponPreviewDropComponent = BaseClass("HeroUniqueWeaponPreviewDropComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local HeroUniqueWeaponPreviewDropItemComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewDropItemComponent")

function HeroUniqueWeaponPreviewDropComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroUniqueWeaponPreviewDropComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewDropComponent:ClearItems()
  self.compDropContent:RemoveComponents(HeroUniqueWeaponPreviewDropItemComponent)
  self.compLevelLine.gameObject:GameObjectRecycleAll()
  self.dropItems = nil
end

function HeroUniqueWeaponPreviewDropComponent:ReInit()
  self.compDropdown:SetActive(false)
  if self.view == nil then
    return
  end
  if self.dropItems == nil then
    self:ClearItems()
    self.dropItems = {}
    local allLv = self.view:GetAllLvList()
    if table.IsNullOrEmpty(allLv) then
      return
    end
    for i, v in pairs(allLv) do
      local item = self.compLevelLine.gameObject:GameObjectSpawn(self.compDropContent.transform)
      item.name = "item" .. i
      local obj = self.compDropContent:AddComponent(HeroUniqueWeaponPreviewDropItemComponent, item.name)
      obj:SetActive(true)
      obj:ReInit(v, self.clickItemCallBack)
      table.insert(self.dropItems, obj)
    end
  end
  self:UpdateSelect()
  local heroId = self.view:GetHeroId()
  if heroId then
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    if heroConfig then
      self.imgCurSelectTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroConfig.type, true))
    end
  end
end

function HeroUniqueWeaponPreviewDropComponent:UpdateSelect()
  if self.dropItems then
    for i, v in pairs(self.dropItems) do
      v:UpdateSelect()
    end
  end
  local curLv = self.view:GetSelectLv()
  self.textCurSelectLevel:SetText("Lv." .. tostring(curLv))
end

function HeroUniqueWeaponPreviewDropComponent:ComponentDefine()
  self.textCurSelectLevel = self:AddComponent(UITextMeshProUGUIEx, "CurSelectedLevel/CurSelectLevelText")
  self.imgCurSelectTypeIcon = self:AddComponent(UIImage, "CurSelectedLevel/CurSelectTypeIcon")
  self.btnDropdown = self:AddComponent(UIButton, "CurSelectedLevel/DropdownBtn")
  self.btnDropdown:SetOnClick(function()
    self:OnBtnDropdownClick()
  end)
  self.compDropdown = self:AddComponent(UIBaseContainer, "Dropdown")
  self.btnCloseDrop = self:AddComponent(UIButton, "Dropdown/CloseDropBtn")
  self.btnCloseDrop:SetOnClick(function()
    self:OnBtnCloseDropClick()
  end)
  self.compDropContent = self:AddComponent(UIBaseContainer, "Dropdown/DropContent")
  self.compLevelLine = self:AddComponent(HeroUniqueWeaponPreviewDropItemComponent, "Dropdown/LevelLine")
  self.compLevelLine.gameObject:GameObjectCreatePool()
  self.compLevelLine:SetActive(false)
  self.dropItems = nil
end

function HeroUniqueWeaponPreviewDropComponent:ComponentDestroy()
  self:ClearItems()
  self.textCurSelectLevel = nil
  self.imgCurSelectTypeIcon = nil
  self.btnDropdown = nil
  self.compDropdown = nil
  self.btnCloseDrop = nil
  self.compDropContent = nil
  self.compLevelLine = nil
end

function HeroUniqueWeaponPreviewDropComponent:DataDefine()
  self.clickItemCallBack = BindCallback(self, self.OnClickItem)
end

function HeroUniqueWeaponPreviewDropComponent:DataDestroy()
  self.clickItemCallBack = nil
end

function HeroUniqueWeaponPreviewDropComponent:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewDropComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HeroUniqueWeaponPreviewDropComponent:OnBtnDropdownClick()
  local isActive = self.compDropdown.gameObject.activeSelf
  self.compDropdown:SetActive(not isActive)
end

function HeroUniqueWeaponPreviewDropComponent:OnBtnCloseDropClick()
  self.compDropdown:SetActive(false)
end

function HeroUniqueWeaponPreviewDropComponent:OnClickItem(lv)
  self.view:SetSelectLv(lv)
end

return HeroUniqueWeaponPreviewDropComponent
