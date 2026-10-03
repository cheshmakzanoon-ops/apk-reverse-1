local ResourceManager = CS.GameEntry.Resource
local UIRewardPreAniShowView = BaseClass("UIRewardPreAniShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local effect_content_path = "effectContent"
local minWaitTime = 1000
local needWaitTime = 3500

local function OnCreate(self)
  base.OnCreate(self)
  self.message = self:GetUserData()
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self:OnCloseBgClick()
  end)
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.effectPath = nil
  self.effectRequest = nil
end

local function ComponentDestroy(self)
  self:DeleteEffectContent()
  self.effect_content = nil
  self.effectPath = nil
  self.effectRequest = nil
end

local function RefreshView(self)
  local effectContentPath
  local activityId = self.message.activityId
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local showTemp = activityInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec4) then
    effectContentPath = showTemp.pic_spec4
  end
  if self.effectPath == effectContentPath then
    return
  end
  self:DeleteEffectContent()
  self.effectPath = effectContentPath
  if string.IsNullOrEmpty(effectContentPath) then
    return
  end
  local request = ResourceManager:InstantiateAsync(effectContentPath)
  self.effectRequest = request
  request:completed("+", function(req)
    if req.isError or req.gameObject == nil then
      return
    end
    local obj = req.gameObject
    local parent = self.effect_content
    obj:SetActive(true)
    local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(parent.transform)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0, 0)
    end
    local skeleton = obj.transform:Find("SkeletonContent/Skeleton"):GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
    self.effect_content:SetActive(false)
    self.effect_content:SetActive(true)
    if not IsNull(skeleton) then
      local animationState = skeleton.AnimationState
      if animationState and UISpine.HasAnimation(animationState, "animation") then
        animationState:SetAnimation(0, "animation", false)
      end
    end
  end)
end

local function OnCloseBgClick(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.openTime + minWaitTime then
    return
  end
  self:CloseFunction()
end

local function CloseFunction(self)
  local t = self.message
  DataCenter.RewardManager:ShowCommonReward(t)
  self.ctrl:CloseSelf()
end

local function Update100MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.openTime + needWaitTime then
    return
  end
  self:CloseFunction()
end

local function DeleteEffectContent(self)
  if self.effectRequest ~= nil then
    self.effectRequest:Destroy()
    self.effectRequest = nil
  end
  self.effectPath = nil
end

UIRewardPreAniShowView.OnCreate = OnCreate
UIRewardPreAniShowView.OnDestroy = OnDestroy
UIRewardPreAniShowView.ComponentDefine = ComponentDefine
UIRewardPreAniShowView.ComponentDestroy = ComponentDestroy
UIRewardPreAniShowView.RefreshView = RefreshView
UIRewardPreAniShowView.OnCloseBgClick = OnCloseBgClick
UIRewardPreAniShowView.CloseFunction = CloseFunction
UIRewardPreAniShowView.Update100MS = Update100MS
UIRewardPreAniShowView.DeleteEffectContent = DeleteEffectContent
return UIRewardPreAniShowView
