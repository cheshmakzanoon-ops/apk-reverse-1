local SquadPlanBtnItem = BaseClass("SquadPlanBtnItem", UIBaseContainer)
local base = UIBaseContainer
local BtnState = {
  CurSquad = 1,
  Available = 2,
  Busy = 3,
  Lock = 4
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.btnState = BtnState.CurSquad
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.enterWay = nil
  self.index = nil
  self.curIndex = nil
  self.callback = nil
  self.btnState = nil
end

local function ComponentDefine(self)
  self.Btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIImage, "")
  self.Btn:SetOnClick(Bind(self, self.OnClickBtn))
  self.Lock_Img = self:AddComponent(UIImage, "Lock")
  self.PlanText = self:AddComponent(UIImage, "PlanText")
end

local function ComponentDestroy(self)
  self.Btn = nil
  self.Lock_Img = nil
  self.bg = nil
end

local function SetData(self, enterWay, index, curIndex, callback)
  self.enterWay = enterWay
  self.index = index
  self.curIndex = curIndex
  self.callback = callback
  self:Refresh()
end

local function Refresh(self)
  local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  local haveIndex = {}
  for k, v in pairs(formationList) do
    haveIndex[v.index] = true
  end
  if self.index == self.curIndex then
    self.btnState = BtnState.CurSquad
  elseif haveIndex[self.index] == nil then
    self.btnState = BtnState.Lock
  else
    self.btnState = BtnState.Available
  end
  if self.enterWay == EnterHeroSquadPanelWay.TruckDeparture then
    local busyList = DataCenter.LWMyStationDataManager:GetBusyDefenceFormationIndexList()
    if busyList[self.index] then
      self.btnState = BtnState.Busy
    end
  end
  if self.btnState == BtnState.CurSquad then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWRailway/lrb_plan_btn01.png")
  elseif self.btnState == BtnState.Busy then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWRailway/lrb_plan_btn03.png")
  elseif self.btnState == BtnState.Lock then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWRailway/lrb_plan_btn03.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWRailway/lrb_plan_btn02.png")
  end
  self.Lock_Img:SetActive(self.btnState == BtnState.Lock)
  self.PlanText:SetActive(self.btnState ~= BtnState.Lock)
  local isGray = self.btnState == BtnState.Lock or self.btnState == BtnState.Busy
  CS.UIGray.SetGray(self.Btn.transform, isGray, true)
end

local function OnClickBtn(self)
  if self.enterWay == EnterHeroSquadPanelWay.TruckDeparture or self.enterWay == EnterHeroSquadPanelWay.HSRDeparture or self.enterWay == EnterHeroSquadPanelWay.TruckRob or self.enterWay == EnterHeroSquadPanelWay.HSRRob then
    if self.btnState == BtnState.Lock then
      local str = DataCenter.ArmyFormationDataManager:GetFormationUnlockTipStr(self.index)
      if str then
        UIUtil.ShowTips(str)
      end
      return
    elseif self.btnState == BtnState.Busy then
      UIUtil.ShowTipsId("city_trade_tips1014")
      return
    end
  elseif self.enterWay == EnterHeroSquadPanelWay.ParkingLotBuilding and self.btnState == BtnState.Lock then
    if self.index == 4 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
    else
      local str = DataCenter.ArmyFormationDataManager:GetFormationUnlockTipStr(self.index)
      if str then
        UIUtil.ShowTips(str)
      end
    end
  end
  if self.callback then
    self:callback()
  end
end

SquadPlanBtnItem.OnCreate = OnCreate
SquadPlanBtnItem.OnDestroy = OnDestroy
SquadPlanBtnItem.ComponentDefine = ComponentDefine
SquadPlanBtnItem.ComponentDestroy = ComponentDestroy
SquadPlanBtnItem.SetData = SetData
SquadPlanBtnItem.Refresh = Refresh
SquadPlanBtnItem.OnClickBtn = OnClickBtn
return SquadPlanBtnItem
