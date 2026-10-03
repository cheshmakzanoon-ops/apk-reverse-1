local NewGaleArenaPreWinnerItem = BaseClass("NewGaleArenaPreWinnerItem", UIBaseContainer)
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
  self.textRank = self:AddComponent(UIText, "HuizhangImg/RankText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textAbbr = self:AddComponent(UIText, "AbbrText")
  self.textName = self:AddComponent(UIText, "NameText")
  self.textLikeCount = self:AddComponent(UIText, "LikeBtn/likeCountText")
  self.compLikeRedDot = self:AddComponent(UIBaseContainer, "LikeBtn/LikeRedDot")
  self.imageBg = self:AddComponent(UIImage, "flag")
  self.dianzanEffect = self:AddComponent(UIBaseContainer, "DianZanEffect")
  self.hand = self:AddComponent(UIBaseContainer, "DianZanEffect/Hand")
  self.diamond = self:AddComponent(UIBaseContainer, "DianZanEffect/Diamond")
  self.dianzanEffect:SetActive(false)
  self.compLikeRedDot:SetActive(false)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.textRank = nil
  self.compUIPlayerHead = nil
  self.textAbbr = nil
  self.textName = nil
  self.btnLike = nil
  self.textLikeCount = nil
  self.compLikeRedDot = nil
  self.dianzanEffect = nil
  self.hand = nil
  self.diamond = nil
  self.dianzanEffect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
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

local bgPath = {
  [1] = "lrb_dianfengduijue_paihang3_bg",
  [2] = "lrb_dianfengduijue_paihang2_bg",
  [3] = "lrb_dianfengduijue_paihang1_bg"
}

local function Refresh(self, data, previewLevel)
  self.data = data
  self.compUIPlayerHead:ParseHeadInfo(data.playerInfo)
  local abbrStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    abbrStr = abbrStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  self.textAbbr:SetText(abbrStr)
  self.textName:SetText(DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.playerInfo.uid, data.playerInfo.name))
  self.textLikeCount:SetText(data.praise or 0)
  local arenaType = previewLevel or NewGaleArenaLevel.Basic
  self.imageBg:LoadSprite(string.format(LoadPath.LWPVPArenaPath, bgPath[arenaType]))
end

NewGaleArenaPreWinnerItem.OnCreate = OnCreate
NewGaleArenaPreWinnerItem.OnDestroy = OnDestroy
NewGaleArenaPreWinnerItem.OnEnable = OnEnable
NewGaleArenaPreWinnerItem.OnDisable = OnDisable
NewGaleArenaPreWinnerItem.ComponentDefine = ComponentDefine
NewGaleArenaPreWinnerItem.ComponentDestroy = ComponentDestroy
NewGaleArenaPreWinnerItem.DataDefine = DataDefine
NewGaleArenaPreWinnerItem.DataDestroy = DataDestroy
NewGaleArenaPreWinnerItem.OnAddListener = OnAddListener
NewGaleArenaPreWinnerItem.OnRemoveListener = OnRemoveListener
NewGaleArenaPreWinnerItem.ShowDianZanEffect = ShowDianZanEffect
NewGaleArenaPreWinnerItem.Refresh = Refresh
return NewGaleArenaPreWinnerItem
