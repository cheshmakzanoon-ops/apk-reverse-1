local base = UIBaseContainer
local UIAllianceCommonSkillInfoItem = BaseClass("UIAllianceCommonSkillInfoItem", base)
local week_text_path = "go_week/weekText"
local time_text_path = "go_time/timeText"
local name_text_path = "go_name/nameText"

function UIAllianceCommonSkillInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllianceCommonSkillInfoItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillInfoItem:ComponentDefine()
  self.week_text = self:AddComponent(UITextMeshProUGUIEx, week_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
end

function UIAllianceCommonSkillInfoItem:ComponentDestroy()
  self.week_text = nil
  self.time_text = nil
  self.name_text = nil
end

function UIAllianceCommonSkillInfoItem:ReInit(aStr, bStr, cStr)
  self.week_text:SetText(aStr)
  self.time_text:SetText(bStr)
  self.name_text:SetText(cStr)
end

return UIAllianceCommonSkillInfoItem
