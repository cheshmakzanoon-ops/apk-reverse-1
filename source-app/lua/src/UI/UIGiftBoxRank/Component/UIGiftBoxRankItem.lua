local UIGiftBoxRankItem = BaseClass("UIGiftBoxRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIGiftBoxRankItem:OnCreate()
  base.OnCreate(self)
  self.nameTxt = self:AddComponent(UIText, "NameTxt")
  self.scoreTxt = self:AddComponent(UIText, "ScoreTxt")
  self.bgImgN = self:AddComponent(UIImage, "bg")
  self.rankIcon = self:AddComponent(UIImage, "RankIcon")
  self.numTxt = self:AddComponent(UIText, "RankIconNum")
  self.noRankTxt = self:AddComponent(UIText, "NoRankText")
  self.playerHead = self:AddComponent(UICommonHead, "playerFlag/UIPlayerHead")
end

function UIGiftBoxRankItem:OnDestroy()
  base.OnDestroy(self)
end

function UIGiftBoxRankItem:OnEnable()
  base.OnEnable(self)
end

function UIGiftBoxRankItem:OnDisable()
  base.OnDisable(self)
end

function UIGiftBoxRankItem:RefreshData(data, rewardArr)
  self.data = data
  if data.abbr == "" then
    self.nameTxt:SetText(data.name)
  else
    self.nameTxt:SetText("[" .. data.abbr .. "]" .. data.name)
  end
  self.scoreTxt:SetText(data.score)
  self:SetRankIcon(data.rank)
  local color = Color.New(0, 0, 0, 1)
  local scoreColor = Color.New(1, 1, 1, 1)
  if data.uid == LuaEntry.Player.uid then
    scoreColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
  end
  if data.rank == 1 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif data.rank == 2 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif data.rank == 3 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self.nameTxt:SetColor(color)
  self.scoreTxt:SetColor(scoreColor)
  self.numTxt:SetText(data.rank)
  self.playerHead:SetData(data.uid, data.pic, data.picVer)
end

function UIGiftBoxRankItem:SetRankIcon(rank)
  self.rankIcon:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  end
end

return UIGiftBoxRankItem
