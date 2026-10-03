local base = UIBaseContainer
local UIEquipItemComponent = BaseClass("UIEquipItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIEquipItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIEquipItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIEquipItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.imgQuality = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textEquipLevelTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgOwnBg = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgSelectMask = self.viewSkin:AddComponent(self, UIImage, 7)
end

function UIEquipItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnClick = nil
  self.imgQuality = nil
  self.imgIcon = nil
  self.textEquipLevelTxt = nil
  self.textNum = nil
  self.imgOwnBg = nil
  self.imgSelectMask = nil
end

function UIEquipItemComponent:DataDefine()
  self.equipData = nil
  self.callBack = nil
end

function UIEquipItemComponent:SetData(equipData, index, showOwn, callBack)
  self.equipData = equipData
  self.showOwn = showOwn
  self.index = index
  self.callBack = callBack
  self:Refresh()
end

function UIEquipItemComponent:DataDestroy()
  self.equipData = nil
  self.callBack = nil
  self.showOwn = nil
  self.index = nil
end

function UIEquipItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIEquipItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIEquipItemComponent:Refresh()
  if not self.equipData then
    return
  end
  self.textEquipLevelTxt:SetActive(false)
  self.textEquipLevelTxt:SetText("Lv." .. (self.equipData.level or 1))
  self.imgQuality:LoadSprite(DataCenter.LWSkyBattleGrowthChapterManager:GetQualityIcon(self.equipData.quality))
  self.imgIcon:LoadSprite(self.equipData.icon)
  if self.equipData.wearing and self.showOwn then
    self.imgOwnBg:SetActive(true)
  else
    self.imgOwnBg:SetActive(false)
  end
  self.imgSelectMask:SetActive(false)
end

function UIEquipItemComponent:ShowSelectMask(show)
  self.imgSelectMask:SetActive(show)
end

function UIEquipItemComponent:OnBtnClickClick()
  if self.callBack ~= nil then
    self.callBack(self.transform, self.index)
  end
end

return UIEquipItemComponent
