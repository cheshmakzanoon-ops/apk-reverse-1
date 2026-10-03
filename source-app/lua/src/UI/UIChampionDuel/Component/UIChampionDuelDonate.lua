local UIChampionDuelDonate = BaseClass("UIChampionDuelDonate", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelDonateTime = require("UI.UIChampionDuel.Component.UIChampionDuelDonateTime")
local UIChampionDuelDonateMsgItem = require("UI.UIChampionDuel.Component.UIChampionDuelDonateMsgItem")
local boxNum = 5
local Localization = CS.GameEntry.Localization
local UIChampionDuelDonateRewardTipView = require("UI.UIChampionDuel.UIChampionDuelDonateRewardTip.View.UIChampionDuelDonateRewardTipView")
local time_path = "topContent/Time"
local boxIconName = {
  [1] = {
    open = "cfm_renwu_baoxiang_kai_1",
    close = "lrb_guanjunduijue_baoxiangguan01"
  },
  [2] = {
    open = "cfm_renwu_baoxiang_kai_2",
    close = "lrb_guanjunduijue_baoxiangguan02"
  },
  [3] = {
    open = "cfm_renwu_baoxiang_kai_3",
    close = "lrb_guanjunduijue_baoxiangguan03"
  },
  [4] = {
    open = "cfm_renwu_baoxiang_kai_4",
    close = "lrb_guanjunduijue_baoxiangguan04"
  },
  [5] = {
    open = "cfm_renwu_baoxiang_kai_5",
    close = "lrb_guanjunduijue_baoxiangguan05"
  }
}
local message_content_path = "bottomContent/messageContent"
local msg_list_path = "bottomContent/messageContent/msgList"
local msg_item_path = "bottomContent/messageContent/msgItem"
local donate_have_txt_path = "bottomContent/donateContent/donateNumContent/donateHaveTxt"
local donate_icon_path = "bottomContent/donateContent/donateNumContent/donateIcon"
local donate_num_path = "bottomContent/donateContent/donateNumContent/donateNum"
local btn_donate_path = "bottomContent/donateContent/BtnDonate"
local text_btn_donate_path = "bottomContent/donateContent/BtnDonate/TextBtnDonate"
local progress_bg_path = "topContent/progress/progressBg"
local progress_img_path = "topContent/progress/progressBg/progressImg"
local msg_empty_tip_path = "bottomContent/messageContent/msgEmptyTip"
local donate_red_point_path = "bottomContent/donateContent/BtnDonate/DonateRedPoint"
local donate_red_num_path = "bottomContent/donateContent/BtnDonate/DonateRedPoint/DonateRedNum"
local box_item_path = "topContent/progress/progressBg/boxContent/boxItem"

function UIChampionDuelDonate:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIChampionDuelDonate:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelDonate:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.time_group = self:AddComponent(UIChampionDuelDonateTime, time_path)
  self.message_content = self:AddComponent(UIBaseContainer, message_content_path)
  self.msg_list = self:AddComponent(UIBaseContainer, msg_list_path)
  self.msg_item = self.transform:Find(msg_item_path).gameObject
  self.msg_item:SetActive(false)
  self.msg_item:GameObjectCreatePool()
  self.msgItemList = {}
  self.donate_have_txt = self:AddComponent(UITextMeshProUGUIEx, donate_have_txt_path)
  self.donate_icon = self:AddComponent(UIImage, donate_icon_path)
  self.donate_num = self:AddComponent(UITextMeshProUGUIEx, donate_num_path)
  self.btn_donate = self:AddComponent(UIButton, btn_donate_path)
  self.text_btn_donate = self:AddComponent(UIText, text_btn_donate_path)
  self.text_btn_donate:SetLocalText("champion_duel_tips1066")
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_img = self:AddComponent(UIImage, progress_img_path)
  self.msg_empty_tip = self:AddComponent(UITextMeshProUGUIEx, msg_empty_tip_path)
  self.donate_red_point = self:AddComponent(UIImage, donate_red_point_path)
  self.donate_red_num = self:AddComponent(UIText, donate_red_num_path)
  self.progressSize = self.progress_bg:GetSizeDelta()
  self.box_item_list = {}
  for i = 1, boxNum do
    local boxRoot = self:AddComponent(UIButton, box_item_path .. i)
    self.box_item_list[i] = {
      root = boxRoot,
      canGet = boxRoot:AddComponent(UIBaseContainer, "canGet"),
      boxImg = boxRoot:AddComponent(UIRawImage, "boxImg")
    }
    self.box_item_list[i].root:SetOnClick(function()
      self:OnBoxClick(i)
    end)
    self.box_item_list[i].root:SetAnchoredPositionXY(self.progressSize.x / boxNum * i, 0)
  end
  self.btn_donate:SetOnClick(function()
    self:OnClickDonateBtn()
  end)
end

function UIChampionDuelDonate:ComponentDestroy()
  self.anim = nil
  self:ClearAllItem()
  self.time_group = nil
  self.message_content = nil
  self.msg_list = nil
  self.msg_item = nil
  self.donate_havbox_item_liste_txt = nil
  self.donate_icon = nil
  self.donate_num = nil
  self.btn_donate = nil
  self.text_btn_donate = nil
  self.progress_bg = nil
  self.progress_img = nil
  self.msg_empty_tip = nil
  self.donate_red_point = nil
  self.donate_red_num = nil
end

function UIChampionDuelDonate:DataDefine()
  self.curPlayList = {}
  self.actInfo = nil
  self.wordsData = nil
  self.stageId = nil
  self.awardTemp = nil
  self.progressScoreList = nil
end

function UIChampionDuelDonate:DataDestroy()
  self.actInfo = nil
  self.wordsData = nil
  self.stageId = nil
  self.awardTemp = nil
  self.progressScoreList = nil
end

function UIChampionDuelDonate:OnEnable()
  base.OnEnable(self)
end

function UIChampionDuelDonate:OnDisable()
  base.OnDisable(self)
end

function UIChampionDuelDonate:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelDonateActInfoGet, self.ActInfoGet)
  self:AddUIListener(EventId.ChampionDuelDonateActWordGet, self.WordGet)
  self:AddUIListener(EventId.ChampionDuelDonateActDonate, self.OnDonateSuc)
  self:AddUIListener(EventId.ChampionDuelDonateActRewardGet, self.OnRewardGet)
  self:AddUIListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UIChampionDuelDonate:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelDonateActInfoGet, self.ActInfoGet)
  self:RemoveUIListener(EventId.ChampionDuelDonateActWordGet, self.WordGet)
  self:RemoveUIListener(EventId.ChampionDuelDonateActDonate, self.OnDonateSuc)
  self:RemoveUIListener(EventId.ChampionDuelDonateActRewardGet, self.OnRewardGet)
  self:RemoveUIListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function UIChampionDuelDonate:ClearAllItem()
  self:ClearPlayList()
  self.msg_list:RemoveComponents(UIChampionDuelDonateMsgItem)
  for _, v in ipairs(self.msg_list.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.msg_item:GameObjectRecycleAll()
  self.msgItemList = {}
end

function UIChampionDuelDonate:ActInfoGet()
  self:SetData()
  self:RefreshView()
end

function UIChampionDuelDonate:OnDonateSuc()
  self:RefreshView()
end

function UIChampionDuelDonate:OnRewardGet()
  self:RefreshView()
end

function UIChampionDuelDonate:WordGet()
  self.wordsData = DataCenter.ChampionDuelManager:GetDonateActWord()
  self:RefreshWordsContent()
end

function UIChampionDuelDonate:GetRefreshItemsMsg()
  self:RefreshView()
end

function UIChampionDuelDonate:OnPassDay()
  self:TrySendMessage()
end

function UIChampionDuelDonate:ReInit()
  self.wordsData = nil
  self:RefreshWordsContent()
  self:TrySendMessage()
  self:SetData()
  self:RefreshView()
  self.anim:Enable(true)
  self.anim:Play("Eff_UIChampionDuelDonateShow", 0, 0)
end

function UIChampionDuelDonate:TrySendMessage()
  DataCenter.ChampionDuelManager:ReqDonateActInfo()
  local wordExpiredTime = DataCenter.ChampionDuelManager:GetDonateActWordsExpiredTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if wordExpiredTime < curTime then
    SFSNetwork.SendMessage(MsgDefines.ChampionDuelHotActWord)
  else
    self:WordGet()
  end
end

function UIChampionDuelDonate:SetData()
  self.actInfo = DataCenter.ChampionDuelManager:GetDonateActInfo()
  self.stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self.wordsData = DataCenter.ChampionDuelManager:GetDonateActWord()
  local awardTempStageId = self.stageId
  if awardTempStageId == ChampionDuelState.SignInAnnouncement then
    awardTempStageId = ChampionDuelState.SignIn
  elseif awardTempStageId == ChampionDuelState.PreStageAnnouncement then
    awardTempStageId = ChampionDuelState.PreStage
  end
  local activityType = 3
  self.awardTemp = DataCenter.ChampionDuelManager:GetTemplateAwardByStageAndType(awardTempStageId, activityType)
  if self.awardTemp and #self.awardTemp > 0 then
    self.progressScoreList = string.string2array_i_oneSep(self.awardTemp[1].para, ",")
  end
end

function UIChampionDuelDonate:RefreshView()
  if self.actInfo == nil or self.awardTemp == nil or self.stageId == nil then
    return
  end
  self.time_group:ReInit()
  self:RefreshProgressContent()
  self:RefreshDonateBtnContent()
  self:RefreshDonateRed()
end

function UIChampionDuelDonate:RefreshProgressContent()
  if self.actInfo == nil or self.awardTemp == nil or self.stageId == nil then
    return
  end
  local curProgress = self.actInfo.progress
  local viewProgressNum = 0
  for i = 1, #self.progressScoreList do
    if curProgress >= self.progressScoreList[i] then
      viewProgressNum = i
    else
      local preProgress = 0
      if 1 < i then
        preProgress = self.progressScoreList[i - 1]
      end
      viewProgressNum = viewProgressNum + (curProgress - preProgress) / (self.progressScoreList[i] - preProgress)
      break
    end
  end
  viewProgressNum = math.max(viewProgressNum, 0)
  local width = self.progressSize.x / boxNum * viewProgressNum
  self.progress_img:SetSizeDeltaXY(width, self.progressSize.y)
  for i = 1, boxNum do
    local boxState = ChampionDuelDonateBoxState.NoComplete
    if self.actInfo.haveGet[i - 1] == true then
      boxState = ChampionDuelDonateBoxState.Received
    elseif curProgress < self.progressScoreList[i] then
      boxState = ChampionDuelDonateBoxState.NoComplete
    else
      boxState = ChampionDuelDonateBoxState.CanReceive
    end
    local activeFlag = false
    local boxImgName = boxIconName[i].close
    if boxState == ChampionDuelDonateBoxState.Received then
      boxImgName = boxIconName[i].open
    elseif boxState == ChampionDuelDonateBoxState.CanReceive then
      activeFlag = true
      self.box_item_list[i].canGet:SetActive(true)
      self.box_item_list[i].boxImg:LoadSpriteAuto(string.format(LoadPath.ChampionDuelTexturePath, boxIconName[i].close))
    end
    self.box_item_list[i].canGet:SetActive(activeFlag)
    self.box_item_list[i].boxImg:LoadSpriteAuto(string.format(LoadPath.ChampionDuelTexturePath, boxImgName))
  end
end

function UIChampionDuelDonate:RefreshDonateBtnContent()
  if self.actInfo == nil or self.awardTemp == nil or self.stageId == nil then
    return
  end
  local costId = tonumber(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k5"))
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costId)
  self.donate_icon:LoadSpriteAuto(iconPath)
  local curNum = DataCenter.ItemData:GetItemRealCount(costId)
  self.donate_num:SetText(curNum)
end

function UIChampionDuelDonate:OnBoxClick(i)
  if self.actInfo == nil or self.awardTemp == nil or self.stageId == nil then
    return
  end
  local curProgress = self.actInfo.progress
  local boxState = ChampionDuelDonateBoxState.NoComplete
  if self.actInfo.haveGet[i - 1] == true then
    boxState = ChampionDuelDonateBoxState.Received
  elseif curProgress < self.progressScoreList[i] then
    boxState = ChampionDuelDonateBoxState.NoComplete
  else
    boxState = ChampionDuelDonateBoxState.CanReceive
  end
  if boxState == ChampionDuelDonateBoxState.NoComplete then
    local rewardList = self.awardTemp[1].activity_reward[i]
    local title = Localization:GetString("champion_duel_tips1077", i, self.actInfo.progress, self.progressScoreList[i])
    local param = UIChampionDuelDonateRewardTipView.ParamDataClass.New()
    param.titleStr = title
    param.position = self.box_item_list[i].root.transform.position
    param.deltaY = -30
    param.rewardList = rewardList
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDonateRewardTip, {anim = false}, param)
  elseif boxState == ChampionDuelDonateBoxState.CanReceive then
    SFSNetwork.SendMessage(MsgDefines.ChampionDuelHotActRewardGet, i - 1)
  else
    local rewardList = self.awardTemp[1].activity_reward[i]
    local title = Localization:GetString("champion_duel_tips1077", i, self.actInfo.progress, self.progressScoreList[i])
    local param = UIChampionDuelDonateRewardTipView.ParamDataClass.New()
    param.titleStr = title
    param.position = self.box_item_list[i].root.transform.position
    param.deltaY = -30
    param.rewardList = rewardList
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDonateRewardTip, {anim = false}, param)
  end
end

function UIChampionDuelDonate:OnClickDonateBtn()
  if self.actInfo == nil or self.awardTemp == nil or self.stageId == nil then
    return
  end
  local donateItemId = tonumber(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k5"))
  local haveCount = DataCenter.ItemData:GetItemCount(donateItemId)
  if haveCount < 1 then
    LWResourceLackUtil:GotoGoodsItemLack(donateItemId, 1)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDonateConfirm)
  end
end

function UIChampionDuelDonate:RefreshDonateRed()
  local donateItemId = tonumber(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k5"))
  local haveCount = DataCenter.ItemData:GetItemCount(donateItemId)
  self.donate_red_point:SetActive(0 < haveCount)
  self.donate_red_num:SetText(haveCount)
end

function UIChampionDuelDonate:RefreshWordsContent()
  self:ClearAllItem()
  if table.IsNullOrEmpty(self.wordsData) then
    self.msg_empty_tip:SetActive(true)
    return
  end
  self.msg_empty_tip:SetActive(false)
  local len = #self.wordsData
  local curNum = math.max(len, 5)
  local showNum = math.min(curNum, 20)
  self.maxNum = showNum
  for i = 1, showNum do
    local name = "msgItem" .. i
    local obj = self.msg_list.transform:Find(name)
    local item = self.msgItemList[i]
    if i <= curNum then
      if obj == nil then
        obj = self.msg_item:GameObjectSpawn(self.msg_list.transform)
        obj.name = name
      end
      if item == nil then
        item = self.msg_list:AddComponent(UIChampionDuelDonateMsgItem, name)
        item:SetLocalPositionXYZ(0, 0, 0)
        self.msgItemList[i] = item
      end
      local idx = i
      while len < idx do
        idx = idx - len
      end
      item:ReInit(self.wordsData[idx])
      item:SetActive(false)
    elseif obj then
      obj:GameObjectRecycle()
      self.msgItemList[i] = nil
    end
  end
  self:StartPlay(1)
end

function UIChampionDuelDonate:ClearPlayList()
  if self.curPlayList ~= nil then
    for _, idx in pairs(self.curPlayList) do
      if self.msgItemList[idx] then
        self.msgItemList[idx]:CleanPlay()
      end
    end
  end
  self.bFirst = true
  self.curPlayList = {}
end

function UIChampionDuelDonate:StartPlay(index)
  local cnt = self.maxNum
  local realI = index <= cnt and index or index - cnt
  table.insert(self.curPlayList, realI)
  local item = self.msgItemList[realI]
  item:SetActive(true)
  item:StartPlay(function()
    self:StartPlay(realI + 1)
  end, function()
    item:SetActive(false)
    if self.curPlayList ~= nil then
      for pos, idx in pairs(self.curPlayList) do
        if idx == realI then
          table.remove(self.curPlayList, pos)
          break
        end
      end
    end
  end, self.bFirst)
  self.bFirst = false
end

return UIChampionDuelDonate
