local SeasonGoldTreeWinnerItem = BaseClass("SeasonGoldTreeWinnerItem", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "head/imgHead",
    name = "imgHead",
    type = UICommonHead
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

function SeasonGoldTreeWinnerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonGoldTreeWinnerItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function SeasonGoldTreeWinnerItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnHead:SetOnClick(function()
    if not self.data then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
  end)
end

function SeasonGoldTreeWinnerItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function SeasonGoldTreeWinnerItem:Refresh(data, icon)
  self.data = data
  if not data then
    self:SetActive(false)
    return
  end
  self.imgHead:SetHeadAndFrame(data.uid, data.pic, data.picVer or data.picver, nil, data.headSkinId, data.headSkinET)
  self:SetActive(true)
  local abbrStr = "#" .. data.serverId
  if not string.IsNullOrEmpty(data.abbr) then
    abbrStr = abbrStr .. " [" .. data.abbr .. "]"
  end
  abbrStr = abbrStr .. "\n" .. data.name
  self.txtName:SetText(abbrStr)
  self.scoreText:SetText(string.format("\195\151%s", string.GetFormattedStr2(data.score)))
  if icon then
    self.scoreIcon:LoadSprite(icon)
    self.scoreIcon:SetNativeSize()
    self.scoreIcon:SetActive(true)
  else
    self.scoreIcon:SetActive(false)
  end
end

return SeasonGoldTreeWinnerItem
