local ActBingo = BaseClass("ActBingo", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActBingoTaskItem = require("UI.UIActivityCenterTable.Component.ActBingo.ActBingoTaskItem")
local ActBingoBoxItem = require("UI.UIActivityCenterTable.Component.ActBingo.ActBingoBoxItem")
local act_name_path = "rect/ActivityTopGo/actName"
local txt_times_path = "rect/ActivityTopGo/TimeContent/txtTimes"
local sub_txt_path = "rect/ActivityTopGo/subTxt"
local info_btn_path = "rect/ActivityTopGo/infoBtn"
local task_item_content_path = "rect/centerContent/taskContent/taskItemContent"
local row_task_box_content_path = "rect/centerContent/rowTaskBoxContent"
local column_task_box_content_path = "rect/centerContent/columnTaskBoxContent"
local task_item_path = "rect/centerContent/taskItem"
local box_item_path = "rect/centerContent/boxItem"
local fin_box_content_path = "rect/centerContent/finBoxContent"
local fin_box_icon_path = "rect/centerContent/finBoxContent/finBoxIcon"
local big_reward_content_path = "rect/centerContent/finBoxRewardContent/RewardScroll/bigRewardContent"
local fin_reward_progress_num_path = "rect/centerContent/finBoxRewardContent/finRewardProgressNum"
local fin_get_content_path = "rect/centerContent/finBoxRewardContent/finGetContent"
local fin_receive_btn_path = "rect/centerContent/finBoxRewardContent/finReceiveBtn"
local eff_ui_s_u_i_act_bingo_path = "rect/centerContent/taskContent/Eff_ui_S_UIActBingo"
local line_bg_path = "rect/centerContent/taskContent/bg2/lineBg"

function ActBingo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function ActBingo:OnDestroy()
  self:CloseAniSeq()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActBingo:OnEnable()
  base.OnEnable(self)
end

function ActBingo:OnDisable()
  base.OnDisable(self)
end

function ActBingo:ComponentDefine()
  self.act_name = self:AddComponent(UIText, act_name_path)
  self.txt_times = self:AddComponent(UIText, txt_times_path)
  self.task_item_content = self:AddComponent(UIBaseContainer, task_item_content_path)
  self.row_task_box_content = self:AddComponent(UICanvasGroup, row_task_box_content_path)
  self.column_task_box_content = self:AddComponent(UICanvasGroup, column_task_box_content_path)
  self.task_item = self:AddComponent(UIBaseContainer, task_item_path)
  self.box_item = self:AddComponent(UIBaseContainer, box_item_path)
  self.fin_box_content = self:AddComponent(UIButton, fin_box_content_path)
  self.fin_box_icon = self:AddComponent(UIImage, fin_box_icon_path)
  self.sub_txt = self:AddComponent(UITextMeshProUGUIEx, sub_txt_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.big_reward_content = self:AddComponent(UIBaseContainer, big_reward_content_path)
  self.fin_reward_progress_num = self:AddComponent(UITextMeshProUGUIEx, fin_reward_progress_num_path)
  self.fin_get_content = self:AddComponent(UIImage, fin_get_content_path)
  self.fin_receive_btn = self:AddComponent(UIButton, fin_receive_btn_path)
  self.eff_ui_s_u_i_act_bingo = self:AddComponent(UIBaseContainer, eff_ui_s_u_i_act_bingo_path)
  self.line_bg = self:AddComponent(UICanvasGroup, line_bg_path)
  self.task_item:SetActive(false)
  self.box_item:SetActive(false)
  self.eff_ui_s_u_i_act_bingo:SetActive(false)
  self.line_bg:SetAlpha(1)
  self.info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.fin_receive_btn:SetOnClick(function()
    self:ClickFinReceiveBtn()
  end)
  self.taskItemList = {}
  self.task_item.gameObject:GameObjectCreatePool()
  self.boxItemHList = {}
  self.boxItemVList = {}
  self.box_item.gameObject:GameObjectCreatePool()
  self.bigRewardItemList = {}
  self.bigRewardItemReqs = {}
end

function ActBingo:ComponentDestroy()
  self:ClearAllItem()
  self.act_name = nil
  self.txt_times = nil
  self.task_item_content = nil
  self.row_task_box_content = nil
  self.column_task_box_content = nil
  self.task_item = nil
  self.box_item = nil
  self.fin_box_content = nil
  self.fin_box_icon = nil
  self.sub_txt = nil
  self.info_btn = nil
  self.big_reward_content = nil
  self.fin_reward_progress_num = nil
  self.fin_get_content = nil
  self.fin_receive_btn = nil
  self.eff_ui_s_u_i_act_bingo = nil
  self.line_bg = nil
  self.bigRewardItemList = nil
  self.bigRewardItemReqs = nil
end

function ActBingo:ClearAllItem()
  self.task_item_content:RemoveComponents(ActBingoTaskItem)
  for _, v in ipairs(self.task_item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.task_item.gameObject:GameObjectRecycleAll()
  self.taskItemList = {}
  self.row_task_box_content:RemoveComponents(ActBingoBoxItem)
  for _, v in ipairs(self.row_task_box_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.column_task_box_content:RemoveComponents(ActBingoBoxItem)
  for _, v in ipairs(self.column_task_box_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.box_item.gameObject:GameObjectRecycleAll()
  self.boxItemHList = {}
  self.boxItemVList = {}
  self:ClearRewardContent()
end

function ActBingo:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.oneHorizontalNum = ActBingoTaskNum.OneHorizontal
  self.oneVerticalNum = ActBingoTaskNum.OneVertical
  self.totalTaskNum = self.oneHorizontalNum * self.oneVerticalNum
  self.aniSeq = nil
  self.needPlayAni = false
end

function ActBingo:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.oneHorizontalNum = nil
  self.oneVerticalNum = nil
  self.totalTaskNum = nil
  self.aniSeq = nil
  self.needPlayAni = nil
end

function ActBingo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBingoDetailData, self.OnRefresh)
  self:AddUIListener(EventId.ActBingoTaskDataUpdate, self.OnRefresh)
  self:AddUIListener(EventId.ActBingoBoxGet, self.OnRefresh)
  self:AddUIListener(EventId.ActBingoTaskReward, self.OnTaskFinAni)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.TryPlayAni)
end

function ActBingo:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBingoDetailData, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBingoTaskDataUpdate, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBingoBoxGet, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBingoTaskReward, self.OnTaskFinAni)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.TryPlayAni)
end

function ActBingo:InitView()
  for i = 1, self.totalTaskNum do
    local index = i
    local item = self.task_item.gameObject:GameObjectSpawn(self.task_item_content.transform)
    item.name = index
    local obj = self.task_item_content:AddComponent(ActBingoTaskItem, item.name)
    obj:SetActive(true)
    self.taskItemList[index] = obj
  end
  for i = 1, self.oneVerticalNum do
    local index = i
    local item = self.box_item.gameObject:GameObjectSpawn(self.row_task_box_content.transform)
    item.name = index
    local obj = self.row_task_box_content:AddComponent(ActBingoBoxItem, item.name)
    obj:SetActive(true)
    self.boxItemHList[index] = obj
  end
  for i = 1, self.oneHorizontalNum do
    local index = i
    local item = self.box_item.gameObject:GameObjectSpawn(self.column_task_box_content.transform)
    item.name = index
    local obj = self.column_task_box_content:AddComponent(ActBingoBoxItem, item.name)
    obj:SetActive(true)
    self.boxItemVList[index] = obj
  end
end

function ActBingo:SetData(activityId)
  self.activityId = tonumber(activityId)
  if self.activityId == nil then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActBingoDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self:OnRefresh()
  self:RefreshFinBoxRewardView()
  self:RefreshLineBg()
end

function ActBingo:OnRefresh()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  self:Update1000MS()
  self.act_name:SetLocalText(self.activityInfo.name)
  self.sub_txt:SetLocalText(self.activityInfo.desc_info)
  self:RefreshTaskView()
  self:RefreshBoxView()
end

function ActBingo:Update1000MS()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
end

function ActBingo:RefreshTaskView()
  for i = 1, self.totalTaskNum do
    local item = self.taskItemList[i]
    item:SetData(self.activityId, self.activityDetailData.taskArr[i], i, self.activityDetailData)
  end
end

function ActBingo:RefreshBoxView()
  for i = 1, self.oneHorizontalNum do
    local item = self.boxItemVList[i]
    item:SetData(self.activityId, self.activityDetailData.vRewardArr[i], ActBingoBoxType.Vertical, i, self.activityDetailData)
  end
  for i = 1, self.oneVerticalNum do
    local item = self.boxItemHList[i]
    item:SetData(self.activityId, self.activityDetailData.hRewardArr[i], ActBingoBoxType.Horizontal, i, self.activityDetailData)
  end
  self:RefreshBigRewardBoxView()
end

function ActBingo:RefreshBigRewardBoxView()
  local bigRewardState = self.activityDetailData:GetBoxState(ActBingoBoxType.BigReward)
  if bigRewardState == ActBingoBoxState.NoComplete then
    local curTaskCompleteNum = self.activityDetailData:GetCompleteTaskNum()
    self.fin_reward_progress_num:SetText(string.format("%s/%s", curTaskCompleteNum, self.totalTaskNum))
    self.fin_receive_btn:SetActive(false)
    self.fin_get_content:SetActive(false)
    local boxImgName = "FX_binguohuodong_baoxiang"
    self.fin_box_icon:LoadSprite(string.format(LoadPath.ActBingoSpritePath, boxImgName))
  elseif bigRewardState == ActBingoBoxState.CanReceive then
    self.fin_reward_progress_num:SetText("")
    self.fin_receive_btn:SetActive(true)
    self.fin_get_content:SetActive(false)
    local boxImgName = "FX_binguohuodong_baoxiang"
    self.fin_box_icon:LoadSprite(string.format(LoadPath.ActBingoSpritePath, boxImgName))
  elseif bigRewardState == ActBingoBoxState.Received then
    self.fin_reward_progress_num:SetText("")
    self.fin_receive_btn:SetActive(false)
    self.fin_get_content:SetActive(true)
    local boxImgName = "FX_binguohuodong_baoxiang2"
    self.fin_box_icon:LoadSprite(string.format(LoadPath.ActBingoSpritePath, boxImgName))
  end
end

function ActBingo:ClearRewardContent()
  if table.count(self.bigRewardItemList) > 0 then
    self.big_reward_content:RemoveComponents(UICommonResItem)
    self.bigRewardItemList = {}
  end
  if table.count(self.bigRewardItemReqs) then
    for _, req in pairs(self.bigRewardItemReqs) do
      req:Destroy()
    end
    self.bigRewardItemReqs = {}
  end
end

function ActBingo:RefreshFinBoxRewardView()
  self:ClearRewardContent()
  self.big_reward_content:SetAnchoredPositionXY(0, 0)
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.activityDetailData.bigReward)
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(self.big_reward_content.transform)
        item.transform:Set_localScale(0.65, 0.65, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.big_reward_content:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.bigRewardItemList, cell)
      end)
      table.insert(self.bigRewardItemReqs, req)
    end
  end
end

function ActBingo:ClickTip()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ActBingo:ClickFinReceiveBtn()
  if self.activityDetailData == nil then
    return
  end
  local bigRewardState = self.activityDetailData:GetBoxState(ActBingoBoxType.BigReward)
  if bigRewardState == ActBingoBoxState.CanReceive then
    SFSNetwork.SendMessage(MsgDefines.BingoBoxReceive, tonumber(self.activityId), ActBingoBoxType.BigReward, 0)
  end
end

function ActBingo:RefreshLineBg()
  if self.activityDetailData == nil then
    return
  end
  self.needPlayAni = false
  self.eff_ui_s_u_i_act_bingo:SetActive(false)
  local isAllReceived = self.activityDetailData:IsAllTaskReceived()
  if isAllReceived then
    self.line_bg:SetAlpha(0)
  else
    self.line_bg:SetAlpha(1)
  end
end

function ActBingo:OnTaskFinAni(message)
  if message and message.activityId == self.activityId then
    local isAllReceived = self.activityDetailData:IsAllTaskReceived()
    if isAllReceived then
      self.needPlayAni = true
    end
  end
end

function ActBingo:TryPlayAni()
  if self.needPlayAni then
    self.needPlayAni = false
    self.eff_ui_s_u_i_act_bingo:SetActive(true)
    self.aniSeq = DOTween.Sequence()
    self.aniSeq:AppendInterval(0.25)
    self.aniSeq:Append(self.line_bg.unity_canvas_group:DOFade(0, 0.75))
    self.aniSeq:AppendCallback(function()
      self:RefreshLineBg()
    end)
    self.aniSeq:OnComplete(function()
      self:CloseAniSeq()
    end)
  end
end

function ActBingo:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

return ActBingo
