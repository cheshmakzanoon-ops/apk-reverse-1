local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_PostWorldBossNewRecord = BaseClass("PostWorldBossNewRecord", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")

function ChatItemPost_PostWorldBossNewRecord:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatItemPost_PostWorldBossNewRecord:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_PostWorldBossNewRecord:ComponentDefine()
  self.rawImgBg = self:AddComponent(UIRawImage, "Content")
  self.textDes = self:AddComponent(UIText, "Content/DesText")
  self.btn = self:AddComponent(UIButton, "Content/Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function ChatItemPost_PostWorldBossNewRecord:ComponentDestroy()
  self.rawImgBg = nil
  self.textDes = nil
  self.btn = nil
end

function ChatItemPost_PostWorldBossNewRecord:DataDefine()
end

function ChatItemPost_PostWorldBossNewRecord:DataDestroy()
end

function ChatItemPost_PostWorldBossNewRecord:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemPost_PostWorldBossNewRecord:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemPost_PostWorldBossNewRecord:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self:RefreshView()
end

function ChatItemPost_PostWorldBossNewRecord:RefreshView()
  if self._chatData and self._chatData.attachmentId then
    local attachJson = rapidjson.decode(self._chatData.attachmentId)
    if attachJson then
      self.textDes:SetLocalText("world_boss_today_damage_limit_30", tostring(attachJson.damageNum))
    end
  end
end

function ChatItemPost_PostWorldBossNewRecord:OnBtnClick()
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.WorldBoss.Type)
  if activityData then
    local id = activityData.id
    GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, id)
  else
    UIUtil.ShowTips(Localization:GetString("458822"))
  end
end

return ChatItemPost_PostWorldBossNewRecord
