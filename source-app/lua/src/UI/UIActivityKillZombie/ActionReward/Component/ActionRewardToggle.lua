local UIActivityKillZombieActionRewardToggle = BaseClass("UIActivityKillZombieActionRewardToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tab1_text_path = "tab1_text"
local tab12_text_path = "Choose/tab12_text"

function UIActivityKillZombieActionRewardToggle:OnCreate()
  base.OnCreate(self)
  self.toggle = self:AddComponent(UIToggle, "")
  self.tab1_text = self:AddComponent(UIText, tab1_text_path)
  self.tab12_text = self:AddComponent(UIText, tab12_text_path)
  self.toggle:SetOnValueChanged(function(tf)
    if tf and self.view ~= nil and self.param ~= nil then
      self.view:SelectTab(self.param.difficulty)
    end
  end)
end

function UIActivityKillZombieActionRewardToggle:OnDestroy()
  self.toggle = nil
  self.tab1_text = nil
  self.tab12_text = nil
  base.OnDestroy(self)
end

function UIActivityKillZombieActionRewardToggle:ActiveTab()
  self.toggle:SetIsOn(true)
end

function UIActivityKillZombieActionRewardToggle:ReInit(param, view)
  self.view = view
  self.param = param
  local realDifficultyInLevel = DataCenter.ActivityKillZombieManager.GetRelDifficultyInLevel(param.difficulty)
  self.tab1_text:SetLocalText("2010219", realDifficultyInLevel)
  self.tab12_text:SetLocalText("2010219", realDifficultyInLevel)
end

return UIActivityKillZombieActionRewardToggle
