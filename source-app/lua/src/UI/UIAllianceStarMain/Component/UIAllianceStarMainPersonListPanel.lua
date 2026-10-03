local UIAllianceStarMainPersonListPanel = BaseClass("UIAllianceStarMainPersonListPanel", UIBaseContainer)
local UIAllianceStarMainPersonListItem = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainPersonListItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ItemCount = 3

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
  self.textTip = self:AddComponent(UIText, "TipText")
  self.personItem1 = self:AddComponent(UIAllianceStarMainPersonListItem, "PersonList/PersonItem1")
  self.personItem2 = self:AddComponent(UIAllianceStarMainPersonListItem, "PersonList/PersonItem2")
  self.personItem3 = self:AddComponent(UIAllianceStarMainPersonListItem, "PersonList/PersonItem3")
  self.flyPlayerHead = self:AddComponent(UICommonHead, "FlyUIPlayerHead")
  self.flyPlayerHead:SetActive(false)
end

local function ComponentDestroy(self)
  self.textTip = nil
  self.personItem1 = nil
  self.personItem2 = nil
  self.personItem3 = nil
  self.flyPlayerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

local function Refresh(self, param)
  self.textTip:SetText(param.tipText)
  for i = 1, ItemCount do
    if param.nominatePlayerInfoList[i] then
      self["personItem" .. i]:SetActive(true)
      self["personItem" .. i]:SetData(param.nominatePlayerInfoList[i])
    else
      self["personItem" .. i]:SetActive(false)
    end
  end
  if param.showAnim then
    if param.starDuration then
      local animTime = 0
      local starPlayerHead = self.personItem1
      for i = 1, ItemCount do
        local playerHead, time = self["personItem" .. i]:PlayStarAnim(param.starPlayerInfo, 0)
        if playerHead then
          starPlayerHead = playerHead
          animTime = time
        end
      end
      self.view:PlayCaidaiEffect()
      local flyTime = 0.3
      if 0 < flyTime then
        TimerManager:GetInstance():DelayInvoke(function()
          if self and self.flyPlayerHead then
            for i = 1, ItemCount do
              self["personItem" .. i]:SetActive(false)
            end
            self.flyPlayerHead:SetActive(true)
            if param.starPlayerInfo then
              self.flyPlayerHead:ParseHeadInfo(param.starPlayerInfo)
            end
            self.flyPlayerHead:SetPosition(starPlayerHead:GetPosition())
            self.flyPlayerHead:SetSizeDelta(starPlayerHead:GetSizeDelta())
            local targetHead = self.view:GetPersonAwardPlayerHead()
            local p0, p2 = self.flyPlayerHead:GetPosition(), targetHead:GetPosition()
            local p1 = (p0 + p2) * 0.5
            local s0, s1 = self.flyPlayerHead:GetSizeDelta(), targetHead:GetSizeDelta()
            if self.tween ~= nil then
              self.tween:Kill()
            end
            self.tween = DOTween.To(function()
              return 0
            end, function(t)
              local pos = CalculateCubicBezierPointFor2C(t, p0, p1, p2)
              self.flyPlayerHead:SetPosition(pos)
              self.flyPlayerHead:SetSizeDelta(Vector2.Lerp(s0, s1, t))
            end, 1, flyTime):SetEase(CS.DG.Tweening.Ease.OutBack)
            self.tween:Play()
          end
        end, animTime)
      end
    end
  elseif param.showAnim == false then
    if param.starDuration then
      for i = 1, ItemCount do
        self["personItem" .. i]:SetActive(false)
      end
      local targetHead = self.view:GetPersonAwardPlayerHead()
      self.flyPlayerHead:SetActive(true)
      self.flyPlayerHead:ParseHeadInfo(param.starPlayerInfo)
      self.flyPlayerHead:SetPosition(targetHead:GetPosition())
      self.flyPlayerHead:SetSizeDelta(targetHead:GetSizeDelta())
    end
  else
    for i = 1, ItemCount do
      if param.nominatePlayerInfoList[i] then
        self["personItem" .. i]:SetActive(true)
      else
        self["personItem" .. i]:SetActive(false)
      end
    end
    self.flyPlayerHead:SetActive(false)
  end
end

UIAllianceStarMainPersonListPanel.OnCreate = OnCreate
UIAllianceStarMainPersonListPanel.OnDestroy = OnDestroy
UIAllianceStarMainPersonListPanel.OnEnable = OnEnable
UIAllianceStarMainPersonListPanel.OnDisable = OnDisable
UIAllianceStarMainPersonListPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainPersonListPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainPersonListPanel.DataDefine = DataDefine
UIAllianceStarMainPersonListPanel.DataDestroy = DataDestroy
UIAllianceStarMainPersonListPanel.OnAddListener = OnAddListener
UIAllianceStarMainPersonListPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainPersonListPanel.Refresh = Refresh
return UIAllianceStarMainPersonListPanel
