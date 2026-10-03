local UIDesertBattleIntroductionItem = BaseClass("UIDesertBattleIntroductionItem", UIBaseContainer)
local base = UIBaseContainer

function UIDesertBattleIntroductionItem:OnCreate()
  base.OnCreate(self)
  self.text_title = self:AddComponent(UIText, "bg/TitleText")
  self.text_desc = self:AddComponent(UIText, "DescText")
  self.img = self:AddComponent(UIRawImage, "RawImg")
end

function UIDesertBattleIntroductionItem:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleIntroductionItem:SetData(data)
  self.text_title:SetLocalText(data.title)
  self.text_desc:SetLocalText(data.desc)
  local flag = not string.IsNullOrEmpty(data.icon)
  self.img:SetActive(flag)
  if flag then
    self.img:LoadSpriteAuto(data.icon)
  end
end

return UIDesertBattleIntroductionItem
