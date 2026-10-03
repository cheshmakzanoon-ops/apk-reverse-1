local base = UIBaseContainer
local UILWSeasonMilitaryEliteTopPlayerComp = require("UI.LWSeason6.UILWSeasonMilitaryElite.Comp.UILWSeasonMilitaryEliteTopPlayerComp")
local p_content_top_3_path = "p_content_top_3"
local p_top_2_path = "p_content_top_3/p_top_2"
local p_top_1_path = "p_content_top_3/p_top_1"
local p_top_3_path = "p_content_top_3/p_top_3"
local p_locate_top_path = "p_locate_top"
local p_locate_bottom_path = "p_locate_bottom"
local p_locate_left_path = "p_locate_left"
local p_locate_right_path = "p_locate_right"
local p_locate_mid_path = "p_locate_mid"
local UILWSeasonMilitaryEliteTopThreeComp = BaseClass("UILWSeasonMilitaryEliteTopThreeComp", UIBaseContainer)

function UILWSeasonMilitaryEliteTopThreeComp:ComponentDefine()
  self.p_content_top_3 = self:AddComponent(UICanvasGroup, p_content_top_3_path)
  self.p_top_2 = self:AddComponent(UILWSeasonMilitaryEliteTopPlayerComp, p_top_2_path)
  self.p_top_1 = self:AddComponent(UILWSeasonMilitaryEliteTopPlayerComp, p_top_1_path)
  self.p_top_3 = self:AddComponent(UILWSeasonMilitaryEliteTopPlayerComp, p_top_3_path)
  self.p_locate_mid = self:AddComponent(UIBaseContainer, p_locate_mid_path)
  self.p_locate_top = self:AddComponent(UIBaseContainer, p_locate_top_path)
  self.p_locate_bottom = self:AddComponent(UIBaseContainer, p_locate_bottom_path)
  self.p_locate_left = self:AddComponent(UIBaseContainer, p_locate_left_path)
  self.p_locate_right = self:AddComponent(UIBaseContainer, p_locate_right_path)
  self.compPlayers = {
    self.p_top_1,
    self.p_top_2,
    self.p_top_3
  }
end

function UILWSeasonMilitaryEliteTopThreeComp:ComponentDestroy()
  if self.Sequence ~= nil then
    self.Sequence:Kill(false)
    self.Sequence = nil
  end
  self.p_content_top_3 = nil
  self.p_top_2 = nil
  self.p_top_1 = nil
  self.p_top_3 = nil
  self.p_locate_mid = nil
  self.p_locate_top = nil
  self.p_locate_bottom = nil
  self.p_locate_left = nil
  self.p_locate_right = nil
end

function UILWSeasonMilitaryEliteTopThreeComp:DataDefine()
  self.Moving = false
  local directionEnum = DataCenter.SeasonMilitaryEliteManager.TopThreeAnimDirection
  self.InFrom = {
    [directionEnum.None] = self.p_locate_mid,
    [directionEnum.Up] = self.p_locate_bottom,
    [directionEnum.Down] = self.p_locate_top,
    [directionEnum.Left] = self.p_locate_right,
    [directionEnum.Right] = self.p_locate_left
  }
  self.OutTo = {
    [directionEnum.None] = self.p_locate_mid,
    [directionEnum.Up] = self.p_locate_top,
    [directionEnum.Down] = self.p_locate_bottom,
    [directionEnum.Left] = self.p_locate_left,
    [directionEnum.Right] = self.p_locate_right
  }
end

function UILWSeasonMilitaryEliteTopThreeComp:DataDestroy()
end

function UILWSeasonMilitaryEliteTopThreeComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryEliteTopThreeComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteTopThreeComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryEliteTopThreeComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteTopThreeComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UILWSeasonMilitaryEliteTopThreeComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UILWSeasonMilitaryEliteTopThreeComp:InitUi()
  for i = 1, 3 do
    if i <= table.count(self.Data.ranks) then
      local playerData = {}
      playerData.PlayerData = self.Data.ranks[i]
      self.compPlayers[i]:ReInit(playerData)
    else
      self.compPlayers[i]:ReInit(nil)
    end
  end
end

function UILWSeasonMilitaryEliteTopThreeComp:UpdateData()
end

function UILWSeasonMilitaryEliteTopThreeComp:UpdateUi()
end

function UILWSeasonMilitaryEliteTopThreeComp:AnimIn(animDirection, delay, onComplete)
  if animDirection == DataCenter.SeasonMilitaryEliteManager.TopThreeAnimDirection.None then
    self.p_content_top_3:SetActive(true)
    self.p_content_top_3:SetAlpha(1)
    self.p_content_top_3.transform.position = self.p_locate_mid.transform.position
    if onComplete ~= nil then
      onComplete()
    end
    self.Moving = false
    return
  end
  self.Moving = true
  self.p_content_top_3:SetActive(true)
  self.p_content_top_3:SetAlpha(0)
  local from = self.InFrom[animDirection]
  local to = self.p_locate_mid
  self:Move(from, to, 0, 1, 0.2, delay, onComplete)
end

function UILWSeasonMilitaryEliteTopThreeComp:AnimOut(animDirection, delay, onComplete)
  delay = delay or 0
  if animDirection == DataCenter.SeasonMilitaryEliteManager.TopThreeAnimDirection.None then
    self.p_content_top_3:SetActive(true)
    self.p_content_top_3:SetAlpha(0)
    if onComplete ~= nil then
      onComplete()
    end
    self.Moving = false
    return
  end
  self.Moving = true
  self.p_content_top_3:SetActive(true)
  self.p_content_top_3:SetAlpha(1)
  local from = self.p_locate_mid
  local to = self.OutTo[animDirection]
  self:Move(from, to, 1, 0, 0.2, delay, onComplete)
end

function UILWSeasonMilitaryEliteTopThreeComp:IsMoving()
  return self.Moving
end

function UILWSeasonMilitaryEliteTopThreeComp:Move(from, to, alphaFrom, alphaTo, duration, delay, onComplete)
  self.p_content_top_3:GetAlpha()
  self.p_content_top_3.transform.position = from.transform.position
  self.p_content_top_3:SetAlpha(alphaFrom)
  self.Sequence = CS.DG.Tweening.DOTween.Sequence()
  self.Sequence:AppendInterval(delay)
  local moveTween = self.p_content_top_3.transform:DOMove(to.transform.position, duration)
  self.Sequence:Append(moveTween)
  local fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.p_content_top_3:GetAlpha()
  end, function(value)
    self.p_content_top_3:SetAlpha(value)
  end, alphaTo, duration)
  self.Sequence:Join(fadeTween)
  self.Sequence:SetEase(CS.DG.Tweening.Ease.InOutCubic)
  self.Sequence:OnComplete(function()
    self.Moving = false
    if onComplete then
      onComplete()
    end
  end)
  self.Sequence:Play()
end

return UILWSeasonMilitaryEliteTopThreeComp
