local LWUIHeroSuggestTipsView = BaseClass("LWUIHeroSuggestTipsView", UIBaseView)
local base = UIBaseView
local delayCloseTime = 0.618
local delayCloseFrame = 10

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
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
  self.img_quality = self:AddComponent(UIImage, "imgQuality")
  self.img_icon = self:AddComponent(UIImage, "imgIcon")
  self.desc = self:AddComponent(UIText, "desc")
end

local function ComponentDestroy(self)
  self.img_quality = nil
  self.img_icon = nil
  self.desc = nil
end

local startTime

local function DataDefine(self)
  self.param = self:GetUserData()
  startTime = Time.realtimeSinceStartup
end

local function DataDestroy(self)
  self.param = nil
  self:DeleteDelayTimer()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

local function OnRemoveListener(self)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  base.OnRemoveListener(self)
end

function LWUIHeroSuggestTipsView.OnUpdate()
  if CS.UnityEngine.Input.GetMouseButtonDown(0) then
    if Time.realtimeSinceStartup - startTime < delayCloseTime then
      return
    end
    local timer = TimerManager:GetInstance():GetTimer(delayCloseFrame, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIHeroSuggestTips)
    end, self, true, true)
    timer:Start()
  end
end

local function InitData(self)
  if self.param then
    local icon = HeroUtils.GetQualityIconPath(self.param.quality, false)
    self.img_quality:LoadSprite(icon)
    local iconPath = HeroUtils.GetHeroIconPath(self.param.modelId)
    self.img_icon:LoadSpriteAuto(iconPath)
    if self.param.showType == 1 then
      self.desc:SetLocalText("newbies_guide_herosquad_desc1", CS.GameEntry.Localization:GetString(self.param.firstName))
    else
      self.desc:SetLocalText("newbies_guide_herosquad_desc2", CS.GameEntry.Localization:GetString(self.param.firstName))
    end
  end
end

local function DeleteDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function OnCloseWindow()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIHeroSuggestTips)
end

LWUIHeroSuggestTipsView.OnCreate = OnCreate
LWUIHeroSuggestTipsView.OnDestroy = OnDestroy
LWUIHeroSuggestTipsView.OnEnable = OnEnable
LWUIHeroSuggestTipsView.OnDisable = OnDisable
LWUIHeroSuggestTipsView.ComponentDefine = ComponentDefine
LWUIHeroSuggestTipsView.ComponentDestroy = ComponentDestroy
LWUIHeroSuggestTipsView.DataDefine = DataDefine
LWUIHeroSuggestTipsView.DataDestroy = DataDestroy
LWUIHeroSuggestTipsView.OnAddListener = OnAddListener
LWUIHeroSuggestTipsView.OnRemoveListener = OnRemoveListener
LWUIHeroSuggestTipsView.InitData = InitData
LWUIHeroSuggestTipsView.OnCloseWindow = OnCloseWindow
LWUIHeroSuggestTipsView.DeleteDelayTimer = DeleteDelayTimer
return LWUIHeroSuggestTipsView
