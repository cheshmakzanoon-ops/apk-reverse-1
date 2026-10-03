local SeasonHunterWinnerItem = BaseClass("SeasonHunterWinnerItem", UIBaseContainer)
local base = UIBaseContainer
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
    path = "ScoreText",
    name = "scoreText",
    type = UIText
  },
  {
    path = "ScoreText/ScoreIcon",
    name = "scoreIcon",
    type = UIImage
  }
}

function SeasonHunterWinnerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonHunterWinnerItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function SeasonHunterWinnerItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.compPlayerHead = self.imgHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.btnHead:SetOnClick(function()
    if not self.data then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
  end)
end

function SeasonHunterWinnerItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function SeasonHunterWinnerItem:Refresh(data, typeInfo)
  self.data = data
  if not data then
    self:SetActive(false)
    return
  end
  self.compPlayerHead:SetData(data.uid, data.pic, data.picVer)
  self:SetActive(true)
  local abbrStr = "#" .. data.serverId
  if not string.IsNullOrEmpty(data.abbr) then
    abbrStr = abbrStr .. " [" .. data.abbr .. "]"
  end
  abbrStr = abbrStr .. "\n" .. data.name
  self.txtName:SetText(abbrStr)
  local pos = self.scoreText:GetLocalPosition()
  if typeInfo.type == SeasonHunterRankType.Time then
    pos.x = 0
    self.scoreText:SetLocalPosition(pos)
    self.scoreText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(tonumber(data.score)))
  else
    pos.x = 28
    self.scoreText:SetLocalPosition(pos)
    self.scoreText:SetText(string.format("\195\151%s", string.GetFormattedSeperatorNum(data.score)))
  end
  if typeInfo.icon then
    self.scoreIcon:LoadSprite(typeInfo.icon)
    self.scoreIcon:SetNativeSize()
    self.scoreIcon:SetActive(true)
  else
    self.scoreIcon:SetActive(false)
  end
end

return SeasonHunterWinnerItem
