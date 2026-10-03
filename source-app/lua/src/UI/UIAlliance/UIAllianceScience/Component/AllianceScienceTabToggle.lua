local AllianceScienceTabToggle = BaseClass("AllianceScienceTabToggle", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization
local tab_text_path = "tab_text"
local choose_path = "Choose"
local tab_2_text_path = "Choose/tab_2_text"
local reco_img_path = "reco_img"
local upgrade_img_path = "upgrade_img"

function AllianceScienceTabToggle:OnCreate()
  base.OnCreate(self)
  self.tab_1_text = self:AddComponent(UIText, tab_text_path)
  self.tab_2_text = self:AddComponent(UIText, tab_2_text_path)
  self.choose = self:AddComponent(UIImage, choose_path)
  self.reco_img = self:AddComponent(UIImage, reco_img_path)
  self.upgrade_img = self:AddComponent(UIImage, upgrade_img_path)
end

function AllianceScienceTabToggle:OnDestroy()
  base.OnDestroy(self)
end

function AllianceScienceTabToggle:OnEnable()
  base.OnEnable(self)
end

function AllianceScienceTabToggle:OnDisable()
  base.OnDisable(self)
end

function AllianceScienceTabToggle:ReInit(txt)
  self.tab_1_text:SetLocalText(txt)
  self.tab_2_text:SetLocalText(txt)
end

return AllianceScienceTabToggle
