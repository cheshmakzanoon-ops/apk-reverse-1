local UICapacityBoxItem = BaseClass("UICapacityBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UICapacityBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxItem:OnEnable()
  base.OnEnable(self)
end

function UICapacityBoxItem:OnDisable()
  base.OnDisable(self)
end

function UICapacityBoxItem:ComponentDefine()
  self.commonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self._name_txt = self:AddComponent(UIText, "Txt_Name")
  
  function self.clickCallBack()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end
end

function UICapacityBoxItem:ComponentDestroy()
  self.commonResItem = nil
  self._name_txt = nil
  self.clickCallBack = nil
end

function UICapacityBoxItem:DataDefine()
  self.param = {}
end

function UICapacityBoxItem:DataDestroy()
  self.param = nil
end

function UICapacityBoxItem:RefreshData(param)
  self.param = param
  param.clickCallBack = self.clickCallBack
  self.commonResItem:ReInit(param)
  self._name_txt:SetText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
end

function UICapacityBoxItem:OnBtnClick()
  if self.param.callback ~= nil then
    self.param.callback(self.transform, self.param.index, self.param.itemId)
  end
end

function UICapacityBoxItem:RefreshCount(count)
  if not self.param then
    return
  end
  if self.param.perCount then
    self.param.count = count * self.param.perCount
  else
    self.param.count = count
  end
  self.commonResItem:ReInit(self.param)
end

return UICapacityBoxItem
