local LW3v3ArenaWinner = BaseClass("LW3v3ArenaWinner", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "imgHead",
    name = "imgHead",
    type = UIImage
  },
  {
    path = "btnHead",
    name = "btnHead",
    type = UIButton
  },
  {
    path = "txtAbbr",
    name = "txtAbbr",
    type = UIText
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "imgBadge/txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "imgBadge/txtLastRank",
    name = "txtLastRank",
    type = UIText
  },
  {
    path = "imgBadge/vfxGlow",
    name = "vfxGlow",
    type = nil
  },
  {
    path = "like",
    name = "likeBtn",
    type = UIButton
  },
  {
    path = "like/likeCountText",
    name = "likeCountText",
    type = UIText
  },
  {
    path = "Score/ScoreText",
    name = "scoreText",
    type = UIText
  },
  {
    path = "DianZanEffect",
    name = "dianzanEffect",
    type = UIText
  },
  {
    path = "DianZanEffect/Hand",
    name = "hand",
    type = UIBaseContainer
  },
  {
    path = "DianZanEffect/Diamond",
    name = "diamond",
    type = UIBaseContainer
  }
}

function LW3v3ArenaWinner:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LW3v3ArenaWinner:OnDestroy()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function LW3v3ArenaWinner:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.compPlayerHead = self.imgHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.btnHead:SetOnClick(function()
    if not self.data then
      return
    end
    if DataCenter.LW3V3ArenaManager.state == PVPArenaState.Open then
      if self.data.uid == LuaEntry.Player.uid then
        self.holder:RequestDefenceTeam()
      else
        self.holder:RequestDefenceTeam(self.data.uid)
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
  self.rankCanvasGroup = self.txtRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.lastRankCanvasGroup = self.txtLastRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.vfxGlow:SetActive(false)
  self.likeBtn:SetOnClick(function()
    if self.data then
      DataCenter.LW3V3ArenaManager:SendLike(self.data.uid)
    end
  end)
  self.dianzanEffect:SetActive(false)
  self.txtLastRank:SetLocalScaleXYZ(1, 1, 1)
  self.txtRank:SetLocalScaleXYZ(1, 1, 1)
end

function LW3v3ArenaWinner:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LW3v3ArenaWinner:Refresh(data)
  self.data = data
  self.compPlayerHead:SetData(data.uid, data.playerInfo.pic, data.playerInfo.picver)
  local abbrStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    abbrStr = abbrStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  abbrStr = abbrStr .. "\n" .. data.playerInfo.name
  self.txtName:SetText(abbrStr)
  self.txtRank:SetText(data.rank)
  self.rankCanvasGroup.alpha = 1
  self.txtLastRank:SetActive(false)
  self.likeCountText:SetText(data.praise)
  self.scoreText:SetText(data.score)
end

function LW3v3ArenaWinner:ShowDianZanEffect()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.dianzanEffect:SetActive(false)
  self.dianzanEffect:SetActive(true)
  self.hand.transform.localEulerAngles = Vector3(0, 0, 40)
  self.diamond:SetActive(true)
  self.diamondSeq = CS.DG.Tweening.DOTween.Sequence()
  self.diamondSeq:Append(self.hand.transform:DOLocalRotate(Vector3(0, 0, -80), 0.6):SetEase(CS.DG.Tweening.Ease.InExpo))
  self.diamondSeq:AppendInterval(0.2)
  self.diamondSeq:AppendCallback(function()
    if self.dianzanEffect then
      self.dianzanEffect:SetActive(false)
    end
  end)
end

return LW3v3ArenaWinner
