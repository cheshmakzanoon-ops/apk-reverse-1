local base = UIBaseContainer
local AssistanceHistoryItem = BaseClass("AssistanceHistoryItem", base)
local Localization = CS.GameEntry.Localization
local playerHead_path = "UIPlayerHead"
local descTxt_path = "Txt_Des"
local timeTxt_path = "Txt_Time"
local titleTxt_path = "Txt_Title"
local type_img_path = "typeImg"
local recordType = {Firefighting = 1, Assistance = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.playerHeadComponent = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHeadComponent:SetEnableClickShowInfo(true, true)
  self.type_img = self:AddComponent(UIImage, type_img_path)
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.descTxt = nil
  self.timeTxt = nil
  self.titleTxt = nil
  self.playerHeadComponent = nil
  self.type_img = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function AssistanceHistoryItem:RefreshView(index, data)
  if data == nil then
    return
  end
  self.data = data
  local userInfo = data
  local name = ""
  local isAnonymous = data.anonymous == 1
  if not isAnonymous then
    name = UIUtil.FormatServerAllianceName(userInfo.serverId, userInfo.abbr, userInfo.name)
  else
    name = Localization:GetString("390810")
  end
  userInfo.isActiveAnonymity = isAnonymous
  local isBlock = ChatManager2:GetInstance().Restrict:isInRestrictList(userInfo.uid, RestrictType.BLOCK)
  if isBlock then
    name = Localization:GetString("390810")
    userInfo.isActiveAnonymity = true
  end
  self.playerHeadComponent:SetEnableClickShowInfo(data.anonymous ~= 1)
  self.playerHeadComponent:ParseHeadInfo(userInfo)
  self.titleTxt:SetText(name)
  self.timeTxt:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  if data.recordType == recordType.Firefighting then
    self.descTxt:SetLocalText("record_page_fire")
    self.type_img:SetActive(true)
    self.type_img:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_pengyouquan_jilu_miehuo_icon.png")
  elseif data.recordType == recordType.Assistance then
    self.descTxt:SetLocalText("record_page_reinforce")
    self.type_img:SetActive(true)
    self.type_img:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_pengyouquan_jilu_zhenyuan_icon.png")
  else
    self.descTxt:SetText("")
    self.type_img:SetActive(false)
  end
end

AssistanceHistoryItem.OnCreate = OnCreate
AssistanceHistoryItem.OnDestroy = OnDestroy
AssistanceHistoryItem.OnEnable = OnEnable
AssistanceHistoryItem.OnDisable = OnDisable
AssistanceHistoryItem.ComponentDefine = ComponentDefine
AssistanceHistoryItem.ComponentDestroy = ComponentDestroy
AssistanceHistoryItem.DataDefine = DataDefine
AssistanceHistoryItem.DataDestroy = DataDestroy
return AssistanceHistoryItem
