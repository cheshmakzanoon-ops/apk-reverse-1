local UIMultiReward = BaseClass("UIMultiReward", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MultiRewardList = require("UI.UIActivityCenterTable.Component.MultiReward.MultiRewardInfoComponent")
local remain_time_text_path = "Root/TopArea/Layout/RemainTimeContent/RemainTimeText"
local name_text_path = "Root/TopArea/NameText"
local activity_desc_text_path = "Root/TopArea/Layout/ActivityDescText"
local multi_reward_info_path = "Root/Content/MultiRewardInfo"
local b_g1_path = "Root/BG1"
local bottom_img_path = "Root/BottomImg"
local banner_img_path = "Root/BannerImg"
local double_img_path = "Root/TopArea/DoubleImg"
local top_eff_point_path = "Root/TopEffPoint"
local info_btn_path = "Root/TopArea/InfoBtn"
local layout_path = "Root/TopArea/Layout"
local bottom_eff_point_path = "Root/BottomEffPoint"

function UIMultiReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.UIHideViewShown, self.OnHideViewShown)
end

function UIMultiReward:OnHideViewShown()
  self:SetData(self.activityId)
end

function UIMultiReward:OnDestroy()
  self:RemoveUIListener(EventId.UIHideViewShown, self.OnHideViewShown)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultiReward:OnEnable()
  base.OnEnable(self)
end

function UIMultiReward:OnDisable()
  base.OnDisable(self)
end

function UIMultiReward:ComponentDefine()
  self.remainTimeText = self:AddComponent(UIText, remain_time_text_path)
  self.titleNameText = self:AddComponent(UIText, name_text_path)
  self.descText = self:AddComponent(UIText, activity_desc_text_path)
  self.cardListCpt = self:AddComponent(MultiRewardList, multi_reward_info_path)
  self.bgImg1 = self:AddComponent(UIImage, b_g1_path)
  self.bottomImg = self:AddComponent(UIImage, bottom_img_path)
  self.bannerImg = self:AddComponent(UIRawImage, banner_img_path)
  self.doubleImg = self:AddComponent(UIImage, double_img_path)
  self.effPoint = self:AddComponent(UIVfx, top_eff_point_path)
  self.bottom_eff_point = self:AddComponent(UIVfx, bottom_eff_point_path)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.doubleEff = self:AddComponent(UIVfx, double_img_path)
  self.baseInfoLayout = self.transform:Find(layout_path):GetComponent(typeof(CS.UnityEngine.UI.VerticalLayoutGroup))
  if not CommonUtil.IsArabic() then
    self.baseInfoLayout.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
  else
    self.baseInfoLayout.childAlignment = CS.UnityEngine.TextAnchor.UpperRight
  end
  self.infoBtn:SetOnClick(function()
    self:OnIntroClick()
  end)
end

function UIMultiReward:ComponentDestroy()
  self.remainTimeText = nil
end

function UIMultiReward:DataDefine()
  self.activityInfo = nil
  self.activityId = nil
  self.remainTimeUpdateTimer = nil
end

function UIMultiReward:DataDestroy()
  self.activityInfo = nil
  self.activityId = nil
  self:StopAllTime()
end

function UIMultiReward:OnAddListener()
  base.OnAddListener(self)
end

function UIMultiReward:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMultiReward:SetData(activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self:OnRefresh()
end

function UIMultiReward:OnRefresh()
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
  self:StopAllTime()
  self:Update1000MS()
  self.remainTimeUpdateTimer = TimerManager:GetInstance():GetTimer(1, self.Update1000MS, self, false, false, false)
  self.cardListCpt:SetData(self.activityId)
end

function UIMultiReward:ReplaceSpriteByConfig()
  if self.activityInfo == nil then
    return
  end
  local showConfig = self.activityInfo:GetShowConfigTemp()
  if showConfig == nil then
    return
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec1) then
    local info = string.split(showConfig.pic_spec1, "|")
    if info and 2 <= #info then
      local img1Path = info[1]
      local img2Path = info[2]
      self.bgImg1:LoadSprite(img1Path)
      self.bottomImg:LoadSprite(img2Path)
    end
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec4) then
    self.bannerImg:LoadSprite(showConfig.pic_spec4)
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec3) then
    self.doubleImg:LoadSprite(showConfig.pic_spec3)
  end
  if not string.IsNullOrEmpty(showConfig.banner_effect) then
    self.effPoint:Play(showConfig.banner_effect, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  if not string.IsNullOrEmpty(showConfig.banner_effect_bottom) then
    self.bottom_eff_point:Play(showConfig.banner_effect_bottom, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  if not string.IsNullOrEmpty(showConfig.pic_spec5) then
    self.doubleImg:SetEnable(false)
    self.doubleEff:Play(showConfig.pic_spec5, {
      lifeType = UIVfxLifeType.Stay
    })
  else
    self.doubleImg:SetEnable(true)
  end
  UIActivityCenterCommonUtil.SetTopViewColor(self.titleNameText.gameObject, nil, self.remainTimeText.gameObject, showConfig)
end

function UIMultiReward:Update1000MS()
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
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.remainTimeText:SetText(countDownTimeStr)
end

function UIMultiReward:OnIntroClick()
  if self.activityInfo and not string.IsNullOrEmpty(self.activityInfo.story) then
    local param = {}
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    param.activityId = self.activityId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
  end
end

function UIMultiReward:StopAllTime()
  if self.remainTimeUpdateTimer then
    self.remainTimeUpdateTimer:Stop()
    self.remainTimeUpdateTimer = nil
  end
end

return UIMultiReward
