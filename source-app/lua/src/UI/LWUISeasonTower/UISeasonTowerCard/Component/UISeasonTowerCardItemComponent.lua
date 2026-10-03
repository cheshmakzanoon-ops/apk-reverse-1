local base = UIBaseContainer
local UISeasonTowerCardItemComponent = BaseClass("UISeasonTowerCardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISeasonTowerCardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISeasonTowerCardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerCardItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFinishBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgUnFinishBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textFinishNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textUnFinishNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function UISeasonTowerCardItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgFinishBg = nil
  self.imgUnFinishBg = nil
  self.textFinishNum = nil
  self.textDesc = nil
  self.textUnFinishNum = nil
end

function UISeasonTowerCardItemComponent:DataDefine()
end

function UISeasonTowerCardItemComponent:DataDestroy()
end

function UISeasonTowerCardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonTowerCardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonTowerCardItemComponent:SetData(data)
  local currentLevel = DataCenter.LWSeasonTowerManager.battleCardTotalLevel
  local isFinish = currentLevel >= data.level
  self.imgFinishBg:SetActive(isFinish)
  self.imgUnFinishBg:SetActive(not isFinish)
  self.textDesc:SetText(Localization:GetString(data.name, table.unpack(data.param)))
  if isFinish then
    self.textDesc:SetColorRGBA255(9, 155, 74, 255)
  else
    self.textDesc:SetColorRGBA255(115, 104, 99, 255)
  end
  self.textFinishNum:SetText(data.level)
  self.textUnFinishNum:SetText(data.level)
end

return UISeasonTowerCardItemComponent
