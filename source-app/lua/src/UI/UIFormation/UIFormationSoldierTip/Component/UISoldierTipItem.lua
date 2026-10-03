local UISoldierTipItem = BaseClass("UISoldierTipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local iconImg_path = "UISoldierTipItem/clickBtn/ItemIcon"
local qualityImg_path = "UISoldierTipItem/clickBtn/ImgQuality"
local soldierLvText_path = "ItemSoldierLv"
local soldierCountText_path = "ItemSoldierCount"
local soldierMoraleText_path = "ItemSoldierMorale"

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
  self.MoraleText = self:AddComponent(UIText, soldierMoraleText_path)
end

function UISoldierTipItem:SetData(data)
  self.data = data
  self:RefreshUIShow()
end

function UISoldierTipItem:RefreshUIShow()
  self.LvText:SetText("Lv." .. self.data.lv)
  self.CountText:SetText(string.GetFormattedStr(self.data.count))
  local morale = 0
  local soldierId = self.data.id
  if soldierId then
    local meta = DataCenter.SoldierDataManager:GetTemplate(soldierId)
    if meta ~= nil then
      morale = toInt(meta.level_factor)
      if meta.type == SoldierType.Mummy then
        self.icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_chuzheng_munaiyi.png")
      else
        self.icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/dl_zhujiemian_chuzheng_yingxiong.png")
      end
    end
  end
  self.totalMorale = morale * self.data.count
  self.MoraleText:SetText(string.GetFormattedStr(self.totalMorale))
end

function UISoldierTipItem:GetTotalMorale()
  return self.totalMorale or 0
end

function UISoldierTipItem:ComponentDestroy()
  self.icon = nil
  self.qualityBg = nil
  self.LvText = nil
  self.CountText = nil
  self.MoraleText = nil
end

return UISoldierTipItem
