local UIMultiRewardPopView = BaseClass("UIMultiRewardPopView", UIBaseView)
local MultiRewardList = require("UI.UIActivityCenterTable.Component.MultiReward.MultiRewardInfoComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local name_text_path = "Content/TopArea/NameText"
local activity_desc_text_path = "Content/TopArea/Layout/ActivityDescText"
local remain_time_text_path = "Content/TopArea/Layout/RemainTimeContent/RemainTimeText"
local multi_reward_info_path = "Content/MultiRewardInfo"
local panel_path = "Panel"
local b_g1_path = "Content/BGRoot/BG1"
local bottom_img_path = "Content/BGRoot/BottomImg"
local banner_img_path = "Content/BGRoot/BannerImg"
local double_img_path = "Content/BGRoot/DoubleImg"
local top_eff_point_path = "Content/TopEffPoint"
local close_btn_path = "Content/CloseBtn"
local bottom_eff_point_path = "Content/BGRoot/BottomEffPoint"

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
  self.param = self:GetUserData()
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.remainTimeText = self:AddComponent(UIText, remain_time_text_path)
  self.titleNameText = self:AddComponent(UIText, name_text_path)
  self.descText = self:AddComponent(UIText, activity_desc_text_path)
  self.cardListCpt = self:AddComponent(MultiRewardList, multi_reward_info_path)
  self.closeBtn = self:AddComponent(UIButton, panel_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bgImg1 = self:AddComponent(UIImage, b_g1_path)
  self.bottomImg = self:AddComponent(UIImage, bottom_img_path)
  self.bannerImg = self:AddComponent(UIRawImage, banner_img_path)
  self.doubleImg = self:AddComponent(UIImage, double_img_path)
  self.effPoint = self:AddComponent(UIVfx, top_eff_point_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl.CloseSelf()
  end)
  self.doubleEff = self:AddComponent(UIVfx, double_img_path)
  self.bottom_eff_point = self:AddComponent(UIVfx, bottom_eff_point_path)
end

local function ComponentDestroy(self)
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

function UIMultiRewardPopView:RefreshView()
  self.activityId = self.param
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self:ReplaceSpriteByConfig()
  self.titleNameText:SetLocalText(self.activityInfo.activityName)
  if not string.IsNullOrEmpty(self.activityInfo.desc_info) then
    self.descText:SetActive(true)
    self.descText:SetLocalText(self.activityInfo.desc_info)
  else
    self.descText:SetActive(false)
  end
  self:Update1000MS()
  self.cardListCpt:SetData(self.activityId)
end

function UIMultiRewardPopView:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
    self.ctrl:CloseSelf()
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.remainTimeText:SetText(countDownTimeStr)
end

function UIMultiRewardPopView:ReplaceSpriteByConfig()
  if self.activityInfo == nil then
    return
  end
  local showConfig = self.activityInfo:GetShowConfigTemp()
  if showConfig == nil then
    return
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec1) then
    local info = string.split(showConfig.pic_spec1, "|")
    if info then
      local img1Path = info[1]
      if img1Path then
        self.bgImg1:LoadSprite(img1Path)
      end
      local img2Path = info[2]
      if img2Path then
        self.bottomImg:LoadSprite(img2Path)
      end
    end
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec2) then
    self.bannerImg:LoadSprite(showConfig.pic_spec2)
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec3) then
    self.doubleImg:LoadSprite(showConfig.pic_spec3)
  end
  if not string.IsNullOrEmpty(showConfig.banner_effect) then
    self.effPoint:Play(showConfig.banner_effect, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  if not string.IsNullOrEmpty(showConfig.banner_effect2) then
    self.bottom_eff_point:Play(showConfig.banner_effect2, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec5) then
    self.doubleEff:Play(showConfig.pic_spec5, {
      lifeType = UIVfxLifeType.Stay
    })
    self.doubleImg:SetEnable(false)
  else
    self.doubleImg:SetEnable(true)
  end
end

UIMultiRewardPopView.OnCreate = OnCreate
UIMultiRewardPopView.OnDestroy = OnDestroy
UIMultiRewardPopView.OnEnable = OnEnable
UIMultiRewardPopView.OnDisable = OnDisable
UIMultiRewardPopView.ComponentDefine = ComponentDefine
UIMultiRewardPopView.ComponentDestroy = ComponentDestroy
UIMultiRewardPopView.DataDefine = DataDefine
UIMultiRewardPopView.DataDestroy = DataDestroy
UIMultiRewardPopView.OnAddListener = OnAddListener
UIMultiRewardPopView.OnRemoveListener = OnRemoveListener
return UIMultiRewardPopView
