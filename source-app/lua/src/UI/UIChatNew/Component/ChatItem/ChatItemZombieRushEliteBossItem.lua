local ChatItemZombieRushEliteBossItem = BaseClass("ChatItemZombieRushEliteBossItem", UIBaseContainer)
local base = UIBaseContainer
local u_i_player_head_path = "UIPlayerHead"
local player_name_text_path = "PlayerNameText"
local help_btn_path = "HelpBtn"
local btn_text_path = "HelpBtn/LW_Btn_Common_New_Base/BtnText"
local BtnStateType = {
  None = 0,
  Full = 1,
  Own = 2
}
local DialogId = {
  [BtnStateType.Full] = "zombierush_eliteBoss_Reinforcement_full",
  [BtnStateType.Own] = "zombierush_eliteBoss_Reinforcement_mine"
}

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

local function ComponentDefine(self)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(false, false)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.help_btn = self:AddComponent(UIButton, help_btn_path)
  self.help_btn:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
end

local function ComponentDestroy(self)
  self.u_i_player_head = nil
  self.player_name_text = nil
  self.help_btn = nil
  self.btn_text = nil
end

local function DataDefine(self)
  self.point = nil
  self.bUuid = nil
  self.uid = nil
  self.btnState = nil
end

local function DataDestroy(self)
  self.point = nil
  self.bUuid = nil
  self.uid = nil
  self.btnState = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  if data then
    self.point = 0
    self.bUuid = 0
    self.uid = 0
    local player = data.player
    local num = data.num
    local maxNum
    if player then
      self.u_i_player_head:ParseHeadInfo(player)
      self.player_name_text:SetText(player.name)
      self.point = player.pointId
      self.bUuid = tostring(player.bUuid)
      self.uid = player.uid
      maxNum = player.maxAssistance
    end
    self:RefreshNum(num, maxNum)
  end
end

local function RefreshNum(self, num, maxNum)
  num = num or 0
  maxNum = maxNum or 0
  self.btn_text:SetText(num .. "/" .. maxNum)
  if num >= maxNum then
    self.btnState = BtnStateType.Full
    CS.UIGray.SetGray(self.help_btn.transform, true, true)
  elseif self.uid == LuaEntry.Player.uid then
    self.btnState = BtnStateType.Own
    CS.UIGray.SetGray(self.help_btn.transform, true, true)
  else
    self.btnState = BtnStateType.None
    CS.UIGray.SetGray(self.help_btn.transform, false, true)
  end
end

local function OnBtnClick(self)
  if self.btnState == BtnStateType.Full or self.btnState == BtnStateType.Own then
    UIUtil.ShowTipsId(DialogId[self.btnState])
    return
  end
  if LuaEntry.Player:IsInSourceServer() then
    if self.point and self.point > 0 then
      local point = self.point
      local bUuid = self.bUuid
      local uid = self.uid
      GoToUtil.CloseAllWindows()
      local pos = SceneUtils.TileIndexToWorld(point)
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
        self:OpenMarchPanel(point, bUuid, uid)
      end, LuaEntry.Player:GetSourceServerId())
    else
      Logger.LogError("the point is invalid")
    end
  else
    UIUtil.ShowTipsId("activity_clock_go_err_01")
  end
end

local function OpenMarchPanel(self, point, bUuid, uid)
  if point and bUuid and uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, bUuid, uid, point, AssistanceType.MainCity)
  end
end

ChatItemZombieRushEliteBossItem.OnCreate = OnCreate
ChatItemZombieRushEliteBossItem.OnDestroy = OnDestroy
ChatItemZombieRushEliteBossItem.ComponentDefine = ComponentDefine
ChatItemZombieRushEliteBossItem.ComponentDestroy = ComponentDestroy
ChatItemZombieRushEliteBossItem.DataDefine = DataDefine
ChatItemZombieRushEliteBossItem.DataDestroy = DataDestroy
ChatItemZombieRushEliteBossItem.OnAddListener = OnAddListener
ChatItemZombieRushEliteBossItem.OnRemoveListener = OnRemoveListener
ChatItemZombieRushEliteBossItem.SetData = SetData
ChatItemZombieRushEliteBossItem.RefreshNum = RefreshNum
ChatItemZombieRushEliteBossItem.OnBtnClick = OnBtnClick
ChatItemZombieRushEliteBossItem.OpenMarchPanel = OpenMarchPanel
return ChatItemZombieRushEliteBossItem
