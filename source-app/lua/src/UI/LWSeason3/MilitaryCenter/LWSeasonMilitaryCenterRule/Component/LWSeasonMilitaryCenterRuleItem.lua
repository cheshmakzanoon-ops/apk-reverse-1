local LWSeasonMilitaryCenterRuleItem = BaseClass("LWSeasonMilitaryCenterRuleItem", UIBaseContainer)
local base = UIBaseContainer
local v1_path = "Content/v1"
local v2_path = "Content/v2"

function LWSeasonMilitaryCenterRuleItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, v2_path)
end

function LWSeasonMilitaryCenterRuleItem:OnDestroy()
  self.v1 = nil
  self.v2 = nil
  base.OnDestroy(self)
end

function LWSeasonMilitaryCenterRuleItem:ReInit(level, buildInfo)
  if buildInfo then
    self.v1:SetText("Lv." .. level)
    self.v2:SetText("+" .. string.GetFormattedSeparatorNum(toInt(buildInfo.hour_product_stone[ResourceType.AllianceStone]) * SEASON_MUMMY_RES_TIME_SCALE) .. "/h")
  else
    self.v1:SetText("")
    self.v2:SetText("")
  end
  if level % 2 == 1 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di1.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di2.png")
  end
end

return LWSeasonMilitaryCenterRuleItem
