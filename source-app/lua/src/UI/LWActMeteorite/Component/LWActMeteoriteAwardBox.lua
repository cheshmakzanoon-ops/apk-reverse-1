local LWActMeteoriteAwardBox = BaseClass("LWActMeteoriteAwardBox", UIBaseContainer)
local base = UIBaseContainer
local eff_light_path = "VFX_ui_box_light"
local icon_path = "Icon"
local eff_reward_path = "VFX_ui_box_reward"
local btn_path = "Button"
local diamond_bg_path = "DiamondBg"
local num_text_path = "DiamondBg/NumText"

function LWActMeteoriteAwardBox:OnCreate()
  base.OnCreate(self)
  self.eff_light = self:AddComponent(UIBaseContainer, eff_light_path)
  self.animator = self:AddComponent(UIAnimator, icon_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.eff_reward = self:AddComponent(UIBaseContainer, eff_reward_path)
  self.diamond_bg = self:AddComponent(UIImage, diamond_bg_path)
  self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view:OpenRewardTips(self.boxIndex)
  end)
end

function LWActMeteoriteAwardBox:OnDestroy()
  self.eff_light = nil
  self.animator = nil
  self.icon = nil
  self.eff_reward = nil
  self.diamond_bg = nil
  self.num_text = nil
  self.btn = nil
  base.OnDestroy(self)
end

function LWActMeteoriteAwardBox:SetBoxInfo(idx, boxIndex, config)
  self.boxIndex = boxIndex
  local state = DataCenter.ActMeteoriteBattleManager:GetBoxStateByCfg(config)
  self.eff_light:SetActive(state == 2)
  local nameIdx = idx * 2
  if state ~= 3 then
    nameIdx = nameIdx - 1
  end
  local boxName = string.format("UIAllianceArmament_img_reward0%d.png", nameIdx)
  local iconPath = string.format(LoadPath.LWActMeteoriteBattlePath, boxName)
  self.icon:LoadSpriteAuto(iconPath)
  self.animator:Play(state == 2 and "box_open" or "box_unOpen", 0, 0)
  self.eff_reward:SetActive(state == 2)
  self.diamond_bg:SetActive(state ~= 3)
  self.num_text:SetText(string.GetFormattedSeperatorNum(toInt(config.value)))
end

return LWActMeteoriteAwardBox
