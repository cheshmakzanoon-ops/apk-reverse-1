local UIShowBlackView = BaseClass("UIShowBlackView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIShowBlackCell = require("UI.UIShowBlack.Component.UIShowBlackCell")
local next_btn_path = "BlackImg"
local des_content_path = "DesContent"
local BtnCanClickTime = 1

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.next_btn = self:AddComponent(UIButton, next_btn_path)
  self.des_content = self:AddComponent(UIBaseContainer, des_content_path)
  self.next_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnNextBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.next_btn = nil
  self.des_content = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
  
  self.template = nil
  self.useIndex = 1
  self.freeCells = {}
  self.cells = {}
  self.time = {}
  self.btnTimer = nil
  
  function self.timer_btn_action(temp)
    self:TimeBtnCallBack()
  end
end

local function DataDestroy(self)
  self:DeleteTimer()
  self:DeleteBtnTimer()
  self.timer = nil
  self.timer_action = nil
  self.template = nil
  self.useIndex = nil
  self.freeCells = nil
  self.cells = nil
  self.time = nil
  self.btnTimer = nil
  self.timer_btn_action = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self:Refresh()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
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

local function TimeCallBack(self)
  self:DeleteTimer()
  if self.cells[self.useIndex] ~= nil then
    self.cells[self.useIndex]:DoShowAnim()
  end
  self.useIndex = self.useIndex + 1
  local time = self.time[self.useIndex]
  if time == nil then
    if self.template.type == GuideType.ShowBlackUI then
      DataCenter.GuideManager:DoNext()
    end
  else
    self:AddTimer(time)
  end
end

local function Refresh(self)
  self.next_btn:SetInteractable(false)
  self:AddBtnTimer()
  self.template = DataCenter.GuideManager:GetCurTemplate()
  if self.template ~= nil and self.template.type == GuideType.ShowBlackUI then
    self:DeleteTimer()
    self:LoadCells()
  end
end

local function RefreshGuideSignal(self)
  self.template = DataCenter.GuideManager:GetCurTemplate()
  if self.template ~= nil and self.template.type == GuideType.ShowBlackUI then
  else
    self.ctrl:CloseSelf()
  end
end

local function RefreshGuideAnimSignal(self)
  self:Refresh()
end

local function OnNextBtnClick(self)
  self:TimeCallBack()
end

local function LoadCells(self)
  self.time = {}
  self.useIndex = 1
  for k, v in pairs(self.cells) do
    v:SetActive(false)
    table.insert(self.freeCells, v)
  end
  self.cells = {}
  if self.template.para1 ~= nil then
    local spl = string.split(self.template.para1, ";")
    for k, v in ipairs(spl) do
      local spl1 = string.split(v, ",")
      if 1 < #spl1 then
        local param = {}
        param.index = k
        param.des = Localization:GetString(spl1[1])
        table.insert(self.time, tonumber(spl1[2]) / 1000)
        self:LoadOneCell(param)
      end
    end
  end
  if self.template.para2 ~= nil then
    table.insert(self.time, tonumber(self.template.para2) / 1000)
  end
end

local function LoadOneCell(self, param)
  if #self.freeCells > 0 then
    local temp = table.remove(self.freeCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetAsLastSibling()
      self.cells[param.index] = temp
      if param.index == 1 then
        self:StartShowTime()
      end
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.UIShowBlackCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.des_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(param.index)
      go.name = nameStr
      local temp = self.des_content:AddComponent(UIShowBlackCell, nameStr)
      temp:ReInit(param)
      self.cells[param.index] = temp
      if param.index == 1 then
        self:StartShowTime()
      end
    end)
  end
end

local function DeleteBtnTimer(self)
  if self.btnTimer ~= nil then
    self.btnTimer:Stop()
    self.btnTimer = nil
  end
end

local function AddBtnTimer(self)
  self:DeleteBtnTimer()
  if self.btnTimer == nil then
    self.btnTimer = TimerManager:GetInstance():GetTimer(BtnCanClickTime, self.timer_btn_action, self, true, false, false)
  end
  self.btnTimer:Start()
end

local function TimeBtnCallBack(self)
  self:DeleteBtnTimer()
  self.next_btn:SetInteractable(true)
end

local function StartShowTime(self)
  local time = self.time[self.useIndex]
  if time ~= nil then
    if time == 0 then
      self:TimeCallBack()
    else
      self:AddTimer(time)
    end
  end
end

UIShowBlackView.OnCreate = OnCreate
UIShowBlackView.OnDestroy = OnDestroy
UIShowBlackView.OnEnable = OnEnable
UIShowBlackView.OnDisable = OnDisable
UIShowBlackView.OnAddListener = OnAddListener
UIShowBlackView.OnRemoveListener = OnRemoveListener
UIShowBlackView.ComponentDefine = ComponentDefine
UIShowBlackView.ComponentDestroy = ComponentDestroy
UIShowBlackView.DataDefine = DataDefine
UIShowBlackView.DataDestroy = DataDestroy
UIShowBlackView.ReInit = ReInit
UIShowBlackView.DeleteTimer = DeleteTimer
UIShowBlackView.AddTimer = AddTimer
UIShowBlackView.TimeCallBack = TimeCallBack
UIShowBlackView.Refresh = Refresh
UIShowBlackView.RefreshGuideSignal = RefreshGuideSignal
UIShowBlackView.RefreshGuideAnimSignal = RefreshGuideAnimSignal
UIShowBlackView.OnNextBtnClick = OnNextBtnClick
UIShowBlackView.LoadOneCell = LoadOneCell
UIShowBlackView.LoadCells = LoadCells
UIShowBlackView.DeleteBtnTimer = DeleteBtnTimer
UIShowBlackView.AddBtnTimer = AddBtnTimer
UIShowBlackView.TimeBtnCallBack = TimeBtnCallBack
UIShowBlackView.StartShowTime = StartShowTime
return UIShowBlackView
