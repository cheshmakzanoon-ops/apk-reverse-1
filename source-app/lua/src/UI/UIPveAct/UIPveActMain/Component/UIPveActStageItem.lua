local UIPveActStageItem = BaseClass("UIPveActStageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local StageIcon = {
  [1] = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox6",
  [2] = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox5",
  [3] = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox4",
  [4] = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox3",
  [5] = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox2",
  [6] = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox1"
}
local btn_path = "Btn"
local icon_path = "Btn/Icon"
local anim_path = "Btn/Icon"
local num_path = "Num"
local check_path = "Check"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.num_text = self:AddComponent(UITweenNumberText, num_path)
  self.num_text:SetTextFunc(function(v)
    local a = string.GetFormattedSeperatorNum(v)
    local b = string.GetFormattedSeperatorNum(self.data.exp)
    return string.format("<color=#BCEE23>%s</color>/%s", a, b)
  end)
  self.check_go = self:AddComponent(UIBaseContainer, check_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.icon_image = nil
  self.anim = nil
  self.num_text = nil
  self.check_go = nil
end

local function DataDefine(self)
  self.data = nil
  self.param = nil
  self.curExp = 0
  self.showCurExp = false
end

local function DataDestroy(self)
  self.data = nil
  self.param = nil
  self.curExp = nil
  self.showCurExp = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data, param)
  if data == nil then
    return
  end
  self.data = data
  self.param = param
  self.transform.localScale = Vector3.one * (param.isLast and 1.2 or 1.0)
  local icon = ""
  if param.isLast then
    icon = StageIcon[6]
  else
    icon = StageIcon[data.stage] or StageIcon[6]
  end
  self.icon_image:LoadSprite(icon)
  if data.state == 0 and param.curExp >= data.exp then
    self.anim:SetBool("Play", true)
    self.anim:SetBool("Idle", false)
  else
    self.anim:SetBool("Play", false)
    self.anim:SetBool("Idle", true)
  end
  self.check_go:SetActive(data.state == 1)
  self:RefreshNum()
end

local function ShowCurExp(self, show)
  self.showCurExp = show
  self:RefreshNum()
end

local function RefreshNum(self)
  if self.showCurExp then
    if self.param.isInit then
      self.num_text:SetNum(self.param.curExp)
    else
      if self.num_text:GetCurNum() == 0 then
        self.num_text:SetNum(self.param.lastExp)
      end
      self.num_text:TweenToNum(self.param.curExp, 1.5)
    end
  else
    self.num_text:Stop()
    self.num_text:SetText(string.GetFormattedSeperatorNum(self.data.exp))
  end
end

local function OnClick(self)
  self.view:OnStageItemClick(self)
end

UIPveActStageItem.OnCreate = OnCreate
UIPveActStageItem.OnDestroy = OnDestroy
UIPveActStageItem.ComponentDefine = ComponentDefine
UIPveActStageItem.ComponentDestroy = ComponentDestroy
UIPveActStageItem.DataDefine = DataDefine
UIPveActStageItem.DataDestroy = DataDestroy
UIPveActStageItem.OnEnable = OnEnable
UIPveActStageItem.OnDisable = OnDisable
UIPveActStageItem.SetData = SetData
UIPveActStageItem.ShowCurExp = ShowCurExp
UIPveActStageItem.RefreshNum = RefreshNum
UIPveActStageItem.OnClick = OnClick
return UIPveActStageItem
