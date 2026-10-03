local LWSeason4MilitaryCenterCarrierRuleItem = BaseClass("LWSeason4MilitaryCenterCarrierRuleItem", UIBaseContainer)
local base = UIBaseContainer
local v1_path = "Content/v1"
local v2_path = "Content/v2"

function LWSeason4MilitaryCenterCarrierRuleItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, v2_path)
end

function LWSeason4MilitaryCenterCarrierRuleItem:OnDestroy()
  self.v1 = nil
  self.v2 = nil
  base.OnDestroy(self)
end

function LWSeason4MilitaryCenterCarrierRuleItem:ReInit(level, meta)
  if level % 2 == 1 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di1.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di2.png")
  end
  if meta.build_level == meta.max_level then
    self.v1:SetText(string.GetFormattedSeparatorNum(toInt(meta.total_stone_exp_value)) .. "+")
  else
    self.v1:SetText(string.GetFormattedSeparatorNum(toInt(meta.total_stone_exp_value)))
  end
  self.v2:SetText("Lv." .. meta.build_level)
end

return LWSeason4MilitaryCenterCarrierRuleItem
