local UITrainVIPInviteConfirmPopView = BaseClass("UITrainVIPInviteConfirmPopView", UIBaseView)
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local toggle_path = "Root/checkObj/item"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitToggleTime()
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
  self.topText = self:AddComponent(UILWScienceDetailDesc, "Root/topText")
  self.bottomText = self:AddComponent(UIText, "Root/bottomText")
  self.confirmBtn = self:AddComponent(UIButton, "Root/confirmBtn")
  self.confirmBtn:SetOnClick(function()
    self:OnClickConfirm()
  end)
  self.cancelBtn = self:AddComponent(UIButton, "Root/cancelBtn")
  self.cancelBtn:SetOnClick(function()
    self:OnClickCancel()
  end)
  self.bgBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.bgBtn:SetOnClick(function()
    self:OnClickCancel()
  end)
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self:OnClickCancel()
  end)
end

local function ComponentDestroy(self)
  self.topText = nil
  self.bottomText = nil
  self.confirmBtn = nil
  self.cancelBtn = nil
  self.toggle = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self.platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  self.readyEndTime = self.platformData.readyEndTime - DataCenter.LWAllyStationDataManager.CHECK_TICKET_TIME
  local index = LuaEntry.Player:GetUserSetting(UserSettingKey.TRAIN_VIP_TIME_SELECT)
  if index then
    self.timeIndex = tonumber(index) + 1
  else
    self.timeIndex = 1
  end
end

local function DataDestroy(self)
  self.platformData = nil
  self.param = nil
  self.timesInMinutes = nil
  self.diffTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitToggleTime(self)
  local typeText
  if self.param.type == TrainVipType.isLucky then
    typeText = Localization:GetString("alliance_train_vip002")
  else
    typeText = Localization:GetString("alliance_train_vip003")
  end
  self.topText:SetTextAndParam(Localization:GetString("alliance_train_vip037", self.param.name, typeText))
  local list = LuaEntry.DataConfig:TryGetStr("alliance_train", "k22")
  if string.IsNullOrEmpty(list) then
    list = "60;120;600;1800"
  end
  self.timesInMinutes = {}
  for num in string.gmatch(list, "%d+") do
    table.insert(self.timesInMinutes, math.floor(tonumber(num) / 60))
  end
  if self.toggle == nil then
    self.toggle = {}
  end
  for i = 1, 4 do
    if self.toggle[i] == nil then
      self.toggle[i] = self:AddComponent(UIToggle, toggle_path .. i)
      self.toggle[i]:SetOnValueChanged(function(tf)
        if tf then
          self:ToggleControlBorS()
        end
      end)
    end
    if self.toggle[i] then
      if self.timesInMinutes[i] then
        self.toggle[i]:SetActive(true)
        if self.toggle[i].text == nil then
          self.toggle[i].text = self.toggle[i]:AddComponent(UIText, "Text_num")
        end
        self.toggle[i].text:SetText(self.timesInMinutes[i] .. Localization:GetString("100165"))
      else
        self.toggle[i]:SetActive(false)
      end
    end
  end
  self.toggle[self.timeIndex]:SetIsOn(true)
  self:ToggleControlBorS()
end

local function ToggleControlBorS(self)
  for i = 1, #self.toggle do
    if self.toggle[i]:GetIsOn() then
      self.timeIndex = i
      break
    end
  end
end

local function OnClickConfirm(self)
  if self.platformData.state == TrainPlatformState.TrainWithPassenger then
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip028"))
    self.ctrl:CloseSelf()
  elseif self.diffTime then
    if self.diffTime > self.timesInMinutes[self.timeIndex] * 60 * 1000 then
      self:SendMessage()
    else
      UIUtil.ShowMessage(Localization:GetString("alliance_train_vip046"), 2, nil, nil, function()
        self:SendMessage()
      end, nil, nil, nil)
    end
  end
end

local function SendMessage(self)
  if self.param then
    if self.param.vipId then
      Logger.LogInfo(string.format("\229\143\145\233\128\129\231\129\171\232\189\166\233\130\128\232\175\183\229\141\143\232\174\174:%s", self.param.vipId))
    else
      Logger.LogInfo("\229\143\145\233\128\129\231\129\171\232\189\166\233\130\128\232\175\183\229\141\143\232\174\174\229\143\130\230\149\176\233\148\153\232\175\175")
    end
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainInviteVIP, self.param.type, self.param.vipId, self.param.platform, self.timeIndex - 1)
  end
  self.ctrl:CloseSelf()
end

local function OnClickCancel(self)
  self.ctrl:CloseSelf()
end

local function CloseSelf(self)
  self.ctrl:CloseSelf()
end

local function Update1000MS(self)
  if not self.readyEndTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.readyEndTime then
    self.diffTime = self.readyEndTime - now
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.diffTime)
    self.bottomText:SetLocalText("alliance_train_vip038", str)
  else
    self:CloseSelf()
  end
end

UITrainVIPInviteConfirmPopView.OnCreate = OnCreate
UITrainVIPInviteConfirmPopView.OnDestroy = OnDestroy
UITrainVIPInviteConfirmPopView.OnEnable = OnEnable
UITrainVIPInviteConfirmPopView.OnDisable = OnDisable
UITrainVIPInviteConfirmPopView.ComponentDefine = ComponentDefine
UITrainVIPInviteConfirmPopView.ComponentDestroy = ComponentDestroy
UITrainVIPInviteConfirmPopView.DataDefine = DataDefine
UITrainVIPInviteConfirmPopView.DataDestroy = DataDestroy
UITrainVIPInviteConfirmPopView.OnAddListener = OnAddListener
UITrainVIPInviteConfirmPopView.OnRemoveListener = OnRemoveListener
UITrainVIPInviteConfirmPopView.OnClickConfirm = OnClickConfirm
UITrainVIPInviteConfirmPopView.OnClickCancel = OnClickCancel
UITrainVIPInviteConfirmPopView.InitToggleTime = InitToggleTime
UITrainVIPInviteConfirmPopView.ToggleControlBorS = ToggleControlBorS
UITrainVIPInviteConfirmPopView.CloseSelf = CloseSelf
UITrainVIPInviteConfirmPopView.Update1000MS = Update1000MS
UITrainVIPInviteConfirmPopView.SendMessage = SendMessage
return UITrainVIPInviteConfirmPopView
