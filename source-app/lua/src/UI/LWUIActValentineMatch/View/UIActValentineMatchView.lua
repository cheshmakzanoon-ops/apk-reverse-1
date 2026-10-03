local UIActValentineMatchView = BaseClass("UIActValentineMatchView", UIBaseView)
local UIActValentineMatchEmojiItem = require("UI.LWUIActValentineMatch.Component.UIActValentineMatchEmojiItem")
local UIActValentineMatchHeadItem = require("UI.LWUIActValentineMatch.Component.UIActValentineMatchHeadItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MaxTitleTextLength = 672
local delta = 200
local TitleFontMax = 82
local TitleFontMin = 18
local emojiNodePath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineMatchEmojiItem.prefab"

function UIActValentineMatchView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.activityId = param.activityId
  self.needRequest = param.needRequest
  self:InitView()
  self:PlayInAnimation()
end

function UIActValentineMatchView:OnDestroy()
  DataCenter.ValentineDataManager:ClearNewMutualFollow(self.activityId)
  self:ClearEmoji()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineMatchView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgTitle = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compHeadNode = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compOperationNode = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnEmoji = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnEmoji:SetOnClick(function()
    self:OnBtnEmojiClick()
  end)
  self.btnSendGift = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnSendGift:SetOnClick(function()
    self:OnBtnSendGiftClick()
  end)
  self.btnChat = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnChat:SetOnClick(function()
    self:OnBtnChatClick()
  end)
  self.compEmojiBubbleNode = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compEmojiNode = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.compSkipClick = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.textLeftNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textNextBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnSkip = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.imgSkipBtnSelect = self.viewSkin:AddComponent(self, UIImage, 16)
  self.btnEmojiClose = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnEmojiClose:SetOnClick(function()
    self:OnBtnEmojiCloseClick()
  end)
  self.animation = self.viewSkin:AddComponent(self, UISimpleAnimation, 18)
  self.headNode1 = self.viewSkin:AddComponent(self, UIActValentineMatchHeadItem, 19)
  self.headNode2 = self.viewSkin:AddComponent(self, UIActValentineMatchHeadItem, 20)
  self.skipClickText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.btnEmojiClose:SetAsFirstSibling()
  local eff_m_glow_path = "Root/Eff_m_glow"
  self.eff_m_glow = self.transform:Find(eff_m_glow_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  local eff_up_glow_path = "Root/Eff_up_glow"
  self.eff_up_glow = self.transform:Find(eff_up_glow_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  local eff_bg_glow_path = "Root/Eff_bg_glow"
  self.eff_bg_glow = self.transform:Find(eff_bg_glow_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
end

function UIActValentineMatchView:ComponentDestroy()
  self.viewSkin = nil
  self.imgTitle = nil
  self.textTitle = nil
  self.textDesc = nil
  self.compHeadNode = nil
  self.compOperationNode = nil
  self.btnEmoji = nil
  self.btnSendGift = nil
  self.btnChat = nil
  self.compEmojiBubbleNode = nil
  self.compEmojiNode = nil
  self.btnNext = nil
  self.compSkipClick = nil
  self.textLeftNum = nil
  self.textNextBtn = nil
  self.btnSkip = nil
  self.imgSkipBtnSelect = nil
  self.btnEmojiClose = nil
  self.animation = nil
  self.headNode1 = nil
  self.headNode2 = nil
  self.skipClickText = nil
end

function UIActValentineMatchView:DataDefine()
  self.activityId = nil
  self.curPlayerInfo = nil
  self.isSkip = false
  self.emojiNodeList = {}
end

function UIActValentineMatchView:DataDestroy()
  self.activityId = nil
  self.curPlayerInfo = nil
  self.isSkip = nil
  self.emojiNodeList = nil
end

function UIActValentineMatchView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineOnRecMatchList, self.OnRecMatchList)
end

function UIActValentineMatchView:OnRemoveListener()
  self:RemoveUIListener(EventId.ValentineOnRecMatchList, self.OnRecMatchList)
  base.OnRemoveListener(self)
end

function UIActValentineMatchView:OnEnable()
  base.OnEnable(self)
  self.eff_m_glow:Simulate(1, true, true)
  self.eff_up_glow:Simulate(1, true, true)
  self.eff_bg_glow:Simulate(1, true, true)
end

function UIActValentineMatchView:OnBtnEmojiClick()
  self.compEmojiBubbleNode:SetActive(true)
end

function UIActValentineMatchView:OnBtnEmojiCloseClick()
  self.compEmojiBubbleNode:SetActive(false)
end

function UIActValentineMatchView:OnBtnSendGiftClick()
  if not (self.curPlayerInfo and self.curPlayerInfo.uid) or not self.curPlayerInfo.server then
    return
  end
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = self.curPlayerInfo.uid,
    targetServerId = self.curPlayerInfo.server
  })
end

function UIActValentineMatchView:OnBtnChatClick()
  if not self.curPlayerInfo then
    return
  end
  local userInfo = {}
  userInfo.uid = self.curPlayerInfo.uid
  userInfo.userName = self.curPlayerInfo.name
  GoToUtil.OpenChatView(false, {anim = false}, {privateUserInfo = userInfo})
end

function UIActValentineMatchView:OnBtnNextClick()
  local showNext = self.ctrl:IfShowNext(self.activityId)
  if not showNext then
    self.ctrl:RequestMarchDone(self.activityId)
    self:PlayOutAnimation()
    self.ctrl:CloseSelf()
  elseif self.isSkip then
    self.ctrl:RequestMatchAllDone(self.activityId)
    self:PlayOutAnimation()
    self.ctrl:CloseSelf()
  else
    self.ctrl:RequestMarchDone(self.activityId)
    self.ctrl:MoveToNext()
    self:UpdateCurMatch()
    self:RefreshViewByCurMatch()
    self:PlayInAnimation()
  end
end

function UIActValentineMatchView:OnBtnSkipClick()
  self.isSkip = not self.isSkip
  self.imgSkipBtnSelect:SetActive(self.isSkip)
end

function UIActValentineMatchView:InitView()
  if not self.activityId then
    Logger.LogError("\230\131\133\228\186\186\232\138\130March\230\180\187\229\138\168\231\149\140\233\157\162\239\188\140activityId\228\184\186\231\169\186\239\188\129")
    return
  end
  self.textDesc:SetLocalText("Valentine_send_bp_desc_06")
  self.skipClickText:SetLocalText("Valentine_send_bp_desc_11")
  self:AdjustTitleWidth()
  if self.needRequest then
    self.ctrl:RequestMarchList(self.activityId)
  end
  self:InitSkip()
  self.compEmojiBubbleNode:SetActive(false)
  self:InitEmojiBubble()
end

function UIActValentineMatchView:AdjustTitleWidth()
  self.textTitle:SetLocalText("Valentine_send_bp_title_05")
  local titleTextWidth = self.textTitle:GetWidth()
  if titleTextWidth > MaxTitleTextLength then
    self.textTitle:SetSizeDeltaX(MaxTitleTextLength - 8)
    self.imgTitle:SetSizeDeltaX(MaxTitleTextLength)
    self.textTitle:SetBestFitEnable(true)
    self.textTitle:SetFontSizeMin(TitleFontMin)
    self.textTitle:SetFontSizeMax(TitleFontMax)
  else
    local imageWidth = titleTextWidth + delta
    self.imgTitle:SetSizeDeltaX(imageWidth)
    self.textTitle:SetSizeDeltaX(titleTextWidth)
  end
end

function UIActValentineMatchView:InitSkip()
  self.isSkip = false
  self.imgSkipBtnSelect:SetActive(self.isSkip)
end

function UIActValentineMatchView:ClearEmoji()
  self.compEmojiNode:RemoveComponents(UIActValentineMatchEmojiItem)
  if self.emojiNodeList then
    for _, req in ipairs(self.emojiNodeList) do
      self:GameObjectDestroy(req)
    end
  end
  self.emojiNodeList = {}
end

function UIActValentineMatchView:InitEmojiBubble()
  self:ClearEmoji()
  local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  local emojiList = temp and temp.emojiList or {}
  if not emojiList or #emojiList == 0 then
    Logger.LogError("\230\131\133\228\186\186\232\138\130\230\180\187\229\138\168\232\161\168\230\131\133\229\136\151\232\161\168\228\184\186\231\169\186")
    return
  end
  for i, emojiId in ipairs(emojiList) do
    local req = self:GameObjectInstantiateAsync(emojiNodePath, function(req)
      if req == nil then
        return
      end
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      NameCount = NameCount + 1
      local nodeName = "valentine_match_emoji" .. NameCount
      obj.name = nodeName
      obj:SetActive(true)
      obj.transform:SetParent(self.compEmojiNode.transform)
      obj.transform:Set_localScale(1, 1, 1)
      obj.transform:Set_pivot(0.5, 0.5)
      local cell = self.compEmojiNode:AddComponent(UIActValentineMatchEmojiItem, nodeName)
      local param = {}
      param.emojiId = emojiId
      
      function param.onClick()
        self:ClickEmoji(emojiId)
      end
      
      cell:ReInit(param)
    end)
    table.insert(self.emojiNodeList, req)
  end
end

function UIActValentineMatchView:OnRecMatchList()
  if not self.activityId then
    Logger.LogError("activityId is nil")
    return
  end
  self:UpdateCurMatch()
  self:RefreshViewByCurMatch()
end

function UIActValentineMatchView:UpdateCurMatch()
  self.curPlayerInfo = self.ctrl:GetMatch(self.activityId)
  if not self.curPlayerInfo then
    Logger.LogError("curPlayerInfo is nil")
  end
end

function UIActValentineMatchView:RefreshViewByCurMatch()
  self:RefreshHead()
  self:RefreshNext()
  self:RefreshLeftNum()
  self:RefreshSkipArea()
end

function UIActValentineMatchView:RefreshHead()
  local selfInfo = {}
  selfInfo.uid = LuaEntry.Player:GetUid()
  selfInfo.pic = LuaEntry.Player:GetPic()
  selfInfo.picVer = LuaEntry.Player:GetPicVer()
  self.headNode1:SetData(selfInfo)
  self.headNode2:SetData(self.curPlayerInfo)
end

function UIActValentineMatchView:RefreshLeftNum()
  local showLeft, curIndex, totalNum = self.ctrl:IfShowLeftNum(self.activityId)
  if showLeft then
    local leftNumText = Localization:GetString("150033", curIndex, totalNum)
    self.textLeftNum:SetText(leftNumText)
    self.textLeftNum:SetActive(true)
  else
    self.textLeftNum:SetActive(false)
  end
end

function UIActValentineMatchView:RefreshNext()
  local showNext = self.ctrl:IfShowNext(self.activityId)
  if showNext then
    self.textNextBtn:SetLocalText("Valentine_send_bp_btn_07")
  else
    self.textNextBtn:SetLocalText("Valentine_send_bp_btn_08")
  end
end

function UIActValentineMatchView:RefreshSkipArea()
  local showSkip = self.ctrl:IfShowSkip(self.activityId)
  self.compSkipClick:SetActive(showSkip)
end

function UIActValentineMatchView:ClickEmoji(emojiId)
  self.ctrl:SendEmojiChatMsg(emojiId, self.activityId)
end

function UIActValentineMatchView:PlayInAnimation()
  self.animation:Play("moveIn")
  self.animation:PlayQueued("idle")
  self.eff_m_glow:Play()
  self.eff_up_glow:Play()
  self.eff_bg_glow:Play()
end

function UIActValentineMatchView:PlayOutAnimation()
  self.animation:Play("moveOut")
end

return UIActValentineMatchView
