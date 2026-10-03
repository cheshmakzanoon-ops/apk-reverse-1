local MailDetailDesertBattleItem = BaseClass("MailDetailDesertBattleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailDetailDesertBattleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailDetailDesertBattleItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDetailDesertBattleItem:ComponentDefine()
  self.NameText = self:AddComponent(UIText, "name")
  self.PowerText = self:AddComponent(UIText, "power")
  self.DescText = self:AddComponent(UIText, "DescText")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
end

function MailDetailDesertBattleItem:ComponentDestroy()
  self.NameText = nil
  self.PowerText = nil
  self.DescText = nil
  self.playerHead = nil
end

function MailDetailDesertBattleItem:SetData(data)
  if data then
    if data.playerInfo then
      self.NameText:SetText(data.playerInfo.name)
      self.playerHead:SetEnableClickShowInfo(true)
      self.playerHead:SetData(data.playerInfo.uid, data.playerInfo.pic, data.playerInfo.picVer, nil, data.playerInfo:GetHeadBgImg())
    end
    if data.score then
      self.PowerText:SetText(data.score)
    end
    if data.statisticName then
      self.DescText:SetText(data.statisticName)
    end
  end
end

return MailDetailDesertBattleItem
