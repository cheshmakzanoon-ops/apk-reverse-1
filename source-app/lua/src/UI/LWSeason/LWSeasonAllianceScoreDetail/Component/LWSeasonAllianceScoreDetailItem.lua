local LWSeasonAllianceScoreDetailItem = BaseClass("LWSeasonAllianceScoreDetailItem", UIBaseContainer)
local base = UIBaseContainer

function LWSeasonAllianceScoreDetailItem:OnCreate()
  base.OnCreate(self)
  self.item = self:AddComponent(UIImage, "")
  self.t1 = self:AddComponent(UIText, "t1")
  self.t2 = self:AddComponent(UIText, "t2")
  self.v1 = self:AddComponent(UIText, "v1")
  self.v2 = self:AddComponent(UIText, "v2")
end

function LWSeasonAllianceScoreDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonAllianceScoreDetailItem:ReInit(index, data, isTitle)
  if isTitle then
    self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di2.png")
  elseif index % 2 == 0 then
    self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di3.png")
  else
    self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di1.png")
  end
  self.t1:SetActive(isTitle)
  self.t2:SetActive(isTitle)
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

return LWSeasonAllianceScoreDetailItem
