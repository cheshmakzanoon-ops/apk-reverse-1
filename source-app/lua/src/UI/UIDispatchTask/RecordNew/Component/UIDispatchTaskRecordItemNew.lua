local base = UIBaseContainer
local UIDispatchTaskRecordItemNew = BaseClass("UIDispatchTaskRecordItemNew", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UIDispatchTaskRecordItemNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDispatchTaskRecordItemNew:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskRecordItemNew:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btnPlayer = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPlayer:SetOnClick(function()
    self:OnBtnPlayerClick()
  end)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 3)
  self.textTxtName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtSteal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTxtAssist = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTxtTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textPoint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.scrollRewards = self.viewSkin:AddComponent(self, UIScrollRect, 9)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.imgEmojiBg = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgEmoji = self.viewSkin:AddComponent(self, UIImage, 12)
  self.imgRevenge = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textRevenge = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnThumbsUp = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnThumbsUp:SetOnClick(function()
    self:OnBtnThumbsUpClick()
  end)
  self.imgThumbsUp = self.viewSkin:AddComponent(self, UIImage, 16)
  self.textTxtAssistOther = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textTxtName2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compUIPlayerHead:SetEnableClickShowInfo(true)
end

function UIDispatchTaskRecordItemNew:ComponentDestroy()
  self.viewSkin = nil
  self.imgBgIcon = nil
  self.btnPlayer = nil
  self.compUIPlayerHead = nil
  self.textTxtName = nil
  self.textTxtSteal = nil
  self.textTxtAssist = nil
  self.textTxtTime = nil
  self.textPoint = nil
  self.scrollRewards = nil
  self.content = nil
  self.imgEmojiBg = nil
  self.imgEmoji = nil
  self.imgRevenge = nil
  self.textRevenge = nil
  self.btnThumbsUp = nil
  self.imgThumbsUp = nil
  self.textTxtAssistOther = nil
  self.textTxtName2 = nil
end

function UIDispatchTaskRecordItemNew:DataDefine()
end

function UIDispatchTaskRecordItemNew:DataDestroy()
  self.playerUid = nil
  self.serverId = nil
  self.rewardList = nil
  self.uuid = nil
end

function UIDispatchTaskRecordItemNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTaskGetThumbsUp, self.UpdateLikeBtn)
end

function UIDispatchTaskRecordItemNew:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTaskGetThumbsUp, self.UpdateLikeBtn)
  base.OnRemoveListener(self)
end

function UIDispatchTaskRecordItemNew:OnBtnThumbsUpClick()
  if self.playerUid and self.uuid and self.isLike ~= 1 then
    InteractiveUtil.TryThumbsUp(tostring(self.playerUid), InteractiveUtil.ThumbsUpType.DispatchRecordLike, nil, function()
      if self and self.imgThumbsUp then
        self.imgThumbsUp:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_xinwen_dianzan_anniu.png")
        self.isLike = 1
        DataCenter.ActDispatchTaskDataManager:UpdateRecordList(self.type, self.uuid)
      end
      UIUtil.ShowTipsId("secret_task_like_tips_01")
    end, tostring(self.uuid))
  end
end

function UIDispatchTaskRecordItemNew:UpdateLikeBtn(uuid)
  if self and self.imgThumbsUp and self.uuid == uuid then
    self.isLike = 1
    self.imgThumbsUp:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_xinwen_dianzan_anniu.png")
  end
end

function UIDispatchTaskRecordItemNew:OnBtnPlayerClick()
  if self.playerUid then
    if self.playerUid == LuaEntry.Player:GetUid() then
      return
    end
    local serverId = LuaEntry.Player:GetSourceServerId()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
      serverId = serverId,
      uid = self.playerUid
    })
  end
end

function UIDispatchTaskRecordItemNew:SetItem(logInfo)
  self.playerUid = nil
  self.textPoint:SetActive(false)
  self.serverId = logInfo.serverId or LuaEntry.Player:GetSourceServerId()
  self.type = logInfo.type
  if logInfo == nil then
    return
  end
  local langKey
  local name = logInfo.name
  if not string.IsNullOrEmpty(logInfo.abbr) then
    name = "[" .. logInfo.abbr .. "]" .. name
  end
  local logInfoUid = logInfo.uid
  self.playerUid = logInfoUid
  local fake = false
  if logInfoUid == LuaEntry.Player:GetUid() then
    fake = true
  end
  if fake then
    local fakeKey = DataCenter.ActDispatchTaskDataManager:GetAssistorName()
    if fakeKey then
      name = Localization:GetString(fakeKey)
    end
  end
  local emojiId = 59
  if logInfo.type == DispatchTaskRecordType.Assist then
    langKey = 456212
    self.imgBgIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
    self.textTxtSteal:SetActive(false)
    if logInfo.reward and type(logInfo.reward) == "table" and #logInfo.reward > 0 then
      self.textTxtAssistOther:SetActive(true)
      self.textTxtAssist:SetActive(false)
      self.textTxtAssistOther:SetLocalText("secret_task_assist_01")
      self.btnThumbsUp.gameObject:SetActive(false)
      self.textTxtName2.gameObject:SetActive(false)
      self.textTxtName.gameObject:SetActive(true)
      self.textTxtName:SetText("<color=#249BC5>" .. name .. "</color>")
    else
      self.textTxtName2.gameObject:SetActive(true)
      self.textTxtName.gameObject:SetActive(false)
      self.textTxtName2:SetText("<color=#249BC5>" .. name .. "</color>")
      self.textTxtAssist:SetActive(true)
      self.textTxtAssistOther:SetActive(false)
      self.textTxtAssist:SetLocalText("dispatch_des026")
      self.btnThumbsUp.gameObject:SetActive(true)
      self.isLike = logInfo.isLike
      if self.isLike == 1 then
        self.imgThumbsUp:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_xinwen_dianzan_anniu.png")
      else
        self.imgThumbsUp:LoadSpriteAsync("Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_xitongtongzhi_dianzan.png")
      end
    end
    self.uuid = logInfo.uuid
  else
    self.textTxtName2.gameObject:SetActive(false)
    self.textTxtName.gameObject:SetActive(true)
    self.btnThumbsUp.gameObject:SetActive(false)
    emojiId = logInfo.msgId
    langKey = 456213
    self.textTxtAssist:SetActive(false)
    self.textTxtAssistOther:SetActive(false)
    self.textTxtSteal:SetActive(true)
    if logInfo.type == DispatchTaskRecordType.Stolen then
      self.textTxtName:SetText("<color=#F53C3D>" .. name .. "</color>")
      self.imgBgIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_01")
      self.textTxtSteal:SetLocalText("dispatch_des027")
    else
      self.textTxtName:SetText("<color=#249BC5>" .. name .. "</color>")
      self.imgBgIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
      self.textTxtSteal:SetLocalText("secret_task_steal_01")
    end
  end
  self.textTxtTime:SetText(UITimeManager:GetInstance():TimeStampToMDHSForLocalMinute(logInfo.time))
  self.imgRevenge.gameObject:SetActive(logInfo.mark == 1)
  if fake then
    local fakeIcon = DataCenter.ActDispatchTaskDataManager:GetAssistorHeadIcon()
    if not string.IsNullOrEmpty(fakeIcon) then
      self.compUIPlayerHead:SetData(nil, fakeIcon, nil)
    end
    self.btnThumbsUp.gameObject:SetActive(false)
  else
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(logInfo.headSkinId, logInfo.headSkinET)
    self.compUIPlayerHead:SetData(logInfo.uid, logInfo.headPic, logInfo.headPicVer, nil, headFrame)
  end
  self:ShowReward(logInfo.reward)
  self:ShowEmoji(emojiId)
end

function UIDispatchTaskRecordItemNew:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = nil
end

function UIDispatchTaskRecordItemNew:ShowReward(reward)
  self:SetAllCellDestroy()
  if reward and type(reward) == "table" and 0 < #reward then
    self.scrollRewards:SetActive(true)
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
    if self.rewardList then
      self.model = {}
      for i = 1, table.length(self.rewardList) do
        local index = i
        self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(0.7, 0.7, 0.7)
          local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
          rectTransform:Set_sizeDelta(93, 92)
          rectTransform.pivot = Vector2.New(0.5, 0.5)
          go.name = "item" .. index
          local cell = self.content:AddComponent(UICommonResItem, go.name)
          cell:ReInit(self.rewardList[index])
        end)
      end
    end
  else
    self.scrollRewards:SetActive(false)
  end
end

function UIDispatchTaskRecordItemNew:ShowEmoji(emojiId)
  if emojiId and 0 < emojiId then
    local data = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
    if data then
      local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png"
      self.imgEmoji:LoadSprite(path)
      self.imgEmojiBg:SetActive(true)
      return
    end
  end
  self.imgEmojiBg:SetActive(false)
end

return UIDispatchTaskRecordItemNew
