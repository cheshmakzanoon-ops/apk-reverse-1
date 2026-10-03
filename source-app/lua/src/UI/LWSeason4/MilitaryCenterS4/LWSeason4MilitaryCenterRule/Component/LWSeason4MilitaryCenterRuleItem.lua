local LWSeason4MilitaryCenterRuleItem = BaseClass("LWSeason4MilitaryCenterRuleItem", UIBaseContainer)
local base = UIBaseContainer
local v1_path = "Content/v1"
local v2_path = "Content/v2"

function LWSeason4MilitaryCenterRuleItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, v2_path)
end

function LWSeason4MilitaryCenterRuleItem:OnDestroy()
  self.v1 = nil
  self.v2 = nil
  base.OnDestroy(self)
end

function LWSeason4MilitaryCenterRuleItem:ReInit(level, buildInfo)
  if buildInfo then
    self.v1:SetText("Lv." .. level)
    self.v2:SetText(UIUtil.GetMinuteSpeedStr(buildInfo.electricity * 60))
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

return LWSeason4MilitaryCenterRuleItem
