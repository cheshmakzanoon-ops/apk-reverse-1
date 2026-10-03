local MailSoldierCell = BaseClass("MailSoldierCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailSoldierCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailSoldierCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailSoldierCell:ComponentDefine()
  self.SoldierLevel = self:AddComponent(UIText, "SoldierLevel")
  self.SoldierIcon = self:AddComponent(UIImage, "SoldierIcon")
  self.Death1 = self:AddComponent(UIText, "Death1")
  self.Injured1 = self:AddComponent(UIText, "Injured1")
  self.Wounded1 = self:AddComponent(UIText, "Wounded1")
  self.Healthy1 = self:AddComponent(UIText, "Healthy1")
  self.Death2 = self:AddComponent(UIText, "Death2")
  self.Injured2 = self:AddComponent(UIText, "Injured2")
  self.Wounded2 = self:AddComponent(UIText, "Wounded2")
  self.Healthy2 = self:AddComponent(UIText, "Healthy2")
end

function MailSoldierCell:ComponentDestroy()
  self.SoldierLevel = nil
  self.SoldierIcon = nil
  self.Death1 = nil
  self.Injured1 = nil
  self.Wounded1 = nil
  self.Healthy1 = nil
  self.Death2 = nil
  self.Injured2 = nil
  self.Wounded2 = nil
  self.Healthy2 = nil
end

function MailSoldierCell:SetData(data)
  local soldierEleven
  if data[1] then
    self.Death1:SetText(tostring(data[1].dead))
    self.Injured1:SetText(tostring(data[1].injured))
    self.Wounded1:SetText(tostring(data[1].wounded))
    self.Healthy1:SetText(tostring(data[1].total - data[1].lost))
    soldierEleven = data[1].soldierEleven
  else
    self.Death1:SetText("0")
    self.Injured1:SetText("0")
    self.Wounded1:SetText("0")
    self.Healthy1:SetText("0")
  end
  if data[2] then
    self.Death2:SetText(tostring(data[2].dead))
    self.Injured2:SetText(tostring(data[2].injured))
    self.Wounded2:SetText(tostring(data[2].wounded))
    self.Healthy2:SetText(tostring(data[2].total - data[2].lost))
    soldierEleven = data[2].soldierEleven
  else
    self.Death2:SetText("0")
    self.Injured2:SetText("0")
    self.Wounded2:SetText("0")
    self.Healthy2:SetText("0")
  end
  local meta = DataCenter.SoldierDataManager:GetTemplate(data.id)
  self.SoldierLevel:SetLocalText("300665", meta.lv)
  local stage = soldierEleven and soldierEleven.stage or 0
  local type = soldierEleven and soldierEleven.type or T11SoldierType.T11NotUnLock
  local soldierIcon = DataCenter.SoldierDataManager:GetSoldierIconById(data.id, {type = type, stage = stage})
  self.SoldierIcon:LoadSpriteAsync(soldierIcon)
end

function MailSoldierCell:DataDefine()
end

function MailSoldierCell:DataDestroy()
end

function MailSoldierCell:OnEnable()
  base.OnEnable(self)
end

function MailSoldierCell:OnDisable()
  base.OnDisable(self)
end

function MailSoldierCell:OnAddListener()
  base.OnAddListener(self)
end

function MailSoldierCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailSoldierCell
