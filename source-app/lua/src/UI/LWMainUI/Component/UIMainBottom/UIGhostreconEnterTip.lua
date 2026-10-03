local UIGhostreconEnterTip = BaseClass("UIGhostreconEnterTip", UIBaseContainer)
local base = UIBaseContainer
local firstInTip_path = "FirstInTip"
local fullTip_path = "FullTip"
local fullTip_text_path = "FullTip/TipTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.firstInTip = self:AddComponent(UIButton, firstInTip_path)
  self.firstInTip:SetOnClick(function()
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Ghostrecon.Type)
    if actList and 0 < #actList then
      local actId = tonumber(actList[1].id)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, actId)
    else
      UIUtil.ShowTipsId(801141)
    end
  end)
  self.fullTip = self:AddComponent(UIBaseContainer, fullTip_path)
  self.fullTipText = self:AddComponent(UIText, fullTip_text_path)
  self.fullTipText:SetLocalText("ghostrecon_077")
end

local function ComponentDestroy(self)
  self.firstInTip = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Refresh(self)
  local state = DataCenter.ActGhostreconManager:GetTipShowState()
  if state == GhostreconEnterTipState.FirstIn then
    self.firstInTip:SetActive(true)
    self.fullTip:SetActive(false)
  elseif state == GhostreconEnterTipState.MemberFull then
    self.firstInTip:SetActive(false)
    self.fullTip:SetActive(true)
  else
    self.firstInTip:SetActive(false)
    self.fullTip:SetActive(false)
  end
end

UIGhostreconEnterTip.OnCreate = OnCreate
UIGhostreconEnterTip.OnDestroy = OnDestroy
UIGhostreconEnterTip.OnEnable = OnEnable
UIGhostreconEnterTip.OnDisable = OnDisable
UIGhostreconEnterTip.ComponentDefine = ComponentDefine
UIGhostreconEnterTip.ComponentDestroy = ComponentDestroy
UIGhostreconEnterTip.DataDefine = DataDefine
UIGhostreconEnterTip.DataDestroy = DataDestroy
UIGhostreconEnterTip.OnAddListener = OnAddListener
UIGhostreconEnterTip.OnRemoveListener = OnRemoveListener
UIGhostreconEnterTip.Refresh = Refresh
return UIGhostreconEnterTip
