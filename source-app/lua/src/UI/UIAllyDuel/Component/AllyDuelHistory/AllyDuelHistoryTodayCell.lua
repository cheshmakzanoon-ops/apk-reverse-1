local base = UIBaseContainer
local AllyDuelHistoryTodayCell = BaseClass("AllyDuelHistoryTodayCell", UIBaseContainer)
local RANK_IMG_PATH = "Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%s.png"
local MVP_PATH = "Assets/Main/Sprites/UI/UIAllyDuel/lrb_lianmengduijue_mvp_%s.png"
local BG_PATH = "Assets/Main/TextureEx/UIActivityBg/AllyDuel/History/lrb_lianmengduijue_diban_%s.png"

function AllyDuelHistoryTodayCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelHistoryTodayCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelHistoryTodayCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textFirstNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 2)
  self.textScoreTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgMVP = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgRankIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textRankIconNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnFavor = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnFavor:SetOnClick(function()
    self:OnBtnFavorClick()
  end)
  self.textFavorTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compSelf = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 10)
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 11)
  self.compDianZanEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
end

function AllyDuelHistoryTodayCell:ComponentDestroy()
  self.viewSkin = nil
  self.textFirstNameTxt = nil
  self.slider = nil
  self.textScoreTxt = nil
  self.imgMVP = nil
  self.imgRankIcon = nil
  self.textRankIconNum = nil
  self.btnFavor = nil
  self.textFavorTxt = nil
  self.compSelf = nil
  self.compUIPlayerHead = nil
  self.rawImgBg = nil
  self.compDianZanEffect = nil
end

function AllyDuelHistoryTodayCell:DataDefine()
  self.compDianZanEffect:SetActive(false)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
end

function AllyDuelHistoryTodayCell:DataDestroy()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
end

function AllyDuelHistoryTodayCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function AllyDuelHistoryTodayCell:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function AllyDuelHistoryTodayCell:OnBtnFavorClick()
  if self.rankInfo == nil then
    return
  end
  InteractiveUtil.TryThumbsUp(self.rankInfo.uid, InteractiveUtil.ThumbsUpType.AllyDuelRank, "AllyDuelHistoryTodayCell", function()
    self:OnFavorClickSuccess()
  end)
end

function AllyDuelHistoryTodayCell:OnFavorClickSuccess()
  if self.textFavorTxt == nil then
    return
  end
  local num = toInt(self.textFavorTxt:GetText()) + 1
  self.textFavorTxt:SetText(num)
  UIUtil.ShowTipsId("activity_sports_uitips_017")
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compDianZanEffect:SetActive(false)
  self.compDianZanEffect:SetActive(true)
  self.diamondSeq = CS.DG.Tweening.DOTween.Sequence()
  self.diamondSeq:AppendInterval(0.8)
  self.diamondSeq:AppendCallback(function()
    if self.compDianZanEffect then
      self.compDianZanEffect:SetActive(false)
    end
  end)
end

function AllyDuelHistoryTodayCell:RefreshItem(rankInfo, rank, maxScore, bMvp)
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compDianZanEffect:SetActive(false)
  local _, y, z = self:GetLocalPositionXYZ()
  self:SetLocalPositionXYZ(0, y, z)
  self.rankInfo = rankInfo
  self.rank = rank
  local bTeamMate = rankInfo.aid == LuaEntry.Player:GetAllianceUid()
  self.rawImgBg:LoadSpriteAuto(string.format(BG_PATH, bTeamMate and "lan" or "hong"))
  self.textRankIconNum:SetText(rank)
  local showTopThree = 1 <= rank and rank <= 3
  self.imgRankIcon:SetActive(showTopThree)
  if showTopThree then
    self.imgRankIcon:LoadSpriteAuto(string.format(RANK_IMG_PATH, rank))
  end
  self.compUIPlayerHead:SetHeadAndFrame(rankInfo.uid, rankInfo.pic, rankInfo.picVer, nil, rankInfo.headSkinId, rankInfo.headSkinET)
  self.imgMVP:SetActive(bMvp)
  if bMvp then
    self.imgMVP:LoadSpriteAuto(string.format(MVP_PATH, bTeamMate and "lan" or "hong"))
  end
  local showName = UIUtil.FormatAllianceAndName(rankInfo.abbr, rankInfo.name, rankInfo.uid)
  self.textFirstNameTxt:SetText(showName)
  local score = rankInfo.score or 0
  self.textScoreTxt:SetText(string.GetFormattedSeparatorNum(score))
  self.slider:SetValue(score / maxScore)
  local bSelf = rankInfo.uid == LuaEntry.Player:GetUid()
  self.compSelf:SetActive(bSelf)
  self:OnGetNewUserInfoSucc(rankInfo.uid)
end

function AllyDuelHistoryTodayCell:OnGetNewUserInfoSucc(uid)
  if self.rankInfo ~= nil and uid == self.rankInfo.uid then
    local info = UIUtil.GetPlayerInfoShowByUid(uid)
    self.textFavorTxt:SetText(info.thumbsUpCount or 0)
  end
end

return AllyDuelHistoryTodayCell
