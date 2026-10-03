local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UISevenDayLoginNew = BaseClass("UISevenDayLoginNew", base)
local UISevenDayLoginPassRewardItem = require("UI.UIActivityCenterTable.Component.UISevenDayLogin.UISevenDayLoginPassRewardItemNew")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local Localization = CS.GameEntry.Localization
local actName_txt_path = "Root/TitleBg/Txt_ActName"
local actDesc_txt_path = "Root/TitleBg/Txt_ActDesc"
local buy_btn_path = "Root/TitleBg/BuyBtn"
local buy_text_path = "Root/TitleBg/BuyBtn/BuyText"
local buyTitle_text_path = "Root/TitleBg/BuyBtn/Txt_BuyTitle"
local scroll_view_path = "Root/Mask/ScrollView"
local scroll_content_path = "Root/Mask/ScrollView/Content"
local point_path = "Root/TitleBg/BuyBtn/UIGiftPackagePoint"
local oneGet_btn_path = "Root/Mask/Btn_List/Btn_OneGet"
local oneGet_txt_path = "Root/Mask/Btn_List/Btn_OneGet/Txt_OneGet"
local oneGetRed_rect_path = "Root/Mask/Btn_List/Btn_OneGet/Rect_OnGetRed"
local intro_btn_path = "Root/TitleBg/Intro"
local progress_path = "Root/Mask/ScrollView/Content/ProgressBar"
local dayText_path = "Root/TitleBg/DayBg/DayText"
local payLockIcon_path = "Root/TitleBg/PayBg/PayContent/LockIcon"
local lineContainer_path = "Root/Mask/ScrollView/Content/Lines"
local lineTemplate_path = "Root/Line"
local payText_path = "Root/TitleBg/PayBg/PayContent/PayText"
local timeText_path = "Root/TitleBg/Txt_Times"
local battle_pass_discount_path = "Root/BattlePassDiscount"
local discount_text_path = "Root/BattlePassDiscount/DiscountText"
local GetRewardType = {
  None = -1,
  Normal = 0,
  Special = 1
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.lineTemplate.gameObject:GameObjectRecycleAll()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveTimer()
end

local function ComponentDefine(self)
  self._actName_txt = self:AddComponent(UIText, actName_txt_path)
  self._actDesc_txt = self:AddComponent(UIText, actDesc_txt_path)
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, buy_btn_path)
  self.buy_btn:SetBuyClickAction(function()
    self:OnBuyClick()
  end)
  self._buyTitle_txt = self:AddComponent(UIText, buyTitle_text_path)
  self._buyTitle_txt:SetLocalText(2000335)
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.scroll_content = self:AddComponent(GridInfinityScrollView, scroll_content_path)
  self._oneGet_btn = self:AddComponent(UIButton, oneGet_btn_path)
  self._oneGet_btn:SetOnClick(function()
    self:OneGetClick()
  end)
  self._oneGetRed_rect = self:AddComponent(UIText, oneGetRed_rect_path)
  self._oneGet_txt = self:AddComponent(UIText, oneGet_txt_path)
  self._oneGet_txt:SetLocalText(110132)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self.progressSlider = self:AddComponent(UISlider, progress_path)
  self.progressSliderInstanceId = self.progressSlider.transform:GetInstanceID()
  self.dayText = self:AddComponent(UIText, dayText_path)
  self.payLockIcon = self:AddComponent(UIImage, payLockIcon_path)
  self.lineContainer = self:AddComponent(UIBaseContainer, lineContainer_path)
  self.lineContainerInstanceId = self.lineContainer.transform:GetInstanceID()
  self.lineTemplate = self:AddComponent(UIBaseContainer, lineTemplate_path)
  self.lineTemplate.gameObject:GameObjectCreatePool()
  local ani_bg_path = "Root/Mask/ScrollView/Content/aniBg"
  self.ani_bg = self:AddComponent(UIBaseContainer, ani_bg_path)
  self.ani_bgInstanceId = self.ani_bg.transform:GetInstanceID()
  local progress_bg_path = "Root/Mask/ScrollView/Content/progressBg"
  self.progress_bg = self:AddComponent(UIBaseContainer, progress_bg_path)
  self.progress_bgInstanceId = self.progress_bg.transform:GetInstanceID()
  self.childIndices = {}
  self.childIndices[self.progressSliderInstanceId] = true
  self.childIndices[self.lineContainerInstanceId] = true
  self.childIndices[self.ani_bgInstanceId] = true
  self.childIndices[self.progress_bgInstanceId] = true
  self.payText = self:AddComponent(UIText, payText_path)
  self.payText:SetLocalText(2000337)
  self.timeText = self:AddComponent(UIText, timeText_path)
  if not IsNull(self.transform:Find(battle_pass_discount_path)) then
    self.battle_pass_discount = self:AddComponent(UIImage, battle_pass_discount_path)
    self.discount_text = self:AddComponent(UIText, discount_text_path)
  end
end

local function ComponentDestroy(self)
  self._actName_txt = nil
  self._actDesc_txt = nil
  self.buy_btn = nil
  self.buy_desc_text = nil
  self.scroll_view = nil
  self.progressSlider = nil
  self.progressSliderInstanceId = nil
  self.dayText = nil
  self.payLockIcon = nil
  self.lineTemplate = nil
  self.lineContainer = nil
  self.lineContainerInstanceId = nil
  self.childIndices = nil
  self.payText = nil
  self.battle_pass_discount = nil
  self.discount_text = nil
end

local function DataDefine(self)
  self.view = nil
  self.specialUnlocked = nil
  self.itemList = {}
  self.curLevel = 0
  self.curIndex = 0
  self.packageInfo = nil
  self.timer = nil
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.view = nil
  self.specialUnlocked = nil
  self.itemList = nil
  self.curLevel = nil
  self.curIndex = nil
  self.listGO = nil
  self.listGOReward = nil
  self.timer_action = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBattlePass, self.OnRefresh)
  self:AddUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:AddUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBattlePass, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.RefreshBattlePass)
  self:RemoveUIListener(EventId.ActBattlePassStage, self.RefreshRewardCell)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  self.curType = 0
  if not self.activityId then
    return
  end
  self.actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self:OnRefresh()
  self:AddTimer()
end

local function RefreshProgressBar(self)
  if self.actData == nil then
    self.progressSlider:SetValue(0)
  end
  local count = #self.actData.stateInfo
  local singleDelta = 1 / (count * 2)
  local progress = 0
  if self.actData.battlePass.level == count then
    progress = 1
  else
    progress = self.actData.battlePass.level / count - singleDelta
  end
  progress = math.max(progress, 0)
  self.progressSlider:SetValue(progress)
end

local function OnRefresh(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.actData and self.actData.lastResetTime == nil then
    SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(self.activityId))
    return
  elseif not UITimeManager:GetInstance():IsSameDayForServer(self.actData.lastResetTime, curTime) then
    SFSNetwork.SendMessage(MsgDefines.GetBattlePassInfo, toInt(self.activityId))
    return
  end
  self.lastLv = self.actData.battlePass.level
  self:RefreshTop()
  self:RefreshRed()
  self:ShowCells()
end

local function RefreshTop(self, lastLv)
  if self.actBaseInfo then
    self._actName_txt:SetLocalText(self.actBaseInfo.name)
    self._actDesc_txt:SetLocalText(self.actBaseInfo.desc_info)
  end
  self.packageInfo = GiftPackageData.get(self.actData:GetExchangeId())
  if self.packageInfo and self.actData.battlePass.unlock == 0 then
    self.buy_btn:SetActive(true)
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.buy_btn:Init(self.packageInfo)
    self.buy_btn:RefreshPoint()
    self.payLockIcon:SetActive(true)
  else
    self.buy_btn:SetActive(false)
    self.payLockIcon:SetActive(false)
  end
  self.dayText:SetText(self.actData.battlePass.level)
  RefreshProgressBar(self)
  self:RefreshDiscountContent()
end

local function RefreshDiscountContent(self)
  if self.battle_pass_discount then
    if self.packageInfo then
      self.battle_pass_discount:SetActive(true)
      self.discount_text:SetText(string.format("%s%%", self.packageInfo:getPercent()))
    else
      self.battle_pass_discount:SetActive(false)
    end
  end
end

local function RefreshRed(self)
  local num = self.actData:GetRedNum(1)
  self._oneGetRed_rect:SetActive(0 < num)
end

local function ShowCells(self)
  if self.listGOReward then
    local count = #self.actData.stateInfo
    if count == 0 then
      self.scroll_view:SetActive(false)
    else
      self.scroll_view:SetActive(true)
      self.scroll_content:SetItemCount(count)
      self.scroll_content:ForceUpdate()
    end
  else
    self.listGOReward = {}
    local bindFunc1 = BindCallback(self, self.OnInitRewardScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateRewardScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyRewardScrollItem)
    self.scroll_content:Init(bindFunc1, bindFunc2, bindFunc3)
    local count = #self.actData.stateInfo
    if count == 0 then
      self.scroll_view:SetActive(false)
    else
      self.scroll_view:SetActive(true)
      self.scroll_content:SetItemCount(count)
      self.scroll_content:ForceUpdate()
      local index = DataCenter.ActBattlePassData:CheckCurGetReward(tonumber(self.activityId))
      self.scroll_content:MoveItemByIndex(index - 1, 0)
    end
    self.lineTemplate.gameObject:GameObjectRecycleAll()
    for i = 1, count - 1 do
      local item = self.lineTemplate.gameObject:GameObjectSpawn(self.lineContainer.transform)
      item:SetActive(true)
      item.name = "line_" .. i
    end
    self.progressSlider.rectTransform:Set_sizeDelta(33, 178 * count + (count - 1) * 8)
  end
end

local function OnInitRewardScroll(self, go, index)
  local item = self.scroll_view:AddComponent(UISevenDayLoginPassRewardItem, go)
  self.listGOReward[go] = item
end

local function OnUpdateRewardScroll(self, go, index)
  index = index + 1
  if index <= #self.actData.stateInfo then
    local item = self.listGOReward[go]
    if item then
      local data = self.actData.stateInfo[index]
      data.isFirst = index == 1
      data.isLast = index == #self.actData.stateInfo
      if index == 1 then
        data.pro = self.actData.battlePass.level / data.level
        data.showBallLeft = false
        if self.actData.battlePass.level < data.level then
          self.curIndex = index
        end
      else
        local lastData = self.actData.stateInfo[index - 1]
        data.pro = (self.actData.battlePass.level - lastData.level) / (data.level - lastData.level)
        data.showBallLeft = self.actData.battlePass.level >= lastData.level
        if self.actData.battlePass.level < data.level and self.actData.battlePass.level >= lastData.level then
          self.curIndex = index
        end
      end
      data.showBallRight = self.actData.battlePass.level >= data.level
      data.curLv = self.actData.battlePass.level
      data.unlock = self.actData.battlePass.unlock
      data.actId = toInt(self.activityId)
      item:SetData(data, self)
      go:SetActive(true)
      self.itemList[index] = item
    else
      Logger.LogError("No Item")
    end
  end
end

local function OnDestroyRewardScrollItem(self, go, index)
end

local function RefreshBattlePass(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self:RefreshTop()
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
end

local function RefreshRewardCell(self)
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(tonumber(self.activityId))
  self.scroll_content:ForceUpdate()
  self:RefreshRed()
end

local function OnBuyPackageSucc(self)
end

local function ClearScroll(self)
  self.scroll_view:RemoveComponents(UISevenDayLoginPassRewardItem)
  self.scroll_content:DestroyChildNodeExceptIndices(self.childIndices)
end

local function OneGetClick(self)
  local num = self.actData:GetRedNum(1)
  if 0 < num then
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassAllReward, toInt(self.activityId))
  else
    UIUtil.ShowTipsId(320446)
  end
end

local function OnBuyClick(self)
  if self.actData and self.actData.battlePass.unlock == 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, tonumber(self.activityId))
  end
end

local function OnIntroClick(self)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData == nil then
    return
  end
  local param = {}
  param.activityRulesStr = Localization:GetString(activityData.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

local function RefreshTime(self)
  if self.actBaseInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.actBaseInfo.endTime then
      self:RemoveTimer()
      self.timeText:SetText("")
    else
      self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.actBaseInfo.endTime - curTime))
    end
  else
    self:RemoveTimer()
    self.timeText:SetText("")
  end
end

local function AddTimer(self)
  if self.timer_action == nil then
    self.timer_action = BindCallback(self, self.RefreshTime)
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, nil, false, false, false)
  end
  self.timer:Start()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

UISevenDayLoginNew.OnCreate = OnCreate
UISevenDayLoginNew.OnDestroy = OnDestroy
UISevenDayLoginNew.OnEnable = OnEnable
UISevenDayLoginNew.OnDisable = OnDisable
UISevenDayLoginNew.ComponentDefine = ComponentDefine
UISevenDayLoginNew.ComponentDestroy = ComponentDestroy
UISevenDayLoginNew.DataDefine = DataDefine
UISevenDayLoginNew.DataDestroy = DataDestroy
UISevenDayLoginNew.OnAddListener = OnAddListener
UISevenDayLoginNew.OnRemoveListener = OnRemoveListener
UISevenDayLoginNew.SetData = SetData
UISevenDayLoginNew.OnRefresh = OnRefresh
UISevenDayLoginNew.RefreshTop = RefreshTop
UISevenDayLoginNew.RefreshRed = RefreshRed
UISevenDayLoginNew.RefreshDiscountContent = RefreshDiscountContent
UISevenDayLoginNew.ShowCells = ShowCells
UISevenDayLoginNew.OnInitRewardScroll = OnInitRewardScroll
UISevenDayLoginNew.OnUpdateRewardScroll = OnUpdateRewardScroll
UISevenDayLoginNew.OnDestroyRewardScrollItem = OnDestroyRewardScrollItem
UISevenDayLoginNew.RefreshBattlePass = RefreshBattlePass
UISevenDayLoginNew.RefreshRewardCell = RefreshRewardCell
UISevenDayLoginNew.OnBuyPackageSucc = OnBuyPackageSucc
UISevenDayLoginNew.ClearScroll = ClearScroll
UISevenDayLoginNew.OneGetClick = OneGetClick
UISevenDayLoginNew.OnBuyClick = OnBuyClick
UISevenDayLoginNew.OnIntroClick = OnIntroClick
UISevenDayLoginNew.RefreshProgressBar = RefreshProgressBar
UISevenDayLoginNew.RefreshTime = RefreshTime
UISevenDayLoginNew.AddTimer = AddTimer
UISevenDayLoginNew.RemoveTimer = RemoveTimer
return UISevenDayLoginNew
