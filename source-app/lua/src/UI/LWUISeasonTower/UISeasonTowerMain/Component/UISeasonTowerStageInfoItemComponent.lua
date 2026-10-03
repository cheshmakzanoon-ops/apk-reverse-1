local base = UIBaseContainer
local UISeasonTowerStageInfoItemComponent = BaseClass("UISeasonTowerStageInfoItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISeasonTowerStageInfoItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISeasonTowerStageInfoItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerStageInfoItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textStageNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgStageBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compKacheNowImg = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textStageNowNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UISeasonTowerStageInfoItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textStageNum = nil
  self.imgStageBg = nil
  self.compKacheNowImg = nil
  self.textStageNowNum = nil
end

function UISeasonTowerStageInfoItemComponent:DataDefine()
end

function UISeasonTowerStageInfoItemComponent:DataDestroy()
end

function UISeasonTowerStageInfoItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonTowerStageInfoItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonTowerStageInfoItemComponent:SetData(floor, isCenter)
  self.compKacheNowImg:SetActive(isCenter)
  self.textStageNum:SetActive(not isCenter)
  self.imgStageBg:SetActive(not isCenter)
  self.textStageNum:SetText(floor)
  self.textStageNowNum:SetText(floor)
end

return UISeasonTowerStageInfoItemComponent
