local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UITacticalWeaponSignIn = BaseClass("UITacticalWeaponSignIn", base)
local TWDayItem = require("UI.UIActivityCenterTable.Component.ActSignIn.TWDayItem")
local claimAll_btn_path = "Root/Mask/Btn_List/Btn_OneGet"
local claimAll_txt_path = "Root/Mask/Btn_List/Btn_OneGet/Txt_OneGet"
local actName_txt_path = "Root/TitleBg/Txt_ActName"
local actTimes_txt_path = "Root/TitleBg/Txt_Times"
local actDesc_txt_path = "Root/TitleBg/Txt_ActDesc"
local prevDays_path = "Root/days/prevDays"
local finalDays_path = "Root/days/fianlDays"
local jumpTo_path = "Root/jumpTo"
local jumpToTxt_path = "Root/jumpTo/jumpToTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DestroyRewardItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.claimAll_btn = self:AddComponent(UIButton, claimAll_btn_path)
  self.claimAll_txt = self:AddComponent(UITextMeshProUGUIEx, claimAll_txt_path)
  self.actName_txt = self:AddComponent(UITextMeshProUGUIEx, actName_txt_path)
  self.actTimes_txt = self:AddComponent(UITextMeshProUGUIEx, actTimes_txt_path)
  self.actDesc_txt = self:AddComponent(UITextMeshProUGUIEx, actDesc_txt_path)
  self.prevDays = self:AddComponent(UIBaseContainer, prevDays_path)
  self.finalDays = self:AddComponent(UIBaseContainer, finalDays_path)
  self.jumpTo = self:AddComponent(UIButton, jumpTo_path)
  self.jumpToTxt = self:AddComponent(UITextMeshProUGUIEx, jumpToTxt_path)
  self.claimAll_btn:SetOnClick(function()
    self:OnClickClaimAllBtn()
  end)
  self.jumpTo:SetOnClick(function()
    if not string.IsNullOrEmpty(self.actBaseData.para_3) then
      GoToUtil.GoToByTypeAndParam(tonumber(self.actBaseData.para_3))
    end
  end)
  self.claimAll_txt:SetLocalText("activity_5401_tips4")
end

local function ComponentDestroy(self)
  self.claimAll_btn = nil
  self.claimAll_txt = nil
  self.actName_txt = nil
  self.actTimes_txt = nil
  self.actDesc_txt = nil
  self.prevDays = nil
  self.finalDays = nil
  self.jumpTo = nil
  self.jumpToTxt = nil
end

local function DataDefine(self)
  self.onClickDayReward = BindCallback(self, self.OnClickDayRewardItem)
end

local function DataDestroy(self)
  self.onClickDayReward = nil
  self.actId = nil
  self.actBaseData = nil
  self.actInfo = nil
  self.endTime = nil
end

local function RefreshBaseInfo(self)
  if not self.actBaseData then
    return
  end
  self.actName_txt:SetLocalText(self.actBaseData.name)
  self.actDesc_txt:SetLocalText(self.actBaseData.bannerTittle)
  if string.IsNullOrEmpty(self.actBaseData.para_2) then
    self.jumpTo:SetActive(false)
  else
    self.jumpTo:SetActive(true)
    self.jumpToTxt:SetLocalText(self.actBaseData.para_2)
  end
end

local function DestroyRewardItems(self)
  if self.dayRewardItems then
    for i, v in pairs(self.dayRewardItems) do
      self.prevDays:RemoveComponent(v:GetName(), TWDayItem)
    end
    self.dayRewardItems = nil
  end
  if self.dayRewardObjs then
    for i, v in pairs(self.dayRewardObjs) do
      self:GameObjectDestroy(v)
    end
    self.dayRewardObjs = nil
  end
  if self.finalDayRewardItem then
    self.finalDays:RemoveComponent(self.finalDayRewardItem:GetName(), TWDayItem)
    self.finalDayRewardItem = nil
  end
  if self.finalDayRewardObj then
    self:GameObjectDestroy(self.finalDayRewardObj)
    self.finalDayRewardObj = nil
  end
end

local function RefreshDayRewardItems(self)
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
      local dayRewardObjRequest = self:GameObjectInstantiateAsync(UIAssets.UITWSignInDayItem, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.prevDays.transform)
        go.transform.localScale = Vector3.New(1, 1, 1)
        local nameStr = i
        go.name = nameStr
        local dayRewardItem = self.prevDays:AddComponent(TWDayItem, go.name)
        dayRewardItem:OnRefresh(dayArr[i], nowReachDay, false)
        dayRewardItem:SetBtnOnClick(self.onClickDayReward)
        self.dayRewardItems[i] = dayRewardItem
      end)
      self.dayRewardObjs[i] = dayRewardObjRequest
    end
  end
  if not self.finalDayRewardObj then
    local finalDayRewardObjRequest = self:GameObjectInstantiateAsync(UIAssets.UITWSignInFinalDayItem, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.finalDays.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      local nameStr = 1
      go.name = nameStr
      self.finalDayRewardItem = self.finalDays:AddComponent(TWDayItem, go.name)
      self.finalDayRewardItem:OnRefresh(dayArr[#dayArr], nowReachDay, true)
      self.finalDayRewardItem:SetBtnOnClick(self.onClickDayReward)
    end)
    self.finalDayRewardObj = finalDayRewardObjRequest
  end
  if self.dayRewardItems then
    for i, v in pairs(self.dayRewardItems) do
      v:OnRefresh(dayArr[i], nowReachDay, false)
    end
  end
  if self.finalDayRewardItem then
    self.finalDayRewardItem:OnRefresh(dayArr[#dayArr], nowReachDay, true)
  end
  local canClaimRewardDay = self.actInfo:GetCanClaimRewardDay()
  self.claimAll_btn:SetActive(2 <= canClaimRewardDay)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.actId = activityId
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.endTime = self.actBaseData.endViewTime > 0 and self.actBaseData.endViewTime or self.actBaseData.endTime
  RefreshBaseInfo(self)
  self.actInfo = DataCenter.LWActSignInManager:GetActSignInInfo(activityId)
  RefreshDayRewardItems(self)
end

local function Update1000MS(self)
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.actTimes_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.actTimes_txt:SetText("")
    end
  else
    self.actTimes_txt:SetText("")
  end
end

local function OnActInfoUpdate(self)
  if self.actId then
    self.actInfo = DataCenter.LWActSignInManager:GetActSignInInfo(self.actId)
    RefreshDayRewardItems(self)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateActSignInData, self.OnActInfoUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateActSignInData, self.OnActInfoUpdate)
end

local function OnClickDayRewardItem(self, dayData)
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

local function OnClickClaimAllBtn(self)
  if self.actId then
    DataCenter.LWActSignInManager:ClaimActReward(self.actId, 0)
  end
end

UITacticalWeaponSignIn.OnCreate = OnCreate
UITacticalWeaponSignIn.OnDestroy = OnDestroy
UITacticalWeaponSignIn.OnEnable = OnEnable
UITacticalWeaponSignIn.OnDisable = OnDisable
UITacticalWeaponSignIn.ComponentDefine = ComponentDefine
UITacticalWeaponSignIn.ComponentDestroy = ComponentDestroy
UITacticalWeaponSignIn.DataDefine = DataDefine
UITacticalWeaponSignIn.DataDestroy = DataDestroy
UITacticalWeaponSignIn.SetData = SetData
UITacticalWeaponSignIn.Update1000MS = Update1000MS
UITacticalWeaponSignIn.OnActInfoUpdate = OnActInfoUpdate
UITacticalWeaponSignIn.OnAddListener = OnAddListener
UITacticalWeaponSignIn.OnRemoveListener = OnRemoveListener
UITacticalWeaponSignIn.DestroyRewardItems = DestroyRewardItems
UITacticalWeaponSignIn.OnClickDayRewardItem = OnClickDayRewardItem
UITacticalWeaponSignIn.OnClickClaimAllBtn = OnClickClaimAllBtn
return UITacticalWeaponSignIn
