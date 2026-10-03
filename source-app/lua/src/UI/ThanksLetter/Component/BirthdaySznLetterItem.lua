local BirthdaySznLetterItem = BaseClass("BirthdaySznLetterItem", UIBaseContainer)
local LetterRewardItem = require("UI.ThanksLetter.Component.LetterRewardItem")
local BirthdayNumContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayNumContent")
local BirthdayYearNumContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayYearNumContent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local reward_btn_path = "MiddleContent/LetterContent/RewardContent/RewardBtn"
local line_text1_path = "MiddleContent/LetterContent/Scroll View/Viewport/Content/LineText1"
local line_text2_path = "MiddleContent/LetterContent/Scroll View/Viewport/Content/LineText2"
local letter_close_btn_path = "MiddleContent/LetterCloseBtn"
local content_path = "MiddleContent/LetterContent/Scroll View/Viewport/Content"
local reward_show_content_path = "MiddleContent/LetterContent/RewardContent/RewardShowContent"
local letter_reward_item_path = "MiddleContent/LetterContent/RewardContent/itemContent/letterRewardItem"
local reward_btn_text_path = "MiddleContent/LetterContent/RewardContent/RewardBtn/RewardBtnText"
local birthday_num_content_path = "BG/BG_Center/Cake/BirthdayNumContent"
local birthday_num_content2_path = "CloseConent/UnOpenImg/caidaiImg/BirthdayNumContent2"
local front_left_path = "BG/BG_Center/front_left"
local spinee_birthday_card_left_path = "BG/BG_Center/front_left/SpineeBirthdayCardLeft"
local front_right_path = "BG/BG_Center/front_right"
local spinee_birthday_card_right_path = "BG/BG_Center/front_right/SpineeBirthdayCardRight"
local year_text_path = "BG/BG_Center/banner/YearText"
local birthday_year_num_content_path = "CloseConent/UnOpenImg/BirthdayYearNumContent"
local letter_txt_arrow_path = "MiddleContent/LetterContent/Scroll View/letterTxtArrow"
local scroll_view_path = "MiddleContent/LetterContent/Scroll View"

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
  self.receiveRewardBtn:SetOnClick(function()
    self:GetReward()
  end)
  self.closeBtn:SetOnClick(function()
    self:ClickCloseBtn()
  end)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.letter_reward_item = self:AddComponent(UIBaseContainer, letter_reward_item_path)
  self.reward_show_content = self:AddComponent(UIBaseContainer, reward_show_content_path)
  self.letter_reward_item:SetActive(false)
  self.letter_reward_item.gameObject:GameObjectCreatePool()
  self.itemList = {}
  self.reward_btn_text = self:AddComponent(UITextMeshProUGUIEx, reward_btn_text_path)
  self.birthday_num_content = self:AddComponent(BirthdayNumContent, birthday_num_content_path)
  self.birthday_num_content2 = self:AddComponent(BirthdayNumContent, birthday_num_content2_path)
  self.front_left = self:AddComponent(UIButton, front_left_path)
  self.spinee_birthday_card_left = self:AddComponent(UIBaseContainer, spinee_birthday_card_left_path)
  self.front_right = self:AddComponent(UIButton, front_right_path)
  self.spinee_birthday_card_right = self:AddComponent(UIBaseContainer, spinee_birthday_card_right_path)
  self.front_left:SetSafeClickMode(true)
  self.front_right:SetSafeClickMode(true)
  self.front_left:SetSafeClickModeTime(1.5)
  self.front_right:SetSafeClickModeTime(1.5)
  self.front_left:SetOnClick(function()
    self:OnLeftClick()
  end)
  self.front_right:SetOnClick(function()
    self:OnRightClick()
  end)
  self.year_text = self:AddComponent(UITextMeshProUGUIEx, year_text_path)
  self.birthday_year_num_content = self:AddComponent(BirthdayYearNumContent, birthday_year_num_content_path)
  self.letter_txt_arrow = self:AddComponent(UIImage, letter_txt_arrow_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_view:AddValueChangeListener(function()
    self:RefreshTxtArrow()
  end)
end

local function ComponentDestroy(self)
  if self.avatarPrefabReq then
    self.avatarPrefabReq:Destroy()
    self.avatarPrefabReq = nil
  end
  self.scroll_view:RemoveAllListeners()
  self.letter_reward_item = nil
  self.reward_show_content = nil
  self.reward_btn_text = nil
  self.birthday_num_content = nil
  self.front_left = nil
  self.spinee_birthday_card_left = nil
  self.front_right = nil
  self.spinee_birthday_card_right = nil
  self.birthday_num_content2 = nil
  self.year_text = nil
  self.birthday_year_num_content = nil
  self.letter_txt_arrow = nil
  self.scroll_view = nil
  self:StopAllTimer()
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshWhenDataUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshWhenDataUpdate)
  base.OnRemoveListener(self)
end

function BirthdaySznLetterItem:SetData(uuid, itemId, letterData, serverData, closeFunc)
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
  self:RefreshItemRewardState()
  self:RefreshLetterContent(titleInfo, descInfo, serverData)
  self.content.rectTransform:Set_anchoredPosition(0, 0, 0)
  local birthdayStr = serverData.birthday
  if not string.IsNullOrEmpty(birthdayStr) then
    local numArr = string.string2array_i_oneSep(birthdayStr, "-")
    if #numArr == 2 then
      self.birthday_num_content:SetActive(true)
      self.birthday_num_content2:SetActive(true)
      local sznType = DataCenter.BirthdayDataManager:GetSznTypeByMonth(numArr[1])
      self.birthday_num_content:SetData(numArr[1], numArr[2], sznType)
      self.birthday_num_content2:SetData(numArr[1], numArr[2], sznType)
      self.birthday_year_num_content:SetData(serverData.receiveYear, sznType)
      self.year_text:SetText(serverData.receiveYear and serverData.receiveYear or "")
    else
      self.birthday_num_content:SetActive(false)
      self.birthday_num_content2:SetActive(false)
    end
  else
    self.birthday_num_content:SetActive(false)
    self.birthday_num_content2:SetActive(false)
  end
  self:RefreshTxtArrow()
  self.simpleAni:SampleAnimationAtTime("Open", 0)
end

function BirthdaySznLetterItem:RefreshWhenDataUpdate()
  if not self.uuid then
    return
  end
  local itemData = DataCenter.ItemData:GetItemByUuid(self.uuid)
  if itemData.otherParam then
    self.serverData = rapidjson.decode(itemData.otherParam)
    self:RefreshItemRewardState()
  end
end

function BirthdaySznLetterItem:RefreshTxtArrow()
  local minChangeNum = 1.0E-4
  local forcePass = false
  if self.changeVNormalizedPosition == nil then
    self.changeVNormalizedPosition = 0
    forcePass = true
  end
  local vNormalizedPosition = self.scroll_view:GetVerticalNormalizedPosition()
  if minChangeNum > math.abs(vNormalizedPosition - self.changeVNormalizedPosition) and not forcePass then
    return
  end
  self.changeVNormalizedPosition = vNormalizedPosition
  self.letter_txt_arrow:SetActive(0.05 < vNormalizedPosition)
end

function BirthdaySznLetterItem:RefreshItemRewardState()
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

function BirthdaySznLetterItem:RefreshLetterContent(titleStr, contextStr)
  local param = self:GetContentParam()
  self.letterTitleText:SetLocalText(titleStr, table.unpack(param))
  self.letterContentText:SetLocalText(contextStr, table.unpack(param))
end

function BirthdaySznLetterItem:GetContentParam()
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

function BirthdaySznLetterItem:GetParam(type)
  local ret
  ret = self:GetParamFromClient(type)
  ret = ret or self:GetParamFromServerData(type)
  return ret or ""
end

function BirthdaySznLetterItem:GetParamFromClient(type)
  if type == LetterClientParamType.PlayerNickName then
    return LuaEntry.Player.name
  elseif type == LetterClientParamType.CreateAccountTime then
    local year, month, day = UITimeManager:GetInstance():TimeStampToServerTime(LuaEntry.Player.regTime)
    return Localization:GetString("letter_newyear_desc_03", year, month, day)
  end
  return false
end

function BirthdaySznLetterItem:GetParamFromServerData(type)
  if not self.serverData or not self.serverData.param then
    return nil
  end
  local key = string.format("p%s", type)
  if not table.containsKey(self.serverData.param, key) then
    return nil
  end
  return self.serverData.param[key]
end

function BirthdaySznLetterItem:GetReward()
  SFSNetwork.SendMessage(MsgDefines.PostCardReceiveMessage, self.itemId)
end

function BirthdaySznLetterItem:ClickCloseBtn()
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

function BirthdaySznLetterItem:PlayCloseAniAndGetAniTime()
  if not self.simpleAni then
    return
  end
  return self.simpleAni:PlayAnimationReturnTime("Close")
end

function BirthdaySznLetterItem:isBannerLoadFinish()
  return true
end

function BirthdaySznLetterItem:OnPlay()
  if self.simpleAni then
  end
  local ret, time = self.simpleAni:PlayAnimationReturnTime("Open")
  self.openAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.simpleAni:Play("Idle")
  end, time)
end

function BirthdaySznLetterItem:OnClose()
  if self.openAniTimer then
    self.openAniTimer:Stop()
  end
end

function BirthdaySznLetterItem:StopAllTimer()
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

function BirthdaySznLetterItem:RefreshItemCount(isExistReward)
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

function BirthdaySznLetterItem:ClearAllItem()
  self.reward_show_content:RemoveComponents(LetterRewardItem)
  for _, v in pairs(self.reward_show_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.letter_reward_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

function BirthdaySznLetterItem:OnLeftClick()
  self.spinee_birthday_card_left:SetActive(false)
  self.spinee_birthday_card_left:SetActive(true)
end

function BirthdaySznLetterItem:OnRightClick()
  self.spinee_birthday_card_right:SetActive(false)
  self.spinee_birthday_card_right:SetActive(true)
end

BirthdaySznLetterItem.OnCreate = OnCreate
BirthdaySznLetterItem.OnDestroy = OnDestroy
BirthdaySznLetterItem.OnEnable = OnEnable
BirthdaySznLetterItem.OnDisable = OnDisable
BirthdaySznLetterItem.ComponentDefine = ComponentDefine
BirthdaySznLetterItem.ComponentDestroy = ComponentDestroy
BirthdaySznLetterItem.DataDefine = DataDefine
BirthdaySznLetterItem.DataDestroy = DataDestroy
BirthdaySznLetterItem.OnAddListener = OnAddListener
BirthdaySznLetterItem.OnRemoveListener = OnRemoveListener
return BirthdaySznLetterItem
