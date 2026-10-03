local MailScoutDecoItem = BaseClass("MailScoutDecoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local IconPath = {
  [3] = "Assets/Main/Sprites/ItemIcons/daoju_building_103301000.png",
  [4] = "Assets/Main/Sprites/ItemIcons/daoju_building_103401000.png",
  [5] = "Assets/Main/Sprites/ItemIcons/daoju_building_103506000.png"
}

function MailScoutDecoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailScoutDecoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutDecoItem:ComponentDefine()
  self.quality1 = self:AddComponent(UIImage, "quality1")
  self.icon1 = self:AddComponent(UIImage, "quality1/icon1")
  self.num1 = self:AddComponent(UIText, "num1")
  self.level1 = self:AddComponent(UIText, "level1")
end

function MailScoutDecoItem:ComponentDestroy()
  self.quality1 = nil
  self.icon1 = nil
  self.num1 = nil
  self.level1 = nil
end

function MailScoutDecoItem:SetData(param1, isHide)
  self.quality1:LoadSprite(UIUtil.GetItemQualityBg(param1.decoQualityId))
  self.icon1:LoadSprite(IconPath[param1.decoQualityId])
  if isHide then
    self.num1:SetLocalText(320479, GameDialogDefine.QUESTION_MARK)
    self.level1:SetText("Lv." .. GameDialogDefine.QUESTION_MARK)
    return
  else
    self.num1:SetLocalText(320479, param1.totalCount)
    self.level1:SetText("Lv." .. param1.totalLv)
  end
end

function MailScoutDecoItem:DataDefine()
end

function MailScoutDecoItem:DataDestroy()
end

function MailScoutDecoItem:OnEnable()
  base.OnEnable(self)
end

function MailScoutDecoItem:OnDisable()
  base.OnDisable(self)
end

function MailScoutDecoItem:OnAddListener()
  base.OnAddListener(self)
end

function MailScoutDecoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailScoutDecoItem
