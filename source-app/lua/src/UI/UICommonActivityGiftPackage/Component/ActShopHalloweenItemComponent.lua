local ActShopHalloweenItemComponent = BaseClass("ActShopHalloweenItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.textTitle = self:AddComponent(UIText, "title")
  self.textDesc = self:AddComponent(UIText, "desc")
  self.btnGoto = self:AddComponent(UIButton, "gotoBtn")
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textGotoBtn = self:AddComponent(UIText, "gotoBtn/gotoBtnText")
  self.icon = self:AddComponent(UIImage, "icon")
  self.bg = self:AddComponent(UIRawImage, "bg")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textDesc = nil
  self.btnGoto = nil
  self.textGotoBtn = nil
  self.icon = nil
  self.bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function ActShopHalloweenItemComponent:SetData(data)
  self.data = data
  self.textTitle:SetLocalText(self.data.name)
  self.textDesc:SetLocalText(self.data.des)
  self.textGotoBtn:SetLocalText(self.data.btn_name)
  self.icon:LoadSprite(self.data.pic)
  self.bg:LoadSpriteAuto(self.data.para3)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnGotoClick(self)
  if self.data.tips == LWResourceLackGetWay.ActivityAndCheckOpen then
    self:GuideToActivityCheckOpen()
  elseif self.data.tips == LWResourceLackGetWay.TorchRelayTaskDaily then
    DataCenter.ActivityTorchRelayManager:OpenDailyTask()
  end
  EventManager:GetInstance():Broadcast(EventId.GF_goods_lack_goto_clicked, self.data.tips)
end

function ActShopHalloweenItemComponent:GuideToActivityCheckOpen()
  local idList = string.split(tostring(self.data.para1), "|")
  for _, v in ipairs(idList) do
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v))
    if actInfo ~= nil then
      GoToUtil.GoActWindow({
        tonumber(actInfo.id)
      })
      break
    end
  end
end

ActShopHalloweenItemComponent.OnCreate = OnCreate
ActShopHalloweenItemComponent.OnDestroy = OnDestroy
ActShopHalloweenItemComponent.OnEnable = OnEnable
ActShopHalloweenItemComponent.OnDisable = OnDisable
ActShopHalloweenItemComponent.ComponentDefine = ComponentDefine
ActShopHalloweenItemComponent.ComponentDestroy = ComponentDestroy
ActShopHalloweenItemComponent.DataDefine = DataDefine
ActShopHalloweenItemComponent.DataDestroy = DataDestroy
ActShopHalloweenItemComponent.OnAddListener = OnAddListener
ActShopHalloweenItemComponent.OnRemoveListener = OnRemoveListener
ActShopHalloweenItemComponent.OnBtnGotoClick = OnBtnGotoClick
return ActShopHalloweenItemComponent
