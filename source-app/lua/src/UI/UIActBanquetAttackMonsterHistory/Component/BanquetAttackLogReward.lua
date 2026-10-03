local base = UIBaseContainer
local BanquetAttackLogReward = BaseClass("BanquetAttackLogReward", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BanquetAttackLogReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BanquetAttackLogReward:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BanquetAttackLogReward:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.compEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
end

function BanquetAttackLogReward:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.compEffect = nil
end

function BanquetAttackLogReward:DataDefine()
end

function BanquetAttackLogReward:DataDestroy()
end

function BanquetAttackLogReward:OnAddListener()
  base.OnAddListener(self)
end

function BanquetAttackLogReward:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BanquetAttackLogReward:ParseInfo(data)
  self.compUICommonResItem:ParseInfo(data)
end

function BanquetAttackLogReward:SetEffect(value)
  self.compEffect:SetActive(value)
end

return BanquetAttackLogReward
