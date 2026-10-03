local MailHonorItem = BaseClass("MailHonorItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local iconScale = Vector3.New(0.35, 0.35, 0.35)
local iconPath = {
  "Assets/Main/Sprites/BuildIconOutCity/UI_building_10116000.png",
  "Assets/Main/Sprites/BuildIconOutCity/UI_building_10117000.png",
  "Assets/Main/Sprites/BuildIconOutCity/UI_building_10213000.png"
}
local nameLanguage = {
  458297,
  458298,
  458299
}

function MailHonorItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailHonorItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailHonorItem:ComponentDefine()
  self.left = self:AddComponent(UIBaseComponent, "left")
  self.right = self:AddComponent(UIBaseComponent, "right")
  self.totalCountText1 = self:AddComponent(UIText, "left/TotalCountText1")
  self.totalCountText2 = self:AddComponent(UIText, "right/TotalCountText2")
  self.totalLevelText1 = self:AddComponent(UIText, "left/TotalLevelText1")
  self.totalLevelText2 = self:AddComponent(UIText, "right/TotalLevelText2")
  self.HonorImg1 = self:AddComponent(UIImage, "left/HonorCellTiny1/imgIcon1")
  self.HonorImg2 = self:AddComponent(UIImage, "right/HonorCellTiny2/imgIcon2")
end

function MailHonorItem:ComponentDestroy()
  self.HonorName1 = nil
  self.HonorName2 = nil
  self.HonorLevel1 = nil
  self.HonorLevel2 = nil
  self.HonorImg1 = nil
  self.HonorImg2 = nil
end

function MailHonorItem:SetData(index, hero1, hero2)
  local itemData = {}
  if hero1 then
    self.left:SetActive(true)
    local iconPath = iconPath[index]
    if not string.IsNullOrEmpty(iconPath) then
      self.HonorImg1:LoadSpriteAuto(iconPath)
      self.HonorImg1:SetLocalScaleXYZ(iconScale.x, iconScale.y, iconScale.z)
    end
    self.totalCountText1:SetText(Localization:GetString("458643") .. hero1.count)
    self.totalLevelText1:SetText("Lv." .. hero1.totalLevel)
  else
    self.left:SetActive(false)
  end
  if hero2 then
    self.right:SetActive(true)
    local iconPath = iconPath[index]
    if not string.IsNullOrEmpty(iconPath) then
      self.HonorImg2:LoadSpriteAuto(iconPath)
      self.HonorImg1:SetLocalScaleXYZ(iconScale.x, iconScale.y, iconScale.z)
    end
    self.totalCountText2:SetText(Localization:GetString("458643") .. hero2.count)
    self.totalLevelText2:SetText("Lv." .. hero2.totalLevel)
  else
    self.right:SetActive(false)
  end
end

function MailHonorItem:OnEnable()
  base.OnEnable(self)
end

function MailHonorItem:OnDisable()
  base.OnDisable(self)
end

function MailHonorItem:OnAddListener()
  base.OnAddListener(self)
end

function MailHonorItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailHonorItem
