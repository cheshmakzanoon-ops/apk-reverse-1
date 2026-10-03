local UIWinterStormBattleTaskView = BaseClass("UIWinterStormBattleTaskView", UIBaseView)
local base = UIBaseView
local ActMgr = DataCenter.ActWinterStormManager

function UIWinterStormBattleTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormBattleTaskView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormBattleTaskView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textBoxDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnMid = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnMid:SetOnClick(function()
    self:OnBtnMidClick()
  end)
  self.compList = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compBoxList = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
end

function UIWinterStormBattleTaskView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textBoxDesc = nil
  self.btnMid = nil
  self.compList = nil
  self.textInfo = nil
  self.compBoxList = nil
  self.textTip = nil
end

function UIWinterStormBattleTaskView:DataDefine()
  self.msg = self:GetUserData() or {}
  self.taskList = ActMgr:CreateTaskListAsync(self, self.compList, function()
    if self.taskList ~= nil then
      self.taskList:SetAnchoredPositionXY(0, 0)
      self.taskList:ShowBattle(self.msg.data)
    end
  end)
  local preAdd = self.taskList:ShowBattle(self.msg.data)
  self.textBoxDesc:SetLocalText("winter_s0_tips_9", preAdd)
  local num = LuaEntry.DataConfig:GetValue("winter_bf_S0", "k2", 0)
  self.textTip:SetLocalText("winter_s0_win_rate_tips", "<sprite=0>", "\195\151" .. num)
  local info = ActMgr:GetRewardInfo()
  self.boxList = ActMgr:CreateTaskBoxListAsync(self, self.compBoxList, function()
    if self.boxList ~= nil then
      self.boxList:SetAnchoredPositionXY(0, 0)
    end
  end)
  self.boxList:SetData({
    curScore = info.score,
    preAdd = preAdd
  })
end

function UIWinterStormBattleTaskView:DataDestroy()
  self.taskList = nil
  self.taskDetailList = nil
  self.boxList = nil
  if self.delayRefresh then
    self.delayRefresh:Stop()
    self.delayRefresh = nil
  end
end

function UIWinterStormBattleTaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WinterStormTaskDetailShow, self.ShowTaskDetail)
end

function UIWinterStormBattleTaskView:OnRemoveListener()
  self:RemoveUIListener(EventId.WinterStormTaskDetailShow, self.ShowTaskDetail)
  base.OnRemoveListener(self)
end

function UIWinterStormBattleTaskView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormBattleTaskView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormBattleTaskView:OnBtnMidClick()
  self.ctrl:CloseSelf()
end

function UIWinterStormBattleTaskView:ShowTaskDetail(pointType)
  if pointType == nil or pointType == BF_RewardPointType.None then
    if self.taskDetailList then
      self.taskDetailList:SetActive(false)
    end
    return
  end
  if self.taskDetailList == nil then
    self.taskDetailList = ActMgr:CreateTaskDetailListAsync(self, self.compList, function()
      if self.taskDetailList ~= nil then
        self.taskDetailList:SetAnchoredPositionXY(0, 0)
      end
    end)
  end
  self.taskDetailList:ShowDetail(pointType)
end

return UIWinterStormBattleTaskView
