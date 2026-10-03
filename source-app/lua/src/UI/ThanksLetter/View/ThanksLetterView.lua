local ThanksLetterView = BaseClass("ThanksLetterView", UIBaseView)
local rapidjson = require("rapidjson")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LetterShell = require("UI.ThanksLetter.Component.ThanksLetterShell")
local BirthdaySznLetterShell = require("UI.ThanksLetter.Component.BirthdaySznLetterShell")
local panel_path = "Panel"
local root_path = "Root"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self:RefreshView()
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
  self.closeBtn = self:AddComponent(UIButton, panel_path)
  self.shellRoot = self:AddComponent(UISimpleAnimation, root_path)
  self.closeBtn:SetOnClick(function()
    self:PlayCloseAni()
  end)
end

local function ComponentDestroy(self)
  if self.shellPrefabReq then
    self.shellPrefabReq:Destroy()
    self.shellPrefabReq = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ThanksLetterView:RefreshView()
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  local uuid = self.param.uuid
  local itemId = self.param.itemId
  local serverData = rapidjson.decode(self.param.otherParam)
  local letterCfgId = serverData.id
  local templateData = LocalController:instance():getLine(TableName.Letter, letterCfgId)
  if not templateData then
    return
  end
  if string.IsNullOrEmpty(templateData.letter_shell_prefab) then
    return
  end
  self.shellPrefabReq = self:GameObjectInstantiateAsync(templateData.letter_shell_prefab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.shellRoot.transform)
    local prefabName = "LetterShell"
    go.transform.name = prefabName
    local shellScript = LetterShell
    if templateData.letter_content_type == LetterContentType.SznDateBirthday then
      shellScript = BirthdaySznLetterShell
    end
    self.letterShell = self:AddComponent(shellScript, string.format("%s/%s", root_path, prefabName))
    self.letterShell:SetData(uuid, itemId, templateData, serverData, function()
      self.ctrl.CloseSelf()
    end)
    self.letterShell:SetAnchoredPositionXY(0, 0)
    self.letterShell:SetLocalScaleXYZ(1, 1, 1)
  end)
end

function ThanksLetterView:PlayCloseAni()
  if self.closeTimer then
    return
  end
  if not self.letterShell or not self.letterShell.isCompleteExpand then
    self.ctrl:CloseSelf()
    return
  end
  local ret, time = self.letterShell:PlayCloseAniAndGetAniTime()
  if not ret then
    self.ctrl:CloseSelf()
    return
  end
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.closeTimer = nil
    self.ctrl:CloseSelf()
  end, time)
end

ThanksLetterView.OnCreate = OnCreate
ThanksLetterView.OnDestroy = OnDestroy
ThanksLetterView.OnEnable = OnEnable
ThanksLetterView.OnDisable = OnDisable
ThanksLetterView.ComponentDefine = ComponentDefine
ThanksLetterView.ComponentDestroy = ComponentDestroy
ThanksLetterView.DataDefine = DataDefine
ThanksLetterView.DataDestroy = DataDestroy
ThanksLetterView.OnAddListener = OnAddListener
ThanksLetterView.OnRemoveListener = OnRemoveListener
return ThanksLetterView
