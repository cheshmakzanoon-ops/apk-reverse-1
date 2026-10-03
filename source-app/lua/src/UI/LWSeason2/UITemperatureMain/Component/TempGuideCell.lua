local TempGuideCell = BaseClass("TempGuideCell", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "icon"
local title_path = "title"
local desc_path = "desc"

function TempGuideCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TempGuideCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempGuideCell:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

function TempGuideCell:ComponentDestroy()
end

function TempGuideCell:SetData(data)
  self.icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UISeasonHint/%s.png", data[3]))
  self.title:SetLocalText(data[4])
  self.desc:SetLocalText(data[5])
end

return TempGuideCell
