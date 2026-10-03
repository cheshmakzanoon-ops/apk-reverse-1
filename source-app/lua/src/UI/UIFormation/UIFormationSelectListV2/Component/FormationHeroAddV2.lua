local FormationHeroAddV2 = BaseClass("FormationHeroAddV2", UIBaseContainer)
local base = UIBaseContainer
local add_img_path = "addImage"
local lock_img_path = "lockImage"
local add_effect_path = "addImage/effect"
local unlock_level_path = "lockImage/unlockLevel"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnSelectClick()
  end)
  self.add_img = self:AddComponent(UIImage, add_img_path)
  self.lock_img = self:AddComponent(UIImage, lock_img_path)
  self.add_effect = self:AddComponent(UIBaseContainer, add_effect_path)
  self.unlock_level_text = self:AddComponent(UIText, unlock_level_path)
end

local function RefreshData(self, index, formationUuid, canAdd, garage)
  local showEffect = false
  self.heroIndex = index
  if not garage then
    self.isLock = false
    self.canAdd = false
  else
    self.isLock = true
    self.scienceId = 0
    self.canAdd = canAdd
    self.garage = garage
    self.formationUuid = formationUuid
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    if formation ~= nil then
      local maxNum = MarchUtil.GetMaxHeroValueByFormationIndex(formation.index)
      self.isLock = index > maxNum
      if self.canAdd == true and self.isLock == false then
        local canAddNum = MarchUtil.GetCanAddHeroNum(formation.heroes, formation.index)
        if 0 < canAddNum then
          showEffect = true
        end
      end
    end
  end
  self.lock_img:SetActive(self.isLock)
  self.add_effect:SetActive(showEffect)
  if self.isLock == false then
    self.add_img:SetActive(true)
    self.add_img:LoadSprite("Assets/Main/Sprites/UI/UITroopsNew/UITroops_img_add.png")
  end
  self.unlock_level_text:SetText("")
end

local function OnSelectClick(self)
  if self.isLock == false then
    if self.canAdd == true then
      self.view:HideAllShowTip()
      self.view:OnEditClick(self.formationUuid, false)
    else
      UIUtil.ShowSingleTip(Localization:GetString("121000"))
    end
  elseif self.scienceId ~= 0 then
    GoToUtil.GotoScience(self.scienceId)
  end
end

FormationHeroAddV2.OnSelectClick = OnSelectClick
FormationHeroAddV2.OnCreate = OnCreate
FormationHeroAddV2.RefreshData = RefreshData
return FormationHeroAddV2
