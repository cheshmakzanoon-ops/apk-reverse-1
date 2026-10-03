local LWUIActMeteoriteRankChangedNoticeView = BaseClass("LWUIActMeteoriteRankChangedNoticeView", UIBaseView)
local base = UIBaseView
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
  local param = self:GetUserData()
  self:TryPlayNotice(param)
end

function LWUIActMeteoriteRankChangedNoticeView:ReopenWithoutCreate()
  local param = self:GetUserData()
  self:TryPlayNotice(param)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compHeadLeft = self:AddComponent(UICommonHead, "Panel/PlayerRank/PlayerRankTween/HeadLeft")
  self.compPlayerRankTween = self:AddComponent(UIBaseContainer, "Panel/PlayerRank/PlayerRankTween")
  self.textTmpLeftRank = self:AddComponent(UITextMeshProUGUIEx, "Panel/PlayerRank/PlayerRankTween/HeadLeft/RankNode/TmpLeftRank")
  self.canvasGroupPlayerRankTween = self:AddComponent(UICanvasGroup, "Panel/PlayerRank/PlayerRankTween")
  self.compAllianceRank = self:AddComponent(UIBaseContainer, "Panel/AllianceRank")
  self.canvasGroupAllianceRankTween = self:AddComponent(UICanvasGroup, "Panel/AllianceRank/AllianceRankTween")
  self.compAllianceRankTween = self:AddComponent(UIBaseContainer, "Panel/AllianceRank/AllianceRankTween")
  self.textTmpAllianceLeftRank = self:AddComponent(UITextMeshProUGUIEx, "Panel/AllianceRank/AllianceRankTween/FlagLeft/RankNode/TmpAllianceLeftRank")
  self.compPlayerRank = self:AddComponent(UIBaseContainer, "Panel/PlayerRank")
  self.textTmpLeftRankLabel = self:AddComponent(UITextMeshProUGUIEx, "Panel/PlayerRank/PlayerRankTween/HeadLeft/RankNode/TmpLeftRankLabel")
  self.compImgLeftArrowUp = self:AddComponent(UIBaseContainer, "Panel/PlayerRank/PlayerRankTween/HeadLeft/RankNode/ImgLeftArrowUp")
  self.compImgLeftArrowDown = self:AddComponent(UIBaseContainer, "Panel/PlayerRank/PlayerRankTween/HeadLeft/RankNode/ImgLeftArrowDown")
  self.animatorPlayerRank = self:AddComponent(UIAnimator, "Panel/PlayerRank")
  self.animatorAllianceRank = self:AddComponent(UIAnimator, "Panel/AllianceRank")
  self.textTmpAllianceLeftName = self:AddComponent(UITextMeshProUGUIEx, "Panel/AllianceRank/AllianceRankTween/FlagLeft/RankNode/TmpAllianceLeftName")
  self.compImgAllianceArrDown = self:AddComponent(UIBaseContainer, "Panel/AllianceRank/AllianceRankTween/FlagLeft/RankNode/ImgAllianceArrDown")
  self.compImgAllianceArrUp = self:AddComponent(UIBaseContainer, "Panel/AllianceRank/AllianceRankTween/FlagLeft/RankNode/ImgAllianceArrUp")
  self.textTmpPlayerNotice = self:AddComponent(UITextMeshProUGUIEx, "Panel/PlayerRank/PlayerRankTween/HeadLeft/TmpPlayerNotice")
  self.textTmpFlagNotice = self:AddComponent(UITextMeshProUGUIEx, "Panel/AllianceRank/AllianceRankTween/FlagLeft/TmpFlagNotice")
  self.imgFlagIcon = self:AddComponent(UIImage, "Panel/AllianceRank/AllianceRankTween/FlagLeft/FlagIcon")
  self.textTmpLeftRankLabel:SetLocalText("302043")
  self.textTmpAllianceLeftName:SetLocalText("302043")
  self.currentPlaying = false
  self.msgQueue = {}
end

local function ComponentDestroy(self)
  self.compHeadLeft = nil
  self.compPlayerRankTween = nil
  self.textTmpLeftRank = nil
  self.canvasGroupPlayerRankTween = nil
  self.compAllianceRank = nil
  self.canvasGroupAllianceRankTween = nil
  self.compAllianceRankTween = nil
  self.textTmpAllianceLeftRank = nil
  self.compPlayerRank = nil
  self.textTmpLeftRankLabel = nil
  self.compImgLeftArrowUp = nil
  self.compImgLeftArrowDown = nil
  self.animatorPlayerRank = nil
  self.animatorAllianceRank = nil
  self.textTmpAllianceLeftName = nil
  self.compImgAllianceArrDown = nil
  self.compImgAllianceArrUp = nil
  self.textTmpPlayerNotice = nil
  self.textTmpFlagNotice = nil
  self.imgFlagIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.currentPlaying = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function LWUIActMeteoriteRankChangedNoticeView:ClearAnim()
end

local colorUpgrade = Color.New(1, 0.7137255, 0.2666667, 1)
local colorDown = Color.New(0.9764706, 0.4392157, 0.4666667, 1)

function LWUIActMeteoriteRankChangedNoticeView:PlayPlayerAnim(info)
  self.compPlayerRank:SetActive(true)
  self.compAllianceRank:SetActive(false)
  local player = info.player
  if not player then
    self:TryPlayNext()
    return
  end
  self.currentPlaying = info
  local currentRank = player.rank or 0
  local lastRank = player.lastRank or 0
  local score = player.score or 0
  local pic = player.pic
  local picVer = player.picVer
  local isUpgrade = lastRank <= 0 or currentRank <= lastRank
  self.compImgLeftArrowUp:SetActive(isUpgrade)
  self.compImgLeftArrowDown:SetActive(not isUpgrade)
  self.compHeadLeft:SetHead(nil, pic, picVer, nil, nil)
  self.textTmpLeftRank:SetText(currentRank)
  self.textTmpPlayerNotice:SetLocalText(isUpgrade and "yuntieBattle_tips_1039" or "yuntieBattle_tips_1040")
  self.textTmpPlayerNotice:SetColor(isUpgrade and colorUpgrade or colorDown)
  local seq = DOTween.Sequence()
  local animName = isUpgrade and "Upgrade" or "Downgrade"
  local _, animLen = self.animatorPlayerRank:GetAnimationReturnTime(animName)
  self.animatorPlayerRank:Play(animName)
  seq:AppendInterval(animLen)
  seq:AppendCallback(Bind(self, self.AnimCompleted))
end

function LWUIActMeteoriteRankChangedNoticeView:PlayAllianceAnim(info)
  self.compPlayerRank:SetActive(false)
  self.compAllianceRank:SetActive(true)
  local player = info.player
  if not player then
    self:TryPlayNext()
    return
  end
  self.currentPlaying = info
  local currentRank = player.rank or 0
  local lastRank = player.lastRank or 0
  local score = player.score or 0
  local pic = player.icon
  local isUpgrade = lastRank <= 0 or currentRank <= lastRank
  self.compImgAllianceArrUp:SetActive(isUpgrade)
  self.compImgAllianceArrDown:SetActive(not isUpgrade)
  self.textTmpAllianceLeftRank:SetText(player.rank)
  self.textTmpFlagNotice:SetLocalText(isUpgrade and "yuntieBattle_tips_1039" or "yuntieBattle_tips_1040")
  self.textTmpFlagNotice:SetColor(isUpgrade and colorUpgrade or colorDown)
  self.imgFlagIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(pic)))
  local seq = DOTween.Sequence()
  local animName = isUpgrade and "Upgrade" or "Downgrade"
  local _, animLen = self.animatorAllianceRank:GetAnimationReturnTime(animName)
  self.animatorAllianceRank:Play(animName)
  seq:AppendInterval(animLen)
  seq:AppendCallback(Bind(self, self.AnimCompleted))
end

function LWUIActMeteoriteRankChangedNoticeView:TryPlayNotice(param)
  table.insert(self.msgQueue, param)
  self:TryPlayNext()
end

function LWUIActMeteoriteRankChangedNoticeView:AnimCompleted()
  self.currentPlaying = nil
  self:TryPlayNext()
end

function LWUIActMeteoriteRankChangedNoticeView:TryPlayNext()
  if self.currentPlaying then
    return
  end
  if #self.msgQueue <= 0 then
    self.ctrl:CloseSelf()
    return
  end
  local next = table.remove(self.msgQueue, 1)
  if not next then
    self:TryPlayNext()
    return
  end
  if next.type == 0 then
    self:PlayPlayerAnim(next)
  elseif next.type == 1 then
    self:PlayAllianceAnim(next)
  else
    self:TryPlayNext()
  end
end

LWUIActMeteoriteRankChangedNoticeView.OnCreate = OnCreate
LWUIActMeteoriteRankChangedNoticeView.OnDestroy = OnDestroy
LWUIActMeteoriteRankChangedNoticeView.OnEnable = OnEnable
LWUIActMeteoriteRankChangedNoticeView.OnDisable = OnDisable
LWUIActMeteoriteRankChangedNoticeView.ComponentDefine = ComponentDefine
LWUIActMeteoriteRankChangedNoticeView.ComponentDestroy = ComponentDestroy
LWUIActMeteoriteRankChangedNoticeView.DataDefine = DataDefine
LWUIActMeteoriteRankChangedNoticeView.DataDestroy = DataDestroy
LWUIActMeteoriteRankChangedNoticeView.OnAddListener = OnAddListener
LWUIActMeteoriteRankChangedNoticeView.OnRemoveListener = OnRemoveListener
return LWUIActMeteoriteRankChangedNoticeView
