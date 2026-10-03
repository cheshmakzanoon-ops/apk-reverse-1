local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActSlotMachine = BaseClass("ActSlotMachine", base)
local Localization = CS.GameEntry.Localization
local UnityAnimator = typeof(CS.UnityEngine.Animator)
local ResourceManager = CS.GameEntry.Resource
local ActSlotMachineProgressContent = require("UI.UIActivityCenterTable.Component.ActSlotMachine.ActSlotMachineProgressContent")
local ActSlotMachineProgressDetailContent = require("UI.UIActivityCenterTable.Component.ActSlotMachine.ActSlotMachineProgressDetailContent")
local UIActSlotMidItem = require("UI.UIActivityCenterTable.Component.ActSlotMachine.UIActSlotMidItem")
local ActSlotMachineTaskContent = require("UI.UIActivityCenterTable.Component.ActSlotMachine.ActSlotMachineTaskContent")
local bg1_path = "maskBg/bg1"
local bg_path = "maskBg/bg"
local top_content_path = "content/topContent"
local mid_content_path = "content/midContent"
local bottom_content_path = "content/bottomContent"
local act_name_path = "content/topContent/actName"
local times_path = "content/topContent/times"
local resource_icon_path = "content/topContent/ResBar/root/resourceIcon"
local resource_num_path = "content/topContent/ResBar/root/resourceNum"
local add_btn_path = "content/topContent/ResBar/addBtn"
local intro_btn_path = "content/topContent/introBtn"
local add_red_point_path = "content/topContent/ResBar/addBtn/addRedPoint"
local progress_content_path = "content/topContent/progressContent"
local progress_detail_content_path = "content/topContent/progressDetailContent"
local progress_back_btn_path = "content/topContent/progressDetailContent/progressBackBtn"
local progress_close_bg_path = "content/topContent/progressDetailContent/progressCloseBg"
local special_task_content_path = "content/midContent/SpecialTaskContent"
local roll_item_path = "content/midContent/rollContent/rollItem"
local roll_content_item1_path = "content/midContent/rollContent/rollContentItem1"
local roll_content_item2_path = "content/midContent/rollContent/rollContentItem2"
local roll_content_item3_path = "content/midContent/rollContent/rollContentItem3"
local tip_txt_path = "content/midContent/tipContent/tipTxt"
local draw_btn_path = "content/midContent/drawBtn"
local draw_btn_txt_path = "content/midContent/drawBtn/root/drawBtnTxt"
local img_cost_item_path = "content/midContent/drawBtn/root/ImgCostItem"
local text_cost_path = "content/midContent/drawBtn/root/ImgCostItem/TextCost"
local cost_change_btn_path = "content/midContent/costChangeBtn"
local cost_img_path = "content/midContent/costChangeBtn/costImg"
local cost_open_txt_path = "content/midContent/costChangeBtn/costOpenTxt"
local cost_num_txt_path = "content/midContent/costChangeBtn/costNumTxt"
local skip_btn_path = "content/bottomContent/skipBtn"
local skip_btn_be_select_path = "content/bottomContent/skipBtn/skipBtnBeSelect"
local skip_tip_path = "content/bottomContent/skipBtn/skipTip"
local draw_time_path = "content/bottomContent/drawTime"
local box_btn_path = "content/bottomContent/boxBtn"
local skip_btn_path = "content/bottomContent/skipBtn"
local btn_b_p_path = "content/topContent/BtnList/BtnBP"
local btn_change_path = "content/topContent/BtnList/BtnChange"
local root_path = "content/midContent/drawBtn/root"
local change_btn_red_point_path = "content/topContent/BtnList/BtnChange/changeBtnRedPoint"
local eff_ui_actslotmachinemain_bgglow_path = "content/midContent/rollContent/Eff_ui_actslotmachinemain_bgglow"
local ActSlotSkipBtnKeyStr = "ActSlotSkipBtnKeyStr"
local ActSlotMultipleBtnKeyStr = "ActSlotMultipleBtnKeyStr"
local eff_ui_actslotmachinemain_1_path = "content/midContent/drawBtn/Eff_ui_actslotmachinemain_qingrenjie"
local bp_btn_red_point_path = "content/topContent/BtnList/BtnBP/bpBtnRedPoint"
local box_btn_txt_path = "content/bottomContent/boxBtn/boxBtnTxt"
local box_btn_icon_path = "content/bottomContent/boxBtn/boxBtnIcon"
local eff_ui_actslotmachinemain_deng_path = "content/midContent/bg/Eff_ui_actslotmachinemain_deng"
local eff_ui_actslotmachinemain_glow1_path = "content/midContent/Eff_ui_actslotmachinemain_glow1"
local eff_ui_actslotmachinemain_glow2_path = "content/midContent/Eff_ui_actslotmachinemain_glow2"
local eff_ui_actslotmachinemain_glow3_path = "content/midContent/Eff_ui_actslotmachinemain_glow3"
local btn_record_path = "content/topContent/BtnList/BtnRecord"
local bg_effect_path = "maskBg/bg1/bgEffect"
local intro_btn_icon_path = "content/topContent/introBtn/introBtnIcon"
local btn_change_icon_path = "content/topContent/BtnList/BtnChange/BtnChangeIcon"
local bgColor_path = "maskBg/BGColor"
local midRollItemNum = 5
local midRollItemTopIndex = 3
local midRollItemInterval = 180
local quicklySpeed = 24
local normalSpeed = 8
local quickMoveTime = 2
local normalMoveTime = 1.5
local showResultTime = 0.5
local default_btn_name1_1 = "Mjc_huodong_laba_yinyuejie__bt1_1"
local default_btn_name1_2 = "Mjc_huodong_laba_yinyuejie__bt1_2"
local default_btn_name2_1 = "Mjc_huodong_laba_yinyuejie__bt2_1"
local default_btn_name2_2 = "Mjc_huodong_laba_yinyuejie__bt2_2"
local default_btn_name3_1 = "Mjc_huodong_laba_yinyuejie__bt3_1"
local default_btn_name3_2 = "Mjc_huodong_laba_yinyuejie__bt3_2"
local dengAniIdleName = "New State"
local dengAniPlayName = "Eff_ui_ActSlotMachineMain_deng"

function ActSlotMachine:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ActSlotMachine:OnDestroy()
  self:DestroyRequest()
  self:ClearMidRollContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActSlotMachine:ComponentDefine()
  self.top_content = self:AddComponent(UIBaseContainer, top_content_path)
  self.mid_content = self:AddComponent(UIBaseContainer, mid_content_path)
  self.bottom_content = self:AddComponent(UIBaseContainer, bottom_content_path)
  self.act_name = self:AddComponent(UITextMeshProUGUIEx, act_name_path)
  self.times = self:AddComponent(UITextMeshProUGUIEx, times_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.resource_num = self:AddComponent(UITextMeshProUGUIEx, resource_num_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.add_red_point = self:AddComponent(UIImage, add_red_point_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.add_btn:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.btn_b_p = self:AddComponent(UIButton, btn_b_p_path)
  self.btn_change = self:AddComponent(UIButton, btn_change_path)
  self.btn_b_p:SetOnClick(function()
    self:OnGotoBp()
  end)
  self.btn_change:SetOnClick(function()
    self:OnGotoChange()
  end)
  self.progress_content = self:AddComponent(ActSlotMachineProgressContent, progress_content_path)
  self.progress_detail_content = self:AddComponent(ActSlotMachineProgressDetailContent, progress_detail_content_path)
  self.progress_content_btn = self:AddComponent(UIButton, progress_content_path)
  self.progress_content_btn:SetOnClick(function()
    self:SetProgressViewOpen(true)
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineProgressOpen, {})
  end)
  self.progress_back_btn = self:AddComponent(UIButton, progress_back_btn_path)
  self.progress_back_btn:SetOnClick(function()
    self:SetProgressViewOpen(false)
  end)
  self.progress_close_bg = self:AddComponent(UIButton, progress_close_bg_path)
  self.progress_close_bg:SetOnClick(function()
    self:SetProgressViewOpen(false)
  end)
  self.special_task_content = self:AddComponent(ActSlotMachineTaskContent, special_task_content_path)
  self.roll_item = self:AddComponent(UIBaseContainer, roll_item_path)
  self.roll_content_item1 = self:AddComponent(UIBaseContainer, roll_content_item1_path)
  self.roll_content_item2 = self:AddComponent(UIBaseContainer, roll_content_item2_path)
  self.roll_content_item3 = self:AddComponent(UIBaseContainer, roll_content_item3_path)
  self.rollItems1 = {}
  self.rollItems2 = {}
  self.rollItems3 = {}
  self.roll_item:SetActive(false)
  self.roll_item.gameObject:GameObjectCreatePool()
  self.eff_ui_actslotmachinemain_bgglow = self:AddComponent(UIVfx, eff_ui_actslotmachinemain_bgglow_path)
  self.eff_ui_actslotmachinemain_bgglow:SetActive(false)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
  self.draw_btn = self:AddComponent(UIButton, draw_btn_path)
  self.draw_btn_img = self:AddComponent(UIImage, draw_btn_path)
  self.draw_btn_trigger = self:AddComponent(UIEventTrigger, draw_btn_path)
  self.draw_btn_ani = self:AddComponent(UIAnimator, draw_btn_path)
  self.btnRoot = self:AddComponent(UIBaseContainer, root_path)
  self.draw_btn_txt = self:AddComponent(UITextMeshProUGUIEx, draw_btn_txt_path)
  self.img_cost_item = self:AddComponent(UIImage, img_cost_item_path)
  self.text_cost = self:AddComponent(UIText, text_cost_path)
  self.cost_change_btn = self:AddComponent(UIButton, cost_change_btn_path)
  self.cost_img = self:AddComponent(UIImage, cost_img_path)
  self.cost_open_txt = self:AddComponent(UITextMeshProUGUIEx, cost_open_txt_path)
  self.cost_num_txt = self:AddComponent(UITextMeshProUGUIEx, cost_num_txt_path)
  self.draw_btn_trigger:OnPointerDown(function()
    self:BtnPointDown()
  end)
  self.draw_btn_trigger:OnPointerUp(function()
    self:BtnPointUp()
  end)
  self.draw_btn_trigger:OnPointerClick(function()
    self:OnDrawBtnClick()
  end)
  self.skip_btn = self:AddComponent(UIButton, skip_btn_path)
  self.skip_btn_be_select = self:AddComponent(UIImage, skip_btn_be_select_path)
  self.skip_tip = self:AddComponent(UIText, skip_tip_path)
  self.draw_time = self:AddComponent(UITextMeshProUGUIEx, draw_time_path)
  self.box_btn = self:AddComponent(UIButton, box_btn_path)
  self.skip_btn:SetOnClick(function()
    self:ClickSkipBtn()
  end)
  self.cost_change_btn:SetOnClick(function()
    self:ClickMultipleBtn()
  end)
  self.box_btn:SetOnClick(function()
    self:ClickBoxBtn()
  end)
  self.multiEffect = self:AddComponent(UIVfx, eff_ui_actslotmachinemain_1_path)
  self.multiEffect:SetActive(false)
  self.change_btn_red_point = self:AddComponent(UIImage, change_btn_red_point_path)
  self.bp_btn_red_point = self:AddComponent(UIImage, bp_btn_red_point_path)
  self.box_btn_txt = self:AddComponent(UITextMeshProUGUIEx, box_btn_txt_path)
  self.box_btn_icon = self:AddComponent(UIImage, box_btn_icon_path)
  self.dengContent = self:AddComponent(UIBaseContainer, eff_ui_actslotmachinemain_deng_path)
  self.eff_ui_actslotmachinemain_glow1 = self:AddComponent(UIVfx, eff_ui_actslotmachinemain_glow1_path)
  self.eff_ui_actslotmachinemain_glow2 = self:AddComponent(UIVfx, eff_ui_actslotmachinemain_glow2_path)
  self.eff_ui_actslotmachinemain_glow3 = self:AddComponent(UIVfx, eff_ui_actslotmachinemain_glow3_path)
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.btn_record = self:AddComponent(UIButton, btn_record_path)
  self.btn_record:SetOnClick(function()
    self:ClickRecordBtn()
  end)
  self.bg_effect = self:AddComponent(UIVfx, bg_effect_path)
  self.intro_btn_icon = self:AddComponent(UIImage, intro_btn_icon_path)
  self.btn_change_icon = self:AddComponent(UIImage, btn_change_icon_path)
  self.bgColor = self:AddComponent(UIImage, bgColor_path)
  self.draw_btn:SetSafeClickMode(true)
  self:CloseTopEffect()
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.cost_img:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.cost_img:SetLocalScaleXYZ(1, 1, 1)
  end
end

function ActSlotMachine:ComponentDestroy()
  self.top_content = nil
  self.mid_content = nil
  self.bottom_content = nil
  self.act_name = nil
  self.times = nil
  self.resource_icon = nil
  self.resource_num = nil
  self.add_btn = nil
  self.intro_btn = nil
  self.progress_content = nil
  self.progress_detail_content = nil
  self.roll_item = nil
  self.roll_content_item1 = nil
  self.roll_content_item2 = nil
  self.roll_content_item3 = nil
  self.tip_txt = nil
  self.draw_btn = nil
  self.draw_btn_txt = nil
  self.img_cost_item = nil
  self.text_cost = nil
  self.cost_change_btn = nil
  self.cost_img = nil
  self.cost_open_txt = nil
  self.cost_num_txt = nil
  self.skip_btn = nil
  self.skip_btn_be_select = nil
  self.skip_tip = nil
  self.draw_time = nil
  self.box_btn = nil
  self.cost_change_btn = nil
  self.cost_img = nil
  self.skip_btn = nil
  if self.multiSeq ~= nil then
    self.multiSeq:Kill()
    self.multiSeq = nil
  end
  self.bgColor = nil
  self.eff_ui_actslotmachinemain_glow1 = nil
  self.eff_ui_actslotmachinemain_glow2 = nil
  self.eff_ui_actslotmachinemain_glow3 = nil
  self.btn_record = nil
  self.bg_effect = nil
  self.intro_btn_icon = nil
  self.btn_change_icon = nil
end

function ActSlotMachine:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.costData = nil
  self.progressIsOpen = false
  self.curState = ActSlotState.Idle
  self.stateTime = 0
  self.isSkip = false
  self.isMultiple = false
  self.midRollShowData1 = {}
  self.midRollShowData2 = {}
  self.midRollShowData3 = {}
  self.midRollPicIndex1 = 0
  self.midRollPicIndex2 = 0
  self.midRollPicIndex3 = 0
  self.midRollPos1 = 0
  self.midRollPos2 = 0
  self.midRollPos3 = 0
  self.midRollTargetPos1 = 0
  self.midRollTargetPos2 = 0
  self.midRollTargetPos3 = 0
  self.tweenMsg = nil
  self.waitBackMsgTime = 0
  self.multiSeq = nil
  self.request = nil
  self.requestPath = nil
  self.dengAni = nil
  self.curDengAniName = nil
end

function ActSlotMachine:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.costData = nil
  self.progressIsOpen = nil
  self.curState = nil
  self.stateTime = nil
  self.isSkip = nil
  self.isMultiple = nil
  self.midRollShowData1 = nil
  self.midRollShowData2 = nil
  self.midRollShowData3 = nil
  self.midRollPicIndex1 = nil
  self.midRollPicIndex2 = nil
  self.midRollPicIndex3 = nil
  self.midRollPos1 = nil
  self.midRollPos2 = nil
  self.midRollPos3 = nil
  self.midRollTargetPos1 = nil
  self.midRollTargetPos2 = nil
  self.midRollTargetPos3 = nil
  self.tweenMsg = nil
  self.waitBackMsgTime = nil
  self.multiSeq = nil
  self.request = nil
  self.requestPath = nil
  self.dengAni = nil
  self.curDengAniName = nil
end

function ActSlotMachine:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActSlotDetailData, self.GetActSlotMachineDetailDataMsg)
  self:AddUIListener(EventId.ActSlotRollResult, self.GetActSlotRollResultMsg)
  self:AddUIListener(EventId.ActSlotDailyRewardUpdate, self.OnCostItemAdd)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnCostItemAdd)
  self:AddUIListener(EventId.ActSlotTaskDataUpdate, self.RefreshMidView)
  self:AddUIListener(EventId.ActSlotBoxRemove, self.RefreshBottomView)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshBpRed)
end

function ActSlotMachine:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActSlotDetailData, self.GetActSlotMachineDetailDataMsg)
  self:RemoveUIListener(EventId.ActSlotRollResult, self.GetActSlotRollResultMsg)
  self:RemoveUIListener(EventId.ActSlotDailyRewardUpdate, self.OnCostItemAdd)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnCostItemAdd)
  self:RemoveUIListener(EventId.ActSlotTaskDataUpdate, self.RefreshMidView)
  self:RemoveUIListener(EventId.ActSlotBoxRemove, self.RefreshBottomView)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshBpRed)
end

function ActSlotMachine:OnEnable()
  base.OnEnable(self)
end

function ActSlotMachine:OnDisable()
  base.OnDisable(self)
  if self.selectMultipleSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.selectMultipleSoundHandle)
    self.selectMultipleSoundHandle = nil
  end
  if self.multiple_5_BlingSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.multiple_5_BlingSoundHandle)
    self.multiple_5_BlingSoundHandle = nil
  end
  if self.drawSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.drawSoundHandle)
    self.drawSoundHandle = nil
  end
  if self.slotReelSpinSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.slotReelSpinSoundHandle)
    self.slotReelSpinSoundHandle = nil
  end
  if self.sameGiftSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.sameGiftSoundHandle)
    self.sameGiftSoundHandle = nil
  end
end

function ActSlotMachine:GetActSlotMachineDetailDataMsg()
  self:SetData(self.activityId)
end

function ActSlotMachine:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActSlotMachineDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    self:RefreshNoDataView()
    return
  end
  self.isSkip = Setting:GetInt(ActSlotSkipBtnKeyStr, 0)
  self.isMultiple = Setting:GetInt(ActSlotMultipleBtnKeyStr, 0)
  self.curState = ActSlotState.Idle
  self.draw_btn_ani.enabled = false
  self.eff_ui_actslotmachinemain_bgglow:SetActive(false)
  self.curDengAniName = dengAniIdleName
  self:InitData()
  self:InitView()
  self:RefreshView()
  self:InitMidRollContent()
  self:CloseTopEffect()
  self:TryPlayDengAni()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
  PostEventLog.Track(PostEventLog.Defines.ActSlotMachineMainOpen, {})
end

function ActSlotMachine:InitData()
  self.btn_name1_1 = default_btn_name1_1
  self.btn_name1_2 = default_btn_name1_2
  self.btn_name2_1 = default_btn_name2_1
  self.btn_name2_2 = default_btn_name2_2
  self.btn_name3_1 = default_btn_name3_1
  self.btn_name3_2 = default_btn_name3_2
  if self.activityDetailData then
    local infoTemp = self.activityDetailData.infoTemp
    if infoTemp and infoTemp.btn_pic and #infoTemp.btn_pic == 6 then
      self.btn_name3_1 = infoTemp.btn_pic[1]
      self.btn_name3_2 = infoTemp.btn_pic[2]
      self.btn_name1_1 = infoTemp.btn_pic[3]
      self.btn_name1_2 = infoTemp.btn_pic[4]
      self.btn_name2_1 = infoTemp.btn_pic[5]
      self.btn_name2_2 = infoTemp.btn_pic[6]
    end
  end
end

function ActSlotMachine:InitView()
  self.top_content:SetActive(true)
  self.mid_content:SetActive(true)
  self.bottom_content:SetActive(true)
  if self.activityDetailData then
    local infoTemp = self.activityDetailData.infoTemp
    if infoTemp and infoTemp.big_box_pic and #infoTemp.big_box_pic >= 1 then
      local iconName = infoTemp.big_box_pic[1]
      local iconPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, iconName)
      self.box_btn_icon:LoadSprite(iconPath)
    end
  end
  self.multiEffect:SetActive(false)
  local bannerName = self.activityInfo.activity_pic
  if not string.IsNullOrEmpty(bannerName) then
    local bannerPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ActSlotMachineTexturePath, bannerName)
    self.bg:LoadSprite(bannerPath)
  end
  local showTemp = self.activityInfo:GetShowConfigTemp()
  self.showTemp = showTemp
  if showTemp then
    if not string.IsNullOrEmpty(showTemp.pic_spec1) then
      local bg1Path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ActSlotMachineTexturePath, showTemp.pic_spec1)
      self.bg1:LoadSprite(bg1Path)
    end
    if not string.IsNullOrEmpty(showTemp.banner_effect) then
      self.bg_effect:Play(showTemp.banner_effect, {
        lifeType = UIVfxLifeType.Stay
      })
    else
      self.bg_effect:Remove()
    end
    local allSameEffectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/laba/Eff_ui_actslotmachinemain_bgglow.prefab"
    if not string.IsNullOrEmpty(showTemp.pic_spec5) then
      allSameEffectPath = showTemp.pic_spec5
    end
    self.eff_ui_actslotmachinemain_bgglow:Play(allSameEffectPath, {
      lifeType = UIVfxLifeType.Stay
    })
    local dengEffectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/laba/Eff_ui_actslotmachinemain_glow1.prefab"
    if not string.IsNullOrEmpty(showTemp.pic_spec2) then
      dengEffectPath = showTemp.pic_spec2
    end
    self.eff_ui_actslotmachinemain_glow1:Play(dengEffectPath, {
      lifeType = UIVfxLifeType.Stay
    })
    self.eff_ui_actslotmachinemain_glow2:Play(dengEffectPath, {
      lifeType = UIVfxLifeType.Stay
    })
    self.eff_ui_actslotmachinemain_glow3:Play(dengEffectPath, {
      lifeType = UIVfxLifeType.Stay
    })
    local arrowObjPath = "Assets/_Art_LastWar/Effect/Prefab/UI/laba/Eff_ui_actslotmachinemain_deng.prefab"
    if not string.IsNullOrEmpty(showTemp.pic_spec3) then
      arrowObjPath = showTemp.pic_spec3
    end
    local oldAniPath = self.requestPath
    if oldAniPath ~= arrowObjPath then
      self:DestroyRequest()
      self.requestPath = arrowObjPath
      local request = ResourceManager:InstantiateAsync(self.requestPath)
      self.request = request
      request:completed("+", function()
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(self.dengContent.transform)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform:Set_localPosition(0, 0, 0)
        self.dengAni = self.request.gameObject.transform:GetComponentInChildren(UnityAnimator)
        self:TryPlayDengAni()
      end)
    else
      self:TryPlayDengAni()
    end
  end
  if self.activityDetailData then
    local infoTemp = self.activityDetailData.infoTemp
    if infoTemp then
      local intro_btn_icon_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_xiangqing.png"
      if not string.IsNullOrEmpty(infoTemp.info_btn_pic) then
        intro_btn_icon_path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, infoTemp.info_btn_pic)
        self.intro_btn_icon:LoadSprite(intro_btn_icon_path)
        self.intro_btn_icon:SetNativeSize()
      end
      local btn_change_icon_path = "Assets/Main/Sprites/UI/ActSlotMachine/zxl_huodong_laba_manyuejie_bt_duihuan.png"
      if not string.IsNullOrEmpty(infoTemp.exchange_btn_pic) then
        btn_change_icon_path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, infoTemp.exchange_btn_pic)
        self.btn_change_icon:LoadSprite(btn_change_icon_path)
      end
      if not string.IsNullOrEmpty(infoTemp.main_bgcolor) then
        local rgbaArr = string.split(infoTemp.main_bgcolor, ";")
        if rgbaArr and 4 <= #rgbaArr then
          self.bgColor:SetColorRGBA255(tonumber(rgbaArr[1]), tonumber(rgbaArr[2]), tonumber(rgbaArr[3]), tonumber(rgbaArr[4]))
        end
      end
    end
  end
end

function ActSlotMachine:RefreshView()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  self.costData = self.activityDetailData.infoTemp.costData
  self.special_task_content:SetData(self, self.activityId, self.activityInfo, self.activityDetailData)
  self:RefreshTopView()
  self:RefreshMidView()
  self:RefreshBottomView()
end

function ActSlotMachine:RefreshTopView()
  self.act_name:SetLocalText(self.activityInfo.name)
  self.actValid = self.activityInfo:IsValid()
  self:Update1000MS()
  local costData = self.costData
  if costData then
    local costId = costData.itemId
    local iconPath = DataCenter.RewardManager:GetPicByType(costData.type, costData.itemId)
    self.resource_icon:LoadSprite(iconPath)
    local curNum = DataCenter.ItemData:GetItemRealCount(costId)
    self.resource_num:SetText(curNum)
  end
  self:RefreshProgressView()
  self.add_red_point:SetActive(DataCenter.ActSlotMachineDataManager:CanGetFreePack(tonumber(self.activityId)))
  self:RefreshBpRed()
  local showConfig = self.activityInfo:GetShowConfigTemp()
  UIActivityCenterCommonUtil.SetTopViewColor(self.act_name.gameObject, nil, self.times.gameObject, showConfig)
end

function ActSlotMachine:RefreshBpRed()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  local infoTemp = self.activityDetailData.infoTemp
  local bpId = tonumber(infoTemp.bp_id) or 0
  local num = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.BattlePass_new.Type, bpId)
  self.bp_btn_red_point:SetActive(0 < num)
  local jumpTo = self.activityInfo:GetFirstActiveJumpTo()
  local changeNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.CitySkinExchange.Type, jumpTo)
  self.change_btn_red_point:SetActive(0 < changeNum)
end

function ActSlotMachine:RefreshMidView()
  local costData = self.costData
  local iconPath = DataCenter.RewardManager:GetPicByType(costData.type, costData.itemId)
  self.img_cost_item:LoadSprite(iconPath)
  self.special_task_content:RefreshView()
  self:RefreshMultipleBtn(true)
end

function ActSlotMachine:RefreshMultipleBtn(setBtnImg)
  local isMultiple = self.isMultiple
  local imgName = isMultiple == 1 and self.btn_name2_1 or self.btn_name2_2
  local costImgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, imgName)
  self.cost_img:LoadSprite(costImgPath)
  local openTxtKey = isMultiple == 1 and "activity_slots_tips028" or "activity_slots_tips029"
  self.cost_open_txt:SetLocalText(openTxtKey)
  local cfgDrawNum = self.activityDetailData.infoTemp.cost_item_multiple
  local drawNum = isMultiple == 1 and cfgDrawNum or 1
  local costKey = isMultiple == 1 and "activity_slots_tips027" or "activity_slots_tips026"
  self.cost_num_txt:SetLocalText(costKey)
  local isHaveFree = self.activityDetailData:IsHaveFreeLottery()
  local freeNum = isHaveFree and 1 or 0
  local costNum = self.costData.num * (drawNum - freeNum)
  self.text_cost:SetText("x" .. costNum)
  local costId = self.costData.itemId
  local curNum = DataCenter.ItemData:GetItemRealCount(costId)
  if costNum > curNum then
    self.text_cost:SetColorRGBA(0.937, 0.329, 0.259, 1)
  else
    self.text_cost:SetColorRGBA(1, 1, 1, 1)
  end
  if setBtnImg then
    self:SetBtnImg(false)
  end
end

function ActSlotMachine:RefreshBottomView()
  self.skip_btn_be_select:SetActive(self.isSkip > 0)
  self.draw_time:SetLocalText(2000344, self.activityDetailData.dayTimes)
  self.box_btn:SetActive(0 < #self.activityDetailData.eventBox)
  if 0 < #self.activityDetailData.eventBox then
    local lastBox = self.activityDetailData.eventBox[#self.activityDetailData.eventBox]
    local boxId = lastBox.id
    local infoTemp = self.activityDetailData.infoTemp
    local eventid = infoTemp.eventid
    local boxRateData = DataCenter.ActSlotMachineDataManager.boxTempDict[eventid]
    local boxTemp = boxRateData[boxId]
    self.box_btn_txt:SetLocalText(boxTemp.name)
  end
end

function ActSlotMachine:RefreshProgressView()
  if self.progressIsOpen then
    self.progress_content:SetActive(false)
    self.progress_detail_content:SetActive(true)
    self.progress_detail_content:SetData(self.activityId, self.activityInfo, self.activityDetailData)
  else
    self.progress_content:SetActive(true)
    self.progress_detail_content:SetActive(false)
    self.progress_content:SetData(self.activityId, self.activityInfo, self.activityDetailData)
  end
end

function ActSlotMachine:SetProgressViewOpen(isOpen)
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if self.progressIsOpen == isOpen then
    return
  end
  self.progressIsOpen = isOpen
  self:RefreshProgressView()
end

function ActSlotMachine:InitMidRollContent()
  self:ClearMidRollContent()
  local infoTemp = self.activityDetailData.infoTemp
  local groupId = infoTemp.pic_group
  local picData = DataCenter.ActSlotMachineDataManager.picDict[groupId]
  local rollData = picData[1]
  self.midRollShowData1 = {}
  for i = 1, #rollData do
    local tempData = rollData[i]
    local iconId = tempData.icon_id
    local iconTemp = DataCenter.ActSlotMachineDataManager.iconDict[iconId]
    table.insert(self.midRollShowData1, {iconId = iconId, iconTemp = iconTemp})
  end
  rollData = picData[2]
  self.midRollShowData2 = {}
  for i = 1, #rollData do
    local tempData = rollData[i]
    local iconId = tempData.icon_id
    local iconTemp = DataCenter.ActSlotMachineDataManager.iconDict[iconId]
    table.insert(self.midRollShowData2, {iconId = iconId, iconTemp = iconTemp})
  end
  rollData = picData[3]
  self.midRollShowData3 = {}
  for i = 1, #rollData do
    local tempData = rollData[i]
    local iconId = tempData.icon_id
    local iconTemp = DataCenter.ActSlotMachineDataManager.iconDict[iconId]
    table.insert(self.midRollShowData3, {iconId = iconId, iconTemp = iconTemp})
  end
  self.midRollPicIndex1 = -1
  self.midRollPicIndex2 = -1
  self.midRollPicIndex3 = -1
  self.midRollPos1 = 0
  self.midRollPos2 = 0
  self.midRollPos3 = 0
  for i = 1, midRollItemNum do
    local index = i
    local item = self.roll_item.gameObject:GameObjectSpawn(self.roll_content_item1.transform)
    item.name = index
    local obj = self.roll_content_item1:AddComponent(UIActSlotMidItem, item.name)
    obj:SetActive(true)
    self.rollItems1[index] = obj
  end
  for i = 1, midRollItemNum do
    local index = i
    local item = self.roll_item.gameObject:GameObjectSpawn(self.roll_content_item2.transform)
    item.name = index
    local obj = self.roll_content_item2:AddComponent(UIActSlotMidItem, item.name)
    obj:SetActive(true)
    self.rollItems2[index] = obj
  end
  for i = 1, midRollItemNum do
    local index = i
    local item = self.roll_item.gameObject:GameObjectSpawn(self.roll_content_item3.transform)
    item.name = index
    local obj = self.roll_content_item3:AddComponent(UIActSlotMidItem, item.name)
    obj:SetActive(true)
    self.rollItems3[index] = obj
  end
  self:RefrehMidRollContent(true)
end

function ActSlotMachine:RefrehMidRollContent(forcePicChange)
  if self.midRollPos1 < 0 then
    local needAdd = math.modf(math.abs(self.midRollPos1) / midRollItemNum)
    self.midRollPos1 = self.midRollPos1 + (needAdd + 1) * midRollItemNum
  end
  if 0 > self.midRollPos2 then
    local needAdd = math.modf(math.abs(self.midRollPos2) / midRollItemNum)
    self.midRollPos2 = self.midRollPos2 + (needAdd + 1) * midRollItemNum
  end
  if 0 > self.midRollPos3 then
    local needAdd = math.modf(math.abs(self.midRollPos3) / midRollItemNum)
    self.midRollPos3 = self.midRollPos3 + (needAdd + 1) * midRollItemNum
  end
  for i = 1, midRollItemNum do
    local curPos = self.midRollPos1 + (i - 1)
    local diffNum = math.modf(curPos / midRollItemNum)
    local realPos = curPos - diffNum * midRollItemNum
    local posY = 0
    if realPos < midRollItemTopIndex then
      posY = 0 - midRollItemInterval * realPos
    else
      posY = 0 + (midRollItemNum - realPos) * midRollItemInterval
    end
    self.rollItems1[i]:SetAnchoredPositionXY(0, posY)
  end
  for i = 1, midRollItemNum do
    local curPos = self.midRollPos2 + (i - 1)
    local diffNum = math.modf(curPos / midRollItemNum)
    local realPos = curPos - diffNum * midRollItemNum
    local posY = 0
    if realPos < midRollItemTopIndex then
      posY = 0 - midRollItemInterval * realPos
    else
      posY = 0 + (midRollItemNum - realPos) * midRollItemInterval
    end
    self.rollItems2[i]:SetAnchoredPositionXY(0, posY)
  end
  for i = 1, midRollItemNum do
    local curPos = self.midRollPos3 + (i - 1)
    local diffNum = math.modf(curPos / midRollItemNum)
    local realPos = curPos - diffNum * midRollItemNum
    local posY = 0
    if realPos < midRollItemTopIndex then
      posY = 0 - midRollItemInterval * realPos
    else
      posY = 0 + (midRollItemNum - realPos) * midRollItemInterval
    end
    self.rollItems3[i]:SetAnchoredPositionXY(0, posY)
  end
  local isBlur = self.curState == ActSlotState.MidQuicklyAni
  if forcePicChange or self.midRollPos1 >= self.midRollPicIndex1 + 1 then
    self.midRollPicIndex1 = math.modf(self.midRollPos1)
    local dataNum = #self.midRollShowData1
    for i = 1, midRollItemNum do
      local dataIndex = self.midRollPicIndex1 - (midRollItemTopIndex - i)
      local realDataIndex = dataIndex
      if dataIndex < 0 then
        local dNum = math.modf(-dataIndex / dataNum)
        realDataIndex = dataIndex + (dNum + 1) * dataNum + 1
      else
        realDataIndex = dataIndex % dataNum + 1
      end
      local posIndex = self.midRollPicIndex1 % midRollItemNum
      local realPosIndex = 0
      if posIndex < midRollItemTopIndex then
        realPosIndex = midRollItemTopIndex - posIndex
      else
        realPosIndex = midRollItemTopIndex - posIndex + midRollItemNum
      end
      realPosIndex = (realPosIndex - (i - 1) + midRollItemNum) % midRollItemNum
      if realPosIndex == 0 then
        realPosIndex = midRollItemNum
      end
      self.rollItems1[realPosIndex]:SetData(self.midRollShowData1[realDataIndex], isBlur, self.showTemp and self.showTemp.pic_spec4 or nil)
    end
  end
  if forcePicChange or self.midRollPos2 >= self.midRollPicIndex2 + 1 then
    self.midRollPicIndex2 = math.modf(self.midRollPos2)
    local dataNum = #self.midRollShowData2
    for i = 1, midRollItemNum do
      local dataIndex = self.midRollPicIndex2 - (midRollItemTopIndex - i)
      local realDataIndex = dataIndex
      if dataIndex < 0 then
        local dNum = math.modf(-dataIndex / dataNum)
        realDataIndex = dataIndex + (dNum + 1) * dataNum + 1
      else
        realDataIndex = dataIndex % dataNum + 1
      end
      local posIndex = self.midRollPicIndex2 % midRollItemNum
      local realPosIndex = 0
      if posIndex < midRollItemTopIndex then
        realPosIndex = midRollItemTopIndex - posIndex
      else
        realPosIndex = midRollItemTopIndex - posIndex + midRollItemNum
      end
      realPosIndex = (realPosIndex - (i - 1) + midRollItemNum) % midRollItemNum
      if realPosIndex == 0 then
        realPosIndex = midRollItemNum
      end
      self.rollItems2[realPosIndex]:SetData(self.midRollShowData2[realDataIndex], isBlur, self.showTemp and self.showTemp.pic_spec4 or nil)
    end
  end
  if forcePicChange or self.midRollPos3 >= self.midRollPicIndex3 + 1 then
    self.midRollPicIndex3 = math.modf(self.midRollPos3)
    local dataNum = #self.midRollShowData3
    for i = 1, midRollItemNum do
      local dataIndex = self.midRollPicIndex3 - (midRollItemTopIndex - i)
      local realDataIndex = dataIndex
      if dataIndex < 0 then
        local dNum = math.modf(-dataIndex / dataNum)
        realDataIndex = dataIndex + (dNum + 1) * dataNum + 1
      else
        realDataIndex = dataIndex % dataNum + 1
      end
      local posIndex = self.midRollPicIndex3 % midRollItemNum
      local realPosIndex = 0
      if posIndex < midRollItemTopIndex then
        realPosIndex = midRollItemTopIndex - posIndex
      else
        realPosIndex = midRollItemTopIndex - posIndex + midRollItemNum
      end
      realPosIndex = (realPosIndex - (i - 1) + midRollItemNum) % midRollItemNum
      if realPosIndex == 0 then
        realPosIndex = midRollItemNum
      end
      self.rollItems3[realPosIndex]:SetData(self.midRollShowData3[realDataIndex], isBlur, self.showTemp and self.showTemp.pic_spec4 or nil)
    end
  end
end

function ActSlotMachine:ClearMidRollContent()
  self.roll_content_item1:RemoveComponents(UIActSlotMidItem)
  for _, v in ipairs(self.roll_content_item1.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.roll_content_item2:RemoveComponents(UIActSlotMidItem)
  for _, v in ipairs(self.roll_content_item2.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.roll_content_item3:RemoveComponents(UIActSlotMidItem)
  for _, v in ipairs(self.roll_content_item3.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.roll_item.gameObject:GameObjectRecycleAll()
  self.rollItems1 = {}
  self.rollItems2 = {}
  self.rollItems3 = {}
end

function ActSlotMachine:OnCostItemAdd()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  self:RefreshTopView()
  self:RefreshBottomView()
  self:RefreshMultipleBtn()
end

function ActSlotMachine:RefreshNoDataView()
  self.top_content:SetActive(false)
  self.mid_content:SetActive(false)
  self.bottom_content:SetActive(false)
end

function ActSlotMachine:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.times:SetText(countDownTimeStr)
end

function ActSlotMachine:Update()
  if self.stateTime == nil then
    return
  end
  if self.curState == ActSlotState.Idle then
    return
  end
  local deltaTime = Time.deltaTime
  self.stateTime = self.stateTime - deltaTime
  if self.curState == ActSlotState.MidQuicklyAni then
    self.midRollPos1 = self.midRollPos1 + deltaTime * quicklySpeed
    self.midRollPos2 = self.midRollPos2 + deltaTime * quicklySpeed
    self.midRollPos3 = self.midRollPos3 + deltaTime * quicklySpeed
    self:RefrehMidRollContent()
  elseif self.curState == ActSlotState.MidResultAni then
    if self.midRollPos1 >= self.midRollTargetPos1 then
      self.midRollPos1 = self.midRollTargetPos1
    else
      local speed = normalSpeed
      local minNum = 3
      if minNum < self.midRollTargetPos1 - self.midRollPos1 then
        local addRate = (self.midRollTargetPos1 - self.midRollPos1) / minNum
        speed = normalSpeed * addRate * addRate * addRate
        speed = math.min(speed, quicklySpeed)
      end
      self.midRollPos1 = self.midRollPos1 + deltaTime * normalSpeed
      self.midRollPos1 = math.min(self.midRollPos1, self.midRollTargetPos1)
    end
    if self.midRollPos2 >= self.midRollTargetPos2 then
      self.midRollPos2 = self.midRollTargetPos2
    else
      local speed = normalSpeed
      if speed < self.midRollTargetPos2 - self.midRollPos2 then
        speed = self.midRollTargetPos2 - self.midRollPos2
      end
      self.midRollPos2 = self.midRollPos2 + deltaTime * normalSpeed
      self.midRollPos2 = math.min(self.midRollPos2, self.midRollTargetPos2)
    end
    if self.midRollPos3 >= self.midRollTargetPos3 then
      self.midRollPos3 = self.midRollTargetPos3
    else
      local speed = normalSpeed
      if speed < self.midRollTargetPos3 - self.midRollPos3 then
        speed = self.midRollTargetPos3 - self.midRollPos3
      end
      self.midRollPos3 = self.midRollPos3 + deltaTime * normalSpeed
      self.midRollPos3 = math.min(self.midRollPos3, self.midRollTargetPos3)
    end
    self:RefrehMidRollContent()
  elseif self.curState == ActSlotState.MidShowAni then
  end
  if self.stateTime <= 0 then
    self:TryStateChange()
  end
end

function ActSlotMachine:ClickTip()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local param = {
    activityId = self.activityId,
    activityInfo = self.activityInfo,
    activityDetailData = self.activityDetailData
  }
  local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.activityId, UIWindowNames.UIActSlotMachineTipCommon)
  if isUse then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineTipCommon, {anim = true}, param)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineTip, {anim = true}, param)
  end
end

function ActSlotMachine:ClickSkipBtn()
  if self.activityDetailData == nil then
    return
  end
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if self.isSkip <= 0 then
    self.isSkip = 1
  else
    self.isSkip = 0
  end
  Setting:SetInt(ActSlotSkipBtnKeyStr, self.isSkip)
  self:RefreshBottomView()
  if self.isSkip == 1 then
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineSkipAniOpen, {})
  end
end

function ActSlotMachine:ClickMultipleBtn()
  if self.activityDetailData == nil then
    return
  end
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if self.isMultiple <= 0 then
    self.isMultiple = 1
  else
    self.isMultiple = 0
  end
  Setting:SetInt(ActSlotMultipleBtnKeyStr, self.isMultiple)
  self:RefreshMultipleBtn(false)
  if self.isMultiple == 1 then
    self.draw_btn_ani:Play("Eff_ui_ActSlotMachineMain_anniubian")
    self.multiEffect:SetActive(false)
    self.multiEffect:SetActive(true)
    local infoTemp = self.activityDetailData.infoTemp
    local btnEffectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/laba/Eff_ui_actslotmachinemain_qingrenjie.prefab"
    if infoTemp and not string.IsNullOrEmpty(infoTemp.btn_effect) then
      btnEffectPath = infoTemp.btn_effect
    end
    self.multiEffect:Play(btnEffectPath, {
      lifeType = UIVfxLifeType.Stay
    })
    if self.multiSeq ~= nil then
      self.multiSeq:Kill()
      self.multiSeq = nil
    end
    self.multiSeq = CS.DG.Tweening.DOTween.Sequence()
    self.draw_btn_img:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, self.btn_name3_1))
    self.multiSeq:AppendInterval(0.3)
    self.multiSeq:AppendCallback(function()
      self.draw_btn_img:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, self.btn_name1_1))
    end)
  else
    local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, self.btn_name3_1)
    self.draw_btn_img:LoadSprite(imgPath)
    self.multiEffect:SetActive(false)
  end
  if self.isMultiple == 1 then
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineMultipleOpen, {})
  else
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineMultipleClose, {})
  end
  self:PlaySoundEffect()
end

function ActSlotMachine:PlaySoundEffect()
  if self.selectMultipleSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.selectMultipleSoundHandle)
    self.selectMultipleSoundHandle = nil
  end
  self.selectMultipleSoundHandle = DataCenter.LWSoundManager:PlaySound(202622, false)
  if self.isMultiple == 1 then
    if self.multiple_5_BlingSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.multiple_5_BlingSoundHandle)
      self.multiple_5_BlingSoundHandle = nil
    end
    self.multiple_5_BlingSoundHandle = DataCenter.LWSoundManager:PlaySound(202620, false)
  end
end

function ActSlotMachine:OpenTaskView()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.activityId, UIWindowNames.UIActSlotMachineTaskCommon)
  if not isUse then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineTask, {anim = true}, self.activityId)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineTaskCommon, {anim = true}, self.activityId)
  end
end

function ActSlotMachine:CanClickBtn()
  local canClick = true
  if self.curState ~= ActSlotState.Idle then
    canClick = false
  end
  return canClick
end

function ActSlotMachine:OnDrawBtnClick()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local cfgDrawNum = self.activityDetailData.infoTemp.cost_item_multiple
  local drawNum = self.isMultiple == 1 and cfgDrawNum or 1
  local isHaveFree = self.activityDetailData:IsHaveFreeLottery()
  local freeNum = isHaveFree and 1 or 0
  local costNum = self.costData.num * (drawNum - freeNum)
  local costId = self.costData.itemId
  local curNum = DataCenter.ItemData:GetItemRealCount(costId)
  if costNum <= curNum then
    local curTime = Time.time
    if self.waitBackMsgTime and curTime < self.waitBackMsgTime then
      return
    end
    self.waitBackMsgTime = curTime + 5
    SFSNetwork.SendMessage(MsgDefines.SlotsLottey, tonumber(self.activityId), isHaveFree, self.isMultiple == 1)
  else
    self:OnGotoBtnClick()
  end
end

function ActSlotMachine:GetActSlotRollResultMsg(msg)
  if self.activityId ~= msg.activityId then
    return
  end
  self:RefreshTopView()
  self:RefreshBottomView()
  self:CloseTopEffect()
  local curTime = Time.time
  self.waitBackMsgTime = curTime + 0.5
  if self.curState ~= ActSlotState.Idle then
    return
  end
  self.tweenMsg = msg
  self:TryStateStart()
end

function ActSlotMachine:TryStateStart()
  if self.drawSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.drawSoundHandle)
    self.drawSoundHandle = nil
  end
  self.drawSoundHandle = DataCenter.LWSoundManager:PlaySound(202621, false)
  if self.isSkip == 0 then
    self.curState = ActSlotState.MidQuicklyAni
    self.stateTime = quickMoveTime
    self:RefrehMidRollContent(true)
    self.curDengAniName = dengAniPlayName
    self:TryPlayDengAni()
    if self.slotReelSpinSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.slotReelSpinSoundHandle)
      self.slotReelSpinSoundHandle = nil
    end
    self.slotReelSpinSoundHandle = DataCenter.LWSoundManager:PlaySound(202623, false)
  else
    self.curState = ActSlotState.MidResultAni
    self.stateTime = 0
    self:TryStateChange()
  end
end

function ActSlotMachine:TryStateChange()
  if self.curState == ActSlotState.Idle then
    return
  elseif self.curState == ActSlotState.MidQuicklyAni then
    if self.stateTime <= 0 then
      self.curState = ActSlotState.MidResultAni
      self.stateTime = normalMoveTime
      self:SetTargetPos()
      self:RefrehMidRollContent(true)
    end
    return
  elseif self.curState == ActSlotState.MidResultAni then
    if self.stateTime <= 0 then
      if self.slotReelSpinSoundHandle then
        DataCenter.LWSoundManager:StopSound(self.slotReelSpinSoundHandle)
        self.slotReelSpinSoundHandle = nil
      end
      self:CloseTopEffect()
      self.curDengAniName = dengAniIdleName
      self:TryPlayDengAni()
      self.curState = ActSlotState.MidShowAni
      self.stateTime = showResultTime
      self:SetTargetPos()
      self.midRollPos1 = self.midRollTargetPos1
      self.midRollPos2 = self.midRollTargetPos2
      self.midRollPos3 = self.midRollTargetPos3
      self:RefrehMidRollContent(true)
      local infoTemp = self.activityDetailData.infoTemp
      local groupData = DataCenter.ActSlotMachineDataManager.groupTempDict[infoTemp.groupid]
      local groupId = self.tweenMsg.groupId
      local targetTemp = groupData[groupId]
      local block_1 = targetTemp.block_1
      local block_2 = targetTemp.block_2
      local block_3 = targetTemp.block_3
      local blockList = {
        block_1,
        block_2,
        block_3
      }
      local blockNum = {}
      for i = 1, #blockList do
        if blockNum[blockList[i]] == nil then
          blockNum[blockList[i]] = 0
        end
        blockNum[blockList[i]] = blockNum[blockList[i]] + 1
      end
      local maxSameNum = 0
      local maxSameId = 0
      for k, v in pairs(blockNum) do
        if v > maxSameNum then
          maxSameNum = v
          maxSameId = k
        end
      end
      if maxSameNum == 3 then
        self.eff_ui_actslotmachinemain_bgglow:SetActive(true)
      end
      if 2 <= maxSameNum then
        for i = 1, #blockList do
          if blockList[i] == maxSameId then
            if i == 1 then
              local curIndex = self.midRollTargetPos1
              local posIndex = curIndex % midRollItemNum
              local realPosIndex = 0
              if posIndex < midRollItemTopIndex then
                realPosIndex = midRollItemTopIndex - posIndex
              else
                realPosIndex = midRollItemTopIndex - posIndex + midRollItemNum
              end
              realPosIndex = (realPosIndex - (midRollItemTopIndex - 1) + midRollItemNum) % midRollItemNum
              if realPosIndex == 0 then
                realPosIndex = midRollItemNum
              end
              self.rollItems1[realPosIndex]:PlayEffect()
              self.eff_ui_actslotmachinemain_glow1:SetActive(true)
            end
            if i == 2 then
              local curIndex = self.midRollTargetPos2
              local posIndex = curIndex % midRollItemNum
              local realPosIndex = 0
              if posIndex < midRollItemTopIndex then
                realPosIndex = midRollItemTopIndex - posIndex
              else
                realPosIndex = midRollItemTopIndex - posIndex + midRollItemNum
              end
              realPosIndex = (realPosIndex - (midRollItemTopIndex - 1) + midRollItemNum) % midRollItemNum
              if realPosIndex == 0 then
                realPosIndex = midRollItemNum
              end
              self.rollItems2[realPosIndex]:PlayEffect()
              self.eff_ui_actslotmachinemain_glow2:SetActive(true)
            end
            if i == 3 then
              local curIndex = self.midRollTargetPos3
              local posIndex = curIndex % midRollItemNum
              local realPosIndex = 0
              if posIndex < midRollItemTopIndex then
                realPosIndex = midRollItemTopIndex - posIndex
              else
                realPosIndex = midRollItemTopIndex - posIndex + midRollItemNum
              end
              realPosIndex = (realPosIndex - (midRollItemTopIndex - 1) + midRollItemNum) % midRollItemNum
              if realPosIndex == 0 then
                realPosIndex = midRollItemNum
              end
              self.rollItems3[realPosIndex]:PlayEffect()
              self.eff_ui_actslotmachinemain_glow3:SetActive(true)
            end
          end
        end
        if self.isSkip == 0 then
          if self.sameGiftSoundHandle then
            DataCenter.LWSoundManager:StopSound(self.sameGiftSoundHandle)
            self.sameGiftSoundHandle = nil
          end
          self.sameGiftSoundHandle = DataCenter.LWSoundManager:PlaySound(202624, false)
        end
      end
    end
  elseif self.curState == ActSlotState.MidShowAni and self.stateTime <= 0 then
    self.curState = ActSlotState.Idle
    self.stateTime = 0
    self:RefrehMidRollContent(true)
    self:CloseTopEffect()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineRewardGet, {anim = true, playEffect = false}, self.tweenMsg)
    self:RefreshMidView()
    self.eff_ui_actslotmachinemain_bgglow:SetActive(false)
  end
end

function ActSlotMachine:SetTargetPos()
  local infoTemp = self.activityDetailData.infoTemp
  local groupData = DataCenter.ActSlotMachineDataManager.groupTempDict[infoTemp.groupid]
  local groupId = self.tweenMsg.groupId
  local targetTemp = groupData[groupId]
  local block_1 = targetTemp.block_1
  local block_2 = targetTemp.block_2
  local block_3 = targetTemp.block_3
  local index1 = -1
  for k, v in pairs(self.midRollShowData1) do
    if v.iconId == block_1 then
      index1 = k
      break
    end
  end
  if index1 < 0 then
    self.roll_content_item1:SetActive(false)
  else
    self.roll_content_item1:SetActive(true)
    local dataNum = #self.midRollShowData1
    local num = math.floor(self.midRollPos1 / dataNum)
    self.midRollTargetPos1 = (num + 1) * dataNum + (index1 - 1)
  end
  local index2 = -1
  for k, v in pairs(self.midRollShowData2) do
    if v.iconId == block_2 then
      index2 = k
      break
    end
  end
  if index2 < 0 then
    self.roll_content_item2:SetActive(false)
  else
    self.roll_content_item2:SetActive(true)
    local dataNum = #self.midRollShowData2
    local num = math.floor(self.midRollPos2 / dataNum)
    self.midRollTargetPos2 = (num + 1) * dataNum + (index2 - 1)
  end
  local index3 = -1
  for k, v in pairs(self.midRollShowData3) do
    if v.iconId == block_3 then
      index3 = k
      break
    end
  end
  if index3 < 0 then
    self.roll_content_item3:SetActive(false)
  else
    self.roll_content_item3:SetActive(true)
    local dataNum = #self.midRollShowData3
    local num = math.floor(self.midRollPos3 / dataNum)
    self.midRollTargetPos3 = (num + 1) * dataNum + (index3 - 1)
  end
end

function ActSlotMachine:ClickBoxBtn()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if #self.activityDetailData.eventBox > 0 then
    PostEventLog.Track(PostEventLog.Defines.ActSlotMachineBoxBtnClick, {})
    local lastData = self.activityDetailData.eventBox[#self.activityDetailData.eventBox]
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineSelectCard, {anim = true}, self.activityId, lastData.uuid, true)
  end
end

function ActSlotMachine:ClickRecordBtn()
  local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.activityId, UIWindowNames.UIActSlotMachineRecordCommon)
  if isUse then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineRecordCommon, {anim = true}, self.activityId)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSlotMachineRecord, {anim = true}, self.activityId)
  end
end

function ActSlotMachine:OnGotoBtnClick()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local costId = self.costData.itemId
  local canGotoPackShop = DataCenter.ActSlotMachineDataManager:CanGotoPackShop(tonumber(self.activityId))
  if canGotoPackShop then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.ActSlotMachineDataManager:GetKeyGiftPackId(tonumber(self.activityId)), costId)
  else
    UIUtil.ShowTipsId(2000655)
  end
end

function ActSlotMachine:OnGotoBp()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local infoTemp = self.activityDetailData.infoTemp
  local jumpTo = tonumber(infoTemp.bp_id) or 0
  if 0 < jumpTo then
    GoToUtil.GoActWindow({jumpTo}, false)
  end
end

function ActSlotMachine:OnGotoChange()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if self.activityInfo then
    local jumpTo = self.activityInfo:GetFirstActiveJumpTo()
    if 0 < jumpTo then
      GoToUtil.GoActWindow({jumpTo}, false)
    end
  end
end

function ActSlotMachine:BtnPointDown()
  self:SetBtnImg(true)
end

function ActSlotMachine:BtnPointUp()
  self:SetBtnImg(false)
end

function ActSlotMachine:SetBtnImg(isPress)
  local yellow_normal = self.btn_name1_1
  local yellow_press = self.btn_name1_2
  local blue_normal = self.btn_name3_1
  local blue_press = self.btn_name3_2
  local curImgName = yellow_normal
  if self.isMultiple == 1 then
    if not isPress then
      curImgName = yellow_normal
    else
      curImgName = yellow_press
    end
  elseif not isPress then
    curImgName = blue_normal
  else
    curImgName = blue_press
  end
  local imgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, curImgName)
  self.draw_btn_img:LoadSprite(imgPath)
  local posY = isPress and -24 or 0
  self.btnRoot:SetAnchoredPositionXY(0, posY)
end

function ActSlotMachine:OnPassDay()
  self.special_task_content:RefreshView()
end

function ActSlotMachine:CloseTopEffect()
  self.eff_ui_actslotmachinemain_glow1:SetActive(false)
  self.eff_ui_actslotmachinemain_glow2:SetActive(false)
  self.eff_ui_actslotmachinemain_glow3:SetActive(false)
end

function ActSlotMachine:DestroyRequest()
  if self.request ~= nil then
    self.request:Destroy()
  end
  self.request = nil
  self.requestPath = nil
  self.dengAni = nil
end

function ActSlotMachine:TryPlayDengAni()
  if self.dengAni and self.dengAni.enabled and self.dengAni.gameObject.activeSelf and self.dengAni.gameObject.activeInHierarchy then
    self.dengAni:Play(self.curDengAniName, 0, 0)
  end
end

return ActSlotMachine
