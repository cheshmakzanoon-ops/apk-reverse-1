local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWUIActRecycleMainComponent = BaseClass("LWUIActRecycleMainComponent", base)
local Localization = CS.GameEntry.Localization
local LWUICommonResBarComponent = require("UI.UICommon.Component.LWUICommonResBarComponent")

function LWUIActRecycleMainComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleMainComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleMainComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtTimes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDescription = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compLWUICommonResBar = self.viewSkin:AddComponent(self, LWUICommonResBarComponent, 4)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.btnPreview = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPreview:SetOnClick(function()
    self:OnBtnPreviewClick()
  end)
  self.textPreviewBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 8)
  self.btnRecruit = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRecruit:SetOnClick(function()
    self:OnBtnRecruitClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgRecruitBtnIcon = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textRecreuitBtnNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.textSwitchBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.toggleLW = self.viewSkin:AddComponent(self, UIToggle, 15)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.btnExchange = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnExchange:SetOnClick(function()
    self:OnBtnExchangeClick()
  end)
  self.compExchangeRed = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.textExchangeBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.rawImgBgRawImg = self.viewSkin:AddComponent(self, UIRawImage, 21)
  self.compBgEffectContent = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.compEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.compUICommonResItem.gameObject:GameObjectCreatePool()
  self.textPreviewBtn:SetLocalText("activity_99165_main_3_btn")
  self.textExchangeBtn:SetLocalText("activity_99165_main_4_name")
  self.textToggle:SetLocalText("activity_99165_main_5_btn")
  self.textSwitchBtn:SetLocalText("activity_99165_main_7_btn")
  self.btnRecruit:SetSafeClickMode(true)
  self.toggleLW:SetOnValueChanged(function(tf)
    DataCenter.ActRecycleManager:SetSkipLotteryAnim(tf)
  end)
  self.effectFrontReq = nil
  self.effectFront = nil
  self.effectBackReq = nil
  self.effectBack = nil
end

function LWUIActRecycleMainComponent:ComponentDestroy()
  self:ClearTopScroll()
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  if self.effectFrontReq then
    self.effectFrontReq:Destroy()
    self.effectFrontReq = nil
  end
  self.effectFront = nil
  if self.effectBackReq then
    self.effectBackReq:Destroy()
    self.effectBackReq = nil
  end
  self.effectBack = nil
  self.viewSkin = nil
  self.textTitle = nil
  self.textTxtTimes = nil
  self.textDescription = nil
  self.compLWUICommonResBar = nil
  self.btnLWInfo = nil
  self.btnPreview = nil
  self.textPreviewBtn = nil
  self.compUICommonResItem = nil
  self.btnRecruit = nil
  self.textBtn = nil
  self.imgRecruitBtnIcon = nil
  self.textRecreuitBtnNum = nil
  self.btnSwitch = nil
  self.textSwitchBtn = nil
  self.toggleLW = nil
  self.textToggle = nil
  self.compLayout = nil
  self.btnExchange = nil
  self.compExchangeRed = nil
  self.textExchangeBtn = nil
  self.rawImgBgRawImg = nil
  self.compBgEffectContent = nil
  self.compEffect = nil
end

function LWUIActRecycleMainComponent:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.mainTemplate = nil
  self.drawNum = 1
  self.soundId = 0
end

function LWUIActRecycleMainComponent:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.mainTemplate = nil
  self.drawNum = nil
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
  self.soundId = nil
end

function LWUIActRecycleMainComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActRecycleExchangeSuccessMsg, self.OnExchangeSuccessMsg)
  self:AddUIListener(EventId.ActRecycleLotterySuccessMsg, self.OnLotterySuccessMsg)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
end

function LWUIActRecycleMainComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
  self:RemoveUIListener(EventId.ActRecycleExchangeSuccessMsg, self.OnExchangeSuccessMsg)
  self:RemoveUIListener(EventId.ActRecycleLotterySuccessMsg, self.OnLotterySuccessMsg)
  base.OnRemoveListener(self)
end

function LWUIActRecycleMainComponent:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    DataCenter.ActRecycleManager:PrintRealErrorLog("SetData: activityInfo is nil activityId = " .. tostring(self.activityId))
    return
  end
  self.mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(self.activityInfo.subType)
  if self.mainTemplate == nil then
    DataCenter.ActRecycleManager:PrintRealErrorLog("SetData: mainTemplate is nil subType = " .. tostring(self.activityInfo.subType))
    return
  end
  DataCenter.ActRecycleManager:SetMultiDrawOn(false)
  self:RefreshAll()
  self.soundId = DataCenter.LWSoundManager:PlaySound(91109)
end

function LWUIActRecycleMainComponent:OnDisable()
  base.OnDisable(self)
  if self.soundId ~= nil and self.soundId ~= 0 then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = 0
  end
end

function LWUIActRecycleMainComponent:RefreshAll()
  if self.activityInfo == nil then
    return
  end
  self:RefreshBase()
  self:RefreshTop()
  self:RefreshBottom()
  self:RefreshExchangeRed()
end

function LWUIActRecycleMainComponent:RefreshBase()
  if self.activityInfo == nil or self.mainTemplate == nil then
    return
  end
  if not string.IsNullOrEmpty(self.activityInfo.activity_pic) then
    self.rawImgBgRawImg:LoadSpriteAsync(self.activityInfo.activity_pic)
  end
  if self.effectFrontReq == nil then
    if not string.IsNullOrEmpty(self.mainTemplate.res_main_a) then
      self.effectFrontReq = self:GameObjectInstantiateAsync(self.mainTemplate.res_main_a, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.compEffect.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.effectFront = go
      end)
    end
    self.compEffect.transform:Set_localScale(CommonUtil.ArabicAutoMirrorFactor(), ResetScale.y, ResetScale.z)
  end
  if self.effectBackReq == nil then
    if not string.IsNullOrEmpty(self.mainTemplate.res_main_b) then
      self.effectBackReq = self:GameObjectInstantiateAsync(self.mainTemplate.res_main_b, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.compBgEffectContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.effectBack = go
      end)
    end
    self.compBgEffectContent.transform:Set_localScale(CommonUtil.ArabicAutoMirrorFactor(), ResetScale.y, ResetScale.z)
  end
end

function LWUIActRecycleMainComponent:RefreshTop()
  if self.activityInfo == nil or self.mainTemplate == nil then
    return
  end
  self.textTitle:SetLocalText(self.activityInfo.name)
  self.textDescription:SetLocalText(self.activityInfo.bannerTittle)
  self:Update1000MS()
  local costData = self.mainTemplate:GetCostData()
  if costData then
    self.compLWUICommonResBar:SetData(costData.itemId)
  end
  self:ClearTopScroll()
  local rewardData = {
    rewardType = RewardType.GOODS,
    itemId = self.mainTemplate.show_item,
    count = nil
  }
  local item = self.compUICommonResItem.gameObject:GameObjectSpawn(self.compLayout.transform)
  local obj = self.compLayout:AddComponent(UICommonResItem, item.name)
  obj:SetActive(true)
  obj:ReInit(rewardData)
end

function LWUIActRecycleMainComponent:RefreshBottom()
  if self.activityInfo == nil or self.mainTemplate == nil then
    return
  end
  local cost = self.mainTemplate:GetCostData()
  if cost == nil then
    return
  end
  local haveNum = DataCenter.ItemData:GetItemCount(cost.itemId)
  local drawNum = 1
  local isMultiOn = DataCenter.ActRecycleManager:IsMultiDrawOn()
  if isMultiOn then
    local canDrawNum = math.floor(haveNum / cost.num)
    if canDrawNum <= 1 or canDrawNum > self.mainTemplate.single_draw_max then
      drawNum = self.mainTemplate.single_draw_max
    else
      drawNum = canDrawNum
    end
  end
  self.drawNum = drawNum
  local costNum = drawNum * cost.num
  local isEnough = haveNum >= costNum
  self.textBtn:SetLocalText("activity_99165_main_6_btn", "\195\151" .. tostring(drawNum))
  if isEnough then
    self.textRecreuitBtnNum:SetText(haveNum .. "/" .. costNum)
  else
    self.textRecreuitBtnNum:SetText(string.format("<color=#EA2525> %s</color>", haveNum) .. "/" .. costNum)
  end
  local itemIcon = DataCenter.ItemTemplateManager:GetIconPath(cost.itemId)
  self.imgRecruitBtnIcon:LoadSprite(itemIcon)
  self.btnSwitch:SetActive(self.mainTemplate:IsShowLotterySwitch())
  self.toggleLW:SetIsOn(DataCenter.ActRecycleManager:IsSkipLotteryAnim())
end

function LWUIActRecycleMainComponent:Update1000MS()
  if self.activityInfo == nil then
    return
  end
  local endTime = self.activityInfo:GetShowEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = endTime - curTime
  self.textTxtTimes:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, leftTime)))
end

function LWUIActRecycleMainComponent:ClearTopScroll()
  self.compLayout:RemoveComponents(UICommonResItem)
  self.compUICommonResItem.gameObject:GameObjectRecycleAll()
end

function LWUIActRecycleMainComponent:OnBtnLWInfoClick()
  if self.activityInfo and not table.IsNullOrEmpty(self.activityInfo.howtoplay) then
    local param = {}
    param.howToPlayList = self.activityInfo.howtoplay
    param.story = self.activityInfo.story
    param.defaultTitle = self.activityInfo.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    DataCenter.LWSoundManager:PlaySound(91125)
  end
end

function LWUIActRecycleMainComponent:OnBtnPreviewClick()
  if not self.activityId then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleDrawInfo, {anim = true}, self.activityId)
end

function LWUIActRecycleMainComponent:OnBtnRecruitClick()
  if not self.activityId or not self.drawNum then
    return
  end
  if not DataCenter.ActRecycleManager:IsLotteryItemEnough(self.activityId, self.drawNum) then
    if not IsNull(self.clickFingerHandle) then
      self.clickFingerHandle:Destroy()
      self.clickFingerHandle = nil
    end
    self.clickFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.clickFingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      if self.btnExchange then
        transform.position = self.btnExchange.transform.position
      end
      self.delayDestroyFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.clickFingerHandle then
          self.clickFingerHandle:Destroy()
          self.clickFingerHandle = nil
        end
      end, 2)
    end)
    return
  end
  DataCenter.ActRecycleManager:SendLottery(self.activityId, self.drawNum)
end

function LWUIActRecycleMainComponent:OnBtnSwitchClick()
  local isOn = DataCenter.ActRecycleManager:IsMultiDrawOn()
  DataCenter.ActRecycleManager:SetMultiDrawOn(not isOn)
  self:RefreshBottom()
end

function LWUIActRecycleMainComponent:OnBtnExchangeClick()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleExchange, {anim = true}, self.activityId)
  end
end

function LWUIActRecycleMainComponent:OnExchangeSuccessMsg(msg)
  self.compLWUICommonResBar:RefreshData()
  self:RefreshBottom()
end

function LWUIActRecycleMainComponent:OnLotterySuccessMsg(msg)
  self.compLWUICommonResBar:RefreshData()
  self:RefreshBottom()
  if msg ~= nil then
    local isSkipAnim = DataCenter.ActRecycleManager:IsSkipLotteryAnim()
    if isSkipAnim then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleReceiveGift, {anim = true}, msg)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleLotteryAnimShow, {anim = true}, msg)
    end
  end
end

function LWUIActRecycleMainComponent:RefreshExchangeRed()
  local data = DataCenter.ActRecycleManager:GetData(self.activityId)
  if data then
    local isShowExchangeRed = data:GetExchangeShopRed() > 0
    self.compExchangeRed:SetActive(isShowExchangeRed)
  end
end

function LWUIActRecycleMainComponent:OnRefreshActivityRedDot()
  self:RefreshExchangeRed()
end

return LWUIActRecycleMainComponent
