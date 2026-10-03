local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_GhostReconRemindLeader = BaseClass("ChatItemPost_GhostReconRemindLeader", IChatItemPost)
local Localization = CS.GameEntry.Localization
local base = IChatItemPost
local UIGray = CS.UIGray
local rapidjson = require("rapidjson")

function ChatItemPost_GhostReconRemindLeader:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "Bg")
  self.buildBg = self:AddComponent(UIRawImage, "Bg/BuildBg")
  self.buildImg = self:AddComponent(UIRawImage, "Bg/BuildBg/BuildIcon")
  self.lvText = self:AddComponent(UIText, "Bg/BuildBg/LvText")
  self.qualityImg = self:AddComponent(UIImage, "Bg/QualityImg")
  self.tipText = self:AddComponent(UIText, "Bg/TipText")
  self.gotoBtn = self:AddComponent(UIButton, "Bg/GotoBtn")
  self.gotoBtnText = self:AddComponent(UIText, "Bg/GotoBtn/GotoBtnText")
  self.gotoBtnText:SetLocalText("110003")
  self.gotoBtn:SetOnClick(Bind(self, self.OnGotoBtnClick))
end

function ChatItemPost_GhostReconRemindLeader:OnGotoBtnClick()
  if self.customJsonParam and self.customJsonParam.pointId and self.customJsonParam.targetServer and self.customJsonParam.uuid then
    DataCenter.ActGhostreconManager:JumpToPoint(self.customJsonParam.pointId, self.customJsonParam.uuid, self.customJsonParam.targetServer)
  end
end

function ChatItemPost_GhostReconRemindLeader:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_GhostReconRemindLeader:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  if chatData.post ~= PostType.GHOST_RECON_REMIND_LEADER then
    Logger.LogError("chatUpdateItem error ----------- > roomId : " .. self._chatData.roomId .. "seqId : " .. chatData.seqId)
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self.customJsonParam = rapidjson.decode(self._chatData.extra.customJsonParam)
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.customJsonParam.cfgId)
  self.bg:LoadSprite(cfg.imgSet.RemindBg)
  self.buildBg:LoadSprite(UIAssets.GhostreconTexturePath .. cfg.imgSet.ChatBuildBg)
  self.qualityImg:LoadSprite(cfg.imgSet.QualityImg)
  self.buildImg:LoadSprite(UIAssets.GhostreconTexturePath .. cfg.imgSet.BuildImg)
  self.tipText:SetLocalText(self.customJsonParam.dialogId)
  self.lvText:SetText("Lv." .. cfg.level)
end

function ChatItemPost_GhostReconRemindLeader:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_GhostReconRemindLeader:ComponentDestroy()
  self.bg = nil
  self.buildBg = nil
  self.buildImg = nil
  self.tipText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
end

function ChatItemPost_GhostReconRemindLeader:DataDestroy()
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.customJsonParam = nil
end

function ChatItemPost_GhostReconRemindLeader:OnRecycle()
end

function ChatItemPost_GhostReconRemindLeader:HandleClick()
  return true
end

return ChatItemPost_GhostReconRemindLeader
