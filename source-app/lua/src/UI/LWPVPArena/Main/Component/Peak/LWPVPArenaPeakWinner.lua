local LWPVPArenaPeakWinner = BaseClass("LWPVPArenaPeakWinner", UIBaseContainer)
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
    path = "btnChallenge",
    name = "btnChallenge",
    type = UIButton
  },
  {
    path = "btnChallenge/txtChallenge",
    name = "txtChallenge",
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
  }
}

function LWPVPArenaPeakWinner:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakWinner:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function LWPVPArenaPeakWinner:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.compPlayerHead = self.imgHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.txtChallenge:SetText(Localization:GetString("372258"))
  self.btnChallenge:SetOnClick(function()
    if self.data then
      self.view:Challenge(self.data.uid)
    end
  end)
  self.btnHead:SetOnClick(function()
    if self.data then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
  self.rankCanvasGroup = self.txtRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.lastRankCanvasGroup = self.txtLastRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.vfxGlow:SetActive(false)
end

function LWPVPArenaPeakWinner:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakWinner:Refresh(data, canChallenge)
  self.data = data
  self.btnChallenge:SetActive(canChallenge)
  self.compPlayerHead:SetData(data.uid, data.playerInfo.pic, data.playerInfo.picver)
  local abbrStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    abbrStr = abbrStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  self.txtAbbr:SetText(abbrStr)
  self.txtName:SetText(data.playerInfo.name)
  self.txtRank:SetText(data.rank)
  self.rankCanvasGroup.alpha = 1
  self.txtLastRank:SetActive(false)
end

return LWPVPArenaPeakWinner
