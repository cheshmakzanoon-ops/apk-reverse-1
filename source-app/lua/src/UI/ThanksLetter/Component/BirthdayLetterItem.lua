local BirthdayLetterItem = BaseClass("BirthdayLetterItem", UIBaseContainer)
local LetterRewardItem = require("UI.ThanksLetter.Component.LetterRewardItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local reward_btn_path = "MiddleContent/LetterContent/RewardContent/RewardBtn"
local line_text1_path = "MiddleContent/LetterContent/Scroll View/Viewport/Content/LineText1"
local line_text2_path = "MiddleContent/LetterContent/Scroll View/Viewport/Content/LineText2"
local letter_close_btn_path = "MiddleContent/LetterCloseBtn"
local title_text_path = "BG/BG_Top/TopArea/TitleText"
local main_title_text_path = "CloseConent/MainTitleText"
local monika_avatar_point_path = "BG/BG_Top/TopArea/Mask/MonikaAvatarPoint"
local content_path = "MiddleContent/LetterContent/Scroll View/Viewport/Content"
local monika_trumpet_btn_path = "BG/BG_Top/TopArea/Image/MonikaTrumpetBtn"
local reward_show_content_path = "MiddleContent/LetterContent/RewardContent/RewardShowContent"
local letter_reward_item_path = "MiddleContent/LetterContent/RewardContent/itemContent/letterRewardItem"
local reward_btn_text_path = "MiddleContent/LetterContent/RewardContent/RewardBtn/RewardBtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAllItem()
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
  self.receiveRewardBtn = self:AddComponent(UIButton, reward_btn_path)
  self.letterTitleText = self:AddComponent(UIText, line_text1_path)
  self.letterContentText = self:AddComponent(UIText, line_text2_path)
  self.closeBtn = self:AddComponent(UIButton, letter_close_btn_path)
  self.mainTitleText = self:AddComponent(UIText, title_text_path)
  self.closeMainTitleText = self:AddComponent(UIText, main_title_text_path)
  self.receiveRewardBtn:SetOnClick(function()
    self:GetReward()
  end)
  self.closeBtn:SetOnClick(function()
    self:ClickCloseBtn()
  end)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.avatarPointObj = self:AddComponent(UIBaseContainer, monika_avatar_point_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.miniMonikaBtn = self:AddComponent(UIButton, monika_trumpet_btn_path)
  self.miniMonikaBtn:SetOnClick(function()
    self:PlayTrumpetSe()
  end)
  self.miniMonikaAni = self:TryAddComponent(UISimpleAnimation, monika_trumpet_btn_path)
  self.letter_reward_item = self:AddComponent(UIBaseContainer, letter_reward_item_path)
  self.reward_show_content = self:AddComponent(UIBaseContainer, reward_show_content_path)
  self.letter_reward_item:SetActive(false)
  self.letter_reward_item.gameObject:GameObjectCreatePool()
  self.itemList = {}
  self.reward_btn_text = self:AddComponent(UITextMeshProUGUIEx, reward_btn_text_path)
end

local function ComponentDestroy(self)
  if self.avatarPrefabReq then
    self.avatarPrefabReq:Destroy()
    self.avatarPrefabReq = nil
  end
  self.letter_reward_item = nil
  self.reward_show_content = nil
  self.reward_btn_text = nil
  self:StopAllTimer()
end

local function DataDefine(self)
  self.bannerAvatarAni = nil
end

local function DataDestroy(self)
  self.bannerAvatarAni = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshWhenDataUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshWhenDataUpdate)
  base.OnRemoveListener(self)
end

function BirthdayLetterItem:SetData(uuid, itemId, letterData, serverData, closeFunc)
  self:StopAllTimer()
  self.uuid = uuid
  self.itemId = itemId
  self.letterData = letterData
  self.serverData = serverData
  self.closeFunc = closeFunc
  local isJap = LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen()
  local typeInfo = letterData.type
  local titleInfo = letterData.title
  local descInfo = letterData.desc
  local bannerInfo = letterData.extra_pic
  self.allKeyWorldList = {}
  if string.find(typeInfo, ";") then
    typeInfo = string.split(typeInfo, ";")
    for _, v in ipairs(typeInfo) do
      table.insert(self.allKeyWorldList, toInt(v))
    end
  end
  if string.find(titleInfo, "|") then
    local tmp = string.split(titleInfo, "|")
    if 2 <= #tmp then
      titleInfo = isJap and tmp[1] or tmp[2]
    end
  end
  if string.find(descInfo, "|") then
    local tmp = string.split(descInfo, "|")
    if 2 <= #tmp then
      descInfo = isJap and tmp[1] or tmp[2]
    end
  end
  if string.find(bannerInfo, "|") then
    local tmp = string.split(bannerInfo, "|")
    if 2 <= #tmp then
      bannerInfo = isJap and tmp[1] or tmp[2]
    end
  end
  self.avatarPrefabReq = self:GameObjectInstantiateAsync(bannerInfo, function(req)
    if req.isError then
      return
    end
    local obj = req.gameObject
    obj.transform:SetParent(self.avatarPointObj.transform)
    obj.transform:Set_localPosition(0, 0, 0)
    obj.transform:Set_localEulerAngles(0, 0, 0)
    obj.transform:Set_localScale(1, 1, 1)
    self.bannerAvatarAni = obj:GetComponent(typeof(CS.SimpleAnimation))
    if self.bannerAvatarAni then
      self.bannerAvatarAni:Play("Idle")
    end
    local rootPoint = obj.transform:Find("root")
    if rootPoint then
      if CommonUtil.IsArabicAutoMirrorOpen() then
        rootPoint:Set_localScale(-1, 1, 1)
      else
        rootPoint:Set_localScale(1, 1, 1)
      end
    end
  end)
  if not string.IsNullOrEmpty(letterData.main_text) then
    self.mainTitleText:SetLocalText(letterData.main_text)
    self.closeMainTitleText:SetLocalText(letterData.main_text)
  end
  self:RefreshItemRewardState()
  self:RefreshLetterContent(titleInfo, descInfo, serverData)
  self.content.rectTransform:Set_anchoredPosition(0, 0, 0)
end

function BirthdayLetterItem:RefreshWhenDataUpdate()
  if not self.uuid then
    return
  end
  local itemData = DataCenter.ItemData:GetItemByUuid(self.uuid)
  if itemData.otherParam then
    self.serverData = rapidjson.decode(itemData.otherParam)
    self:RefreshItemRewardState()
  end
end

function BirthdayLetterItem:RefreshItemRewardState()
  if not self.serverData then
    return
  end
  local isExistReward = self.serverData.state == nil or toInt(self.serverData.state) == 0
  CS.UIGray.SetGray(self.receiveRewardBtn.transform, not isExistReward, isExistReward)
  if isExistReward then
    self.reward_btn_text:SetLocalText("456207")
  else
    self.reward_btn_text:SetLocalText("170003")
  end
  self:RefreshItemCount(isExistReward)
end

function BirthdayLetterItem:RefreshLetterContent(titleStr, contextStr)
  local param = self:GetContentParam()
  self.letterTitleText:SetLocalText(titleStr, table.unpack(param))
  self.letterContentText:SetLocalText(contextStr, table.unpack(param))
end

function BirthdayLetterItem:GetContentParam()
  local ret = {}
  for _, v in ipairs(self.allKeyWorldList) do
    local type = v
    local param = self:GetParam(type)
    if param then
      table.insert(ret, param)
    end
  end
  return ret
end

function BirthdayLetterItem:GetParam(type)
  local ret
  ret = self:GetParamFromClient(type)
  ret = ret or self:GetParamFromServerData(type)
  return ret or ""
end

function BirthdayLetterItem:GetParamFromClient(type)
  if type == LetterClientParamType.PlayerNickName then
    return LuaEntry.Player.name
  elseif type == LetterClientParamType.CreateAccountTime then
    local year, month, day = UITimeManager:GetInstance():TimeStampToServerTime(LuaEntry.Player.regTime)
    return Localization:GetString("letter_newyear_desc_03", year, month, day)
  end
  return false
end

function BirthdayLetterItem:GetParamFromServerData(type)
  if not self.serverData or not self.serverData.param then
    return nil
  end
  local key = string.format("p%s", type)
  if not table.containsKey(self.serverData.param, key) then
    return nil
  end
  return self.serverData.param[key]
end

function BirthdayLetterItem:GetReward()
  SFSNetwork.SendMessage(MsgDefines.PostCardReceiveMessage, self.itemId)
end

function BirthdayLetterItem:ClickCloseBtn()
  if self.timer then
    return
  end
  local ret, time = self:PlayCloseAniAndGetAniTime()
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.closeFunc then
        self.closeFunc()
      end
    end, time)
  end
  self:OnClose()
end

function BirthdayLetterItem:PlayCloseAniAndGetAniTime()
  if not self.simpleAni then
    return
  end
  return self.simpleAni:PlayAnimationReturnTime("Close")
end

function BirthdayLetterItem:isBannerLoadFinish()
  return self.avatarPrefabReq
end

function BirthdayLetterItem:OnPlay()
  if self.simpleAni then
  end
  local ret, time = self.simpleAni:PlayAnimationReturnTime("Open")
  self.openAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.bannerAvatarAni then
      self.simpleAni:Play("Idle")
      self.openAniTimer = nil
    end
  end, time)
  self.bannerAvatarAni:Play("Open")
  if self.miniMonikaAni then
    self.miniMonikaAni:Play("Init")
  end
end

function BirthdayLetterItem:OnClose()
  if self.bannerAvatarAni then
    self.bannerAvatarAni:Play("Close")
  end
  if self.openAniTimer then
    self.openAniTimer:Stop()
  end
end

function BirthdayLetterItem:StopAllTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.openAniTimer then
    self.openAniTimer:Stop()
    self.openAniTimer = nil
  end
  if self.playSeTimer then
    self.playSeTimer:Stop()
    self.playSeTimer = nil
  end
end

function BirthdayLetterItem:PlayTrumpetSe()
  if self.playSeTimer then
    return
  end
  local random = math.random(1, 2)
  local aniName = string.format("Play%s", random)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    aniName = string.format("PlayMirror%s", random)
  end
  local ret, time = self.miniMonikaAni:PlayAnimationReturnTime(aniName)
  if ret then
    self.playSeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.miniMonikaAni:Play("Idle")
      self.playSeTimer = nil
    end, time)
  end
  if random == 1 then
    DataCenter.LWSoundManager:PlayEffect(61142)
  else
    DataCenter.LWSoundManager:PlayEffect(61143)
  end
end

function BirthdayLetterItem:RefreshItemCount(isExistReward)
  local rewardList = {}
  if not string.IsNullOrEmpty(self.letterData.goods) then
    local strData = string.string2array_i(self.letterData.goods, ";", "|")
    for _, v in ipairs(strData) do
      if #v == 3 then
        local rewardData = {
          rewardType = v[1],
          itemId = v[2],
          count = v[3]
        }
        table.insert(rewardList, rewardData)
      end
    end
  end
  for index, v in ipairs(rewardList) do
    if self.itemList[index] == nil then
      local item = self.letter_reward_item.gameObject:GameObjectSpawn(self.reward_show_content.transform)
      item.name = index
      local obj = self.reward_show_content:AddComponent(LetterRewardItem, item.name)
      obj:SetActive(true)
      obj:SetData(v, not isExistReward)
      self.itemList[index] = obj
    else
      self.itemList[index]:SetData(v, not isExistReward)
    end
  end
end

function BirthdayLetterItem:ClearAllItem()
  self.reward_show_content:RemoveComponents(LetterRewardItem)
  for _, v in pairs(self.reward_show_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.letter_reward_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

BirthdayLetterItem.OnCreate = OnCreate
BirthdayLetterItem.OnDestroy = OnDestroy
BirthdayLetterItem.OnEnable = OnEnable
BirthdayLetterItem.OnDisable = OnDisable
BirthdayLetterItem.ComponentDefine = ComponentDefine
BirthdayLetterItem.ComponentDestroy = ComponentDestroy
BirthdayLetterItem.DataDefine = DataDefine
BirthdayLetterItem.DataDestroy = DataDestroy
BirthdayLetterItem.OnAddListener = OnAddListener
BirthdayLetterItem.OnRemoveListener = OnRemoveListener
return BirthdayLetterItem
