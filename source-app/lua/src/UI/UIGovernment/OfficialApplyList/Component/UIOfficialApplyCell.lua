local base = UIBaseContainer
local UIOfficialApplyCell = BaseClass("UIOfficialApplyCell", base)
local nameText_path = "NameText"
local dialogText_path = "DialogText"
local applyBtn_path = "BtnGroup/ApplyBtn"
local removeBtn_path = "BtnGroup/RemoveBtn"
local bg_path = "Bg"
local tipText_path = "TipText"
local playerHead_Path = "Head/UIPlayerHead"
local state_text_path = "StateText"
local btn_group_path = "BtnGroup"
local tip_text_path = "TipText"
local await_text_path = "AwaitText"
local upPosY = 14
local centerPosY = 0
local posX = 246

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
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.dialogText = self:AddComponent(UIText, dialogText_path)
  self.applyBtn = self:AddComponent(UIEventTrigger, applyBtn_path)
  self.removeBtn = self:AddComponent(UIButton, removeBtn_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_Path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.removeBtn:SetOnClick(BindCallback(self, self.OnRemoveBtnClick))
  self.state_text = self:AddComponent(UITextMeshProUGUIEx, state_text_path)
  self.btn_group = self:AddComponent(UIBaseContainer, btn_group_path)
  posX = self.btn_group:GetAnchoredPositionX()
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.applyBtn:OnPointerClick(function(data)
    if self.OnAgreeBtnClick then
      self.OnAgreeBtnClick(self, data)
    end
  end)
  self.await_text = self:AddComponent(UIText, await_text_path)
  self.await_text:SetActive(false)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.dialogText = nil
  self.applyBtn = nil
  self.removeBtn = nil
  self.bg = nil
  self.tipText = nil
  self.playerHead = nil
  self.state_text = nil
  self.btn_group = nil
  self.tip_text = nil
  self.await_text = nil
end

local function DataDefine(self)
  self.positionId = nil
  self.data = nil
end

local function DataDestroy(self)
  self.positionId = nil
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OfficialGetAutoAgreeInfo, self.RefreshBtnGroup)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OfficialGetAutoAgreeInfo, self.RefreshBtnGroup)
  base.OnRemoveListener(self)
end

local function SetData(self, positionId, data, serverId)
  self.serverId = serverId
  self.positionId = positionId
  self.data = data
  local framePath
  if data.headSkinId then
    framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET, false)
  end
  self.playerHead:SetData(data.uid, data.pic, data.picver, nil, framePath)
  self.nameText:SetText(data:GetFullName(data.uid))
  local isServer = CS.GameEntry.Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true)
  self:SetTimeShowMode(data.applyTime, isServer)
  if data.uid == LuaEntry.Player.uid then
    self.bg:SetColor(Color.New(0.6392156862745098, 0.8901960784313725, 0.5215686274509804, 1))
    self.nameText:SetColor(Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1))
    self.dialogText:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
    self.tipText:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
  else
    self.bg:SetColor(Color.New(0.9098039215686274, 0.8274509803921568, 0.8431372549019608, 1))
    if not string.IsNullOrEmpty(data.allianceId) and data.allianceId == LuaEntry.Player:GetAllianceUid() then
      self.nameText:SetColor(Color.New(0.14901960784313725, 0.5803921568627451, 0.8, 1))
    else
      self.nameText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    end
    self.dialogText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    self.tipText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
  end
  self:RefreshBtnGroup()
end

local function OnAgreeBtnClick(self, data)
  if DataCenter.OfficialApplyManager:GetAppointmentListFull() then
    UIUtil.ShowTipsId("officer_apply_035")
    return
  end
  local position = data.position
  local items = {
    self.positionId,
    math.floor(position.x),
    math.floor(position.y)
  }
  local str = table.concat(items, ",")
  local aes = CS.AESHelper.Encrypt(str, self.data.uid)
  DataCenter.OfficialApplyManager:SendKingdomPositionApplyAgree(self.positionId, self.data.uid, aes)
end

local function OnRemoveBtnClick(self)
  local isCtrl = DataCenter.OfficialApplyManager:IsManager(self.serverId)
  self.view.ctrl:SendKingdomPositionApplyDelete(self.positionId, self.data, isCtrl)
end

local function SetTimeShowMode(self, time, isServer)
  local timeText = ""
  if isServer then
    timeText = UITimeManager:GetInstance():TimeStampToTimeForServer(tonumber(time))
    self.tip_text:SetLocalText("officer_apply_013")
  else
    timeText = UITimeManager:GetInstance():TimeStampToTimeForLocal(tonumber(time))
    self.tip_text:SetLocalText("officer_apply_048")
  end
  self.dialogText:SetText(timeText)
end

local function RefreshBtnGroup(self)
  local autoAgreeInfo = DataCenter.GovernmentManager:GetKingdomPositionAutoAgreeInfo()
  local showAutoAgree = DataCenter.GovernmentManager:GetAutoAgreeShow() and tonumber(self.positionId) ~= 10002 and autoAgreeInfo and autoAgreeInfo.autoAgree
  if self.data then
    self.await_text:SetActive(false)
    local isCtrl = DataCenter.OfficialApplyManager:IsManager(self.serverId)
    if isCtrl then
      self.applyBtn:SetActive(not showAutoAgree)
      self.removeBtn:SetActive(true)
      self.state_text:SetActive(true)
      self.btn_group:SetAnchoredPositionXY(posX, upPosY)
      if self.data.state == 0 then
        self.state_text:SetLocalText("393016")
        self.state_text:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
      elseif self.data.state == 1 then
        self.state_text:SetLocalText("393015")
        self.state_text:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
      elseif self.data.state == 2 then
        self.state_text:SetLocalText("officer_apply_027")
        self.state_text:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
      end
    else
      self.state_text:SetActive(false)
      self.btn_group:SetAnchoredPositionXY(posX, centerPosY)
      if self.data.uid == LuaEntry.Player.uid then
        self.applyBtn:SetActive(false)
        self.removeBtn:SetActive(true)
      else
        self.applyBtn:SetActive(false)
        self.removeBtn:SetActive(false)
        if showAutoAgree then
          self.await_text:SetActive(true)
          self.await_text:SetLocalText("officer_apply_056")
        end
      end
    end
  else
    self.applyBtn:SetActive(false)
    self.removeBtn:SetActive(false)
    self.state_text:SetActive(false)
    self.await_text:SetActive(false)
  end
end

UIOfficialApplyCell.OnCreate = OnCreate
UIOfficialApplyCell.OnDestroy = OnDestroy
UIOfficialApplyCell.OnEnable = OnEnable
UIOfficialApplyCell.OnDisable = OnDisable
UIOfficialApplyCell.ComponentDefine = ComponentDefine
UIOfficialApplyCell.ComponentDestroy = ComponentDestroy
UIOfficialApplyCell.DataDefine = DataDefine
UIOfficialApplyCell.DataDestroy = DataDestroy
UIOfficialApplyCell.SetData = SetData
UIOfficialApplyCell.OnAgreeBtnClick = OnAgreeBtnClick
UIOfficialApplyCell.OnRemoveBtnClick = OnRemoveBtnClick
UIOfficialApplyCell.SetTimeShowMode = SetTimeShowMode
UIOfficialApplyCell.RefreshBtnGroup = RefreshBtnGroup
UIOfficialApplyCell.OnAddListener = OnAddListener
UIOfficialApplyCell.OnRemoveListener = OnRemoveListener
return UIOfficialApplyCell
