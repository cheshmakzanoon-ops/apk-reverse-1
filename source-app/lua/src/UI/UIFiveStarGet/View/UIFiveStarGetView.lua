local UIFiveStarGetView = BaseClass("UIFiveStarGetView", UIBaseView)
local base = UIBaseView
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local UIStartCell = require("UI.UIFiveStarGet.Component.UIStarCell")
local UISuggest = require("UI.UIFiveStarGet.Component.UISuggest")
local title_text_path = "Image/titleText"
local close_btn_path = "Image/anim_close/CloseBtn"
local content_text_path = "Image/Node_speak/img_bg_speak/DesName"
local img_bg_speak_path = "Image/Node_speak/img_bg_speak"
local goto_btn_path = "Image/BtnGo/GotoBtn"
local goto_btn_text_path = "Image/BtnGo/GotoBtn/GotoBtnName"
local receive_btn_path = "Image/BtnGo/ReceiveBtn"
local receive_btn_text_path = "Image/BtnGo/ReceiveBtn/ReceiveBtnName"
local reward_value_root_path = "Image/ResourceCell"
local reward_value_text_path = "Image/ResourceCell/ResourceNum"
local minStar = 3

local function OnCreate(self)
  base.OnCreate(self)
  local usrData = self:GetUserData()
  if usrData ~= nil then
    self.type = usrData.type
  else
    self.type = "none"
  end
  self:ComponentDefine()
  DataCenter.LWSoundManager:PlaySound(62293, false)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.title_text:SetLocalText(129273)
  self.close_mask = self:AddComponent(UIButton, "panel")
  self.close_mask:SetOnClick(function()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content_text = self:AddComponent(UIText, content_text_path)
  self.speakBg = self:AddComponent(UIBaseContainer, img_bg_speak_path)
  self.goto_btn_text = self:AddComponent(UIText, goto_btn_text_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.btnLayout = self:AddComponent(UIBaseContainer, "Image/BtnGo")
  self.receive_btn_text = self:AddComponent(UIText, receive_btn_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:OnReceiveBtnClick()
  end)
  self.reward_value_root = self:AddComponent(UIBaseComponent, reward_value_root_path)
  self.reward_value_text_text = self:AddComponent(UIText, reward_value_text_path)
  local k2 = LuaEntry.DataConfig:TryGetStr("five_star_evaluation_0", "k2")
  self.reward_value_text_text:SetText("X" .. tostring(k2))
  local starCell
  self.starCellList = {}
  for i = 1, 5 do
    starCell = self:AddComponent(UIStartCell, "Image/Star/star" .. i)
    starCell:InitData(i)
    table.insert(self.starCellList, starCell)
  end
  self.suggestView = self:AddComponent(UISuggest, "suggestRoot")
  self.scoreView = self:AddComponent(UIBaseContainer, "Image")
  self.scoreView:SetActive(true)
  self.suggestView:SetActive(false)
  self:OnStartClick(0)
  Setting:SetPrivateInt("APS_FiveStar_Jump", 1)
  Setting:SetPrivateInt("APS_FiveStar", 1)
end

function UIFiveStarGetView:OnStartClick(index)
  if self.showCount == index or index == nil or not self.starCellList then
    return
  end
  if self.showCount and self.showCount > 0 then
    return
  end
  self.showCount = index
  if self.showCount then
    PostEventLog.Track(PostEventLog.Defines.FiveStartScore, {
      score = self.showCount,
      type = self.type
    })
  end
  if self.showCount ~= 0 then
    SFSNetwork.SendMessage(MsgDefines.FiveStar, 1)
    DataCenter.LWFiveStarManager:SetFlag()
  end
  if self.showCount == 0 then
    self.content_text:SetLocalText(129276)
    self.btnLayout:SetActive(false)
  elseif self.showCount <= minStar then
    self.content_text:SetLocalText(129275)
    self.goto_btn_text:SetLocalText(129278)
    self.btnLayout:SetActive(true)
  else
    self.content_text:SetLocalText(129274)
    self.goto_btn_text:SetLocalText(110003)
    self.btnLayout:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.speakBg.transform)
  self:DestroyDelay()
  for i = 1, #self.starCellList do
    local indexs = i
    self["delaySend" .. indexs] = TimerManager:GetInstance():DelayInvoke(function()
      if self and self.starCellList then
        self.starCellList[indexs]:IconSetActive(indexs <= self.showCount)
      end
    end, 0.1 * (indexs - 1))
  end
end

local function OnDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.GF_five_star_finish)
  self.speakBg = nil
  self:DestroyDelay()
  self.starCellList = nil
  base.OnDestroy(self)
end

function UIFiveStarGetView:DestroyDelay()
  if self.starCellList and not table.IsNullOrEmpty(self.starCellList) then
    for i = 1, #self.starCellList do
      if self["delaySend" .. i] then
        self["delaySend" .. i]:Stop()
        self["delaySend" .. i] = nil
      end
    end
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  self:SetButtonState()
end

local function SetButtonState(self)
end

local function OnReceiveBtnClick(self)
  self.ctrl:CloseSelf()
end

local function OnGotoBtnClick(self)
  if self.showCount and self.showCount > 3 then
    EventManager:GetInstance():Broadcast(EventId.GF_five_star_finish)
    CS.GameEntry.Sdk:RequestInAppReview()
    TimerManager:GetInstance():DelayInvoke(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, 1.5)
  else
    self.scoreView:SetActive(false)
    self.suggestView:SetActive(true)
  end
end

UIFiveStarGetView.OnCreate = OnCreate
UIFiveStarGetView.OnDestroy = OnDestroy
UIFiveStarGetView.OnEnable = OnEnable
UIFiveStarGetView.OnDisable = OnDisable
UIFiveStarGetView.OnAddListener = OnAddListener
UIFiveStarGetView.OnRemoveListener = OnRemoveListener
UIFiveStarGetView.ComponentDefine = ComponentDefine
UIFiveStarGetView.RefreshView = RefreshView
UIFiveStarGetView.SetButtonState = SetButtonState
UIFiveStarGetView.OnGotoBtnClick = OnGotoBtnClick
UIFiveStarGetView.OnReceiveBtnClick = OnReceiveBtnClick
return UIFiveStarGetView
