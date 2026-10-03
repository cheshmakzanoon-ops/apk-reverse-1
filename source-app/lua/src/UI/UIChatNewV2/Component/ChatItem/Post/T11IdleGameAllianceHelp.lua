local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_T11IdleGameAllianceHelp = BaseClass("ChatItemPost_T11IdleGameAllianceHelp", IChatItemPost)
local base = IChatItemPost
local M = ChatItemPost_T11IdleGameAllianceHelp
local rapidjson = require("rapidjson")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local Localization = CS.GameEntry.Localization
local sendMsgTime = 0

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.chatData = nil
end

function M:ComponentDefine()
  self.btnRoot = self:AddComponent(UIButton, "Root")
  self.btnRoot:SetOnClick(function()
    self:OnBtnRootClick()
  end)
  self.textTitleDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/TitleDesc")
  self.textTaskDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/TaskDesc")
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnLoaded()
  if self:ChatData() == nil then
    Logger.LogError("T11\232\129\148\231\155\159\229\184\174\229\138\169\228\186\139\228\187\182\228\184\139\229\143\145chatData\228\184\186\231\169\186\239\188\129")
    return
  end
  self.chatData = self:ChatData()
  local param
  if not string.IsNullOrEmpty(self.chatData.attachmentId) then
    param = rapidjson.decode(self.chatData.attachmentId)
  end
  self.eventPlayerUuid = param.eventPlayerUuid
  self.eventUuid = param.eventUuid
  self.eventId = param.eventId
  self.questId = param.questId
  self.eventCfgData = DataCenter.T11IdleGameTemplateManager:GetGameEventTemplateById(self.eventId)
  if self.eventCfgData == nil then
    return
  end
  self.questCfgData = DataCenter.QuestTemplateManager:GetQuestTemplate(self.questId)
  if self.questCfgData == nil then
    return
  end
  self.textTitleDesc:SetLocalText("t11_idle_game_desc_51")
  local taskDescStr = self:GetRequirementDesc()
  self.textTaskDesc:SetText(taskDescStr)
end

function M:OnRecycle()
  self.chatData = nil
  self.eventPlayerUuid = nil
  self.eventUuid = nil
  self.eventId = nil
  self.questId = nil
end

function M:GetRequirementDesc()
  local requirementStr = ""
  if not string.IsNullOrEmpty(self.eventCfgData.quest_para) then
    local strList = string.split(self.eventCfgData.quest_para, ";")
    requirementStr = Localization:GetString(self.questCfgData.desc, table.unpack(strList))
  else
    requirementStr = Localization:GetString(self.questCfgData.desc, "0", self.questCfgData.para2)
  end
  return requirementStr
end

function M:OnBtnRootClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sendMsgTime + 2000 then
    return
  end
  sendMsgTime = curTime
  if not DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn() then
    UIUtil.ShowTipsId("t11_idle_game_desc_83")
    return
  end
  DataCenter.T11IdleGameDataManager:SendIdleGameEventGetMessage(self.eventPlayerUuid, self.eventUuid, Const.IdleGameEventGetType.GetDataAndOpenHelpView)
end

return M
