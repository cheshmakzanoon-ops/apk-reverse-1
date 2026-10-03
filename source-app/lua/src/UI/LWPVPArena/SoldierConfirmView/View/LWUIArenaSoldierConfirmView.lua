local LWUIArenaSoldierConfirmView = BaseClass("LWUIArenaSoldierConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local titleText_path = "UICommonMiniPopUpTitle/titleText"
local desText_path = "UICommonMiniPopUpTitle/DesName"
local recommendCombatPowerText_path = "UICommonMiniPopUpTitle/ContentBase/RightContent/LayoutPower/RecommendCombatPowerText"
local recommendArmyLevelText_path = "UICommonMiniPopUpTitle/ContentBase/RightContent/RecommendArmyLevelText"
local ownPowerText_path = "UICommonMiniPopUpTitle/ContentBase/LeftContent/LayoutPower/OwnPowerText"
local ownArmyLevelText_path = "UICommonMiniPopUpTitle/ContentBase/LeftContent/OwnArmyLevelText"
local closeBtn_path = "UICommonMiniPopUpTitle/panel"
local confirmBtn_path = "BtnGo/ConfirmBtn"
local cancelBtn_path = "BtnGo/CancelBtn"
local confirmBtnText_path = "BtnGo/ConfirmBtn/ConfirmBtnText"
local cancelBtnText_path = "BtnGo/CancelBtn/CancelBtnText"
local recommendArmyLevelQualityImage_path = "UICommonMiniPopUpTitle/ContentBase/RightContent/RecommendArmyQualityImage"
local recommendArmyLevelIconImage_path = "UICommonMiniPopUpTitle/ContentBase/RightContent/RecommendArmyQualityImage/RecommendArmyIconImage"
local ownArmyLevelQualityImage_path = "UICommonMiniPopUpTitle/ContentBase/LeftContent/OwnArmyQualityImage"
local ownArmyLevelIconImage_path = "UICommonMiniPopUpTitle/ContentBase/LeftContent/OwnArmyQualityImage/OwnArmyIconImage"
local ownPlayerHead_path = "UICommonMiniPopUpTitle/ContentBase/LeftContent/headLeft"
local armyPlayerHead_path = "UICommonMiniPopUpTitle/ContentBase/RightContent/headRight"

function LWUIArenaSoldierConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.myData, self.enemyData = self:GetUserData()
  self:ReInit()
end

function LWUIArenaSoldierConfirmView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIArenaSoldierConfirmView:ComponentDefine()
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
  self.compPlayerHeadOwn = self:AddComponent(UICommonHead, ownPlayerHead_path)
  self.compPlayerHeadEnemy = self:AddComponent(UICommonHead, armyPlayerHead_path)
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
end

function LWUIArenaSoldierConfirmView:ComponentDestroy()
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

function LWUIArenaSoldierConfirmView:ReInit()
  self.titleText:SetLocalText("trialtower_027")
  local data = self:GetUserData()
  if data == nil then
    return
  end
  self.data = data
  self.desText:SetLocalText("warning_soldier_level")
  self.ownPowerText:SetText("<color=#5FEF87>" .. string.GetFormattedStr(data.myPower) .. "</color>")
  local mySoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(data.mySoldierData.id)
  if mySoldierTemplate ~= nil then
    local soldierLevel = mySoldierTemplate.lv
    self.ownArmyLevelText:SetText(string.format("Lv.%d", soldierLevel))
    local soldierIcon = string.format(LoadPath.ItemPath, mySoldierTemplate.icon)
    self.ownArmyLevelIconImage:LoadSprite(soldierIcon)
    self.ownArmyLevelQualityImage:LoadSprite(UIUtil.GetItemQualityBg(mySoldierTemplate.quality))
  end
  self.compPlayerHeadOwn:SetData(data.myHeadData.uid, data.myHeadData.pic, data.myHeadData.picVer)
  self.recommendCombatPowerText:SetText("<color=#5FEF87>" .. string.GetFormattedStr(data.enemyPower) .. "</color>")
  local enemySoldierTemplate = DataCenter.SoldierDataManager:GetTemplate(data.enemySoldierData.id)
  if enemySoldierTemplate ~= nil then
    local soldierLevel = enemySoldierTemplate.lv
    self.recommendArmyLevelText:SetText(string.format("Lv.%d", soldierLevel))
    local soldierIcon = string.format(LoadPath.ItemPath, enemySoldierTemplate.icon)
    self.recommendArmyLevelIconImage:LoadSprite(soldierIcon)
    self.recommendArmyLevelQualityImage:LoadSprite(UIUtil.GetItemQualityBg(enemySoldierTemplate.quality))
  end
  self.compPlayerHeadEnemy:SetData(data.enemyHeadData.uid, data.enemyHeadData.pic, data.enemyHeadData.picVer)
end

function LWUIArenaSoldierConfirmView:ConfirmBtnClick()
  local data = self:GetUserData()
  if data ~= nil and data.confirmCallback ~= nil then
    data.confirmCallback()
  end
  self.ctrl:CloseSelf()
end

return LWUIArenaSoldierConfirmView
