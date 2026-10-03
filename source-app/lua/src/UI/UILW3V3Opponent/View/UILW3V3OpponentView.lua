local UILW3V3OpponentView = BaseClass("UILW3V3OpponentView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local bgPanel_path = "panel"
local root_path = "Root"
local blowEffect_path = "Root/Eff_ui_peijian_mubiaoshengji_hong"
local selfPlayer_path = "Root/Self"
local selfPlayerHead_path = "Root/Self/SelfHead"
local selfPlayerName_path = "Root/Self/SelfNameLayout"
local selfPower_path = "Root/Self/Power"
local selfPowerText_path = "Root/Self/Power/SelfPowerText"
local selfScore_path = "Root/Self/Score"
local selfScoreText_path = "Root/Self/Score/SelfScoreText"
local opponentPlayer_path = "Root/Opponent"
local opponentPlayerHead_path = "Root/Opponent/OpponentHead"
local opponentPlayerName_path = "Root/Opponent/OpponentNameLayout"
local opponentPower_path = "Root/Opponent/OppoPower"
local opponentPowerText_path = "Root/Opponent/OppoPower/OpponentPowerText"
local opponentScore_path = "Root/Opponent/OppoScore"
local opponentScoreText_path = "Root/Opponent/OppoScore/OpponentScoreText"
local fireEffect_path = "Root/Eff_ui_jiasu_fire_xiao"

local function KillAllTweens(self)
  for i, v in ipairs(self.tweens) do
    v:Kill()
  end
  self.tweens = {}
  self.root.transform:DOKill()
  self.opponentPlayer.transform:DOKill()
end

local function SetLeftPlayerInfo(self)
  if not self.leftPlayerInfo then
    return
  end
  if not self.selfPlayerHead then
    return
  end
  self.selfPlayer:SetActive(true)
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(self.leftPlayerInfo.headSkinId, nil, false)
  self.selfPlayerHead:SetData(self.leftPlayerInfo.uid, self.leftPlayerInfo.pic, self.leftPlayerInfo.picver, nil, headFramePath)
  self.selfPlayerName:SetData(self.leftPlayerInfo.name, self.leftPlayerInfo.abbr, nil, nil, nil, nil, self.leftPlayerInfo.srcServer)
  self.selfPowerText:SetText(self.leftPlayerInfo.formationPower)
  self.selfScoreText:SetText(self.leftPlayerInfo.score)
end

local function SetRightPlayerInfo(self, playerInfo)
  if not playerInfo then
    return
  end
  if not self.opponentPlayerHead then
    return
  end
  self.opponentPlayer:SetActive(true)
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET, false)
  self.opponentPlayerHead:SetData(playerInfo.uid, playerInfo.pic, playerInfo.picver, nil, headFramePath)
  self.opponentPlayerName:SetData(playerInfo.name, playerInfo.abbr, nil, nil, nil, nil, playerInfo.srcServer)
  self.opponentPowerText:SetText(playerInfo.formationPower)
  self.opponentScoreText:SetText(playerInfo.score)
end

local function HideLeftPlayerInfo(self)
  self.selfPlayer:SetActive(false)
end

local function HideRightPlayerInfo(self)
  self.opponentPlayer:SetActive(false)
end

local function OnAnimFinish(self)
  self.skipTween = true
  if self.delayOpen then
    self.delayOpen:Stop()
    self.delayOpen = nil
  end
  self.delayOpen = TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl == nil then
      return
    end
    self.ctrl:CloseSelf()
    self:OpenBattleScene()
  end, 1.3)
end

function UILW3V3OpponentView:OpenBattleScene()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILW3V3Campaign, {anim = false}, false, PVEEnterType.Arena3V3)
end

local function StartPlayChooseOpponentAnim(self, players, playerInfo)
  local roundTime = 0.05
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  local playerIndex = 0
  for i, v in ipairs(players) do
    if v.uid == playerInfo.uid then
      playerIndex = i - 1
      break
    end
  end
  for i = 1, #players + playerIndex do
    if i ~= 1 then
      sequence:AppendInterval(roundTime)
    end
    sequence:AppendCallback(function()
      local playerIndex = i % #players
      SetRightPlayerInfo(self, players[playerIndex])
    end)
  end
  sequence:AppendInterval(roundTime)
  sequence:AppendCallback(function()
    if self and self.blowEffect then
      self.blowEffect:SetActive(false)
      self.blowEffect:SetActive(true)
    end
  end)
  sequence:AppendCallback(function()
    SetRightPlayerInfo(self, playerInfo)
    OnAnimFinish(self)
  end)
  table.insert(self.tweens, sequence)
end

local function StartPlayAnim(self)
  local sizeTween = self.root.rectTransform:DOSizeDelta(Vector2.New(800, 800), 0.5):OnComplete(function()
    SetLeftPlayerInfo(self)
    StartPlayChooseOpponentAnim(self, self.rightPlayers, self.rightPlayerInfo)
  end)
  local alphaTween = self.root:FadeIn(1, 0.5)
  table.insert(self.tweens, sizeTween)
  table.insert(self.tweens, alphaTween)
end

local function SkipAnim(self)
  KillAllTweens(self)
  self.root.rectTransform:Set_sizeDelta(800, 800)
  self.root:SetAlpha(1)
  SetLeftPlayerInfo(self)
  SetRightPlayerInfo(self, self.rightPlayerInfo)
  self.blowEffect:SetActive(false)
  self.skipTween = true
  OnAnimFinish(self)
end

local function ComponentDefine(self)
  self.bgPanel = self:AddComponent(UIButton, bgPanel_path)
  self.bgPanel:SetOnClick(function()
    if not self.skipTween then
      SkipAnim(self)
    end
  end)
  self.root = self:AddComponent(UICanvasGroup, root_path)
  self.blowEffect = self:AddComponent(UIBaseContainer, blowEffect_path)
  self.blowEffect:SetActive(false)
  self.selfPlayer = self:AddComponent(UICanvasGroup, selfPlayer_path)
  self.selfPlayerHead = self:AddComponent(UICommonHead, selfPlayerHead_path)
  self.selfPlayerName = self:AddComponent(UICommonNameLayout, selfPlayerName_path)
  self.selfPower = self:AddComponent(UIBaseContainer, selfPower_path)
  self.selfPowerText = self:AddComponent(UIText, selfPowerText_path)
  self.selfScore = self:AddComponent(UIBaseContainer, selfScore_path)
  self.selfScoreText = self:AddComponent(UIText, selfScoreText_path)
  self.opponentPlayer = self:AddComponent(UICanvasGroup, opponentPlayer_path)
  self.opponentPlayerHead = self:AddComponent(UICommonHead, opponentPlayerHead_path)
  self.opponentPlayerName = self:AddComponent(UICommonNameLayout, opponentPlayerName_path)
  self.opponentPower = self:AddComponent(UIBaseContainer, opponentPower_path)
  self.opponentPowerText = self:AddComponent(UIText, opponentPowerText_path)
  self.opponentScore = self:AddComponent(UIBaseContainer, opponentScore_path)
  self.opponentScoreText = self:AddComponent(UIText, opponentScoreText_path)
  self.fireEffect = self:AddComponent(UIBaseContainer, fireEffect_path)
  self.root.rectTransform:Set_sizeDelta(0, 800)
  self.root:SetAlpha(0)
  HideLeftPlayerInfo(self)
  HideRightPlayerInfo(self)
end

local function ComponentDestroy(self)
  self.bgPanel = nil
  self.root = nil
  self.blowEffect = nil
  self.selfPlayer = nil
  self.selfPlayerHead = nil
  self.selfPlayerName = nil
  self.selfPower = nil
  self.selfPowerText = nil
  self.selfScore = nil
  self.selfScoreText = nil
  self.opponentPlayer = nil
  self.opponentPlayerHead = nil
  self.opponentPlayerName = nil
  self.opponentPower = nil
  self.opponentPowerText = nil
  self.opponentScore = nil
  self.opponentScoreText = nil
  self.fireEffect = nil
end

local function DataDefine(self)
  self.tweens = {}
  self.skipTween = false
end

local function DataDestroy(self)
  self.tweens = {}
  self.skipTween = false
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  self.leftPlayerInfo, self.rightPlayerInfo, self.rightPlayers = self:GetUserData()
  StartPlayAnim(self)
end

local function OnDestroy(self)
  if self.delayOpen then
    self.delayOpen:Stop()
    self.delayOpen = nil
  end
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

UILW3V3OpponentView.OnCreate = OnCreate
UILW3V3OpponentView.OnDestroy = OnDestroy
UILW3V3OpponentView.OnEnable = OnEnable
UILW3V3OpponentView.OnDisable = OnDisable
UILW3V3OpponentView.ComponentDefine = ComponentDefine
UILW3V3OpponentView.ComponentDestroy = ComponentDestroy
UILW3V3OpponentView.DataDefine = DataDefine
UILW3V3OpponentView.DataDestroy = DataDestroy
return UILW3V3OpponentView
