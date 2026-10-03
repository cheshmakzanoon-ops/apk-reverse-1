local BuildGetItemAfterShowTalk = BaseClass("BuildGetItemAfterShowTalk")
local des_path = "Go/Bg/Des"
local bg_go_path = "Go"
local AutoCloseTime = 3
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.des_text = self.transform:Find(des_path):GetComponent(typeof(CS.SuperTextMesh))
  self.bg_go = self.transform:Find(bg_go_path):GetComponent(typeof(CS.UnityEngine.Animator))
end

local function ComponentDestroy(self)
  self.des_text = nil
  self.bg_go = nil
end

local function DataDefine(self)
  self.param = nil
  self.showTimer = nil
end

local function DataDestroy(self)
  self.param = nil
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.autoCloseTimer ~= nil then
    self.autoCloseTimer:Stop()
    self.autoCloseTimer = nil
  end
end

local function ReInit(self, param)
  self.param = param
  self:ComponentDefine()
  self:ShowPanel()
end

local function ShowPanel(self)
  self.bg_go.transform:Set_localPosition(0, self.param.modelHeight, 0)
  local ret, time = UIUtil.PlayAnimationReturnTime(self.bg_go, AnimName.Enter)
  if ret then
    self.showTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.showTimer ~= nil then
        self.showTimer:Stop()
        self.showTimer = nil
      end
      self.bg_go:Play(AnimName.Normal, 0, 0)
    end, self, true, false, false)
    self.showTimer:Start()
  end
  self.des_text.text = self.param.des
  if self.param.posIndex ~= nil then
    self:UpdatePosition(self.param.posIndex)
  end
  self.autoCloseTimer = TimerManager:GetInstance():GetTimer(AutoCloseTime, function()
    if self.autoCloseTimer ~= nil then
      self.autoCloseTimer:Stop()
      self.autoCloseTimer = nil
    end
    self:Close()
  end, self, true, false, false)
  self.autoCloseTimer:Start()
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY))
  end
end

local function SetPosition(self, value)
  self.transform.position = value
end

local function Close(self)
  local ret, time = UIUtil.PlayAnimationReturnTime(self.bg_go, AnimName.Hide)
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      DataCenter.BuildBubbleManager:CheckShowBubble(self.param.uuid)
      DataCenter.BuildGetItemAfterShowTalkManager:DeleteOneTalk(self.param)
    end, self, true, false, false)
    self.closeTimer:Start()
  end
end

BuildGetItemAfterShowTalk.OnCreate = OnCreate
BuildGetItemAfterShowTalk.OnDestroy = OnDestroy
BuildGetItemAfterShowTalk.ComponentDefine = ComponentDefine
BuildGetItemAfterShowTalk.ComponentDestroy = ComponentDestroy
BuildGetItemAfterShowTalk.DataDefine = DataDefine
BuildGetItemAfterShowTalk.DataDestroy = DataDestroy
BuildGetItemAfterShowTalk.ReInit = ReInit
BuildGetItemAfterShowTalk.ShowPanel = ShowPanel
BuildGetItemAfterShowTalk.UpdatePosition = UpdatePosition
BuildGetItemAfterShowTalk.SetPosition = SetPosition
BuildGetItemAfterShowTalk.Close = Close
return BuildGetItemAfterShowTalk
