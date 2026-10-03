local UIEarthOrderRewardCell = BaseClass("UIEarthOrderRewardCell", UIBaseContainer)
local base = UIBaseContainer
local item_icon_path = "NumText/IconImg"
local num_text_path = "NumText"

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
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.num_text = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  if param.rewardType == RewardType.FOOD then
    param.num = DataCenter.HeroStationManager:CalcEffectedValue(param.num, HeroStationEffectType.GlobalMoney)
    param.num = Mathf.Round(param.num)
  end
  self.param = param
  self.item_icon:LoadSprite(param.icon)
  self.num_text:SetText(string.GetFormattedSeperatorNum(param.num))
end

local function ShowGetRewardEffect(self, moneyPos)
  local pos = self.gameObject.transform.position
  if self.param.rewardType == RewardType.EXP then
    local dest = UIUtil.GetUIMainSavePos(UIMainSavePosType.PlayerLevel)
    UIUtil.DoFly(tonumber(self.param.rewardType), self.param.num, self.param.icon, pos, dest, 57, 62)
  elseif self.param.rewardType == RewardType.FOOD then
    UIUtil.DoFly(tonumber(self.param.rewardType), 5, self.param.icon, pos, Vector3.New(moneyPos.x, moneyPos.y, moneyPos.z))
  else
    local endPos = Vector3.New(0, 0, 0)
    UIUtil.DoFly(tonumber(self.param.rewardType), 5, self.param.icon, pos, endPos)
  end
end

UIEarthOrderRewardCell.OnCreate = OnCreate
UIEarthOrderRewardCell.OnDestroy = OnDestroy
UIEarthOrderRewardCell.OnEnable = OnEnable
UIEarthOrderRewardCell.OnDisable = OnDisable
UIEarthOrderRewardCell.ComponentDefine = ComponentDefine
UIEarthOrderRewardCell.ComponentDestroy = ComponentDestroy
UIEarthOrderRewardCell.DataDefine = DataDefine
UIEarthOrderRewardCell.DataDestroy = DataDestroy
UIEarthOrderRewardCell.ReInit = ReInit
UIEarthOrderRewardCell.ShowGetRewardEffect = ShowGetRewardEffect
return UIEarthOrderRewardCell
