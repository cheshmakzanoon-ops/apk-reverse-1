local MailScoutHonorItem = BaseClass("MailScoutHonorItem", UIBaseContainer)
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

function MailScoutHonorItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailScoutHonorItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutHonorItem:ComponentDefine()
  self.totalCountText1 = self:AddComponent(UIText, "num1")
  self.totalLevelText1 = self:AddComponent(UIText, "level1")
  self.HonorImg1 = self:AddComponent(UIImage, "quality1/icon1")
end

function MailScoutHonorItem:ComponentDestroy()
  self.HonorName1 = nil
  self.HonorName2 = nil
  self.HonorLevel1 = nil
  self.HonorLevel2 = nil
  self.HonorImg1 = nil
end

function MailScoutHonorItem:SetData(index, hero1, isHide)
  if hero1 then
    self:SetActive(true)
    local iconPath = iconPath[index]
    if not string.IsNullOrEmpty(iconPath) then
      self.HonorImg1:LoadSprite(iconPath)
    end
    if isHide then
      self.totalCountText1:SetText(Localization:GetString("458643") .. GameDialogDefine.QUESTION_MARK)
      self.totalLevelText1:SetText("Lv." .. GameDialogDefine.QUESTION_MARK)
    else
      self.totalCountText1:SetText(Localization:GetString("458643") .. hero1.count)
      self.totalLevelText1:SetText("Lv." .. hero1.totalLevel)
    end
  else
    self:SetActive(false)
  end
end

function MailScoutHonorItem:OnEnable()
  base.OnEnable(self)
end

function MailScoutHonorItem:OnDisable()
  base.OnDisable(self)
end

function MailScoutHonorItem:OnAddListener()
  base.OnAddListener(self)
end

function MailScoutHonorItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailScoutHonorItem
