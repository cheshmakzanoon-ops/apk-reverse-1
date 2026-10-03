local LWUIActValentineRankItem = BaseClass("LWUIActValentineRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local love_king_flag_btn_path = "loveKingFlagBtn"
local ranking_text2_path = "RankingText2"

function LWUIActValentineRankItem:OnCreate()
  base.OnCreate(self)
  self.nameTxt = self:AddComponent(UIText, "GenderNameGroup/PlayerNameText")
  self.scoreTxt = self:AddComponent(UIText, "PointsText")
  self.bgImgN = self:AddComponent(UIImage, "bg")
  self.rankIcon = self:AddComponent(UIImage, "RankingBg")
  self.numTxt = self:AddComponent(UIText, "RankingText")
  self.noRankTxt = self:AddComponent(UIText, "NoRankText")
  self.noRankTxt:SetLocalText(2800057)
  self.itemIcon = self:AddComponent(UIImage, "ItemIcon")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.btn = self:AddComponent(UIButton, "Button")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.ranking_text2 = self:AddComponent(UITextMeshProUGUIEx, ranking_text2_path)
end

function LWUIActValentineRankItem:OnDestroy()
  base.OnDestroy(self)
end

function LWUIActValentineRankItem:OnEnable()
  base.OnEnable(self)
end

function LWUIActValentineRankItem:OnDisable()
  base.OnDisable(self)
end

function LWUIActValentineRankItem:SetData(data, iconPath, activityId)
  self.data = data
  self.iconPath = iconPath
  self.activityId = activityId
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if temp and tonumber(data.score) > temp.rank_max_score then
    self.scoreTxt:SetText(temp.rank_max_score .. "+")
  else
    self.scoreTxt:SetText(data.score)
  end
  self.itemIcon:LoadSprite(self.iconPath)
  self:SetRankIcon(data.rank)
  local color = Color.New(0, 0, 0, 1)
  local scoreColor = Color.New(0, 0, 0, 1)
  if data.isSelf then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png")
    scoreColor = Color.New(0.25098039215686274, 0.4980392156862745, 0.13333333333333333, 1)
    color = Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1)
  elseif data.rank == 1 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif data.rank == 2 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif data.rank == 3 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self.playerHead:SetActive(true)
  if data.isSelf then
    local userPic = LuaEntry.Player:GetPic() or ""
    local userPicVer = LuaEntry.Player.picVer or 0
    self.playerHead:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
    if LuaEntry.Player:IsInAlliance() then
      local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      self.nameTxt:SetText("[" .. allInfo.abbr .. "]" .. LuaEntry.Player.name)
    else
      self.nameTxt:SetText(LuaEntry.Player.name)
    end
  else
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
    self.playerHead:SetData(data.uid, data.pic, data.picVer, nil, headFrame)
    if data.abbr == "" then
      self.nameTxt:SetText(data.name)
    else
      self.nameTxt:SetText("[" .. data.abbr .. "]" .. data.name)
    end
  end
  self.numTxt:SetText(data.rank)
  self.ranking_text2:SetText(data.rank)
  self.noRankTxt:SetActive(false)
  if data.rank <= 0 then
    self.numTxt:SetText("-")
    self.ranking_text2:SetText("-")
    self.rankIcon:SetActive(false)
    self.noRankTxt:SetActive(true)
  end
  if data.rank >= 1 and data.rank <= 3 then
    self.numTxt:SetActive(true)
    self.ranking_text2:SetActive(false)
  else
    self.numTxt:SetActive(false)
    self.ranking_text2:SetActive(true)
  end
  self.nameTxt:SetColor(color)
  self.scoreTxt:SetColor(scoreColor)
end

function LWUIActValentineRankItem:SetRankIcon(rank)
  self.rankIcon:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png")
    elseif rank == 2 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png")
    elseif rank == 3 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png")
    end
  end
  self.rankIcon:SetNativeSize()
end

function LWUIActValentineRankItem:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function LWUIActValentineRankItem:OnClick()
end

return LWUIActValentineRankItem
