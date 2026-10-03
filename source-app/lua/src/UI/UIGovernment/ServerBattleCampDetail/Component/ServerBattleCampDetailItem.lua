local ServerBattleCampDetailItem = BaseClass("ServerBattleCampDetailItem", UIBaseContainer)
local base = UIBaseContainer

function ServerBattleCampDetailItem:OnCreate()
  base.OnCreate(self)
  self.big_image = self:AddComponent(UIRawImage, "BigImage")
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, "TextScrollRect/ViewPort/TitleText")
end

function ServerBattleCampDetailItem:OnDestroy()
  self.big_image = nil
  self.title_text = nil
  base.OnDestroy(self)
end

function ServerBattleCampDetailItem:ReInit(data)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy then
    self.big_image:LoadSprite("Assets/Main/SeasonRes/S3/Textures/King/ppt/" .. data.img)
  else
    self.big_image:LoadSprite(data.img)
  end
  self.title_text:SetLocalText(data.txt)
end

return ServerBattleCampDetailItem
