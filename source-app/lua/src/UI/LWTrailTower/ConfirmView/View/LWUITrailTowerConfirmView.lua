local LWUITrailTowerConfirmView = BaseClass("LWUITrailTowerConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local titleText_path = "UICommonMiniPopUpTitle/titleText"
local desText_path = "UICommonMiniPopUpTitle/DesName"
local recommendCombatPowerText_path = "UICommonMiniPopUpTitle/RightContent/Content1/RecommendPowerText"
local recommendArmyLevelText_path = "UICommonMiniPopUpTitle/RightContent/Content2/RecommendArmyLevelText"
local ownPowerText_path = "UICommonMiniPopUpTitle/LeftContent/Content1/OwnPowerText"
local ownArmyLevelText_path = "UICommonMiniPopUpTitle/LeftContent/Content2/OwnArmyLevelText"
local closeBtn_path = "UICommonMiniPopUpTitle/panel"
local confirmBtn_path = "BtnGo/ConfirmBtn"
local cancelBtn_path = "BtnGo/CancelBtn"
local confirmBtnText_path = "BtnGo/ConfirmBtn/ConfirmBtnText"
local cancelBtnText_path = "BtnGo/CancelBtn/CancelBtnText"
local recommendArmyLevelQualityImage_path = "UICommonMiniPopUpTitle/RightContent/Content2/RecommendArmyQualityImage"
local recommendArmyLevelIconImage_path = "UICommonMiniPopUpTitle/RightContent/Content2/RecommendArmyQualityImage/RecommendArmyIconImage"
local ownArmyLevelQualityImage_path = "UICommonMiniPopUpTitle/LeftContent/Content2/OwnArmyQualityImage"
local ownArmyLevelIconImage_path = "UICommonMiniPopUpTitle/LeftContent/Content2/OwnArmyQualityImage/OwnArmyIconImage"
local left_tips_text_path = "UICommonMiniPopUpTitle/LeftContent/LeftTipsText"
local left_head_item_path = "UICommonMiniPopUpTitle/LeftContent/LeftHeadItem"
local right_tips_text_path = "UICommonMiniPopUpTitle/RightContent/RightTipsText"
local right_head_item_path = "UICommonMiniPopUpTitle/RightContent/RightHeadItem"

function LWUITrailTowerConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.trailTowerTemplate, self.selectDifficultyGroup = self:GetUserData()
  self:ReInit()
end

function LWUITrailTowerConfirmView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerConfirmView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.recommendCombatPowerText = self:AddComponent(UIText, recommendCombatPowerText_path)
  self.recommendArmyLevelText = self:AddComponent(UIText, recommendArmyLevelText_path)
  self.ownPowerText = self:AddComponent(UIText, ownPowerText_path)
  self.ownArmyLevelText = self:AddComponent(UIText, ownArmyLevelText_path)
  self.cancelBtnText = self:AddComponent(UIText, cancelBtnText_path)
  self.cancelBtnText:SetLocalText("393109")
  self.confirmBtnText = self:AddComponent(UIText, confirmBtnText_path)
  self.confirmBtnText:SetLocalText("457057")
  self.recommendArmyLevelQualityImage = self:AddComponent(UIImage, recommendArmyLevelQualityImage_path)
  self.recommendArmyLevelIconImage = self:AddComponent(UIImage, recommendArmyLevelIconImage_path)
  self.ownArmyLevelQualityImage = self:AddComponent(UIImage, ownArmyLevelQualityImage_path)
  self.ownArmyLevelIconImage = self:AddComponent(UIImage, ownArmyLevelIconImage_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.cancelBtn = self:AddComponent(UIButton, cancelBtn_path)
  self.cancelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirmBtn = self:AddComponent(UIButton, confirmBtn_path)
  self.confirmBtn:SetOnClick(function()
    self:ConfirmBtnClick()
  end)
  self.left_tips_text = self:AddComponent(UITextMeshProUGUIEx, left_tips_text_path)
  self.left_tips_text:SetLocalText("trialtower_030")
  self.left_head_item = self:AddComponent(UICommonHead, left_head_item_path)
  self.right_tips_text = self:AddComponent(UITextMeshProUGUIEx, right_tips_text_path)
  self.right_tips_text:SetLocalText("trialtower_029")
  self.right_head_item = self:AddComponent(UICommonHead, right_head_item_path)
end

function LWUITrailTowerConfirmView:ComponentDestroy()
  self.titleText = nil
  self.desText = nil
  self.recommendCombatPowerText = nil
  self.recommendArmyLevelText = nil
  self.ownPowerText = nil
  self.ownArmyLevelText = nil
  self.closeBtn = nil
  self.cancelBtn = nil
  self.confirmBtn = nil
  self.recommendArmyLevelQualityImage = nil
  self.recommendArmyLevelIconImage = nil
  self.ownArmyLevelQualityImage = nil
  self.ownArmyLevelIconImage = nil
end

function LWUITrailTowerConfirmView:ReInit()
  self.titleText:SetLocalText("trialtower_027")
  local recommendPower = self.trailTowerTemplate:GetDifficultyGroup2Power(self.selectDifficultyGroup)
  self.recommendCombatPowerText:SetText(tostring(recommendPower))
  local recommendArmyLevel = self.trailTowerTemplate:GetDifficultyGroup2SoldierLevel(self.selectDifficultyGroup)
  self.recommendArmyLevelText:SetText("Lv." .. recommendArmyLevel)
  local recommendSoldierTemplate = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(recommendArmyLevel)
  self.recommendArmyLevelIconImage:LoadSprite(string.format(LoadPath.ItemPath, recommendSoldierTemplate.icon))
  self.recommendArmyLevelQualityImage:LoadSprite(UIUtil.GetItemQualityBg(recommendSoldierTemplate.quality))
  self.right_head_item:SetData(nil, nil, nil, nil, nil)
  local squadData = DataCenter.LWTrailTowerManager:GetTrailTowerFormation(self.trailTowerTemplate.id)
  local power = squadData == nil and 0 or squadData:GetTotalCapacity()
  if recommendPower <= power then
    self.ownPowerText:SetText("<color=#5FEF87>" .. math.ceil(power) .. "</color>")
  else
    self.ownPowerText:SetText("<color=#F97077>" .. math.ceil(power) .. "</color>")
  end
  local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
  local maxLevel = maxLevelSoldier ~= nil and maxLevelSoldier.lv or 0
  if recommendArmyLevel <= maxLevel then
    self.ownArmyLevelText:SetText("<color=#5FEF87>" .. "Lv." .. maxLevelSoldier.lv .. "</color>")
  else
    self.ownArmyLevelText:SetText("<color=#F97077>" .. "Lv." .. maxLevelSoldier.lv .. "</color>")
  end
  self.left_head_item:SetAsMyself()
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(maxLevelSoldier.id)
  self.ownArmyLevelIconImage:LoadSprite(string.format(LoadPath.ItemPath, soldierTemplate.icon))
  self.ownArmyLevelQualityImage:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
  if recommendPower > power or recommendArmyLevel > maxLevelSoldier.lv then
    self.desText:SetText(Localization:GetString("trialtower_040"))
  else
    local trailTowerName = Localization:GetString(self.trailTowerTemplate.name)
    self.desText:SetText(Localization:GetString("trialtower_028", self.selectDifficultyGroup, trailTowerName))
  end
end

function LWUITrailTowerConfirmView:ConfirmBtnClick()
  DataCenter.LWTrailTowerManager:OpenTrailTowerStagePanel(self.trailTowerTemplate.id, self.selectDifficultyGroup, true, false)
  self.ctrl:CloseSelf()
end

return LWUITrailTowerConfirmView
