local LWCommonScoreDetailItem = BaseClass("LWCommonScoreDetailItem", UIBaseContainer)
local base = UIBaseContainer

function LWCommonScoreDetailItem:OnCreate()
  base.OnCreate(self)
  self.item = self:AddComponent(UIImage, "")
  self.v1 = self:AddComponent(UIText, "v1")
  self.v2 = self:AddComponent(UIText, "v2")
end

function LWCommonScoreDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function LWCommonScoreDetailItem:SetData(index, data)
  if index % 2 == 0 then
    self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di3.png")
  else
    self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di1.png")
  end
  self.v1:SetActive(not isTitle)
  self.v2:SetActive(not isTitle)
  if data then
    self.v1:SetLocalText(data.name)
    self.v2:SetText("+" .. data.score)
  else
    self.v1:SetText("")
    self.v2:SetText("")
  end
end

return LWCommonScoreDetailItem
