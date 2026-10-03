local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local UILWChatZREliteBossAttackMsg = BaseClass("UILWChatZREliteBossAttackMsg", base)
local rapidjson = require("rapidjson")
local ui_player_head_path = "Content/UIPlayerHead"
local player_name_text_path = "Content/PlayerNameText"
local des_text_path = "Content/DesText"
local btn_path = "Content/Btn"
local pic_path = "Content/Pic"
local content_path = "Content"

function UILWChatZREliteBossAttackMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWChatZREliteBossAttackMsg:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWChatZREliteBossAttackMsg:ComponentDefine()
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.BtnClick))
  self.pic = self:AddComponent(UIImage, pic_path)
  self._headCanvasGroup = self:AddComponent(UICanvasGroup, ui_player_head_path)
  self._headCanvasGroup:SetAlpha(ChatUIThemeConfig.HeadAlpha[ChatInterface.GetChatTheme()])
  self.content = self:AddComponent(UIImage, content_path)
  self.content:SetColor(ChatUIThemeConfig.ZREliteBossAtkMsgThemeColor[ChatInterface.GetChatTheme()])
  self.pic:SetColor(ChatUIThemeConfig.ZREliteBossAtkMsgThemeColor[ChatInterface.GetChatTheme()])
end

function UILWChatZREliteBossAttackMsg:ComponentDestroy()
  self.ui_player_head = nil
  self.player_name_text = nil
  self.des_text = nil
  self.btn = nil
  self.pic = nil
  self._headCanvasGroup = nil
end

function UILWChatZREliteBossAttackMsg:DataDefine()
  self.uid = nil
  self.point = nil
  self.bUuid = nil
end

function UILWChatZREliteBossAttackMsg:DataDestroy()
  self.uid = nil
  self.point = nil
  self.bUuid = nil
end

function UILWChatZREliteBossAttackMsg:UpdateItem(_chat_data, _index)
  self._chatData = _chat_data
  self.des_text:SetLocalText("radar_tips_7")
  if _chat_data and _chat_data.extra and _chat_data.extra.customJsonParam then
    local jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
    if jsonObj then
      if jsonObj.targetInfo then
        local targetInfo = jsonObj.targetInfo
        local uid = targetInfo.uid
        self.uid = uid
        local playerName = targetInfo.name
        local pic = ""
        local picVer = 0
        local headSkinId, headSkinET
        if targetInfo.headPic then
          pic = targetInfo.headPic
        end
        if targetInfo.headPicVer then
          picVer = targetInfo.headPicVer
        end
        if targetInfo.headSkinId then
          headSkinId = targetInfo.headSkinId
        end
        if targetInfo.headSkinET then
          headSkinET = targetInfo.headSkinET
        end
        local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, playerName)
        self.player_name_text:SetText(showName)
        self.ui_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
        self.ui_player_head:SetEnableClickShowInfo(true, true)
      end
      if jsonObj.monsterId then
        local line = LocalController:instance():getLine(TableName.Monster, jsonObj.monsterId)
        if line then
          local name = CS.GameEntry.Localization:GetString(line.name)
          self.des_text:SetLocalText("zombierush_eliteBoss_alter_appear", name)
          local pic = line.pic_name
          if not string.IsNullOrEmpty(pic) then
            self.pic:LoadSpriteAuto(UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, pic))
          end
        end
      end
      self.point = jsonObj.pointId or 0
      self.bUuid = jsonObj.bUuid or 0
    end
  end
end

function UILWChatZREliteBossAttackMsg:BtnClick()
  if LuaEntry.Player:IsInSourceServer() then
    if self.point and self.point > 0 then
      local point = self.point
      local bUuid = self.bUuid
      local uid = self.uid
      GoToUtil.CloseAllWindows()
      local pos = SceneUtils.TileIndexToWorld(point)
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
        self:OpenMarchPanel(point, bUuid, uid)
      end, LuaEntry.Player:GetSourceServerId())
    else
      Logger.LogError("the point is invalid")
    end
  else
    UIUtil.ShowTipsId("activity_clock_go_err_01")
  end
end

local function OpenMarchPanel(self, point, bUuid, uid)
  if point and bUuid and uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, bUuid, uid, point, AssistanceType.MainCity)
  end
end

UILWChatZREliteBossAttackMsg.OpenMarchPanel = OpenMarchPanel
return UILWChatZREliteBossAttackMsg
