local p_img_bg_path = "p_img_bg"
local p_text_desc_path = "p_text_desc"
local p_content_chat_path = "p_img_bg/p_content_chat"
local chat_prefab_path = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceWarTime/SeasonAllianceWarTimeStateChatComp.prefab"
local rapidjson = require("rapidjson")
local UILWSeasonAllianceWarTimeStateComp = require("UI.LWSeason5.UILWSeasonAllianceWarTime.Common.UILWSeasonAllianceWarTimeStateComp")
local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local AllianceWarTimeStateChatNotice = BaseClass("AllianceWarTimeStateChatNotice", base)

function AllianceWarTimeStateChatNotice:ComponentDefine()
  self.p_img_bg = self:AddComponent(UIImage, p_img_bg_path)
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
  self.p_text_desc:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.p_content_chat = self:AddComponent(UIBaseContainer, p_content_chat_path)
end

function AllianceWarTimeStateChatNotice:ComponentDestroy()
  if self.Req ~= nil then
    self:GameObjectDestroy(self.Req)
    self.Req = nil
  end
  self.p_img_bg = nil
  self.p_text_desc = nil
  self.p_content_chat = nil
end

function AllianceWarTimeStateChatNotice:DataDefine()
end

function AllianceWarTimeStateChatNotice:DataDestroy()
end

function AllianceWarTimeStateChatNotice:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceWarTimeStateChatNotice:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceWarTimeStateChatNotice:OnAddListener()
  base.OnAddListener(self)
end

function AllianceWarTimeStateChatNotice:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceWarTimeStateChatNotice:UpdateItem(chatData, index)
  base.UpdateItem(self, chatData, index)
  if not (chatData and chatData.extra) or not chatData.extra.customJsonParam then
    return
  end
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  local timeIndex = checknumber(jsonObj.wartimeindex)
  if 0 <= timeIndex and timeIndex <= 2 then
    local timeConfig = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigData(timeIndex)
    local titleStr = string.format("<u>%s</u>", CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui27"))
    local nameStr = ""
    if not string.IsNullOrEmpty(jsonObj.username) then
      nameStr = jsonObj.username
    end
    local timeStr = ""
    if timeConfig ~= nil then
      timeStr = timeConfig:GetServerTimeRangeStr()
    end
    local descStr = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui28", titleStr .. nameStr, timeStr)
    local linkStr = string.gsub(descStr, "<u>", "<u><link='action_open_alliance_war_set'>")
    linkStr = string.gsub(linkStr, "</u>", "</link></u>")
    self.p_text_desc:SetText(linkStr)
    self.Req = self:GameObjectInstantiateAsync(chat_prefab_path, function(req)
      local go = req.gameObject
      go.name = string.format("SeasonAllianceWarTimeStateChatComp_%d", UITimeManager:GetInstance():GetServerTime())
      local transform = go.transform
      local transRoot = self.p_content_chat.transform
      transform:SetParent(transRoot)
      local comp = self:AddComponent(UILWSeasonAllianceWarTimeStateComp, go)
      comp:SetLocalScaleXYZ(1, 1, 1)
      comp:SetAnchoredPositionXY(0, 0)
      local data = {}
      data.TimeIndex = timeIndex
      data.SetTime = 0
      data.PreviewMode = true
      comp:ReInit(data)
    end)
  end
end

function AllianceWarTimeStateChatNotice:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function AllianceWarTimeStateChatNotice:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function AllianceWarTimeStateChatNotice:InitUi()
end

function AllianceWarTimeStateChatNotice:OnPointerClick(clickPos)
  if self.p_text_desc == nil then
    return
  end
  local linkId = self.p_text_desc:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(true) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeSetView)
  end
end

return AllianceWarTimeStateChatNotice
