local base = require("Scene.AllianceStarCeremony.State.AlStarBaseInnerState")
local State = {}
State.__index = State
setmetatable(State, base)
local Localization = CS.GameEntry.Localization

function State.Create(stateId)
  local copy = {}
  setmetatable(copy, State)
  copy:Init(stateId)
  return copy
end

function State:OnRefresh()
  local panelParam = {}
  panelParam.panelType = AlStarCeremonyPanelType.Thumb
  panelParam.param = {}
  local starTemplate = self.ceremonyInfo:GetTemplateInfo()
  panelParam.param.tipText = Localization:GetString(starTemplate.name)
  panelParam.param.ceremonyInfo = self.ceremonyInfo
  local emojiPanelParam = {}
  emojiPanelParam.panelType = AlStarCeremonyPanelType.EmojiList
  emojiPanelParam.param = {}
  emojiPanelParam.param.configId = self.ceremonyInfo.configId
  local thumbInfo = DataCenter.AllianceStarManager:GetCeremonyStarThumbInfo(self.ceremonyInfo.configId)
  if thumbInfo then
    emojiPanelParam.param.targetUid = thumbInfo.uid
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceStarCeremonyRefreshMainPanel, {panelParam, emojiPanelParam})
  if self.elapsedTime == 0 then
    self.scene:PlayReadPersonRewardAnim()
  end
end

return State
