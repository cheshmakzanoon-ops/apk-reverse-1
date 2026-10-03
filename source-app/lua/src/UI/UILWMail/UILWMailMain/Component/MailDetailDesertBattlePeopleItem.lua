local MailDetailDesertBattlePeopleItem = BaseClass("MailDetailDesertBattlePeopleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailDetailDesertBattlePeopleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailDetailDesertBattlePeopleItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDetailDesertBattlePeopleItem:ComponentDefine()
  self.NameText = self:AddComponent(UIText, "Name")
  self.RText = self:AddComponent(UIText, "RText")
  self.SoldierPowerText = self:AddComponent(UIText, "SoldierPower")
  self.TotalPowerText = self:AddComponent(UIText, "TotalPower")
  self.SelfBgImg = self:AddComponent(UIText, "SelfBg")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.SoldierPowerText:SetActive(false)
end

function MailDetailDesertBattlePeopleItem:ComponentDestroy()
  self.NameText = nil
  self.RText = nil
  self.SoldierPowerText = nil
  self.TotalPowerText = nil
  self.playerHead = nil
  self.SelfBgImg = nil
end

function MailDetailDesertBattlePeopleItem:SetData(data)
  if data then
    if data then
      self.NameText:SetText(data.name)
      self.playerHead:SetEnableClickShowInfo(true)
      self.playerHead:SetData(data.uid, data.pic, data.picVer, nil, data:GetHeadBgImg())
      self.SelfBgImg:SetActive(data.uid == LuaEntry.Player.uid)
    end
    if data.armyPower then
      self.SoldierPowerText:SetText(string.GetFormattedStr(data.armyPower))
    end
    if data.power then
      self.TotalPowerText:SetText(string.GetFormattedStr(data.power))
    end
    if data.rank then
      self.RText:SetText("R" .. data.rank)
    end
  end
end

return MailDetailDesertBattlePeopleItem
