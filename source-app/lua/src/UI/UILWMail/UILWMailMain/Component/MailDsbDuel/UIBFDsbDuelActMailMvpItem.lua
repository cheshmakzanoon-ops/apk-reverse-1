local UIBFDsbDuelActMailMvpItem = BaseClass("UIBFDsbDuelActMailMvpItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActMailMvpItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBFDsbDuelActMailMvpItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActMailMvpItem:ComponentDefine()
  self.NameText = self:AddComponent(UIText, "name")
  self.PowerText = self:AddComponent(UIText, "power")
  self.DescText = self:AddComponent(UIText, "DescText")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
end

function UIBFDsbDuelActMailMvpItem:ComponentDestroy()
  self.NameText = nil
  self.PowerText = nil
  self.DescText = nil
  self.playerHead = nil
end

function UIBFDsbDuelActMailMvpItem:SetData(data)
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

return UIBFDsbDuelActMailMvpItem
