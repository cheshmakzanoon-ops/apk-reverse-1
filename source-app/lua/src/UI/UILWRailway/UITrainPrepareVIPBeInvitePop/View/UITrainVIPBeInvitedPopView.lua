local UITrainVIPBeInvitedPopView = BaseClass("UITrainVIPBeInvitedPopView", UIBaseView)
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
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
  self.blackBtn = self:AddComponent(UIButton, "black")
  self.blackBtn:SetOnClick(function()
    self:CloseBtnOnClick()
  end)
  self.bgImg = self:AddComponent(UIRawImage, "bg/bg_1")
  self.bgTop = self:AddComponent(UIRawImage, "bg/bg_2")
  self.bgBottom = self:AddComponent(UIRawImage, "bg/bg_3")
  self.iconImg = self:AddComponent(UIImage, "bg/icon")
  self.titleText = self:AddComponent(UIText, "bg/txtTitle")
  self.timeText = self:AddComponent(UIText, "bg/timeText")
  self.nameText = self:AddComponent(UIText, "bg/name")
  self.descText = self:AddComponent(UILWScienceDetailDesc, "bg/desc")
  self.acceptBtn = self:AddComponent(UIButton, "bg/acceptBtn")
  self.acceptBtn:SetOnClick(function()
    self:OnAcceptBtnClick()
  end)
  self.sendGiftBtn = self:AddComponent(UIButton, "bg/sendGiftBtn")
  self.sendGiftBtn:SetOnClick(function()
    self:OnSendGiftBtnClick()
  end)
  self.closeBtn = self:AddComponent(UIButton, "bg/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self:CloseBtnOnClick()
  end)
  self.acceptText = self:AddComponent(UIText, "bg/acceptBtn/LW_Btn_Common_New_Base/BtnText")
  self.head = self:AddComponent(UICommonHead, "bg/Head")
  self.head:SetEnableClickShowInfo(true, true)
  self.animator = self:AddComponent(UIAnimator, "")
  self.animatorTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.animator:Play("UITrainVIPBeInvitedPopLoop", 0, 0)
  end, 0.5)
end

local function ComponentDestroy(self)
  self.blackBtn = nil
  self.bgImg = nil
  self.iconImg = nil
  self.titleText = nil
  self.nameText = nil
  self.descText = nil
  self.acceptBtn = nil
  self.acceptText = nil
  self.head = nil
  self.bgTop = nil
  self.bgBottom = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self.endTime = 10
  local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platform.vipInvite then
    self.endTime = platform.vipInvite.endTime
  end
end

local function DataDestroy(self)
  self.param = nil
  self.endTime = nil
  self.trainData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function CloseSelf(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainRefuseVip, 1)
  UIUtil.ShowTips(Localization:GetString("alliance_train_vip024"))
  self.ctrl.CloseSelf(self)
end

local function InitData(self)
  self.trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not self.trainData then
    return
  end
  if self.param == 0 then
    self.bgImg:LoadSpriteAsync("Assets/Main/TextureEx/LWTrainVIPNew/zxl_huoche_yaoqing_fen.png")
    self.iconImg:LoadSpriteAsync("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huoche_huizhang_fen.png")
    self.bgTop:LoadSpriteAsync("Assets/Main/TextureEx/LWTrainVIPNew/zxl_huoche_yaoqing_fen1.png")
    self.bgBottom:LoadSpriteAsync("Assets/Main/TextureEx/LWTrainVIPNew/zxl_huoche_yaoqing_fen2.png")
    self.descText:SetTextAndParam(Localization:GetString("alliance_train_vip008", LuaEntry.Player.name))
  elseif self.param == 1 then
    self.bgImg:LoadSpriteAsync("Assets/Main/TextureEx/LWTrainVIPNew/zxl_huoche_yaoqing_huang.png")
    self.iconImg:LoadSpriteAsync("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huoche_huizhang_huang.png")
    self.bgTop:LoadSpriteAsync("Assets/Main/TextureEx/LWTrainVIPNew/zxl_huoche_yaoqing_huang1.png")
    self.bgBottom:LoadSpriteAsync("Assets/Main/TextureEx/LWTrainVIPNew/zxl_huoche_yaoqing_huang2.png")
    self.descText:SetTextAndParam(Localization:GetString("alliance_train_vip009", LuaEntry.Player.name))
  end
  self.head:SetHeadAndFrame(self.trainData.ownerId, self.trainData.pic, self.trainData.picVer, false, self.trainData.headSkinId, self.trainData.headSkinET)
  self.nameText:SetText(self.trainData.name)
end

local function OnAcceptBtnClick(self)
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if platformData.state == TrainPlatformState.TrainWithPassenger then
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip028"))
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainRefuseVip, 1)
    self.ctrl.CloseSelf(self)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainAcceptVip, 1)
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip023"))
    self.ctrl.CloseSelf(self)
  end
end

local function OnSendGiftBtnClick(self)
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = self.trainData.ownerId,
    targetServerId = self.trainData.serverId
  })
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  if 0 < diff then
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
  else
    self.timeText:SetText("00:00:00")
    EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipInfo)
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip024"))
    self.ctrl.CloseSelf(self)
  end
end

local function CloseBtnOnClick(self)
  UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("alliance_train_vip020", self.trainData.name), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self:CloseSelf()
  end, function()
  end)
end

UITrainVIPBeInvitedPopView.OnCreate = OnCreate
UITrainVIPBeInvitedPopView.OnDestroy = OnDestroy
UITrainVIPBeInvitedPopView.OnEnable = OnEnable
UITrainVIPBeInvitedPopView.OnDisable = OnDisable
UITrainVIPBeInvitedPopView.ComponentDefine = ComponentDefine
UITrainVIPBeInvitedPopView.ComponentDestroy = ComponentDestroy
UITrainVIPBeInvitedPopView.DataDefine = DataDefine
UITrainVIPBeInvitedPopView.DataDestroy = DataDestroy
UITrainVIPBeInvitedPopView.OnAddListener = OnAddListener
UITrainVIPBeInvitedPopView.OnRemoveListener = OnRemoveListener
UITrainVIPBeInvitedPopView.CloseSelf = CloseSelf
UITrainVIPBeInvitedPopView.InitData = InitData
UITrainVIPBeInvitedPopView.OnAcceptBtnClick = OnAcceptBtnClick
UITrainVIPBeInvitedPopView.OnSendGiftBtnClick = OnSendGiftBtnClick
UITrainVIPBeInvitedPopView.Update1000MS = Update1000MS
UITrainVIPBeInvitedPopView.CloseBtnOnClick = CloseBtnOnClick
return UITrainVIPBeInvitedPopView
