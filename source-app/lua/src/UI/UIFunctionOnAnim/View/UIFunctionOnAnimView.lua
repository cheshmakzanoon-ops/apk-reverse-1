local base = UIBaseView
local UIFunctionOnAnimView = BaseClass("UIFunctionOnAnimView", base)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.IconImg.transform.position = self.beginPos
  DataCenter.FunctionOnManager:RefreshNeedWait(DataCenter.BuildManager.MainLv)
  EventManager:GetInstance():Broadcast(EventId.OnFunctionOnAnimFinsh)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ShowAnim()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.Effect = self:AddComponent(UIBaseComponent, "Root/Eff_ui_common_jiesuo_new")
  self.IconImg = self:AddComponent(UIImage, "Root/IconImg")
  self.IconText = self:AddComponent(UITextMeshProUGUIEx, "Root/IconImg/IconText")
  self.Target1 = self:AddComponent(UIBaseComponent, "Root/Target1")
  self.Target2 = self:AddComponent(UIBaseComponent, "Root/Target2")
  self.Target3 = self:AddComponent(UIBaseComponent, "Root/Target3")
end

local function ComponentDestroy(self)
  self.Effect = nil
  self.IconImg = nil
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
end

local function DataDefine(self)
  self.openData = self:GetUserData()
  self.beginPos = self.IconImg.transform.position
  self.timer = nil
  
  function self.timer_action(temp)
    local firstDayShow = DataCenter.FirstPayManager:CheckCanShow()
    local targetPos = self.Target1.transform.position
    if not firstDayShow then
      targetPos = self.Target2.transform.position
    end
    self.IconImg:SetActive(true)
    self.IconImg:SetLocalScaleXYZ(0, 0, 0)
    self.seq = DOTween.Sequence()
    self.seq:AppendInterval(0.5)
    self.seq:Append(self.IconImg.transform:DOScale(Vector3.New(2, 2, 2), 0.3))
    self.seq:Append(self.IconImg.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
    self.seq:AppendInterval(0.5)
    self.seq:AppendCallback(function()
      self.Effect:SetActive(false)
    end)
    self.seq:Append(self.IconImg.transform:DOMove(targetPos, 1))
    
    function self.seq.onComplete()
      self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.delayCloseTimer = nil
        self.ctrl:CloseSelf()
      end, 0.5)
    end
  end
end

local function DataDestroy(self)
  self:DeleteTimer()
  self.openData = nil
  self.beginPos = nil
  self.timer = nil
  self.timer_action = nil
end

local function ShowAnim(self)
  if not self.openData then
    return
  end
  self.IconImg:LoadSprite(self.openData.icon)
  self.IconText:SetLocalText(self.openData.name)
  self.Effect:SetActive(false)
  self.Effect:SetActive(true)
  self.IconImg:SetActive(false)
  self:AddTimer(1.2)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_SpecialEvent_Icon_Unlock, false)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self, time)
  self:DeleteTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

UIFunctionOnAnimView.OnCreate = OnCreate
UIFunctionOnAnimView.OnDestroy = OnDestroy
UIFunctionOnAnimView.OnEnable = OnEnable
UIFunctionOnAnimView.OnDisable = OnDisable
UIFunctionOnAnimView.ComponentDefine = ComponentDefine
UIFunctionOnAnimView.ComponentDestroy = ComponentDestroy
UIFunctionOnAnimView.DataDefine = DataDefine
UIFunctionOnAnimView.DataDestroy = DataDestroy
UIFunctionOnAnimView.ShowAnim = ShowAnim
UIFunctionOnAnimView.AddTimer = AddTimer
UIFunctionOnAnimView.DeleteTimer = DeleteTimer
return UIFunctionOnAnimView
