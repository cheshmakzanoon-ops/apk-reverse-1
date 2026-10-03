local UIScratchOffRankItem = BaseClass("UIScratchOffRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIScratchOffRankItem:OnCreate()
  base.OnCreate(self)
  self.rankingBg = self:AddComponent(UIImage, "RankingBg")
  self.rankingText = self:AddComponent(UIText, "RankingText")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.nameLayout = self:AddComponent(UICommonNameLayout, "UIPlayerNameLayout")
  self.pointsText = self:AddComponent(UIText, "PointsText")
  self.bg = self:AddComponent(UIImage, "Bg")
end

function UIScratchOffRankItem:OnDestroy()
  self.rankingBg = nil
  self.rankingText = nil
  self.playerHead = nil
  self.nameLayout = nil
  self.pointsText = nil
  self.bg = nil
  base.OnDestroy(self)
end

function UIScratchOffRankItem:OnEnable()
  base.OnEnable(self)
end

function UIScratchOffRankItem:OnDisable()
  base.OnDisable(self)
end

function UIScratchOffRankItem:RefreshData(data, isSelf)
  self.data = data
  self.nameLayout:SetData(data.name, data.abbr, nil, nil, nil, nil)
  self.pointsText:SetText(data.score)
  local headFrame
  if data.headBg then
    headFrame = data.headBg
  else
    headFrame = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  end
  self.playerHead:SetData(data.uid, data.pic, data.picVer, nil, headFrame)
  self.playerHead:SetEnableClickShowInfo(true)
  if data.rank <= 0 then
    self.rankingText:SetActive(false)
  else
    self.rankingText:SetActive(true)
    local showRanking = data.rank
    if 100 < showRanking then
      showRanking = "100+"
    end
    self.rankingText:SetText(data.rank)
  end
  self:SetRankIcon(self.rankingBg, data.rank)
  if isSelf then
    local color = Color.New(0.3176, 0.3176, 0.3176, 1)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
    if self.nameLayout._nameLable then
      self.nameLayout._nameLable:SetColor(color)
    end
  else
    local color = Color.New(0.3176, 0.3176, 0.3176, 1)
    if data.rank == 1 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
      color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
    elseif data.rank == 2 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
      color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
    elseif data.rank == 3 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
      color = Color.New(0.3176471, 0.4666666666666667, 0.34509803921568627, 1)
    else
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
    end
    if self.nameLayout._nameLable then
      self.nameLayout._nameLable:SetColor(color)
    end
  end
end

function UIScratchOffRankItem:SetRankIcon(image, rank)
  if IsNull(image.gameObject) then
    return
  end
  image:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      image:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      image:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      image:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  end
end

return UIScratchOffRankItem
