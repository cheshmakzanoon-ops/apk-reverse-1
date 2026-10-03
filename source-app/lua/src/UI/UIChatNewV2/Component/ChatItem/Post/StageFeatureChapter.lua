local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_StageFeatureChapter = BaseClass("ChatItemPost_StageFeatureChapter", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local shareBtn = ""
local share_msg_path = "Texts/ShareMsg"
local share_Title_path = "Texts/TitleMsg"

function ChatItemPost_StageFeatureChapter:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_StageFeatureChapter:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.texts = self:AddComponent(UIBaseContainer, "Texts")
  self.btn = self:AddComponent(UIButton, shareBtn)
  self.share_msg = self:AddComponent(UITextMeshProUGUIEx, share_msg_path)
  self.share_title = self:AddComponent(UITextMeshProUGUIEx, share_Title_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function ChatItemPost_StageFeatureChapter:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self._chatData = chatData
  if self._chatData and self._chatData.attachmentIdJsonObj then
    local extraInfo = self._chatData.attachmentIdJsonObj
    if extraInfo.fromChapter then
      local stageName = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), extraInfo.stageId, "name"), extraInfo.stageOrder or 0)
      self.share_msg:SetLocalText("breakthough_tips_04", stageName, extraInfo.score or 0, extraInfo.rank or "")
      self.share_title:SetText(stageName)
    elseif extraInfo.fromActFrontBreakSunday then
      local serRankNew = extraInfo.ActFrontBreakSerRankNew or 0
      local serRankOld = extraInfo.ActFrontBreakSerRankOld or 0
      local alRankNew = extraInfo.ActFrontBreakAlRankNew or 0
      local alRankOld = extraInfo.ActFrontBreakAlRankOld or 0
      local topRankNew = extraInfo.ActFrontBreakTopRankNew or 0
      local topRankOld = extraInfo.ActFrontBreakTopRankOld or 0
      local totalLeft = extraInfo.totalLeft or 0
      if 0 < topRankNew and (topRankOld == 0 or topRankNew < topRankOld) then
        self.share_msg:SetLocalText("activity_breakthrough_tips_44", topRankNew)
      elseif 0 < serRankNew and serRankNew < serRankOld then
        self.share_msg:SetLocalText("activity_breakthrough_tips_31", serRankNew)
      elseif 0 < alRankNew and alRankNew < alRankOld then
        local allianceAbbr = LuaEntry.Player:GetAllianceAbbr()
        self.share_msg:SetLocalText("activity_breakthrough_tips_32", allianceAbbr, alRankNew)
      else
        local stageId = extraInfo.stageId or 0
        local actId = extraInfo.frontBreakSundayActId or 0
        local win = extraInfo.win or false
        local index = DataCenter.ActFrontBreakSundayDataManager:GetActData(actId):GetStageIndex(stageId) or 0
        index = win and index or math.max(index - 1, 0)
        self.share_msg:SetLocalText("activity_breakthrough_tips_33", index, totalLeft)
      end
      self.share_title:SetLocalText("activity_breakthrough_tips_1")
    else
      self.share_msg:SetText("")
      self.share_title:SetText("")
    end
  end
  self:SetRootHeight()
end

function ChatItemPost_StageFeatureChapter:OnBtnClick()
  local isMe = self._chatData:isMyChat()
  if isMe then
    return
  end
  if self._chatData and self._chatData.attachmentIdJsonObj then
    local extraInfo = self._chatData.attachmentIdJsonObj
    if extraInfo.fromChapter then
      GoToUtil:GoToCountBattleMap(true)
    elseif extraInfo.fromActFrontBreakSunday then
      local player = LuaEntry.Player
      if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
        UIUtil.ShowTips(Localization:GetString("activity_breakthrough_tips_36"))
      else
        local actData = DataCenter.ActivityListDataManager:GetActivityDataById(extraInfo.frontBreakSundayActId)
        local now = UITimeManager:GetInstance():GetServerTime()
        local actIsOpen = actData and now < actData.endTime or false
        if actIsOpen then
          GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, extraInfo.frontBreakSundayActId)
        else
          UIUtil.ShowTips(Localization:GetString("458822"))
        end
      end
    end
  end
end

function ChatItemPost_StageFeatureChapter:SetRootHeight()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.texts.transform)
  local txtContX, txtContY = self.texts:GetSizeDeltaXY()
  local itemHeight = txtContY + 25
  itemHeight = math.max(itemHeight, 193)
  self.root:SetSizeDeltaY(itemHeight)
end

return ChatItemPost_StageFeatureChapter
