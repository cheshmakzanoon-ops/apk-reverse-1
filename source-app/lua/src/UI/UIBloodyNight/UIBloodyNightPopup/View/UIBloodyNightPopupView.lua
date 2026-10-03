local UIBloodyNightPopupView = BaseClass("UIBloodyNightPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
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
  self.monster = {}
  for i = 1, 4 do
    self.monster[i] = self:AddComponent(UIRawImage, "bg/BG/monster" .. i)
  end
  self.animator = self:AddComponent(UIAnimator, "")
  self.u_i_player_head = self:AddComponent(UICommonHead, "bg/UIPlayerHead")
  self.u_i_player_head:SetEnableClickShowInfo(true, true)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "bg/title")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "bg/playerName")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "bg/desc")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "bg/time")
  self.panelClose = self:AddComponent(UIButton, "panel")
  self.panelClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnClose = self:AddComponent(UIButton, "bg/BtnClose")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnGo = self:AddComponent(UIButton, "bg/BtnGo")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnBtn = {}
  self.imgIcon = {}
  for i = 1, 5 do
    self.btnBtn[i] = self:AddComponent(UIButton, "bg/layout/btn" .. i)
    self.btnBtn[i]:SetOnClick(function()
      self:OnBtnBtnClick(i)
    end)
    self.imgIcon[i] = self:AddComponent(UIImage, "bg/layout/btn" .. i .. "/icon" .. i)
  end
end

local function ComponentDestroy(self)
  self.u_i_player_head = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTime = nil
  self.btnClose = nil
  self.btnGo = nil
  self.btnBtn = nil
  self.imgIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.endTime = nil
  self.BNTemplate = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIBloodyNightPopupView:Refresh()
  local stageTemp = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  if stageTemp then
    for i = 1, 4 do
      self.monster[i]:SetActive(i == stageTemp.stage)
    end
  end
  local state, BNTemplate, startTime, endTime, nightStalker = DataCenter.BloodyNightDataManager:GetBloodyNightState()
  self.endTime = endTime
  self.BNTemplate = BNTemplate
  if nightStalker then
    self.u_i_player_head:SetActive(true)
    self.u_i_player_head:SetHeadAndFrame(nightStalker.uid, nightStalker.pic, nightStalker.picVer, nil, nightStalker.headSkinId, nightStalker.headSkinET)
    self.textName:SetText(nightStalker.name)
    self.textTitle:SetText("")
    self.animator:Play("V_ui_S4_UIBloodyNightPopup_Manuallyin", 0, 0)
  else
    self.u_i_player_head:SetActive(false)
    self.textName:SetText("")
    self.textTitle:SetLocalText("season_s4_activity_1200009_name")
    self.animator:Play("V_ui_S4_UIBloodyNightPopup_in", 0, 0)
  end
  if state == BloodyNightState.Bloody then
    CommonUtil.PlayerPrefsSetLong("BloodyNightPopupCoolDown", endTime + 10000)
    self.textDesc:SetLocalText("season_s4_activity_1200009_desc3")
  elseif state == BloodyNightState.Silent then
    self.textDesc:SetLocalText("season_s4_activity_1200009_desc2")
  else
    self.textDesc:SetText("")
  end
  self:Update1000MS()
  if BNTemplate then
    for i = 1, 5 do
      local iconPath = BNTemplate.buff_icon[i]
      if iconPath then
        self.btnBtn[i]:SetActive(true)
        self.imgIcon[i]:LoadSprite(BNTemplate.buff_icon[i])
      else
        self.btnBtn[i]:SetActive(false)
      end
    end
  end
end

function UIBloodyNightPopupView:Update1000MS()
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - now))
  end
end

local function OnBtnGoClick(self)
  SeasonUtil.OpenSeasonActivityByType(EnumActivity.BloodyNight.Type)
  self.ctrl:CloseSelf()
end

local function OnBtnBtnClick(self, index)
  if self.BNTemplate then
    local tip = Localization:GetString(self.BNTemplate.buff_desc[index])
    UIUtil.ShowBubbleTips(tip, self.btnBtn[index].transform.position, 0, -30, 0, nil, nil)
  end
end

UIBloodyNightPopupView.OnCreate = OnCreate
UIBloodyNightPopupView.OnDestroy = OnDestroy
UIBloodyNightPopupView.OnEnable = OnEnable
UIBloodyNightPopupView.OnDisable = OnDisable
UIBloodyNightPopupView.ComponentDefine = ComponentDefine
UIBloodyNightPopupView.ComponentDestroy = ComponentDestroy
UIBloodyNightPopupView.DataDefine = DataDefine
UIBloodyNightPopupView.DataDestroy = DataDestroy
UIBloodyNightPopupView.OnAddListener = OnAddListener
UIBloodyNightPopupView.OnRemoveListener = OnRemoveListener
UIBloodyNightPopupView.OnBtnGoClick = OnBtnGoClick
UIBloodyNightPopupView.OnBtnBtnClick = OnBtnBtnClick
return UIBloodyNightPopupView
