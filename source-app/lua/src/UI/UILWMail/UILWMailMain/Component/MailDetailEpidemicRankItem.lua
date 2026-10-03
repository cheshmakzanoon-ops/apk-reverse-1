local MailDetailEpidemicRankItem = BaseClass("MailDetailEpidemicRankItem", UIBaseContainer)
local base = UIBaseContainer

function MailDetailEpidemicRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailDetailEpidemicRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDetailEpidemicRankItem:ComponentDefine()
  self.nameText = self:AddComponent(UIText, "name")
  self.powerText = self:AddComponent(UIText, "power")
  self.rankText = self:AddComponent(UIText, "MedalImg/numTxt")
  self.medalImg = self:AddComponent(UIImage, "MedalImg")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
end

function MailDetailEpidemicRankItem:ComponentDestroy()
  self.nameText = nil
  self.powerText = nil
  self.rankText = nil
  self.medalImg = nil
  self.playerHead = nil
end

function MailDetailEpidemicRankItem:SetData(data, type)
  if data == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.nameText:SetText("[" .. data.abbr .. "]" .. data.name)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  self.playerHead:SetData(data.uid, data.pic, data.picVer, nil, headBgImg)
  local mRank = data.rank
  if mRank then
    self.medalImg:SetEnable(true)
    self.rankText:SetText(mRank)
    if mRank == 1 then
      self.medalImg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif mRank == 2 then
      self.medalImg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif mRank == 3 then
      self.medalImg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
    else
      self.medalImg:SetEnable(false)
    end
  end
  local score
  if type == 1 then
    score = data.score
  elseif type == 2 then
    score = data.battleScore
  elseif type == 3 then
    score = data.cooperationScore
  elseif type == 4 then
    score = data.tacticsScore
  end
  self.powerText:SetText(score or 0)
end

return MailDetailEpidemicRankItem
