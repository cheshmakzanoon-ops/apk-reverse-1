local base = UIBaseView
local UIAllianceAutoJoinRallyView = BaseClass("UIAllianceAutoJoinRallyView", base)
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local subTitle_path = "offset/Title"
local desc_path = "offset/desc"
local rewardTip_path = "offset/rewardTip"
local rewardContent_path = "offset/rewards"
local infoBtn_path = "offset/rewardTimes/infoBtn"
local rewardTimes_path = "offset/rewardTimes"
local autoJoinBtn_path = "offset/autoBtn"
local autoJoinBtnTxt_path = "offset/autoBtn/autoTxt"
local autoInfo_path = "offset/autoInfo"
local leftTimeTip_path = "offset/autoInfo/remainTime/remainTimeTip"
local leftTime_path = "offset/autoInfo/remainTime"
local curPosTip_path = "offset/autoInfo/curPos/curPosTip"
local curPos_path = "offset/autoInfo/curPos"
local autoBtnRed_path = "offset/autoBtn/autoBtnRed"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(143565)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetLocalText(143566)
  self.descN = self:AddComponent(UIText, desc_path)
  self.descN:SetLocalText(143567)
  self.rewardTipN = self:AddComponent(UIText, rewardTip_path)
  self.rewardTipN:SetLocalText(143568)
  self.rewardContentN = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.rewardTimesN = self:AddComponent(UIText, rewardTimes_path)
  self.autoJoinBtnN = self:AddComponent(UIButton, autoJoinBtn_path)
  self.autoJoinBtnN:SetOnClick(function()
    self:OnClickAutoJoinBtn()
  end)
  self.autoJoinBtnTxtN = self:AddComponent(UIText, autoJoinBtnTxt_path)
  self.autoInfoN = self:AddComponent(UIBaseContainer, autoInfo_path)
  self.leftTimeTipN = self:AddComponent(UIText, leftTimeTip_path)
  self.leftTimeTipN:SetLocalText(143572)
  self.leftTimeN = self:AddComponent(UIText, leftTime_path)
  self.curPosTipN = self:AddComponent(UIText, curPosTip_path)
  self.curPosTipN:SetLocalText(143570)
  self.curPosN = self:AddComponent(UIText, curPos_path)
  self.autoBtnRedN = self:AddComponent(UIBaseContainer, autoBtnRed_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.descN = nil
  self.rewardTipN = nil
  self.rewardContentN = nil
  self.infoBtnN = nil
  self.rewardTimesN = nil
  self.autoJoinBtnN = nil
  self.autoJoinBtnTxtN = nil
  self.leftTimeN = nil
  self.curPosN = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function DataDefine(self)
  self.endTime = 0
  self.models = {}
end

local function DataDestroy(self)
  self:DelTimer()
  self:SetAllCellDestroy()
  self.endTime = nil
  self.models = nil
end

local function InitData(self)
  self:RefreshAll()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceAutoJoinRallyInfo)
end

local function RefreshAll(self)
  self:ShowRewardList()
  local killedNum = DataCenter.MonsterManager:GetKillBossNum()
  local maxNum = DataCenter.MonsterManager:GetMaxKillBossNum()
  killedNum = killedNum > maxNum and maxNum or killedNum
  self.rewardTimesN:SetText(Localization:GetString("143569", math.floor(killedNum) .. "/" .. math.floor(maxNum)))
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local autoInfo = DataCenter.AllianceBaseDataManager:GetAutoRallyInfo()
  if not autoInfo then
    self.autoInfoN:SetActive(false)
    return
  end
  self.endTime = autoInfo.endTime
  if serverTime < self.endTime then
    self.autoJoinBtnTxtN:SetLocalText(110106)
    self.autoInfoN:SetActive(true)
    self:AddTimer()
    self:RefreshRemainTime()
    self.curPosN:SetText(autoInfo.curPos)
    self.autoBtnRedN:SetActive(false)
  else
    self.autoJoinBtnTxtN:SetLocalText(143571)
    self.autoInfoN:SetActive(false)
    self:DelTimer()
    self:RefreshRemainTime()
    self.curPosN:SetLocalText(143573)
    if killedNum < maxNum then
      self.autoBtnRedN:SetActive(true)
    else
      self.autoBtnRedN:SetActive(false)
    end
  end
end

local function ShowRewardList(self)
  self:SetAllCellDestroy()
  local rewardList = {}
  local strRewards = LuaEntry.DataConfig:TryGetStr("world_auto_join_team", "k4")
  local arrRewards = string.split(strRewards, "|")
  for i, v in ipairs(arrRewards) do
    local idType = string.split(v, ";")
    if #idType == 2 then
      local reward = {}
      reward.rewardType = tonumber(idType[2])
      reward.itemId = idType[1]
      table.insert(rewardList, reward)
    end
  end
  self.models = {}
  if rewardList ~= nil then
    for i = 1, table.length(rewardList) do
      self.models[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardContentN.transform)
        go.transform:Set_localScale(0.8, 0.8, 0.8)
        go.transform:Set_localPosition(0, 0, 0)
        go.name = "item" .. i
        local cell = self.rewardContentN:AddComponent(UICommonResItem, go.name)
        local param = {}
        param.rewardType = rewardList[i].rewardType
        param.itemId = rewardList[i].itemId
        cell:ReInit(param)
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.rewardContentN:RemoveComponents(UICommonResItem)
  if self.models ~= nil then
    for k, v in pairs(self.models) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.models = nil
end

local function AddTimer(self)
  function self.TimerAction()
    self:RefreshRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.leftTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.leftTimeN:SetLocalText(143573)
    self:DelTimer()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtnN.transform.position + Vector3.New(0, 10, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = Localization:GetString("361018")
  param.content = Localization:GetString("361067")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickAutoJoinBtn(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if self.endTime and serverTime < self.endTime then
    SFSNetwork.SendMessage(MsgDefines.StopAllianceAutoRally)
  elseif DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.FUN_BUILD_SMITHY, 1) then
    SFSNetwork.SendMessage(MsgDefines.StartAllianceAutoRally)
  else
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.FUN_BUILD_SMITHY)
  end
end

UIAllianceAutoJoinRallyView.OnCreate = OnCreate
UIAllianceAutoJoinRallyView.OnDestroy = OnDestroy
UIAllianceAutoJoinRallyView.OnAddListener = OnAddListener
UIAllianceAutoJoinRallyView.OnRemoveListener = OnRemoveListener
UIAllianceAutoJoinRallyView.ComponentDefine = ComponentDefine
UIAllianceAutoJoinRallyView.ComponentDestroy = ComponentDestroy
UIAllianceAutoJoinRallyView.DataDefine = DataDefine
UIAllianceAutoJoinRallyView.DataDestroy = DataDestroy
UIAllianceAutoJoinRallyView.InitData = InitData
UIAllianceAutoJoinRallyView.RefreshAll = RefreshAll
UIAllianceAutoJoinRallyView.ShowRewardList = ShowRewardList
UIAllianceAutoJoinRallyView.AddTimer = AddTimer
UIAllianceAutoJoinRallyView.RefreshRemainTime = RefreshRemainTime
UIAllianceAutoJoinRallyView.DelTimer = DelTimer
UIAllianceAutoJoinRallyView.OnClickInfoBtn = OnClickInfoBtn
UIAllianceAutoJoinRallyView.OnClickAutoJoinBtn = OnClickAutoJoinBtn
UIAllianceAutoJoinRallyView.SetAllCellDestroy = SetAllCellDestroy
return UIAllianceAutoJoinRallyView
