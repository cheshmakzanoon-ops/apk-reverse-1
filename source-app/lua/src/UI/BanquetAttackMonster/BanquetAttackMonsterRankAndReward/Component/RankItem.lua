local RankItem = BaseClass("RankItem", UIBaseContainer)
local UIRankDetailListView = require("UI.UIRank.UIRankDetailList.View.UIRankDetailListView")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function RankItem:OnCreate()
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
  self.allyFlag = self:AddComponent(UIImage, "ItemFlagIcon")
  self.btn = self:AddComponent(UIButton, "Button")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
end

function RankItem:OnDestroy()
  base.OnDestroy(self)
end

function RankItem:OnEnable()
  base.OnEnable(self)
end

function RankItem:OnDisable()
  base.OnDisable(self)
end

function RankItem:RefreshData(data)
  self.data = data
  self.nameTxt:SetText(data.name)
  self.scoreTxt:SetText(data.score)
  self.itemIcon:LoadSprite(data.iconPath)
  self:SetRankIcon(data.rank)
  local color = Color.New(0, 0, 0, 1)
  local scoreColor = Color.New(1, 1, 1, 1)
  if data.isSelf then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
    scoreColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
    color = Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1)
  elseif data.rank == 1 then
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
  if not data.isAlly then
    self.playerHead:SetActive(true)
    self.allyFlag:SetActive(false)
    if data.isSelf then
      local userPic = LuaEntry.Player:GetPic() or ""
      local userPicVer = LuaEntry.Player.picVer or 0
      self.playerHead:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
    else
      local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
      self.playerHead:SetData(data.uid, data.pic, data.picVer, nil, headFrame)
    end
  else
    self.playerHead:SetActive(false)
    self.allyFlag:SetActive(true)
    if not string.IsNullOrEmpty(data.icon) then
      self.allyFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.icon))
    else
      Logger.LogError("Flag icon is null data.name:" .. data.name .. " data.icon:" .. data.icon)
    end
  end
  self.noRankTxt:SetActive(false)
  if data.rank == -1 then
    self.numTxt:SetText("-")
    self.rankIcon:SetActive(false)
    self.noRankTxt:SetActive(true)
    return
  end
end

function RankItem:SetRankIcon(rank)
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

function RankItem:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function RankItem:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

function RankItem:OnClick()
  local isAlly = self.data.isAlly
  if not self.data.isSelf then
    if isAlly then
      UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.uid, self.data.allianceName)
    else
      self:OnPlayerDetailClick(self.data.serverId, self.data.uid)
    end
  end
end

return RankItem
