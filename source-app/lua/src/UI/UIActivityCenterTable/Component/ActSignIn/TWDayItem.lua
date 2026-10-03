local base = UIBaseContainer
local TWDayItem = BaseClass("TWDayItem", base)
local rewardItem_path = "rewardItem"
local dayNumberTxt_path = "dayNumberText"
local dayTxt_path = "dayText"
local claimed_path = "claimed"
local canClaim_path = "canclaim"
local btn_path = ""

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
  self.rewardItem = self:AddComponent(UIBaseContainer, rewardItem_path)
  self.dayNumberTxt = self:AddComponent(UITextMeshProUGUIEx, dayNumberTxt_path)
  self.dayTxt = self:AddComponent(UITextMeshProUGUIEx, dayTxt_path)
  self.claimed = self:AddComponent(UIBaseContainer, claimed_path)
  self.canClaim = self:AddComponent(UIBaseContainer, canClaim_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if not self.data then
      return
    end
    if self.data.state == 2 then
      if self.reward then
        self.reward.btn:Click()
      end
      return
    end
    if self.data.state == 0 and self.data.day - 1 > self.nowDay then
      if self.reward then
        self.reward.btn:Click()
      end
      return
    end
    if self.onBtnClick then
      self.onBtnClick(self.data)
    end
  end)
  self.reward = self:AddComponent(UICommonResItem, rewardItem_path)
  self.dayNumberTxt:SetText("")
end

local function ComponentDestroy(self)
  self.rewardItem = nil
  self.dayNumberTxt = nil
  self.dayTxt = nil
  self.claimed = nil
  self.canClaim = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
  self.onBtnClick = nil
end

local function OnRefresh(self, data, nowDay, isFinalDay)
  self.data = data
  self.nowDay = nowDay
  self.isFinalDay = isFinalDay
  if data.day < 10 then
    self.dayNumberTxt:SetLocalText("activity_5401_tips5", "0" .. data.day)
  else
    self.dayNumberTxt:SetLocalText("activity_5401_tips5", data.day)
  end
  if data.state == 2 then
    self.claimed:SetActive(true)
    self.canClaim:SetActive(false)
  elseif data.state == 1 then
    self.claimed:SetActive(false)
    self.canClaim:SetActive(true)
  else
    local canClaim = nowDay >= data.day - 1
    self.claimed:SetActive(false)
    self.canClaim:SetActive(canClaim)
  end
  if not isFinalDay then
    if data.state == 2 then
      self.dayNumberTxt:SetColor(Color.New(0.5568627450980392, 0.6549019607843137, 0.8117647058823529, 1))
    else
      self.dayNumberTxt:SetColor(Color.New(0.6196078431372549, 0.8156862745098039, 1, 1))
    end
  end
  if self.data.showReward and self.data.showReward[1] then
    self.reward:SetActive(true)
    self.reward:ReInit(data.showReward[1])
    self.reward:SetImgQuailtyShow(not isFinalDay)
  else
    self.reward:SetActive(false)
  end
end

local function SetBtnOnClick(self, func)
  self.onBtnClick = func
end

TWDayItem.OnCreate = OnCreate
TWDayItem.OnDestroy = OnDestroy
TWDayItem.OnEnable = OnEnable
TWDayItem.OnDisable = OnDisable
TWDayItem.ComponentDefine = ComponentDefine
TWDayItem.ComponentDestroy = ComponentDestroy
TWDayItem.DataDefine = DataDefine
TWDayItem.DataDestroy = DataDestroy
TWDayItem.OnRefresh = OnRefresh
TWDayItem.SetBtnOnClick = SetBtnOnClick
return TWDayItem
