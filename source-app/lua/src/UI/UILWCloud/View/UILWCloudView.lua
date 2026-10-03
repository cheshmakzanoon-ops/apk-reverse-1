local UILWCloudView = BaseClass("UILWCloudView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local FIRST_ANIM_LENGTH = 0.7
local SECOND_ANIM_LENGTH = 1.3
local server_jump_info_path = "ServerJumpInfo"

function UILWCloudView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UILWCloudView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWCloudView:ComponentDefine()
  self.server_jump_info = self:AddComponent(UIText, server_jump_info_path)
  self.theCanvas = self:AddComponent(UICanvas, "")
  self.anim = self:AddComponent(UISimpleAnimation, "Eff_zhuanchang_yun")
end

function UILWCloudView:ComponentDestroy()
  self.server_jump_info = nil
  self.theCanvas = nil
  self.anim = nil
end

function UILWCloudView:DataDefine()
  self.midAction, self.holdFunc, self.toServerId, self.timeout, self.timeoutFunc, self.animSpeed = self:GetUserData()
  local nServerId = toInt(self.toServerId)
  if 0 < nServerId and nServerId ~= LuaEntry.Player:GetCurServerId() then
    self.server_jump_info:SetActive(true)
    self.server_jump_info:SetLocalText(801623, nServerId)
    SFSNetwork.SendMessage(MsgDefines.GetServerState, nServerId)
    self.fetchServerStateFinish = false
  else
    self.server_jump_info:SetActive(false)
    self.fetchServerStateFinish = true
  end
  self.firstAnimFinish = false
end

function UILWCloudView:DataDestroy()
  self.timeWait = nil
  self.midAction = nil
  self.holdFunc = nil
  self.timeoutFunc = nil
  self.timeout = nil
  self.toServerId = nil
  self.animSpeed = nil
  self.firstAnimFinish = nil
end

function UILWCloudView:OnEnable()
  base.OnEnable(self)
  if self.theCanvas then
    self.theCanvas:SetOverrideSorting(true)
    self.theCanvas:SetSortingOrder(CanvasOrder.Cloud)
  end
end

function UILWCloudView:OnDisable()
  base.OnDisable(self)
end

function UILWCloudView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CheckServerOK, self.OnCheckServerOK)
end

function UILWCloudView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CheckServerOK, self.OnCheckServerOK)
end

function UILWCloudView:OnCheckServerOK(errCode)
  self.fetchServerStateFinish = true
  if self.toServerId then
    local nServerId = toInt(self.toServerId)
    if errCode ~= nil then
      local text1 = Localization:GetString(801623, nServerId)
      local text2 = ""
      if errCode == "E000000" then
        text2 = Localization:GetString("server_open_tips001")
      else
        text2 = Localization:GetString(errCode)
      end
      self.server_jump_info:SetText(text1 .. "\n" .. text2)
      self.midAction = nil
      self.holdFunc = nil
      if self.firstAnimFinish then
        self:DoDiffuse()
      end
      Logger.LogInfo("CloudViewCheckServerFail : " .. tostring(errCode))
    end
  end
  BattleFieldUtil.CleanTestJump(errCode)
end

function UILWCloudView:Init()
  self.timeWait = nil
  local speed = self.animSpeed and self.animSpeed > 0 and self.animSpeed or 1
  self.anim:Play("Default")
  self.anim:SetStateSpeed("Default", speed)
  if self.holdFunc then
    TimerManager:GetInstance():DelayInvoke(function()
      if self.midAction then
        self.midAction()
        self.midAction = nil
      end
      self.firstAnimFinish = true
      if self.holdFunc then
        self.timeWait = self.timeout or (FIRST_ANIM_LENGTH + SECOND_ANIM_LENGTH) * 2
        self:Update100MS()
      else
        self:DoDiffuse()
      end
    end, FIRST_ANIM_LENGTH / speed)
  else
    TimerManager:GetInstance():DelayInvoke(function()
      if self.midAction then
        self.midAction()
        self.midAction = nil
      end
      if self.anim then
        self.anim:Play("Diffuse")
        self.anim:SetStateSpeed("Diffuse", speed)
      end
      self.firstAnimFinish = true
    end, FIRST_ANIM_LENGTH / speed)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, (FIRST_ANIM_LENGTH + SECOND_ANIM_LENGTH) / speed)
  end
end

function UILWCloudView:Update100MS()
  if self.firstAnimFinish and self.fetchServerStateFinish and self.holdFunc and self.holdFunc() then
    self:DoDiffuse()
  elseif self.timeWait then
    self.timeWait = self.timeWait - 0.1
    if self.timeWait < 0 then
      if self.toServerId and self.server_jump_info then
        local nServerId = toInt(self.toServerId)
        local text1 = Localization:GetString(801623, nServerId)
        local text2 = Localization:GetString("avatar_tips006")
        self.server_jump_info:SetText(text1 .. "\n" .. text2)
        Logger.LogInfo("CloudViewTimeOut : " .. tostring(nServerId))
      end
      self:DoDiffuse()
      if self.timeoutFunc then
        self.timeoutFunc()
        self.timeoutFunc = nil
      end
    end
  end
end

function UILWCloudView:DoDiffuse()
  local speed = self.animSpeed and self.animSpeed > 0 and self.animSpeed or 1
  if self.anim then
    self.anim:Play("Diffuse")
    self.anim:SetStateSpeed("Diffuse", speed)
  end
  self.holdFunc = nil
  self.timeWait = nil
  TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, SECOND_ANIM_LENGTH / speed)
end

return UILWCloudView
