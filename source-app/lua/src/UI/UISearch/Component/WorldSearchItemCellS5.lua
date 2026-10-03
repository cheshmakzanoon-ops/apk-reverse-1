local base = UIBaseContainer
local WorldSearchItemCellS5 = BaseClass("WorldSearchItemCellS5", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ARMY_TYPE_SPRITE = {
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_tanke.png",
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_feiji.png",
  "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_huojian.png"
}

function WorldSearchItemCellS5:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorldSearchItemCellS5:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldSearchItemCellS5:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgMonsterIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.compSelection = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.btnChange = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnChange:SetOnClick(function()
    self:OnBtnChangeClick()
  end)
  self.textMonsterName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgArmyType = self.viewSkin:AddComponent(self, UIImage, 5)
  self.lock = self:AddComponent(UIBaseComponent, "lock")
  self.act = self:AddComponent(UIText, "flag/act")
  self.act:SetLocalText("2010117")
  self.flag = self:AddComponent(UIImage, "flag")
end

function WorldSearchItemCellS5:ComponentDestroy()
  self.viewSkin = nil
  self.imgMonsterIcon = nil
  self.compSelection = nil
  self.btnChange = nil
  self.textMonsterName = nil
  self.imgArmyType = nil
  self.lock = nil
end

function WorldSearchItemCellS5:DataDefine()
end

function WorldSearchItemCellS5:DataDestroy()
end

function WorldSearchItemCellS5:OnAddListener()
  base.OnAddListener(self)
end

function WorldSearchItemCellS5:OnRemoveListener()
  base.OnRemoveListener(self)
end

function WorldSearchItemCellS5:OnBtnChangeClick()
  self.holder:ShowSelection(self.compSelection:GetPosition())
end

function WorldSearchItemCellS5:SetGray(isLock)
  CS.UIGray.SetGray(self.transform, isLock, true)
end

function WorldSearchItemCellS5:SetMonster(config, index, isLock)
  if config then
    self.imgMonsterIcon:LoadSprite(config.icon)
    self.imgMonsterIcon:SetNativeSize()
    self.textMonsterName:SetLocalText(config.name)
  end
  self.imgArmyType:SetActive(true)
  self.imgArmyType:LoadSprite(ARMY_TYPE_SPRITE[index])
  self.flag:SetActive(false)
  CS.UIGray.SetGray(self.transform, false, true)
  self.btnChange:SetActive(not isLock)
  self.lock:SetActive(isLock)
end

function WorldSearchItemCellS5:Refresh(config, v)
  if config then
    self.imgMonsterIcon:LoadSprite(config.icon)
    self.imgMonsterIcon:SetNativeSize()
    self.textMonsterName:SetLocalText(config.name)
  end
  self.imgArmyType:SetActive(false)
  self.flag:SetActive(v ~= nil and v.activityType ~= nil)
  self.btnChange:SetActive(false)
  self.lock:SetActive(false)
end

return WorldSearchItemCellS5
