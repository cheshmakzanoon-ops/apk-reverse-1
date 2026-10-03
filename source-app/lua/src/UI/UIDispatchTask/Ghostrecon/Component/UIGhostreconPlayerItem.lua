local base = UIBaseContainer
local UIGhostreconPlayerItem = BaseClass("UIGhostreconPlayerItem", base)
local joinIcon_path = "joinIcon"
local headHolder_path = "headIcon"
local joinBtn_path = "joinBtn"
local selfFlag_path = "selfFlag"
local playerHead_path = "headIcon/UIPlayerHead"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.joinIcon = self:AddComponent(UIBaseContainer, joinIcon_path)
  self.headHolder = self:AddComponent(UIBaseContainer, headHolder_path)
  self.joinBtn = self:AddComponent(UIButton, joinBtn_path)
  self.selfFlag = self:AddComponent(UIBaseContainer, selfFlag_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.joinBtn:SetOnClick(function()
    if self.headHolder:GetActive() then
      self.playerHead:OnHeadClick()
    elseif self.joinFunc then
      self.joinFunc()
    end
  end)
  self.selfFlag:SetActive(false)
end

local function ComponentDestroy(self)
  self.joinIcon = nil
  self.headHolder = nil
  self.joinBtn = nil
  self.selfFlag = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.joinFunc = nil
  self.headInfo = nil
end

local function SetData(self, headInfo)
  if headInfo then
    self.headInfo = headInfo
    self.headHolder:SetActive(true)
    self.playerHead:ParseHeadInfo(headInfo)
  else
    self.headHolder:SetActive(false)
  end
end

local function SetJoinFunc(self, joinFunc)
  self.joinFunc = joinFunc
end

local function SetJoinActive(self, active)
  self.joinIcon:SetActive(active)
end

local function SetEmpty(self)
  self.joinIcon:SetActive(false)
  self.headHolder:SetActive(false)
end

local function RefreshHead(self)
  if self.headInfo then
    self.playerHead:ParseHeadInfo(self.headInfo)
  end
end

UIGhostreconPlayerItem.OnCreate = OnCreate
UIGhostreconPlayerItem.OnDestroy = OnDestroy
UIGhostreconPlayerItem.OnEnable = OnEnable
UIGhostreconPlayerItem.OnDisable = OnDisable
UIGhostreconPlayerItem.ComponentDefine = ComponentDefine
UIGhostreconPlayerItem.ComponentDestroy = ComponentDestroy
UIGhostreconPlayerItem.DataDefine = DataDefine
UIGhostreconPlayerItem.DataDestroy = DataDestroy
UIGhostreconPlayerItem.SetData = SetData
UIGhostreconPlayerItem.SetJoinActive = SetJoinActive
UIGhostreconPlayerItem.SetEmpty = SetEmpty
UIGhostreconPlayerItem.SetJoinFunc = SetJoinFunc
UIGhostreconPlayerItem.RefreshHead = RefreshHead
return UIGhostreconPlayerItem
