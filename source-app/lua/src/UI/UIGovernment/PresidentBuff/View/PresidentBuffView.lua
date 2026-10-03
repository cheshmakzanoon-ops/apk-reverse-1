local PresidentBuffView = BaseClass("PresidentBuffView", UIBaseView)
local base = UIBaseView
local PresidentBuffItem = require("UI.UIGovernment.PresidentBuff.Component.PresidentBuffItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "Content/TitleText"
local unset_path = "Content/unset"
local player_path = "Content/player"
local name_path = "Content/Name"
local icon_path = "Content/icon"
local effect_path = "Content/effect"
local row_path = "Content/row"
local cd_path = "Content/cd"
local duration_path = "Content/duration"
local back_toggle_path = "Content/backToggle"
local text_path = "Content/backToggle/Text"
local btn_skip_path = "Content/backToggle/btnSkip"

function PresidentBuffView:OnCreate()
  base.OnCreate(self)
  local param, serverData, serverId, curPresident, positionInfo = self:GetUserData()
  self.param = param
  self.serverData = serverData
  self.serverId = serverId
  self.curPresident = curPresident
  self.positionInfo = positionInfo
  self.configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, param)
  self.CanChangeAppointRight = false
  self:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, effect_path)
  self.theItem = self.transform:Find(row_path).gameObject
  self.theItem:GameObjectCreatePool()
  local goItem, itemNode
  local buffs = DataCenter.GovernmentManager:GetEffectBuffs(self.configData.id, self.serverId)
  for index, buff in ipairs(buffs) do
    local effectId = buff.effectId
    local buffAddNum = buff.buffAddNum
    local effectName = buff.effectName
    local levelName = "eff_" .. effectId
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    itemNode = self.content:AddComponent(PresidentBuffItem, levelName)
    itemNode:ReInit(effectName, buffAddNum)
  end
  if itemNode ~= nil then
    itemNode:HideLine()
  end
  self:UpdateData()
end

function PresidentBuffView:OnDestroy()
  if self.CanChangeAppointRight and self.thePositionInfo then
    local oldAppointRight = self.thePositionInfo:HasAppointRight()
    local newAppointRight = self.right_toggle:GetIsOn()
    if oldAppointRight ~= newAppointRight then
      SFSNetwork.SendMessage(MsgDefines.KingdomSetAppointRight, tostring(self.governmentId), newAppointRight)
    end
  end
  self.content:RemoveComponents(PresidentBuffItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PresidentBuffView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.UpdateData)
end

function PresidentBuffView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function PresidentBuffView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.unset = self:AddComponent(UIText, unset_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerName = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.cd_time = self:AddComponent(UIText, cd_path)
  self.duration = self:AddComponent(UIText, duration_path)
  self.dialog_title_text:SetLocalText("390003")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title_text:SetLocalText(self.configData.name)
  self.right_toggle = self:AddComponent(UIToggle, back_toggle_path)
  self.right_text = self:AddComponent(UIText, text_path)
  self.right_btn_skip = self:AddComponent(UIButton, btn_skip_path)
  self.right_btn_skip:SetOnClick(function()
    UIUtil.ShowTipsId(393018)
  end)
  self.player:SetEnableClickShowInfo(true, true)
  self.configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, self.param)
  self.governmentId = self.configData.id
end

function PresidentBuffView:ComponentDestroy()
  self.btn_back = nil
  self.right_toggle = nil
  self.right_btn_skip = nil
  self.right_text = nil
end

function PresidentBuffView:UpdateData()
  local isEmpty = true
  local tryShowBtn = true
  self.theCD = nil
  self.endTime = nil
  self.duration:SetText("")
  if self.param == nil or self.param == 0 then
    local curPresident = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
    if self.serverId and self.serverId ~= LuaEntry.Player:GetSourceServerId() then
      curPresident = self.curPresident
      tryShowBtn = false
    end
    if curPresident ~= nil then
      self.playerName:SetText(curPresident:GetFullName())
      self.player:SetHead(curPresident.uid, curPresident.pic, curPresident.picVer, nil, curPresident:GetHeadBgImg())
      isEmpty = false
    end
  else
    local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(self.governmentId)
    if self.serverId and self.serverId ~= LuaEntry.Player:GetSourceServerId() then
      positionInfo = self.positionInfo
      tryShowBtn = false
    end
    if positionInfo ~= nil and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
      self.thePositionInfo = positionInfo
      self.playerName:SetText(positionInfo:GetFullName())
      self.player:SetHead(positionInfo.uid, positionInfo.pic, positionInfo.picVer, nil, positionInfo:GetHeadBgImg())
      isEmpty = false
    end
    if positionInfo ~= nil and positionInfo:IsInAppointTimeCD() then
      self.theCD = positionInfo:GetAppointTimeCD()
      self.cd_time:SetActive(true)
    end
    if positionInfo and positionInfo.endTime > 0 then
      self.endTime = positionInfo.endTime
    end
  end
  self.player:SetActive(not isEmpty)
  self.playerName:SetActive(not isEmpty)
  self.icon:SetActive(isEmpty)
  self.unset:SetActive(isEmpty)
  if isEmpty then
    self.icon:LoadSprite(self.configData.icon)
    self.icon:SetNativeSize()
    self.unset:SetLocalText(208255)
  end
  if self.serverId and self.serverId ~= LuaEntry.Player:GetSourceServerId() then
    self.right_toggle:SetActive(false)
    self.theCD = nil
  elseif tryShowBtn and toInt(self.governmentId) == 10002 and self.thePositionInfo ~= nil then
    self.CanChangeAppointRight = LuaEntry.Player:IsPresident()
    self.right_toggle:SetActive(self.CanChangeAppointRight)
    self.right_toggle:SetIsOn(self.thePositionInfo:HasAppointRight())
    self.right_toggle:SetInteractable(self.CanChangeAppointRight)
    self.right_btn_skip:SetActive(not self.CanChangeAppointRight)
    self.right_text:SetLocalText("grant_permissions_desc")
  else
    self.right_toggle:SetActive(false)
  end
  self:Update1000MS()
end

function PresidentBuffView:Update1000MS()
  if self.theCD ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.theCD - curTime
    if 0 < remainTime then
      self.cd_time:SetLocalText("officer_apply_009", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.theCD = nil
      self.cd_time:SetActive(false)
    end
  else
    self.cd_time:SetActive(false)
  end
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - now
    if 0 < remainTime then
      self.duration:SetLocalText("zone_war_government_18", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.duration:SetText("")
    end
  end
end

return PresidentBuffView
