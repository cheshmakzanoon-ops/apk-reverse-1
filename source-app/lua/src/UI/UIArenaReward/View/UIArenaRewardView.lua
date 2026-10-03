local UIArenaRewardView = BaseClass("UIArenaRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIArenaRewardCell = require("UI.UIArenaReward.Component.UIArenaRewardCell")
local title_path = "UICommonMidPopUpTitle/titleText"
local scroll_view_path = "ScrollView"
local closeBtn_path = "UICommonMidPopUpTitle/CloseBtn"
local maskBtn_path = "UICommonMidPopUpTitle/panel"
local tips_path = "Tip"
local endTime_txt_path = "Txt_EndTime"
local myRank_txt_path = "Txt_MyRank"

local function OnCreate(self)
  base.OnCreate(self)
  self.actId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetCellDestroy()
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
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, title_path)
  self.titleTxtN:SetLocalText(361012)
  self.tips = self:AddComponent(UIText, tips_path)
  self.tips:SetLocalText(372263)
  self._endTime_txt = self:AddComponent(UIText, endTime_txt_path)
  self._myRank_txt = self:AddComponent(UIText, myRank_txt_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.goalN = nil
  self.tip1N = nil
  self.tip2N = nil
  self.tip3N = nil
  self.tip4N = nil
  self.joinBtnN = nil
  self.joinBtnTxtN = nil
  self.createBtnN = nil
  self.createBtnTxtN = nil
  self.closeBtnN = nil
end

local function DataDefine(self)
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self:DeleteTimer()
  self.endTime = nil
  self.selfInfo = nil
  self.timer_action = nil
end

local function ReInit(self)
  self.listReward = self.ctrl:ShowReward(self.actId)
  self.selfInfo = DataCenter.ArenaManager:GetSelfInfo()
  self.endTime = DataCenter.ArenaManager:GetRoundEndTime()
  self:RefreshTime()
  self:AddTimer()
  if self.selfInfo.selfRank == -1 then
    self._myRank_txt:SetLocalText(372283, "--")
  else
    self._myRank_txt:SetLocalText(372283, self.selfInfo.selfRank)
  end
  self.scroll_view:SetTotalCount(#self.listReward.strLevel)
  self.scroll_view:RefillCells()
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIArenaRewardCell, itemObj)
  item:ShowRewards(self.listReward.strLevel[index], self.listReward.strReward[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIArenaRewardCell)
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.endTime then
    self:DeleteTimer()
    self._endTime_txt:SetText("00:00:00")
  else
    self._endTime_txt:SetLocalText(372256, UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function SetCellDestroy(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIArenaRewardCell)
  self.model = {}
end

UIArenaRewardView.OnCreate = OnCreate
UIArenaRewardView.OnDestroy = OnDestroy
UIArenaRewardView.ComponentDefine = ComponentDefine
UIArenaRewardView.DataDefine = DataDefine
UIArenaRewardView.DataDestroy = DataDestroy
UIArenaRewardView.ReInit = ReInit
UIArenaRewardView.SetCellDestroy = SetCellDestroy
UIArenaRewardView.OnEnable = OnEnable
UIArenaRewardView.OnDisable = OnDisable
UIArenaRewardView.ComponentDestroy = ComponentDestroy
UIArenaRewardView.AddTimer = AddTimer
UIArenaRewardView.RefreshTime = RefreshTime
UIArenaRewardView.DeleteTimer = DeleteTimer
UIArenaRewardView.OnCreateCell = OnCreateCell
UIArenaRewardView.OnDeleteCell = OnDeleteCell
return UIArenaRewardView
