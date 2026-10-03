local UILWSeasonStoveCenterRuleItem = BaseClass("UILWSeasonStoveCenterRuleItem", UIBaseContainer)
local base = UIBaseContainer
local v1_path = "Content/v1"
local v2_path = "Content/v2"

function UILWSeasonStoveCenterRuleItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, v2_path)
end

function UILWSeasonStoveCenterRuleItem:OnDestroy()
  self.v1 = nil
  self.v2 = nil
  base.OnDestroy(self)
end

function UILWSeasonStoveCenterRuleItem:ReInit(level, cityInfo)
  if cityInfo then
    self.v1:SetText("Lv." .. level)
    self.v2:SetText("+" .. string.GetFormattedSeparatorNum(cityInfo.season_snow_stone_value) .. "/h")
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

return UILWSeasonStoveCenterRuleItem
