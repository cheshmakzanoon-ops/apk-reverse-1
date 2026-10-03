local UIFormationTipView = BaseClass("UIFormationTipView", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local param = self:GetUserData()
  self.param = param
  
  function self.timer_action(temp)
    self:UpdateTime()
  end
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgArrow")
  self.textContent = self:AddComponent(UIText, "Root/Image/TextContent")
  self.textTitle = self:AddComponent(UIText, "Root/TextTitle")
  self.isUpdate = false
end

local function ComponentDestroy(self)
  self.root = nil
  self.imgArrow = nil
  self.textContent = nil
  self.textTitle = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:SetData()
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function SetData(self)
  if self.param ~= nil then
    self.textTitle:SetText(self.param.title)
    local rootRt = self.root.rectTransform
    if self.param.pivot ~= nil then
      self.root.rectTransform.pivot = self.param.pivot
    else
      self.root.rectTransform.pivot = Vector2.New(0.5, 0)
    end
    rootRt.position = self.param.position
    if 0 < self.param.endTime then
      self.isUpdate = true
      self:AddTimer()
      self:UpdateTime()
    else
      self.isUpdate = false
      self.textContent:SetText(self.param.content2)
    end
    if self.param.isTop == true then
      self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, 270)
      self.imgArrow.transform:Set_localPosition(19, 97, 0)
    elseif self.param.isLeft == true then
      self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, 0)
      self.imgArrow.transform:Set_localPosition(-143, 50, 0)
    else
      self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, 90)
      self.imgArrow.transform:Set_localPosition(19, 7, 0)
    end
  end
end

local function UpdateTime(self)
  if self.isUpdate == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.param.endTime
    local timeLeft = endTime - curTime
    if 0 < timeLeft then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
      local content = self.param.content1 .. ": " .. "<color=#27BE8C>" .. timeStr .. "</color>"
      if not string.IsNullOrEmpty(self.param.content0) then
        content = self.param.content0 .. "\n" .. content
      end
      self.textContent:SetText(content)
    else
      self.isUpdate = false
      self.textContent:SetText(self.param.content2)
    end
  end
end

UIFormationTipView.OnCreate = OnCreate
UIFormationTipView.OnDestroy = OnDestroy
UIFormationTipView.ComponentDefine = ComponentDefine
UIFormationTipView.ComponentDestroy = ComponentDestroy
UIFormationTipView.OnEnable = OnEnable
UIFormationTipView.OnDisable = OnDisable
UIFormationTipView.AddTimer = AddTimer
UIFormationTipView.DeleteTimer = DeleteTimer
UIFormationTipView.SetData = SetData
UIFormationTipView.UpdateTime = UpdateTime
return UIFormationTipView
