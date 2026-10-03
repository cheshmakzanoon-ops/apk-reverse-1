local base = require("UI.UIDispatchTask.Main.Component.UIDispatchContentBase")
local DispatchTask = BaseClass("DispatchTask", base)
local Localization = CS.GameEntry.Localization
local DispatchTaskItem = require("UI.UIActivityCenterTable.Component.DispatchTask.DispatchTaskItem")
local DispatchTaskMarkItem = require("UI.UIActivityCenterTable.Component.DispatchTask.DispatchTaskMarkItem")
local DispatchTaskStarTip = require("UI.UIActivityCenterTable.Component.DispatchTask.DispatchTaskStarTip")
local uibutton = require("Framework.UI.Component.UIButton")
local UIGray = CS.UIGray
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local intro_btn_path = "rect/ActivityTopGo/IntroBtn"
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local txt_act_name_Treasure_path = "rect/ActivityTopGo/Txt_ActName_Treasure"
local txt_act_extra_path = "rect/ActivityTopGo/Txt_ActExtra"
local txt_act_extra_Treasure_path = "rect/ActivityTopGo/Txt_ActExtra_Treasure"
local txt_ass_num_path = "rect/ActivityTopGo/Content1/Txt_AssNum"
local txt_plu_num_path = "rect/ActivityTopGo/Content2/Txt_PluNum"
local toggle1_path = "rect/CenterGo/ToggleGroup/Toggle1"
local toggle2_path = "rect/CenterGo/ToggleGroup/Toggle2"
local toggle3_path = "rect/CenterGo/ToggleGroup/Toggle3"
local scroll_view_path = "rect/CenterGo/Scroll View"
local content_path = "rect/CenterGo/Scroll View/Viewport/Content"
local no_alliance_go_path = "rect/CenterGo/NoAllianceGo"
local empty_go_path = "rect/CenterGo/EmptyGo"
local join_btn_path = "rect/CenterGo/NoAllianceGo/joinBtn"
local red_point_path = "rect/CenterGo/ToggleGroup/Toggle1/RedPoint"
local red_num_path = "rect/CenterGo/ToggleGroup/Toggle1/RedPoint/RedNum"
local alnc_red_point_path = "rect/CenterGo/ToggleGroup/Toggle2/AlncRedPoint"
local alnc_red_num_path = "rect/CenterGo/ToggleGroup/Toggle2/AlncRedPoint/AlncRedNum"
local mark_red_point_path = "rect/CenterGo/ToggleGroup/Toggle3/MarkRedPoint"
local mark_red_num_path = "rect/CenterGo/ToggleGroup/Toggle3/MarkRedPoint/MarkRedNum"
local refresh_btn_path = "rect/refreshBtn"
local refresh_btn_item_count_path = "rect/refreshBtn/item/itemCount"
local refresh_btn_item_icon_path = "rect/refreshBtn/item/itemIcon"
local refresh_btn_goods_icon_path = "rect/refreshBtn/item/goodsIcon"
local refresh_icon_path = "rect/refreshBtn/refreshBg"
local go_text_path = "rect/refreshBtn/GoText"
local super_refresh_bg_path = "rect/superBtns/superRefreshBtn/superRefreshBg"
local super_dispatch_bg_path = "rect/superBtns/superDispatchBtn/superDispatchBg"
local record_btn_root_path = "rect/ActivityTopGo/BtnList/recordBtn"
local record_btn_path = "rect/ActivityTopGo/BtnList/recordBtn/recordBtnClickArea"
local star_btn_path = "rect/ActivityTopGo/BtnList/starBtn/starBtnClickArea"
local star_btn_root_path = "rect/ActivityTopGo/BtnList/starBtn"
local starList_path = "rect/ActivityTopGo/BtnList/starBtn/starList"
local starTemplate_path = "rect/ActivityTopGo/BtnList/starBtn/starList/starTemplate"
local starTmpStart_path = "rect/ActivityTopGo/BtnList/starBtn/starList/tmpStart"
local starTmpEnd_path = "rect/ActivityTopGo/BtnList/starBtn/starList/tmpEnd"
local tip_root_path = "rect/ActivityTopGo/BtnList/starBtn/btnTxt/TipRoot"
local star_btn_effect_path = "rect/ActivityTopGo/BtnList/starBtn/effect"
local normal_btn_path = "rect/normalBtn"
local normal_text_path = "rect/normalBtn/normalText"
local super_btn_path = "rect/superBtn"
local super_text_path = "rect/superBtn/superText"
local super_btns_path = "rect/superBtns"
local super_refresh_btn_path = "rect/superBtns/superRefreshBtn"
local super_refresh_text_path = "rect/superBtns/superRefreshBtn/superRefreshText"
local super_dispatch_btn_path = "rect/superBtns/superDispatchBtn"
local super_dispatch_text_path = "rect/superBtns/superDispatchBtn/superDispatchText"
local reward_all_btn_path = "rect/rewardAllBtn"
local reward_all_txt_path = "rect/rewardAllBtn/rewardAllTxt"
local ppt_btn_path = "rect/ActivityTopGo/Content2"
local txt_AssTip_path = "rect/ActivityTopGo/Content1/Txt_AssTip"
local txt_AssTip_Treasure_path = "rect/ActivityTopGo/Content1/Txt_AssTip_Treasure"
local txt_PluNum_path = "rect/ActivityTopGo/Content2/Txt_PluTip"
local txt_PluNum_Treasure_path = "rect/ActivityTopGo/Content2/Txt_PluTip_Treasure"

function DispatchTask:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:CheckNeedShowIntro()
end

function DispatchTask:ComponentDefine()
  self.tip_root = self:AddComponent(DispatchTaskStarTip, tip_root_path)
  self.refresh_btn_bg = self:AddComponent(UIImage, refresh_icon_path)
  self.refresh_btn_item_icon = self:AddComponent(UIBaseComponent, refresh_btn_item_icon_path)
  self.refresh_btn_goods_icon = self:AddComponent(UIBaseComponent, refresh_btn_goods_icon_path)
  self.refresh_btn_item_count = self:AddComponent(UITextMeshProUGUIEx, refresh_btn_item_count_path)
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.go_text:SetText(Localization:GetString(110028))
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRefreshBtn()
  end)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.txt_ass_num = self:AddComponent(UIText, txt_ass_num_path)
  self.txt_plu_num = self:AddComponent(UIText, txt_plu_num_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(1)
    end
  end)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(2)
    end
  end)
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle3:SetIsOn(false)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(3)
    end
  end)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.record_btn_root = self:AddComponent(UIBaseComponent, record_btn_root_path)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.record_btn:SetSafeClickMode(true)
  self.record_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRecordBtn()
  end)
  self.star_btn = self:AddComponent(UIButton, star_btn_path)
  self.star_btn_effect = self:AddComponent(UICanvasGroup, star_btn_effect_path)
  self.star_btn_root = self:AddComponent(UIBaseComponent, star_btn_root_path)
  self.no_alliance_go = self:AddComponent(UIBaseContainer, no_alliance_go_path)
  self.empty_go = self:AddComponent(UIBaseContainer, empty_go_path)
  self.empty_txt = self:AddComponent(UIText, "rect/CenterGo/EmptyGo/Txt_Empty")
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnJoinAllianceClick()
  end)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_num = self:AddComponent(UIText, red_num_path)
  self.alnc_red_point = self:AddComponent(UIImage, alnc_red_point_path)
  self.alnc_red_num = self:AddComponent(UIText, alnc_red_num_path)
  self.mark_red_point = self:AddComponent(UIImage, mark_red_point_path)
  self.mark_red_num = self:AddComponent(UITextMeshProUGUIEx, mark_red_num_path)
  self.starList = self:AddComponent(UIBaseContainer, starList_path)
  self.starTemplate = self.transform:Find(starTemplate_path).gameObject
  self.starTemplate:GameObjectCreatePool()
  self.starTemplate:SetActive(false)
  self.starTmpStart = self:AddComponent(UIBaseContainer, starTmpStart_path)
  self.starTmpEnd = self:AddComponent(UIBaseContainer, starTmpEnd_path)
  local starLevel = DataCenter.ActDispatchTaskDataManager:GetCurrentStarLevel()
  self.star_btn_effect_tick = nil
  self.star_btn_effect:SetActive(false)
  if starLevel < 1 then
    self.star_btn_root:SetActive(false)
  else
    self.star_btn:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:ClickStarBtn()
    end)
    self.starTemplate:GameObjectRecycleAll()
    local sprites = DataCenter.ActDispatchTaskDataManager:GetStarSprites(starLevel)
    for i = 1, #sprites do
      local star = self.starTemplate:GameObjectSpawn(self.starList.transform)
      star.name = "star" .. i
      star:GetComponent(UnityImage):LoadSprite(string.format(LoadPath.LWCommonPath, sprites[i]))
      star:SetActive(true)
    end
    self.starTmpStart.transform:SetAsFirstSibling()
    self.starTmpEnd.transform:SetAsLastSibling()
    if starLevel < 5 then
      self.star_btn_effect_tick = 0
      self.star_btn_effect:SetActive(true)
    end
  end
  self.normal_btn = self:AddComponent(UIButton, normal_btn_path)
  self.normal_text = self:AddComponent(UITextMeshProUGUIEx, normal_text_path)
  self.super_btn = self:AddComponent(UIButton, super_btn_path)
  self.super_text = self:AddComponent(UITextMeshProUGUIEx, super_text_path)
  self.super_btns = self:AddComponent(UIBaseContainer, super_btns_path)
  self.super_refresh_btn = self:AddComponent(UIButton, super_refresh_btn_path)
  self.super_refresh_text = self:AddComponent(UITextMeshProUGUIEx, super_refresh_text_path)
  self.super_dispatch_btn = self:AddComponent(UIButton, super_dispatch_btn_path)
  self.super_dispatch_text = self:AddComponent(UITextMeshProUGUIEx, super_dispatch_text_path)
  self.normal_text:SetText(Localization:GetString("dispatch_des005"))
  self.super_text:SetText(Localization:GetString("dispatch_des004"))
  self.super_refresh_text:SetText(Localization:GetString("dispatch_des002"))
  self.super_dispatch_text:SetText(Localization:GetString("dispatch_des003"))
  self.normal_btn:SetOnClick(function()
    self:OnNormalBtnClick()
  end)
  self.super_btn:SetOnClick(function()
    self:OnSuperBtnClick()
  end)
  self.super_refresh_btn:SetOnClick(function()
    self:OnSuperRefreshBtnClick()
  end)
  self.super_dispatch_btn:SetOnClick(function()
    self:OnSuperDispatchBtnClick()
  end)
  self.super_refresh_bg = self:AddComponent(UIImage, super_refresh_bg_path)
  self.super_dispatch_bg = self:AddComponent(UIImage, super_dispatch_bg_path)
  self.reward_all_btn = self:AddComponent(UIButton, reward_all_btn_path)
  self.reward_all_txt = self:AddComponent(UITextMeshProUGUIEx, reward_all_txt_path)
  self.reward_all_txt:SetText(Localization:GetString("dispatch_des031"))
  self.reward_all_btn:SetActive(false)
  self.reward_all_btn:SetOnClick(function()
    self:OnRewardAllBtnClick()
  end)
  self.ppt_btn = self:AddComponent(UIButton, ppt_btn_path)
  self.ppt_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 1500)
  end)
  self.normalStatus = true
  local lastSet = Setting:GetPrivateInt("DispatchTaskNormalStatus", 0)
  if lastSet == 1 then
    local isOpen = DataCenter.ActDispatchTaskDataManager:CheckSuperModeOpen()
    if not isOpen then
      Setting:SetPrivateInt("DispatchTaskNormalStatus", 0)
    else
      self.normalStatus = false
    end
  end
  self.targetJumpUuid = -1
  self.objTreasure = self:AddComponent(UIBaseContainer, "rect/treasureGo")
  self.textTreasureItemNum = self:AddComponent(UITextMeshProUGUIEx, "rect/treasureGo/textTreasureItemNum")
  self.btnTreasureDesc = self:AddComponent(UIButton, "rect/treasureGo/btnTreasureDesc")
  self.btnTreasureDesc:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIExplorerTreasureIntroduce)
  end)
  self.btnBox = self:AddComponent(UIButton, "rect/treasureGo/btnBox")
  self.btnBox:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskMain, {anim = false})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIExplorerTreasure)
  end)
  self.imgKeyIcon = self:AddComponent(UIImage, "rect/treasureGo/imgKeyIcon")
  self.rawImageBgDefault = self:AddComponent(UIImage, "rect/RawImage")
  self.rawImageBgTreasure = self:AddComponent(UIRawImage, "rect/RawImage2")
  self.rawImageBgTreasure2 = self:AddComponent(UIRawImage, "rect/treasureGo/bg")
  self.toggleGroup = self:AddComponent(UIBaseContainer, "rect/CenterGo/ToggleGroup")
  self.textTreasureItemTitle = self:AddComponent(UITextMeshProUGUIEx, "rect/treasureGo/textTreasureItemTitle")
  self.textTreasureItemTitle:SetLocalText("explorer_treasure_activity_name_01")
  self.red_point_obj = self:AddComponent(UIBaseContainer, "rect/treasureGo/RedPointNum")
  self.tex_red_point_num = self:AddComponent(UITextMeshProUGUIEx, "rect/treasureGo/RedPointNum/Text")
  self.txt_act_name_treasure = self:AddComponent(UITextMeshProUGUIEx, txt_act_name_Treasure_path)
  self.txt_act_extra_treasure = self:AddComponent(UITextMeshProUGUIEx, txt_act_extra_Treasure_path)
  self.txt_assTip_treasure = self:AddComponent(UIBaseContainer, txt_AssTip_Treasure_path)
  self.txt_pluNum_treasure = self:AddComponent(UIBaseContainer, txt_PluNum_Treasure_path)
  self.txt_assTip = self:AddComponent(UIBaseContainer, txt_AssTip_path)
  self.txt_pluNum = self:AddComponent(UIBaseContainer, txt_PluNum_path)
  self:UpdateRefreshButton()
  DataCenter.ActDispatchTaskDataManager:SendGetMarkList(true)
end

function DispatchTask:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDatalist then
    return nil
  end
  local data = self.showDatalist[index]
  local prefabName = self:GetItemPrefabName(index, self.tab)
  local itemScript = self:GetItemScript(index)
  local item = loopScroll:NewListViewItem(prefabName)
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  script:SetData(data, self.tab)
  return item
end

function DispatchTask:GetItemPrefabName(index, tab)
  if tab == 1 or tab == 2 then
    return "UIActivityDispatchTaskItem"
  elseif tab == 3 then
    return "UIActivityDispatchTaskMarkItem"
  end
end

function DispatchTask:GetItemScript(index)
  if self.tab == 1 or self.tab == 2 then
    return DispatchTaskItem
  elseif self.tab == 3 then
    return DispatchTaskMarkItem
  end
  return DispatchTaskItem
end

function DispatchTask:UpdateRefreshButton()
  local superRefreshOpen = DataCenter.ActDispatchTaskDataManager:CheckSuperRefreshOpen()
  local coinCount, itemId, itemCount = DataCenter.ActDispatchTaskDataManager:GetTaskRefreshSetting()
  if 0 < coinCount or 0 < itemCount then
    local item = DataCenter.ItemData:GetItemById(itemId)
    self.refresh_btn:SetActive((not superRefreshOpen or self.normalStatus) and self.tab == 1)
    if item and item.count and itemCount <= item.count then
      self.refresh_btn_item_icon:SetActive(true)
      self.refresh_btn_goods_icon:SetActive(false)
      self.refresh_btn_item_count:SetText(tostring(item.count) .. "/" .. tostring(itemCount))
      self.refresh_btn_bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      self.useItemRefresh = true
      self.useGoodRefresh = false
    else
      self.refresh_btn_item_icon:SetActive(false)
      self.refresh_btn_goods_icon:SetActive(true)
      if coinCount > LuaEntry.Player.gold then
        self.refresh_btn_item_count:SetText("<color=#E84242>" .. coinCount .. "</color>")
      else
        self.refresh_btn_item_count:SetText(coinCount)
      end
      self.refresh_btn_bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png")
      self.useItemRefresh = false
      self.useGoodRefresh = true
    end
  else
    self.refresh_btn:SetActive(false)
  end
  if not superRefreshOpen then
    self.super_btn:SetActive(false)
    self.normal_btn:SetActive(false)
    self.super_btns:SetActive(false)
  else
    self.super_btn:SetActive(self.normalStatus and self.tab == 1)
    self.normal_btn:SetActive(not self.normalStatus and self.tab == 1)
    self.super_btns:SetActive(not self.normalStatus and self.tab == 1)
  end
  if DataCenter.ExplorerTreasureManager:IsOpen() then
    self:RefreshExplorerTreasureItemNum()
  end
end

function DispatchTask:ComponentDestroy()
  if self.starTemplate then
    self.starTemplate:GameObjectRecycleAll()
  end
  self.txt_act_name = nil
  self.txt_act_extra = nil
  self.txt_ass_num = nil
  self.txt_plu_num = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.scroll_view = nil
  self.record_btn = nil
  self.no_alliance_go = nil
  self.empty_go = nil
  self.join_btn = nil
  self.red_point = nil
  self.red_num = nil
  self.alnc_red_point = nil
  self.alnc_red_num = nil
  self.targetJumpUuid = nil
  self.normal_btn = nil
  self.normal_text = nil
  self.super_btn = nil
  self.super_text = nil
  self.super_btns = nil
  self.super_refresh_btn = nil
  self.super_refresh_text = nil
  self.super_dispatch_btn = nil
  self.super_dispatch_text = nil
  self.go_text = nil
  self.super_refresh_bg = nil
  self.super_dispatch_bg = nil
  self.reward_all_btn = nil
  self.reward_all_txt = nil
  self.starList = nil
  self.starTemplate = nil
end

function DispatchTask:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DispatchTask:OnEnable()
  base.OnEnable(self)
end

function DispatchTask:OnDisable()
  DataCenter.ActDispatchTaskDataManager:FinishPlot()
  DataCenter.ActDispatchTaskDataManager:SetNeedPlayedSweepEffect(false)
  base.OnDisable(self)
end

function DispatchTask:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTaskTodayNumUpdate, self.RefreshTodayNum)
  self:AddUIListener(EventId.DispatchTaskUpdateSingle, self.RefreshSingleTask)
  self:AddUIListener(EventId.DispatchTaskUpdateAlliance, self.RefreshAllianceTask)
  self:AddUIListener(EventId.DispatchGetRealPoint, self.DoGetRealPoint)
  self:AddUIListener(EventId.RefreshItems, self.UpdateRefreshButton)
  self:AddUIListener(EventId.DispatchTaskUpdateAll, self.OnDispatchTaskUpdateAll)
  self:AddUIListener(EventId.DispatchTaskRefreshError, self.OnDispatchTaskUpdateAll)
  self:AddUIListener(EventId.DispatchTaskGetRecord, self.OnGetRecord)
  self:AddUIListener(EventId.DispatchTaskDeleteAllianceItem, self.OnDispatchTaskDeleteAllianceItem)
  self:AddUIListener(EventId.DispatchTaskGetMarkList, self.RefreshMarkList)
  self:AddUIListener(EventId.DispatchTaskStealSuccess, self.OnStealSuccess)
  self:AddUIListener(EventId.DispatchStealRangeUpdate, self.RefreshMarkList)
end

function DispatchTask:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTaskTodayNumUpdate, self.RefreshTodayNum)
  self:RemoveUIListener(EventId.DispatchTaskUpdateSingle, self.RefreshSingleTask)
  self:RemoveUIListener(EventId.DispatchTaskUpdateAlliance, self.RefreshAllianceTask)
  self:RemoveUIListener(EventId.DispatchGetRealPoint, self.DoGetRealPoint)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateRefreshButton)
  self:RemoveUIListener(EventId.DispatchTaskUpdateAll, self.OnDispatchTaskUpdateAll)
  self:RemoveUIListener(EventId.DispatchTaskRefreshError, self.OnDispatchTaskUpdateAll)
  self:RemoveUIListener(EventId.DispatchTaskGetRecord, self.OnGetRecord)
  self:RemoveUIListener(EventId.DispatchTaskDeleteAllianceItem, self.OnDispatchTaskDeleteAllianceItem)
  self:RemoveUIListener(EventId.DispatchTaskGetMarkList, self.RefreshMarkList)
  self:RemoveUIListener(EventId.DispatchTaskStealSuccess, self.OnStealSuccess)
  self:RemoveUIListener(EventId.DispatchStealRangeUpdate, self.RefreshMarkList)
  base.OnRemoveListener(self)
end

function DispatchTask:Update1000MS()
  if self.star_btn_effect_tick ~= nil then
    self.star_btn_effect_tick = self.star_btn_effect_tick + 1
    if toInt(self.star_btn_effect_tick % 5) == 4 then
      local alpha = self.star_btn_effect:GetAlpha()
      if alpha < 0.01 then
        self.star_btn_effect:FadeIn(1)
      else
        self.star_btn_effect:FadeOut(1)
      end
    end
  end
end

function DispatchTask:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.txt_act_name:SetLocalText(self.data.bannerTittle)
  self.txt_act_name_treasure:SetLocalText(self.data.bannerTittle)
  self.txt_act_extra:SetLocalText(456202)
  self.txt_act_extra_treasure:SetLocalText(456202)
  self.toggle3:SetActive(DataCenter.ActDispatchTaskDataManager:IsMarkFuncOpen())
  if self.toggle1:GetIsOn() then
    self.lastTab = 1
    self:ToggleControlBorS(1)
  elseif self.toggle2:GetIsOn() then
    self.lastTab = 2
    self:ToggleControlBorS(2)
  elseif self.toggle3:GetIsOn() then
    self.lastTab = 3
    self:ToggleControlBorS(3)
  end
  self:ClearWaitingForMsg()
  DataCenter.ActDispatchTaskDataManager:GetAllSingleTasksFromServer()
end

function DispatchTask:ClickTip()
  if DataCenter.ExplorerTreasureManager:IsOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 1510)
    return
  end
  if self.data ~= nil and self.data.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    local ruleStr = DataCenter.ActDispatchTaskDataManager:GetRuleStr()
    if not string.IsNullOrEmpty(ruleStr) then
      param.activityRulesStr = Localization:GetString(ruleStr)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function DispatchTask:ClickRecordBtn()
  if LuaEntry.DataConfig:CheckSwitch("secret_team_information") then
    SFSNetwork.SendMessage(MsgDefines.DispatchGetRecord, DispatchTaskRecordType.Assist)
  else
    SFSNetwork.SendMessage(MsgDefines.DispatchGetRecord, DispatchTaskRecordType.All)
  end
end

function DispatchTask:OnGetRecord()
  if LuaEntry.DataConfig:CheckSwitch("secret_team_information") then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskRecordNewView, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskRecord, {anim = true})
  end
end

function DispatchTask:ClickStarBtn()
  self.tip_root:ShowIt()
end

function DispatchTask:DoTaskRefresh()
  if self.refreshCount == 0 then
    UIUtil.ShowTips(Localization:GetString("dispatch_des023"))
    return
  end
  DataCenter.ActDispatchTaskDataManager:SetNeedPlayedSweepEffect(true)
  if self.useGoodRefresh then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.RefreshDispatchTask, Localization:GetString("456291"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if self.__waitingForMsg then
        return
      end
      SFSNetwork.SendMessage(MsgDefines.DispatchTaskRefresh, 1)
      self:SetWaitingForMsg()
    end, function()
    end, nil, nil, false, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold), nil)
  else
    if self.__waitingForMsg then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.DispatchTaskRefresh, 0)
    self:SetWaitingForMsg()
  end
end

function DispatchTask:ClickRefreshBtn()
  if self.useGoodRefresh then
    local coinCount, itemId, itemCount = DataCenter.ActDispatchTaskDataManager:GetTaskRefreshSetting()
    if coinCount > LuaEntry.Player.gold then
      UIUtil.ShowTipsId("E100001")
      return
    end
  end
  local hasBestTask = false
  if self.showDatalist then
    for _, v in ipairs(self.showDatalist) do
      if v.completionTime == 0 and v.cfg.color == 5 then
        hasBestTask = true
        break
      end
    end
  end
  if hasBestTask then
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.RefreshBestDispatchTask, Localization:GetString("456292"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:DoTaskRefresh()
    end, function()
    end, nil, nil, false, nil, nil)
  else
    self:DoTaskRefresh()
  end
end

function DispatchTask:ClearScroll()
  self.scroll_view:ClearAllItems()
  self.content:RemoveComponents(DispatchTaskItem)
  self.scrollCellPool = {}
  self.showDatalist = {}
end

function DispatchTask:ToggleControlBorS(tab)
  self.tab = tab
  self:RefreshAll(true)
  if tab == 2 then
    DataCenter.ActDispatchTaskDataManager:GetAllAllianceTasksFromServer()
  end
  if tab == 3 and not CommonUtil.PlayerPrefsGetBool(SettingKeys.DISPATCH_TASK_MARK_LIST_PLOT, false) then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.DISPATCH_TASK_MARK_LIST_PLOT, true)
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 9290, hideMainUI = false})
  end
  DataCenter.ActDispatchTaskDataManager:SendGetMarkList(tab == 3)
end

function DispatchTask:RefreshSingleTask()
  if self.tab == 1 then
    self:RefreshSingle()
  else
    self:RefreshRedPoint()
  end
end

function DispatchTask:OnDispatchTaskUpdateAll()
  self:ClearWaitingForMsg()
  ProfilerUtil.BeginSample("DispatchTaskUpdateAll")
  self:RefreshAll()
  ProfilerUtil.EndSample()
end

function DispatchTask:RefreshAllianceTask()
  ProfilerUtil.BeginSample("RefreshAllianceTask")
  if self.tab == 2 then
    self:RefreshAll()
  else
    self:RefreshAlncRedPoint()
  end
  ProfilerUtil.EndSample()
end

function DispatchTask:OnDispatchTaskDeleteAllianceItem()
  ProfilerUtil.BeginSample("DispatchTaskDeleteAllianceItem")
  if self.tab == 2 then
    self:RefreshAll()
    DataCenter.ActDispatchTaskDataManager:GetAllAllianceTasksFromServer()
  else
    self:RefreshAlncRedPoint()
  end
  ProfilerUtil.EndSample()
end

function DispatchTask:RefreshSingle()
  if self.lastTab ~= self.tab then
    return
  end
  self:UpdateRefreshButton()
  self:RefreshTodayNum()
  self:RefreshRedPoint()
  self:RefreshAlncRedPoint()
  if (self.tab == 2 or self.tab == 3) and not LuaEntry.Player:IsInAlliance() then
    self.no_alliance_go:SetActive(true)
    self.scroll_view:SetActive(false)
    return
  end
  self.no_alliance_go:SetActive(false)
  self.scroll_view:SetActive(true)
  if self.tab == 1 then
    self:CheckSuperBtnStatus()
  else
    return
  end
  if #self.showDatalist > 0 then
    self.empty_go:SetActive(false)
    self.scroll_view:RefreshAllShownItem()
  else
    self:UpdateEmptyText()
    self.empty_go:SetActive(true)
    self.scroll_view:SetActive(false)
  end
end

function DispatchTask:RefreshAll(moveToBegin)
  if self.lastTab ~= self.tab then
    self.lastTab = self.tab
  end
  ProfilerUtil.BeginSample("RefreshExplorerTreasureInfo")
  self:RefreshExplorerTreasureInfo()
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("UpdateRefreshButton")
  self:UpdateRefreshButton()
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("RefreshTodayNum")
  self:RefreshTodayNum()
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("RefreshRedPoint")
  self:RefreshRedPoint()
  ProfilerUtil.EndSample()
  self:RefreshAlncRedPoint()
  self:RefreshMarkListRedPoint()
  if (self.tab == 2 or self.tab == 3) and not LuaEntry.Player:IsInAlliance() then
    self.no_alliance_go:SetActive(true)
    self.scroll_view:SetActive(false)
    return
  end
  self:RefreshList(moveToBegin)
end

function DispatchTask:RefreshList(moveToBegin)
  ProfilerUtil.BeginSample("RefreshAllOther")
  self.no_alliance_go:SetActive(false)
  self.scroll_view:SetActive(true)
  if self.tab == 1 then
    ProfilerUtil.BeginSample("GetAllSingleTasks")
    self.showDatalist = DataCenter.ActDispatchTaskDataManager:GetAllSingleTasks()
    ProfilerUtil.EndSample()
    DataCenter.ActDispatchTaskDataManager:TriggerPlot()
    self:CheckNeedPlaySweepEffect()
    ProfilerUtil.BeginSample("CheckSuperBtnStatus")
    self:CheckSuperBtnStatus()
    ProfilerUtil.EndSample()
  elseif self.tab == 2 then
    ProfilerUtil.BeginSample("GetAllAllianceTasks")
    self.showDatalist = DataCenter.ActDispatchTaskDataManager:GetAllAllianceTasks()
    ProfilerUtil.EndSample()
  elseif self.tab == 3 then
    ProfilerUtil.BeginSample("GetAllMarkList")
    self.showDatalist = DataCenter.ActDispatchTaskDataManager:GetMarkList()
    ProfilerUtil.EndSample()
  end
  if #self.showDatalist > 0 then
    self.empty_go:SetActive(false)
    ProfilerUtil.BeginSample("RefreshCells")
    self.scroll_view:SetListItemCount(#self.showDatalist, false, false)
    if moveToBegin then
      self.scroll_view:MovePanelToItemIndex(0, 0)
    else
      self.scroll_view:RefreshAllShownItem()
    end
    ProfilerUtil.EndSample()
  else
    self:UpdateEmptyText()
    self.empty_go:SetActive(true)
    self.scroll_view:SetActive(false)
  end
  ProfilerUtil.EndSample()
end

function DispatchTask:UpdateEmptyText()
  local tab = checknumber(self.tab)
  if tab == 1 or tab == 2 then
    if LuaEntry.Player:AtHomeNow() or DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() then
      self.empty_txt:SetLocalText(456232)
    else
      self.empty_txt:SetLocalText(500021)
    end
  else
    self.empty_txt:SetLocalText("dispatch_quick_mark_empty_desc")
  end
end

function DispatchTask:CheckNeedPlaySweepEffect()
  if not self.showDatalist then
    return
  end
  local bNeedPlayedEffect = DataCenter.ActDispatchTaskDataManager:GetNeedPlayedSweepEffect()
  for i, v in ipairs(self.showDatalist) do
    if v.completionTime == 0 then
      v.isNeedPlayOrangeEffect = bNeedPlayedEffect and v.cfg.color == ItemColor.ORANGE
      v.isNeedPlayNormalEffect = bNeedPlayedEffect and v.cfg.color ~= ItemColor.ORANGE
    end
  end
  DataCenter.ActDispatchTaskDataManager:SetNeedPlayedSweepEffect(false)
end

function DispatchTask:CheckSuperBtnStatus()
  if self.tab ~= 1 then
    return
  end
  local superRefreshCount = 0
  local refreshCount = 0
  local dispatchCount = 0
  for _, taskInfo in ipairs(self.showDatalist) do
    if taskInfo.completionTime == 0 and taskInfo.cfg then
      if taskInfo.cfg.color < 5 then
        superRefreshCount = superRefreshCount + 1
      end
      refreshCount = refreshCount + 1
      dispatchCount = dispatchCount + 1
    end
  end
  self.superRefreshCount = superRefreshCount
  self.refreshCount = refreshCount
  self.dispatchCount = dispatchCount
  UIGray.SetGray(self.refresh_btn_bg.transform, self.refreshCount == 0, true)
  UIGray.SetGray(self.super_refresh_bg.transform, self.refreshCount == 0 or self.superRefreshCount == 0, true)
  UIGray.SetGray(self.super_dispatch_bg.transform, self.refreshCount == 0 or self.dispatchCount == 0, true)
end

function DispatchTask:RefreshTodayNum()
  local mgr = DataCenter.ActDispatchTaskDataManager
  local aid_count = mgr:GetDispatchSetting("aid_count")
  local steal_count = mgr:GetDispatchSetting("steal_count")
  local AssNum = mgr:GetTodayAssistNum()
  local StealNum = mgr:GetTodayStealNum()
  local con = Localization:GetString(135225, AssNum, aid_count)
  if aid_count > AssNum then
    local cont = "<color=#3fea20>" .. con .. "</color>"
    self.txt_ass_num:SetText(cont)
  else
    self.txt_ass_num:SetText(con)
  end
  con = Localization:GetString(135225, StealNum, steal_count)
  if steal_count > StealNum then
    local cont = "<color=#3fea20>" .. con .. "</color>"
    self.txt_plu_num:SetText(cont)
  else
    self.txt_plu_num:SetText(con)
  end
end

function DispatchTask:RefreshRedPoint()
  local redpointNum = DataCenter.ActDispatchTaskDataManager:GetSingleTaskRedCount()
  self.red_point:SetActive(0 < redpointNum)
  if 0 < redpointNum then
    self.red_num:SetText(tostring(redpointNum))
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function DispatchTask:RefreshAlncRedPoint()
  ProfilerUtil.BeginSample("RefreshAlncRedPoint")
  local mgr = DataCenter.ActDispatchTaskDataManager
  local alncCount = mgr:GetAllianceAssisTaskCount()
  local assNum = mgr:GetTodayAssistNum()
  local assistMax = toInt(mgr:GetDispatchSetting("aid_count"))
  local diff = math.max(0, assistMax - assNum)
  local count = math.min(alncCount, diff)
  self.alnc_red_point:SetActive(0 < count)
  if 0 < count then
    self.alnc_red_num:SetText(count)
  end
  ProfilerUtil.EndSample()
end

function DispatchTask:OnJoinAllianceClick()
  self.view.ctrl:CloseSelf()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    return
  end
  local params = {guide = false}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
end

function DispatchTask:DoGetRealPoint(uuid)
  for k, v in pairs(self.showDatalist) do
    if v.uuid == uuid then
      if v.pointId > 0 then
        local pointId = v.pointId
        GoToUtil.CloseAllWindows()
        GoToUtil.MoveToWorldPointAndOpen(pointId, nil, nil, LuaEntry.Player:GetSelfServerId())
      end
      break
    end
  end
end

function DispatchTask:OnNormalBtnClick()
  self:ChangeBtnStatus()
end

function DispatchTask:OnSuperBtnClick()
  local isOpen = DataCenter.ActDispatchTaskDataManager:CheckSuperModeOpen()
  if not isOpen then
    UIUtil.ShowTipsId("dispatch_des014")
    return
  end
  self:ChangeBtnStatus()
end

function DispatchTask:OnSuperRefreshBtnClick()
  if self.refreshCount == 0 then
    UIUtil.ShowTips(Localization:GetString("dispatch_des023"))
    return
  end
  local allTasks = DataCenter.ActDispatchTaskDataManager:GetAllSingleTasks()
  local validCount = 0
  for _, taskInfo in ipairs(allTasks) do
    if taskInfo.completionTime == 0 and taskInfo.cfg and taskInfo.cfg.color < 5 then
      validCount = validCount + 1
    end
  end
  if validCount == 0 then
    UIUtil.ShowTips(Localization:GetString("dispatch_des015"))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskRefreshConfirm, {anim = true})
end

function DispatchTask:OnSuperDispatchBtnClick()
  if not LuaEntry.Player:AtHomeNow() then
    local isCrossServerSwitchOpen = DataCenter.ActDispatchTaskDataManager:IsCrossServerSwitchOpen()
    if not isCrossServerSwitchOpen then
      UIUtil.ShowTips(Localization:GetString("500021"))
      return
    end
  end
  if self.dispatchCount == 0 then
    UIUtil.ShowTips(Localization:GetString("dispatch_des022"))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskSuperPopup, {anim = true})
end

function DispatchTask:OnRewardAllBtnClick()
  DataCenter.ActDispatchTaskDataManager:TryRewardAll()
end

function DispatchTask:ChangeBtnStatus()
  self.normalStatus = not self.normalStatus
  Setting:SetPrivateInt("DispatchTaskNormalStatus", self.normalStatus and 0 or 1)
  self:UpdateRefreshButton()
end

function DispatchTask:SetWaitingForMsg()
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
  end
end

function DispatchTask:ClearWaitingForMsg()
  self.__waitingForMsg = false
end

function DispatchTask:RefreshExplorerTreasureInfo()
  local isOpenExplorerTreasure = DataCenter.ExplorerTreasureManager:IsOpen()
  if isOpenExplorerTreasure then
    self.rawImageBgTreasure:LoadSpriteAsync("Assets/Main/TextureEx/UIActivityBg/Banner/ExplorerTreasure/FX_YMJJD_tanxianbaoxiaang_zhujiemian_banner.png")
    self.rawImageBgTreasure2:LoadSpriteAsync("Assets/Main/TextureEx/UIActivityBg/Banner/ExplorerTreasure/FX_YMJDD_tanxiaanbaoxiang_bg2.png")
    self.rawImageBgTreasure:SetActive(true)
  else
    self.rawImageBgTreasure:SetActive(false)
  end
  self.rawImageBgDefault:SetActive(not isOpenExplorerTreasure)
  self.txt_assTip_treasure:SetActive(isOpenExplorerTreasure)
  self.txt_pluNum_treasure:SetActive(isOpenExplorerTreasure)
  self.txt_act_extra_treasure:SetActive(isOpenExplorerTreasure)
  self.txt_act_name_treasure:SetActive(isOpenExplorerTreasure)
  self.txt_assTip:SetActive(not isOpenExplorerTreasure)
  self.txt_pluNum:SetActive(not isOpenExplorerTreasure)
  self.txt_act_extra:SetActive(not isOpenExplorerTreasure)
  self.txt_act_name:SetActive(not isOpenExplorerTreasure)
  self.objTreasure:SetActive(isOpenExplorerTreasure)
  if isOpenExplorerTreasure then
    self.scroll_view.rectTransform:Set_sizeDelta(780, -552)
    self.scroll_view.rectTransform:Set_anchoredPosition(0, -244)
    self.toggleGroup.rectTransform:Set_anchoredPosition(0, -487)
    self:RefreshExplorerTreasureItemNum()
    self:RefreshExplorerTreasureRedPointNum()
  else
    self.scroll_view.rectTransform:Set_sizeDelta(780, -452)
    self.scroll_view.rectTransform:Set_anchoredPosition(0, -184)
    self.toggleGroup.rectTransform:Set_anchoredPosition(0, -376)
  end
end

function DispatchTask:RefreshExplorerTreasureItemNum()
  local curNum = DataCenter.ExplorerTreasureManager:GetTreasureHaveItemNum()
  local maxNum = DataCenter.ExplorerTreasureManager:GetTreasureOpenNeedItemNum()
  self.textTreasureItemNum:SetText(curNum .. "/" .. maxNum)
end

function DispatchTask:RefreshExplorerTreasureRedPointNum()
  local redPointNum = DataCenter.ExplorerTreasureManager:GetRedPointCount()
  self.red_point_obj:SetActive(0 < redPointNum)
  self.tex_red_point_num:SetText(redPointNum)
end

function DispatchTask:CheckNeedShowIntro()
  local isOpenDigTreasure = DataCenter.DigTreasureManager:IsActivityOpen()
  local isShownDig = DataCenter.DigTreasureManager:CheckIsShownPlotInDispatchTask()
  if isOpenDigTreasure and not isShownDig then
    CS.GameEntry.Setting:SetPrivateBool("DigPlotShownInDispatchTask", true)
    TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 8164, hideMainUI = false})
    end, 0.4)
  end
  local isOpenExplorerTreasure = DataCenter.ExplorerTreasureManager:IsOpen()
  local isShown = DataCenter.ExplorerTreasureManager:IsIntroduceShown()
  if isOpenExplorerTreasure and not isShown then
    CS.GameEntry.Setting:SetPrivateBool("ExplorerTreasureIntroduceShown", true)
    TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIExplorerTreasureIntroduce)
    end, 0.6)
  end
end

function DispatchTask:RefreshMarkListRedPoint()
  local count = DataCenter.ActDispatchTaskDataManager:GetMarkListRedCount()
  self.mark_red_point:SetActive(0 < count)
  if 0 < count then
    self.mark_red_num:SetText(count)
  end
end

function DispatchTask:RefreshMarkList()
  if self.tab == 3 then
    self:RefreshAll()
  else
    self:RefreshMarkListRedPoint()
  end
end

function DispatchTask:OnStealSuccess(missionUuid)
  if self.tab == 3 then
    self:RefreshAll()
  else
    self:RefreshMarkListRedPoint()
  end
end

return DispatchTask
