local LW3v3ArenaRankItemPerson = BaseClass("LW3v3ArenaRankItemPerson", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "root",
    name = "root",
    type = nil
  },
  {
    path = "root/imgHead",
    name = "imgHead",
    type = UICommonHead
  },
  {
    path = "root/btnHead",
    name = "btnHead",
    type = UIButton
  },
  {
    path = "root/txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "root/txtLastRank",
    name = "txtLastRank",
    type = UIText
  },
  {
    path = "root/txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "root/txtPower",
    name = "txtPower",
    type = UIText
  },
  {
    path = "root/vfxGlow",
    name = "vfxGlow",
    type = nil
  },
  {
    path = "root/Score/ScoreText",
    name = "scoreText",
    type = UIText
  }
}

function LW3v3ArenaRankItemPerson:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LW3v3ArenaRankItemPerson:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function LW3v3ArenaRankItemPerson:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnHead:SetOnClick(function()
    if self.data and self.holder then
      if DataCenter.LW3V3ArenaManager.state == PVPArenaState.Open then
        if self.data.uid == LuaEntry.Player.uid then
          self.holder:RequestDefenceTeam()
        else
          self.holder:RequestDefenceTeam(self.data.uid)
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
      end
    end
  end)
  self.rankCanvasGroup = self.txtRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.lastRankCanvasGroup = self.txtLastRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.vfxGlow:SetActive(false)
end

function LW3v3ArenaRankItemPerson:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LW3v3ArenaRankItemPerson:Refresh(data)
  self.data = data
  local nameStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    nameStr = nameStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. data.playerInfo.name
  self.txtName:SetText(nameStr)
  if data.formationPower then
    self.txtPower:SetText(string.GetFormattedStr(data.formationPower))
  else
    self.txtPower:SetText(string.GetFormattedStr(data.playerInfo.power))
  end
  local framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.playerInfo.headSkinId, data.playerInfo.headSkinET, false)
  self.imgHead:SetData(data.uid, data.playerInfo.pic, data.playerInfo.picver, nil, framePath)
  self.txtRank:SetText(data.rank)
  if data.rankScale then
    self.txtRank:SetLocalScaleXYZ(data.rankScale, data.rankScale, data.rankScale)
  else
    self.txtRank:SetLocalScaleXYZ(1, 1, 1)
  end
  if data.rankAlpha then
    self.rankCanvasGroup.alpha = data.rankAlpha
  else
    self.rankCanvasGroup.alpha = 1
  end
  if data.lastRank then
    self.txtLastRank:SetActive(true)
    self.txtLastRank:SetText(data.lastRank)
    self.txtLastRank:SetLocalScaleXYZ(data.lastRankScale, data.lastRankScale, data.lastRankScale)
    self.lastRankCanvasGroup.alpha = data.lastRankAlpha
  else
    self.txtLastRank:SetActive(false)
  end
  if data.playVfxGlow then
    data.playVfxGlow = nil
    self.vfxGlow:SetActive(false)
    self.vfxGlow:SetActive(true)
  end
  self.scoreText:SetText(data.score)
end

return LW3v3ArenaRankItemPerson
