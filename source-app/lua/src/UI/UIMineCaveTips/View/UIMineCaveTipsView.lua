local base = UIBaseView
local UIMineCaveTipsView = BaseClass("UIMineCaveTipsView", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Pivot_Max = 1.1
local Pivot_Min = -0.1
local Pivot_Mid = 0.5
local arrow_path = "offset/imgArrow"
local offset_path = "offset"
local icon_path = "offset/cave/caveIcon"
local name_path = "offset/cave/caveName"
local level_path = "offset/cave/caveLvTxt/caveLv"
local levelTxt_path = "offset/cave/caveLvTxt"
local resSpeed_path = "offset/res/resSpeedTxt/resSpeed"
local resTxtSpeed_path = "offset/res/resSpeedTxt"
local resItem_path = "offset/res/resItem"
local extra_path = "offset/rewards"
local extraTip_path = "offset/rewards/rewardTip"
local extraReward_path = "offset/rewards/layout/reward"
local occupy_path = "offset/occupy"
local remainTime_path = "offset/occupy/remainLayout/remainTimes"
local remainLayout_path = "offset/occupy/remainLayout"
local resProduct_path = "offset/occupy/nowLayout/nowGot"
local resProductTxt_path = "offset/occupy/nowLayout/nowTxt"
local resProductLayout_path = "offset/occupy/nowLayout"
local attackBtn_path = "offset/occupy/attackBtn"
local attackBtnTxt_path = "offset/occupy/attackBtn/Txt_Reward"
local bgBtn_path = "Panel"
local playerHeadContainer_path = "offset/cave/GameObject/UIPlayerHead"
local playerHead_path = "offset/cave/GameObject/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "offset/cave/GameObject/UIPlayerHead/Foreground"
local toUnlock_path = "offset/toUnlock"
local toUnlockTip_path = "offset/toUnlock/toUnlockTip"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self.offsetN.transform.position = Vector3.New(10000, 0, 0)
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.offsetN = self:AddComponent(UIBaseContainer, offset_path)
  self.offsetN.transform.position = Vector3.New(10000, 0, 0)
  self.arrowN = self:AddComponent(UIImage, arrow_path)
  self.iconN = self:AddComponent(UIImage, icon_path)
  self.nameN = self:AddComponent(UIText, name_path)
  self.levelN = self:AddComponent(UIText, level_path)
  self.levelTxtN = self:AddComponent(UIText, levelTxt_path)
  self.resSpeedN = self:AddComponent(UIText, resSpeed_path)
  self.resTxtSpeedN = self:AddComponent(UIText, resTxtSpeed_path)
  self.resItemN = self:AddComponent(UICommonResItem, resItem_path)
  self.extraN = self:AddComponent(UIBaseContainer, extra_path)
  self.extraTipN = self:AddComponent(UIText, extraTip_path)
  self.extraRewardsTb = {}
  for i = 1, 3 do
    local extra = self:AddComponent(UICommonResItem, extraReward_path .. i)
    table.insert(self.extraRewardsTb, extra)
  end
  self.occupyN = self:AddComponent(UIBaseContainer, occupy_path)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.remainLayoutN = self:AddComponent(UIBaseContainer, remainLayout_path)
  self.resProductLayoutN = self:AddComponent(UIBaseContainer, resProductLayout_path)
  self.resProductN = self:AddComponent(UIText, resProduct_path)
  self.resProductTxtN = self:AddComponent(UIText, resProductTxt_path)
  self.attackBtnN = self:AddComponent(UIButton, attackBtn_path)
  self.attackBtnN:SetOnClick(function()
    self:OnClickAttackBtn()
  end)
  self.attackBtnTxtN = self:AddComponent(UIText, attackBtnTxt_path)
  self.attackBtnTxtN:SetLocalText(302216)
  self.closeBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerHeadContainerN = self:AddComponent(UIBaseContainer, playerHeadContainer_path)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
  self.toUnlockN = self:AddComponent(UIBaseContainer, toUnlock_path)
  self.toUnlockTipN = self:AddComponent(UIText, toUnlockTip_path)
end

local function ComponentDestroy(self)
  self.offsetN = nil
  self.arrowN = nil
  self.iconN = nil
  self.nameN = nil
  self.levelN = nil
  self.levelTxtN = nil
  self.resSpeedN = nil
  self.resItemN = nil
  self.extraTipN = nil
  self.extraRewardsTb = nil
  self.remainTimeN = nil
  self.remainLayoutN = nil
  self.resProductLayoutN = nil
  self.resProductN = nil
  self.resProductTxtN = nil
  self.attackBtnN = nil
  self.attackBtnTxtN = nil
  self.closeBtnN = nil
  self.playerHeadContainerN = nil
  self.playerHeadN = nil
  self.playerHeadFgN = nil
end

local function DataDefine(self)
  self.showType = nil
  self.mineConf = nil
  self.myCaveInfo = nil
  self.caveInfo = nil
end

local function DataDestroy(self)
  self.showType = nil
  self.mineConf = nil
  self.myCaveInfo = nil
  self.caveInfo = nil
end

local function RefreshAll(self)
  local showType, num, alignObject = self:GetUserData()
  self.showType = showType
  if showType == 1 then
    self.mineConf = DataCenter.MineCaveManager:GetMineConf(num)
  elseif showType == 2 then
    self.caveInfo = DataCenter.MineCaveManager:GetMineInfo(num)
    self.mineConf = DataCenter.MineCaveManager:GetMineConf(self.caveInfo.mineId)
  elseif showType == 3 then
    self.myCaveInfo = DataCenter.MineCaveManager:GetMyCaveInfo(num)
    self.mineConf = DataCenter.MineCaveManager:GetMineConf(self.myCaveInfo.mineId)
  elseif showType == 4 then
    self.mineConf = DataCenter.MineCaveManager:GetMineConf(num)
  end
  self.alignObject = alignObject
  self.productSpeed = self.mineConf:GetResSpeed(DataCenter.BuildManager.MainLv)
  local resName = DataCenter.RewardManager:GetNameByType(self.mineConf.rewardType, self.mineConf.rewardId)
  local strSpeed = string.GetFormattedStr(self.productSpeed) .. "/h"
  self.resTxtSpeedN:SetText(Localization:GetString("302224", resName, strSpeed))
  self.resSpeedN:SetText("")
  local res = {
    rewardType = self.mineConf.rewardType,
    itemId = self.mineConf.rewardId
  }
  self.resItemN:ReInit(res)
  self.extraTipN:SetLocalText(302215)
  for i, v in ipairs(self.extraRewardsTb) do
    if i <= #self.mineConf.extraRewards then
      v:SetActive(true)
      local extra = {
        rewardType = self.mineConf.extraRewards[i].rewardType,
        itemId = self.mineConf.extraRewards[i].itemId
      }
      v:ReInit(extra)
    else
      v:SetActive(false)
    end
  end
  self:DelCountDownTimer()
  if self.showType == 1 then
    self:ShowPreview()
  elseif self.showType == 2 then
    self:ShowMine()
  elseif self.showType == 3 then
    self:ShowMyMine()
  elseif self.showType == 4 then
    local tempInfo = DataCenter.MineCaveManager:GetToUnlockMinesInfo()
    if tempInfo then
      self.toUnlockTipN:SetText(Localization:GetString("302328", tempInfo.score))
    else
      self.toUnlockTipN:SetText("")
    end
    self:ShowToUnlock(self)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    self:CheckAlign()
  end, 0.04)
end

local function ShowPreview(self)
  self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", self.mineConf.picture))
  self.nameN:SetLocalText(self.mineConf.name)
  self.levelN:SetText("")
  self.levelTxtN:SetLocalText(302220, self.mineConf.level)
  self.playerHeadContainerN:SetActive(false)
  self.extraN:SetActive(true)
  self.remainLayoutN:SetActive(true)
  self.occupyN:SetActive(true)
  self.attackBtnN:SetActive(false)
  self.resProductLayoutN:SetActive(false)
  self.toUnlockN:SetActive(false)
  self.remainTimeN:SetText(UITimeManager:GetInstance():SecondToFmtString(self.mineConf.occupyTime))
end

local function ShowMine(self)
  if not self.caveInfo then
    return
  end
  self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", self.mineConf.picture))
  self.levelN:SetText("")
  self.levelTxtN:SetLocalText(302220, self.mineConf.level)
  self.occupyN:SetActive(true)
  self.remainLayoutN:SetActive(true)
  self.resProductLayoutN:SetActive(false)
  self.toUnlockN:SetActive(false)
  self.extraN:SetActive(true)
  if not self.caveInfo.ownerUid then
    self.playerHeadContainerN:SetActive(false)
    self.nameN:SetLocalText(self.mineConf.name)
    self.remainTimeN:SetText(UITimeManager:GetInstance():SecondToFmtString(self.mineConf.occupyTime))
    self.attackBtnN:SetActive(true)
    local canAttack = DataCenter.MineCaveManager:CheckIfCanAttack()
    UIGray.SetGray(self.attackBtnN.transform, not canAttack, canAttack)
  else
    self.playerHeadContainerN:SetActive(true)
    self.playerHeadN:SetData(self.caveInfo.ownerUid, self.caveInfo.ownerPic, self.caveInfo.ownerPicVer)
    local tempFg = self.caveInfo:GetHeadBgImg()
    if tempFg then
      self.playerHeadFgN:SetActive(true)
    else
      self.playerHeadFgN:SetActive(false)
    end
    if string.IsNullOrEmpty(self.caveInfo.allianceAbbr) then
      self.nameN:SetText(Localization:GetString("302223", self.caveInfo.ownerName))
    else
      self.nameN:SetText(Localization:GetString("302223", "[" .. self.caveInfo.allianceAbbr .. "]" .. self.caveInfo.ownerName))
    end
    if self.caveInfo.allianceId == LuaEntry.Player.allianceId or self.caveInfo.ownerUid == LuaEntry.Player.uid then
      self.attackBtnN:SetActive(false)
    else
      self.attackBtnN:SetActive(true)
      local canAttack = DataCenter.MineCaveManager:CheckIfCanAttack()
      UIGray.SetGray(self.attackBtnN.transform, not canAttack, canAttack)
    end
    self.endTime = self.caveInfo.endTime
    self:AddCountDownTimer()
    self:RefreshRemainTime()
  end
end

local function ShowMyMine(self)
  if not self.myCaveInfo then
    return
  end
  self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", self.mineConf.picture))
  self.nameN:SetLocalText(self.mineConf.name)
  self.levelN:SetText("")
  self.levelTxtN:SetLocalText(302220, self.mineConf.level)
  self.occupyN:SetActive(true)
  self.remainLayoutN:SetActive(true)
  self.resProductLayoutN:SetActive(true)
  self.toUnlockN:SetActive(false)
  self.attackBtnN:SetActive(false)
  self.extraN:SetActive(true)
  self.endTime = self.myCaveInfo.endTime
  self:AddCountDownTimer()
  self:RefreshRemainTime()
end

local function ShowToUnlock(self)
  self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", self.mineConf.picture))
  self.nameN:SetLocalText(self.mineConf.name)
  self.levelN:SetText("")
  self.levelTxtN:SetLocalText(302220, self.mineConf.level)
  self.remainLayoutN:SetActive(false)
  self.resProductLayoutN:SetActive(true)
  self.toUnlockN:SetActive(true)
  self.occupyN:SetActive(false)
  self.extraN:SetActive(false)
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    if self.showType == 3 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local totalTime = self.myCaveInfo.endTime - self.myCaveInfo.startTime
      local passedTime = curTime - self.myCaveInfo.startTime
      local passedT = passedTime / 3600000
      local producted = math.modf(passedT * self.productSpeed)
      local strProducted = string.GetFormattedStr(producted)
      self.resProductN:SetText(strProducted)
      self.resProductTxtN:SetLocalText(302218)
    end
  else
    self.remainTimeN:SetText("")
    self:DelCountDownTimer()
    self.ctrl:CloseSelf()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function CheckAlign(self)
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scale = ScreenHeight / 750.0
  local _rect = self.offsetN.rectTransform.rect
  local BgWidth = _rect.width * scale
  local BgHeight = _rect.height * scale
  local alignObject = self.alignObject
  local _screenPos = PosConverse.WorldToScreenPos(alignObject.transform.position)
  local objWidth = alignObject.rectTransform.rect.width * scale
  local pivot = Vector2.New(0.5, 0.5)
  if ScreenWidth < _screenPos.x + objWidth * 0.4 + BgWidth then
    pivot.x = Pivot_Max
    _arrowX = BgWidth / scale * 0.5 + 3
  else
    pivot.x = Pivot_Min
    _arrowX = -BgWidth / scale * 0.5 - 3
  end
  local pivotY = 0.5
  if _screenPos.y < (ScreenHeight - BgHeight) / 2 then
    pivotY = 0.1
  elseif _screenPos.y > ScreenHeight / 2 + BgHeight / 2 then
    pivotY = 0.9
  else
    pivotY = (_screenPos.y - (ScreenHeight - BgHeight) / 2) / BgHeight
  end
  pivotY = math.min(pivotY, 0.9)
  pivotY = math.max(pivotY, 0.1)
  pivot.y = pivotY
  local rectH = _rect.height == 0 and 540 or _rect.height
  _arrowY = (pivotY - 0.5) * rectH
  if pivot.x == Pivot_Max then
    _rotation = 180
  else
    _rotation = 0
  end
  self.offsetN.rectTransform.pivot = pivot
  self.offsetN.transform.position = alignObject.transform.position
  self.arrowN.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self.arrowN.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
end

local function OnClickAttackBtn(self)
  DataCenter.MineCaveManager:CacheTargetMineInfo(self.caveInfo)
  EventManager:GetInstance():Broadcast(EventId.MineCaveShowDispatch, true)
  self.ctrl:CloseSelf()
end

UIMineCaveTipsView.OnCreate = OnCreate
UIMineCaveTipsView.OnDestroy = OnDestroy
UIMineCaveTipsView.ComponentDefine = ComponentDefine
UIMineCaveTipsView.ComponentDestroy = ComponentDestroy
UIMineCaveTipsView.DataDefine = DataDefine
UIMineCaveTipsView.DataDestroy = DataDestroy
UIMineCaveTipsView.RefreshAll = RefreshAll
UIMineCaveTipsView.ShowPreview = ShowPreview
UIMineCaveTipsView.ShowMine = ShowMine
UIMineCaveTipsView.ShowMyMine = ShowMyMine
UIMineCaveTipsView.ShowToUnlock = ShowToUnlock
UIMineCaveTipsView.AddCountDownTimer = AddCountDownTimer
UIMineCaveTipsView.RefreshRemainTime = RefreshRemainTime
UIMineCaveTipsView.DelCountDownTimer = DelCountDownTimer
UIMineCaveTipsView.DelayCheckAlign = DelayCheckAlign
UIMineCaveTipsView.CheckAlign = CheckAlign
UIMineCaveTipsView.OnClickAttackBtn = OnClickAttackBtn
return UIMineCaveTipsView
