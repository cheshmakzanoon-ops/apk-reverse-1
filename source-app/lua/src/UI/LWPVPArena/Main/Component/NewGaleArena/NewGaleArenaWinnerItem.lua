local NewGaleArenaWinnerItem = BaseClass("NewGaleArenaWinnerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textAbbr = self:AddComponent(UIText, "AbbrText")
  self.textName = self:AddComponent(UIText, "NameText")
  self.textPower = self:AddComponent(UIText, "Power/PowerText")
  self.textScore = self:AddComponent(UIText, "Score/ScoreText")
  self.btnLike = self:AddComponent(UIButton, "LikeBtn")
  self.btnLike:SetOnClick(function()
    self:OnBtnLikeClick()
  end)
  self.compLikeRedDot = self:AddComponent(UIBaseContainer, "LikeBtn/LikeRedDot")
  self.textLikeCount = self:AddComponent(UIText, "LikeBtn/likeCountText")
  self.dianzanEffect = self:AddComponent(UIBaseContainer, "DianZanEffect")
  self.hand = self:AddComponent(UIBaseContainer, "DianZanEffect/Hand")
  self.diamond = self:AddComponent(UIBaseContainer, "DianZanEffect/Diamond")
  self.dianzanEffect:SetActive(false)
  self.compLikeRedDot:SetActive(false)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compUIPlayerHead = nil
  self.textAbbr = nil
  self.textName = nil
  self.textPower = nil
  self.textScore = nil
  self.btnLike = nil
  self.compLikeRedDot = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnLikeClick(self)
  if self.data then
    DataCenter.NewGaleArenaManager:SendNewArenaPraise(self.data.uid)
  end
end

local function ShowDianZanEffect(self)
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

local function Refresh(self, data)
  self.data = data
  self.compUIPlayerHead:ParseHeadInfo(data.playerInfo)
  self.textPower:SetText(string.GetFormattedStr(data.formationPower or 0))
  self.textScore:SetText(data.score)
  local abbrStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    abbrStr = abbrStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  self.textAbbr:SetText(abbrStr)
  self.textName:SetText(DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.playerInfo.uid, data.playerInfo.name))
  self.textLikeCount:SetText(data.praise or 0)
end

NewGaleArenaWinnerItem.OnCreate = OnCreate
NewGaleArenaWinnerItem.OnDestroy = OnDestroy
NewGaleArenaWinnerItem.OnEnable = OnEnable
NewGaleArenaWinnerItem.OnDisable = OnDisable
NewGaleArenaWinnerItem.ComponentDefine = ComponentDefine
NewGaleArenaWinnerItem.ComponentDestroy = ComponentDestroy
NewGaleArenaWinnerItem.DataDefine = DataDefine
NewGaleArenaWinnerItem.DataDestroy = DataDestroy
NewGaleArenaWinnerItem.OnAddListener = OnAddListener
NewGaleArenaWinnerItem.OnRemoveListener = OnRemoveListener
NewGaleArenaWinnerItem.OnBtnLikeClick = OnBtnLikeClick
NewGaleArenaWinnerItem.ShowDianZanEffect = ShowDianZanEffect
NewGaleArenaWinnerItem.Refresh = Refresh
return NewGaleArenaWinnerItem
