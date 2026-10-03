local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIFestivalCommonSignIn = BaseClass("UIFestivalCommonSignIn", base)
local Localization = CS.GameEntry.Localization
local FestivalCommonDayItem = require("UI.UIActivityCenterTable.Component.ActSignInFestivalCommon.FestivalCommonDayItem")

function UIFestivalCommonSignIn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFestivalCommonSignIn:OnDestroy()
  self:DestroyRewardItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFestivalCommonSignIn:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.rawImgTopBg = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.btnOneGet = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnOneGet:SetOnClick(function()
    self:OnBtnOneGetClick()
  end)
  self.textTxtOneGet = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRectOnGetRed = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnIntro = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnIntro:SetOnClick(function()
    self:OnBtnIntroClick()
  end)
  self.textTxtActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textOpenTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textTxtActDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compPrevDays = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compFianlDays = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.btnJumpTo = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnJumpTo:SetOnClick(function()
    self:OnBtnJumpToClick()
  end)
  self.textJumpToTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.imgJumpToIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.compTopBgEffectNode = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.textTxtOneGet:SetLocalText("activity_5401_tips4")
  self.btnJumpTo:SetActive(false)
  self.btnOneGet:SetSafeClickMode(true)
end

function UIFestivalCommonSignIn:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.rawImgTopBg = nil
  self.btnOneGet = nil
  self.textTxtOneGet = nil
  self.compRectOnGetRed = nil
  self.btnIntro = nil
  self.textTxtActName = nil
  self.textOpenTime = nil
  self.textTxtActDesc = nil
  self.compPrevDays = nil
  self.compFianlDays = nil
  self.btnJumpTo = nil
  self.textJumpToTxt = nil
  self.imgJumpToIcon = nil
  self.compTopBgEffectNode = nil
end

function UIFestivalCommonSignIn:DataDefine()
  self.onClickDayReward = BindCallback(self, self.OnClickDayRewardItem)
  self.itemShowConfig = {}
end

function UIFestivalCommonSignIn:DataDestroy()
  self.onClickDayReward = nil
  self.actId = nil
  self.actBaseData = nil
  self.actInfo = nil
  self.endTime = nil
  self.itemShowConfig = nil
end

function UIFestivalCommonSignIn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateActSignInData, self.OnActInfoUpdate)
end

function UIFestivalCommonSignIn:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateActSignInData, self.OnActInfoUpdate)
end

function UIFestivalCommonSignIn:OnBtnOneGetClick()
  self:OnClickClaimAllBtn()
end

function UIFestivalCommonSignIn:OnBtnIntroClick()
  local param = {}
  param.activityRulesStr = Localization:GetString(GetTableData(TableName.Activity, self.activityId, "desc"))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UIFestivalCommonSignIn:OnBtnJumpToClick()
  if not string.IsNullOrEmpty(self.actBaseData.para_3) then
    GoToUtil.GoToByTypeAndParam(tonumber(self.actBaseData.para_3))
  end
end

function UIFestivalCommonSignIn:SetData(activityId)
  base.SetData(self, activityId)
  self.actId = activityId
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.endTime = self.actBaseData.endViewTime > 0 and self.actBaseData.endViewTime or self.actBaseData.endTime
  self:RefreshBaseInfo()
  self.actInfo = DataCenter.LWActSignInManager:GetActSignInInfo(activityId)
  self:ModifyViewSkinByConfig()
  self:RefreshDayRewardItems()
end

function UIFestivalCommonSignIn:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.textOpenTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.textOpenTime:SetText("")
    end
  else
    self.textOpenTime:SetText("")
  end
end

function UIFestivalCommonSignIn:RefreshBaseInfo()
  if not self.actBaseData then
    return
  end
  self.textTxtActName:SetLocalText(self.actBaseData.name)
  self.textTxtActDesc:SetLocalText(self.actBaseData.bannerTittle)
end

function UIFestivalCommonSignIn:DestroyRewardItems()
  if self.dayRewardItems then
    for _, v in pairs(self.dayRewardItems) do
      self.compPrevDays:RemoveComponent(v:GetName(), FestivalCommonDayItem)
    end
    self.dayRewardItems = nil
  end
  if self.dayRewardObjs then
    for _, v in pairs(self.dayRewardObjs) do
      self:GameObjectDestroy(v)
    end
    self.dayRewardObjs = nil
  end
  if self.finalDayRewardItem then
    self.compFianlDays:RemoveComponent(self.finalDayRewardItem:GetName(), FestivalCommonDayItem)
    self.finalDayRewardItem = nil
  end
  if self.finalDayRewardObj then
    self:GameObjectDestroy(self.finalDayRewardObj)
    self.finalDayRewardObj = nil
  end
  if self.bannerEffect then
    self:GameObjectDestroy(self.bannerEffect)
    self.bannerEffect = nil
  end
end

function UIFestivalCommonSignIn:RefreshDayRewardItems()
  if not self.actInfo then
    return
  end
  local dayArr = self.actInfo:GetDayArr()
  if not dayArr then
    return
  end
  local nowReachDay = 0
  local now = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.actInfo.startTime
  nowReachDay = (now - startTime) / 86400000
  if not self.dayRewardObjs then
    self.dayRewardObjs = {}
    self.dayRewardItems = {}
    for i = 1, #dayArr - 1 do
      local dayRewardObjRequest = self:GameObjectInstantiateAsync(UIAssets.UIFestivalCommonDayItem, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compPrevDays.transform)
        go.transform.localScale = Vector3.New(1, 1, 1)
        local nameStr = i
        go.name = nameStr
        local dayRewardItem = self.compPrevDays:AddComponent(FestivalCommonDayItem, go.name)
        dayRewardItem:OnRefresh(dayArr[i], nowReachDay, false, self.itemShowConfig)
        dayRewardItem:SetBtnOnClick(self.onClickDayReward)
        self.dayRewardItems[i] = dayRewardItem
      end)
      self.dayRewardObjs[i] = dayRewardObjRequest
    end
  end
  if not self.finalDayRewardObj then
    local finalDayRewardObjRequest = self:GameObjectInstantiateAsync(UIAssets.UIFestivalCommonFinalDayItem, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compFianlDays.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      local nameStr = 1
      go.name = nameStr
      self.finalDayRewardItem = self.compFianlDays:AddComponent(FestivalCommonDayItem, go.name)
      self.finalDayRewardItem:OnRefresh(dayArr[#dayArr], nowReachDay, true, self.itemShowConfig)
      self.finalDayRewardItem:SetBtnOnClick(self.onClickDayReward)
    end)
    self.finalDayRewardObj = finalDayRewardObjRequest
  end
  if self.dayRewardItems then
    for i, v in pairs(self.dayRewardItems) do
      v:OnRefresh(dayArr[i], nowReachDay, false, self.itemShowConfig)
    end
  end
  if self.finalDayRewardItem then
    self.finalDayRewardItem:OnRefresh(dayArr[#dayArr], nowReachDay, true, self.itemShowConfig)
  end
  local canClaimRewardDay = self.actInfo:GetCanClaimRewardDay()
  self.btnOneGet:SetActive(2 <= canClaimRewardDay)
end

function UIFestivalCommonSignIn:OnActInfoUpdate()
  if self.actId then
    self.actInfo = DataCenter.LWActSignInManager:GetActSignInInfo(self.actId)
    self:RefreshDayRewardItems()
  end
end

function UIFestivalCommonSignIn:OnClickDayRewardItem(dayData)
  if not self.actInfo then
    return
  end
  if not self.endTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now >= self.endTime then
    return
  end
  if dayData and self.actId then
    local nowDay = 0
    local startTime = self.actInfo.startTime
    nowDay = (now - startTime) / 86400000
    if dayData.state == 0 and nowDay < dayData.day - 1 then
      return
    end
    if dayData.state == 2 then
      return
    end
    DataCenter.LWActSignInManager:ClaimActReward(self.actId, dayData.day)
  end
end

function UIFestivalCommonSignIn:OnClickClaimAllBtn()
  if self.actId then
    DataCenter.LWActSignInManager:ClaimActReward(self.actId, 0)
  end
end

function UIFestivalCommonSignIn:ModifyViewSkinByConfig()
  if not self.actBaseData then
    return
  end
  local bannerPath = self.actBaseData.activity_pic
  if not string.IsNullOrEmpty(bannerPath) then
    self.rawImgTopBg:LoadSpriteAuto(bannerPath)
  end
  local showConfig = self.actBaseData:GetShowConfigTemp()
  if not showConfig then
    return
  end
  local titleColor = showConfig.title_Color
  local descColor = showConfig.desc_Color
  local time_color = showConfig.time_Color
  if titleColor then
    local titleColorArr = string.split(titleColor, ",")
    self.textTxtActName:SetColorRGBA255(titleColorArr[1], titleColorArr[2], titleColorArr[3], titleColorArr[4])
  end
  if descColor then
    local descColorArr = string.split(descColor, ",")
    self.textTxtActDesc:SetColorRGBA255(descColorArr[1], descColorArr[2], descColorArr[3], descColorArr[4])
  end
  if time_color then
    local timeColorArr = string.split(time_color, ",")
    self.textOpenTime:SetColorRGBA255(timeColorArr[1], timeColorArr[2], timeColorArr[3], timeColorArr[4])
  end
  local pic_spec5 = showConfig.pic_spec5
  if not string.IsNullOrEmpty(pic_spec5) then
    self.imgBg:LoadSpriteAuto(pic_spec5)
  end
  self.itemShowConfig.itemBg = showConfig.pic_spec1
  self.itemShowConfig.itemFinalBg = showConfig.pic_spec2
  self.itemShowConfig.itemColor = showConfig.desc_Color
  self.itemShowConfig.itemFinalColor = showConfig.time_Color
  self.itemShowConfig.itemColor = showConfig.pic_spec3
  self.itemShowConfig.itemFinalColor = showConfig.pic_spec4
  self.itemShowConfig.showEffect = showConfig._showEffect == 1
  self.itemShowConfig.effectPath = showConfig.banner_effect2
  self:AddEffect(showConfig._showEffect == 1)
end

function UIFestivalCommonSignIn:AddEffect(showEffect)
  if not showEffect then
    return
  end
  if self.bannerEffect then
    self:GameObjectDestroy(self.bannerEffect)
    self.bannerEffect = nil
  end
  local showConfig = self.actBaseData:GetShowConfigTemp()
  if not showConfig then
    return
  end
  local path = showConfig.banner_effect_bottom
  if string.IsNullOrEmpty(path) then
    return
  end
  self.bannerEffect = self:GameObjectInstantiateAsync(path, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.compTopBgEffectNode.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end)
end

return UIFestivalCommonSignIn
