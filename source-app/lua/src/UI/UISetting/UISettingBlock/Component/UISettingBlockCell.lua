local UISettingBlockCell = BaseClass("UISettingBlockCell", UIBaseContainer)
local base = UIBaseContainer

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
  self._server_txt = self:AddComponent(UIText, "Rect_Normal/Txt_Server")
  self._name_txt = self:AddComponent(UIText, "Rect_Normal/Txt_Name")
  self.headIconN = self:AddComponent(UIPlayerHead, "Rect_Normal/UIPlayerHead/HeadIcon")
  self.headFgN = self:AddComponent(UIImage, "Rect_Normal/UIPlayerHead/Foreground")
  self.btn_txt = self:AddComponent(UIText, "Rect_Normal/challengeBtn/BtnTxt")
  self.btn = self:AddComponent(UIButton, "Rect_Normal/challengeBtn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btn_txt:SetLocalText(141027)
end

local function ComponentDestroy(self)
  self.btn = nil
  self._server_txt = nil
  self._name_txt = nil
  self.headIconN = nil
  self.headFgN = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if param ~= nil then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(param.uid, param.name)
    if param.abbr ~= nil and param.abbr ~= "" then
      self._name_txt:SetText("[" .. param.abbr .. "]" .. showName)
    else
      self._name_txt:SetText(showName)
    end
    self._server_txt:SetLocalText(208236, param.server)
    self.headIconN:SetData(param.uid, param.pic, param.picVer)
  end
end

local function OnBtnClick(self)
  if self.param ~= nil then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNBLOCK_COMMAND, self.param.uuid)
  end
end

UISettingBlockCell.OnCreate = OnCreate
UISettingBlockCell.OnDestroy = OnDestroy
UISettingBlockCell.Param = Param
UISettingBlockCell.OnEnable = OnEnable
UISettingBlockCell.OnDisable = OnDisable
UISettingBlockCell.ComponentDefine = ComponentDefine
UISettingBlockCell.ComponentDestroy = ComponentDestroy
UISettingBlockCell.DataDefine = DataDefine
UISettingBlockCell.DataDestroy = DataDestroy
UISettingBlockCell.ReInit = ReInit
UISettingBlockCell.OnBtnClick = OnBtnClick
UISettingBlockCell.SetSelect = SetSelect
return UISettingBlockCell
