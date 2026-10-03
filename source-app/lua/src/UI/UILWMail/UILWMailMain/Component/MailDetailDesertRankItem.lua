local MailDetailDesertRankItem = BaseClass("MailDetailDesertRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailDetailDesertRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailDetailDesertRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDetailDesertRankItem:ComponentDefine()
  self.nameText = self:AddComponent(UIText, "name")
  self.powerText = self:AddComponent(UIText, "power")
  self.rankText = self:AddComponent(UIText, "MedalImg/numTxt")
  self.medalImg = self:AddComponent(UIImage, "MedalImg")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
end

function MailDetailDesertRankItem:ComponentDestroy()
  self.nameText = nil
  self.powerText = nil
  self.rankText = nil
  self.medalImg = nil
  self.playerHead = nil
end

function MailDetailDesertRankItem:SetData(data)
  if data then
    if data then
      self.nameText:SetText("[" .. data.abbr .. "]" .. data.name)
      self.playerHead:SetEnableClickShowInfo(true)
      self.playerHead:SetData(data.uid, data.pic, data.picVer, nil, data:GetHeadBgImg())
    end
    if data.score then
      self.powerText:SetText(data.score)
    end
    if data.rank then
      self.medalImg:SetEnable(true)
      self.rankText:SetText(data.rank)
      if data.rank == 1 then
        self.medalImg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
      elseif data.rank == 2 then
        self.medalImg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
      elseif data.rank == 3 then
        self.medalImg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
      else
        self.medalImg:SetEnable(false)
      end
    end
  end
end

return MailDetailDesertRankItem
