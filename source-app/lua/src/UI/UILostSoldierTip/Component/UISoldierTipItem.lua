local UISoldierTipItem = BaseClass("UISoldierTipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local iconImg_path = "UISoldierTipItem/clickBtn/ItemIcon"
local qualityImg_path = "UISoldierTipItem/clickBtn/ImgQuality"
local soldierLvText_path = "ItemSoldierLv"
local soldierCountText_path = "ItemSoldierCount"

function UISoldierTipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISoldierTipItem:OnDisable()
  self.data = nil
end

function UISoldierTipItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, iconImg_path)
  self.qualityBg = self:AddComponent(UIImage, qualityImg_path)
  self.LvText = self:AddComponent(UIText, soldierLvText_path)
  self.CountText = self:AddComponent(UIText, soldierCountText_path)
end

function UISoldierTipItem:SetData(data, soldierData)
  self.data = data
  self.soldierData = soldierData
  self:RefreshUIShow()
end

function UISoldierTipItem:RefreshUIShow()
  local soldierTempalte = DataCenter.SoldierDataManager:GetTemplate(self.data.id or self.data.soldierId)
  if soldierTempalte == nil then
    return
  end
  local type = self.soldierData and T11Util.GetSoldierTypeByEffectList(self.soldierData.effects) or T11SoldierType.T11NotUnLock
  local stage = self.soldierData and self.soldierData.stage or 0
  self.icon:LoadSpriteAsync(DataCenter.SoldierDataManager:GetSoldierIconById(self.data.id or self.data.soldierId, {type = type, stage = stage}))
  self.qualityBg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.RESOURCE_ITEM, soldierTempalte.id))
  self.LvText:SetText("Lv." .. soldierTempalte.lv)
  self.CountText:SetText(string.GetFormattedStr(self.data.count))
end

function UISoldierTipItem:ComponentDestroy()
  self.icon = nil
  self.qualityBg = nil
  self.LvText = nil
  self.CountText = nil
end

return UISoldierTipItem
