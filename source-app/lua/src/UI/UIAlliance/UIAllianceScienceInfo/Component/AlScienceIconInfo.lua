local AlScienceIconInfo = BaseClass("AlScienceIconInfo", UIBaseContainer)
local DesCell = require("UI.UIAlliance.UIAllianceScienceInfo.Component.DesCell")
local AlScienceDonateInfo = require("UI.UIAlliance.UIAllianceScienceInfo.Component.AlScienceDonateInfo")
local AlSciencePreConditionItem = require("UI.UIAlliance.UIAllianceScienceInfo.Component.AlSciencePreConditionItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local donate_pro_path = "donatePro"
local build_icon_path = "IconBg/BuildIcon"
local science_name_path = "IconBg/ScienceName"
local science_des_path = "IconBg/ScienceDes"
local science_level_text_path = "IconBg/LevelText"
local detail_btn_path = "IconBg/DetailsBtn"
local leader_recommend_path = "IconBg/leaderRecommend"
local cur_level_path = "IconBg/CurLevelText"
local next_level_obj_path = cur_level_path .. "/Common_btn_arrow"
local next_level_path = next_level_obj_path .. "/NextLevelText"
local recommend_reward_tip_path = "IconBg/RecommendRewardTip"
local buff_content_path = "IconBg/BuffContent"
local cell_path = "IconBg/DesCell"
local buff_txt1_path = "IconBg/BuffContent/CurrentLv/txt1"
local buff_value1_path = "IconBg/BuffContent/CurrentLv/value1"
local buff_next_lv_path = "IconBg/BuffContent/NextLv"
local buff_txt2_path = buff_next_lv_path .. "/txt2"
local buff_value2_path = buff_next_lv_path .. "/value2"
local donate_info_path = "DonateInfoGo"
local rate_btn_path = "rateBtnContent/rateBtn"
local up_go_path = "UpGo"
local up_title_text_path = up_go_path .. "/layout/UpTitleText"
local up_time_text_path = up_go_path .. "/layout/UpTimeText"
local confirm_btn_path = "ConfirmBtn"
local confirm_btn_txt_path = confirm_btn_path .. "/ConfirmBtnTxt"
local condition_path = "ConditionGo"
local need_text_path = condition_path .. "/NeedText"
local need_res_content_path = condition_path .. "/NeedResContent"
local needResCell_path = condition_path .. "/NeedResContent/NeedResourceCell"
local need_res_icon_path = condition_path .. "/NeedResContent/NeedResourceCell/ResourceIcon"
local need_res_num_path = condition_path .. "/NeedResContent/NeedResourceCell/ResourceNum"
local preConditionContainer_path = condition_path .. "/pre"
local preConditionContent_path = preConditionContainer_path .. "/PreConditions/Viewport/Content"
local preConditionItem_path = condition_path .. "/ConditionItem"

local function OnCreate(self)
  base.OnCreate(self)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.science_name = self:AddComponent(UIText, science_name_path)
  self.science_des = self:AddComponent(UILWScienceDetailDesc, science_des_path)
  self.science_level_text = self:AddComponent(UIText, science_level_text_path)
  self.recommend_reward_tip = self:AddComponent(UIText, recommend_reward_tip_path)
  local recommandRewardAdd = LuaEntry.DataConfig:TryGetNum("union_critical", "k3")
  self.recommend_reward_tip:SetLocalText(454135, recommandRewardAdd * 100)
  self.details_btn = self:AddComponent(UIButton, detail_btn_path)
  self.details_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view:DetailsBtnClick()
  end)
  self.leader_recommend = self:AddComponent(UIImage, leader_recommend_path)
  self.cur_level = self:AddComponent(UIText, cur_level_path)
  self.cur_level:SetActive(false)
  self.next_level_obj = self:AddComponent(UIBaseContainer, next_level_obj_path)
  self.next_level = self:AddComponent(UIText, next_level_path)
  self.buff_content = self:AddComponent(UIBaseContainer, buff_content_path)
  self.buff_txt1 = self:AddComponent(UIText, buff_txt1_path)
  self.buff_txt1:SetLocalText(454100)
  self.buff_value1 = self:AddComponent(UIText, buff_value1_path)
  self.buff_next_lv = self:AddComponent(UIBaseContainer, buff_next_lv_path)
  self.buff_txt2 = self:AddComponent(UIText, buff_txt2_path)
  self.buff_txt2:SetLocalText(454103)
  self.buff_value2 = self:AddComponent(UIText, buff_value2_path)
  self.needUpdate = false
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.donate_info = self:AddComponent(AlScienceDonateInfo, donate_info_path)
  self.rate_btn = self:AddComponent(UIButton, rate_btn_path)
  self.rate_btn:SetOnClick(function()
    self:OnClickRateBtn()
  end)
  self.up_go = self:AddComponent(UIBaseContainer, up_go_path)
  self.up_title_text = self:AddComponent(UIText, up_title_text_path)
  self.up_time_text = self:AddComponent(UIText, up_time_text_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.confirm_btn_txt = self:AddComponent(UIText, confirm_btn_txt_path)
  self.confirm_btn_txt:SetLocalText(454115)
  self.item_prefab = self.transform:Find(cell_path).gameObject
  self.item_prefab:GameObjectCreatePool()
  self.condition = self:AddComponent(UIBaseContainer, condition_path)
  self.need_text = self:AddComponent(UIText, need_text_path)
  self.need_text:SetLocalText(391082)
  self.need_res_content = self:AddComponent(UIBaseContainer, need_res_content_path)
  self.needResCellN = self:AddComponent(UIButton, needResCell_path)
  self.needResCellN:SetOnClick(function()
    self:OnClickNeedRes()
  end)
  self.need_res_icon = self:AddComponent(UIImage, need_res_icon_path)
  self.need_res_num = self:AddComponent(UIText, need_res_num_path)
  self.preConditionContainer = self:AddComponent(UIBaseContainer, preConditionContainer_path)
  self.preConditionContent = self:AddComponent(UIBaseContainer, preConditionContent_path)
  self.preConditionItem = self.transform:Find(preConditionItem_path).gameObject
  self.preConditionItem:GameObjectCreatePool()
  self.condition:SetActive(false)
  self.PreConditionList = {}
  self.ResourceModels = {}
end

local function OnDestroy(self)
  self.item_prefab.gameObject:GameObjectRecycleAll()
  self.item_prefab = nil
  self.build_icon = nil
  self.science_name = nil
  self.science_des = nil
  self.science_level_text = nil
  self.details_btn = nil
  self.leader_recommend = nil
  self.cur_level = nil
  self.next_level_obj = nil
  self.next_level = nil
  self.buff_content = nil
  self.buff_txt1 = nil
  self.buff_value1 = nil
  self.buff_next_lv = nil
  self.buff_txt2 = nil
  self.buff_value2 = nil
  self.donate_info = nil
  self.up_go = nil
  self.up_title_text = nil
  self.up_time_text = nil
  self.needUpdate = nil
  self.curScience = nil
  self.isUpdate = nil
  self.lastChangeTextDeltaTime = nil
  self.lastChangeImageDeltaTime = nil
  self.scienceData = nil
  self.condition = nil
  self.need_text = nil
  self.need_res_icon = nil
  self.need_res_num = nil
  self.preConditionContainer = nil
  self.preConditionContent = nil
  self.preConditionItem.gameObject:GameObjectRecycleAll()
  self.preConditionItem = nil
  self.confirm_btn = nil
  self.confirm_btn_txt = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAlScienceRecommendChange, self.OnUpdateRecommendId)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAlScienceRecommendChange, self.OnUpdateRecommendId)
  base.OnRemoveListener(self)
end

local function RefreshData(self, scienceData, tabIndex, showRecommendEffect)
  self.tabIndex = tabIndex
  self.scienceData = scienceData
  self.leader_recommend:SetActive(self.scienceData.state == 1)
  self.recommend_reward_tip:SetActive(self.scienceData.state == 1)
  self.build_icon:LoadSprite(self.scienceData.icon)
  self.science_name:SetLocalText(self.scienceData.name)
  
  local function ProcessDesc(desc)
    local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#EF6B00"))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  end
  
  local scienceId = self.scienceData.scienceId
  local allianceSciTemplate = DataCenter.AllianceScienceTemplateManager:GetAlScienceInfo(scienceId)
  local desLocal = ProcessDesc(allianceSciTemplate:GetDesc())
  self.science_des:SetText(desLocal)
  self.science_level_text:SetText(self.scienceData.curLevel .. "/" .. self.scienceData.maxLevel)
  self.cur_level:SetLocalText(GameDialogDefine.LEVEL_NUMBER, self.scienceData.curLevel)
  local nextLevel = 0
  
  local function ProcessValueText(str)
    local strArray = string.split_ss_array(str, ";")
    if 2 <= #strArray then
      local strType = tonumber(strArray[1])
      if strType == 1 then
        return strArray[2] or ""
      elseif strType == 2 then
        if #strArray == 3 then
          return Localization:GetString(strArray[2], strArray[3])
        else
          return Localization:GetString(strArray[2])
        end
      end
    end
    return ""
  end
  
  local info_vec = string.split_ss_array(self.scienceData.info, "|")
  self.buff_value1:SetText(ProcessValueText(info_vec[self.scienceData.curLevel + 1]))
  if self.scienceData.curLevel < self.scienceData.maxLevel then
    self.next_level_obj:SetActive(true)
    nextLevel = self.scienceData.curLevel + 1
    self.next_level:SetText(nextLevel)
    self.buff_next_lv:SetActive(true)
    self.buff_value2:SetText(ProcessValueText(info_vec[nextLevel + 1]))
    self.confirm_btn:SetActive(false)
  else
    self.confirm_btn:SetActive(true)
    self.buff_next_lv:SetActive(false)
    nextLevel = self.scienceData.curLevel
    self.next_level_obj:SetActive(false)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.scienceData.isLock then
    self.up_go:SetActive(false)
    self.donate_info:SetActive(false)
    self.needUpdate = false
  elseif curTime < self.scienceData.finishTime then
    self.up_go:SetActive(true)
    self.up_title_text:SetLocalText(454121)
    self.donate_info:SetActive(false)
    self.needUpdate = true
    self.confirm_btn:SetActive(true)
  else
    self.needUpdate = false
    self.donate_info:SetActive(true)
    self.donate_info:RefreshData(scienceData, tabIndex, showRecommendEffect)
    local currentPro = self.scienceData.currentPro
    local needPro = self.scienceData.needPro
    if needPro ~= 0 and currentPro >= needPro then
      self.up_go:SetActive(true)
      self.up_title_text:SetLocalText(454116)
      self.up_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(self.scienceData.time))
    else
      self.up_go:SetActive(false)
    end
  end
  self:OnUpdateDonate()
  self:SetCondition()
  self:RefreshUpgradeCost()
  self:Update1000MS()
end

local function OnUpdateRecommendId(self, scienceId)
  self.leader_recommend:SetActive(scienceId and self.scienceData.scienceId == scienceId)
  self.recommend_reward_tip:SetActive(scienceId and self.scienceData.scienceId == scienceId)
end

local function RefreshUpgradeCost(self)
  local currentPro = self.scienceData.currentPro
  local needPro = self.scienceData.needPro
  if currentPro >= needPro and self.scienceData.research_consume > 0 then
    self.need_text:SetActive(true)
    self.need_res_content:SetActive(true)
  else
    self.need_text:SetActive(false)
    self.need_res_content:SetActive(false)
  end
end

local function Update1000MS(self)
  if self.needUpdate then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = 0
    local maxTime = 0
    if curTime < self.scienceData.finishTime then
      self.isUpdate = true
      deltaTime = self.scienceData.finishTime - curTime
      maxTime = self.scienceData.finishTime - self.scienceData.startTime
    else
      self.isUpdate = false
      self.up_go:SetActive(false)
    end
    if self.isUpdate then
      if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
        self.lastChangeTextDeltaTime = deltaTime
        self.up_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      end
    else
      self.lastChangeTextDeltaTime = 0
      self.lastChangeImageDeltaTime = 0
      self.up_time_text:SetLocalText(170008)
      self.view.ctrl:CloseSelf()
    end
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetCondition(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.scienceData.curLevel < self.scienceData.maxLevel and curTime >= self.scienceData.finishTime then
    local consumeNum = self.scienceData.research_consume
    if 0 < consumeNum then
      self.need_res_content:SetActive(true)
      local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_SCIENCE_RESEARCH_CONSUME)
      consumeNum = math.floor(consumeNum * (1 - effectNum / 100) + 0.5)
      local ownCount = DataCenter.AllianceStorageManager:GetResCountByRewardType(RewardType.SAPPHIRE)
      self.need_res_num:SetText(string.GetFormattedStr(consumeNum))
      if consumeNum > ownCount then
        self.need_res_num:SetColor(Color.New(0.917, 0.26, 0.26, 1))
      else
        self.need_res_num:SetColor(WhiteColor)
      end
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.need_res_content.rectTransform)
    else
      self.need_res_content:SetActive(false)
    end
    if self.scienceData.isLock then
      self.preConditionContainer:SetActive(true)
      local retTb = {}
      if self.scienceData.science_condition ~= nil and self.scienceData.science_condition ~= "" then
        local condition_vec = string.split_ss_array(self.scienceData.science_condition, ";")
        for k = 1, #condition_vec do
          local condition = condition_vec[k]
          local level = tonumber(string.sub(condition, -2))
          local id = tonumber(condition) - level
          local pSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(id)
          if pSciencedata ~= nil then
            local curLevel = pSciencedata.curLevel
            if level > curLevel then
              local cond = {}
              cond.itemId = pSciencedata.scienceId
              cond.level = level
              table.insert(retTb, cond)
            end
          end
        end
      end
      self:ShowPreConditions(retTb)
    else
      self.preConditionContainer:SetActive(false)
    end
  else
    self.condition:SetActive(false)
  end
end

local function ShowPreConditions(self, conditions)
  local list = conditions
  self.preConditionContent:RemoveComponents(AlSciencePreConditionItem)
  self.preConditionItem.gameObject:GameObjectRecycleAll()
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      local item = self.preConditionItem:GameObjectSpawn(self.preConditionContent.transform)
      item.name = "item" .. i
      local cell = self.preConditionContent:AddComponent(AlSciencePreConditionItem, item.name)
      cell:SetCondition(list[i])
    end
  end
end

local function OnClickNeedRes(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCity, 2)
end

local function OnClickRateBtn(self)
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString("drop_info_desc6"))
end

local function OnUpdateDonate(self)
end

AlScienceIconInfo.OnCreate = OnCreate
AlScienceIconInfo.OnDestroy = OnDestroy
AlScienceIconInfo.OnEnable = OnEnable
AlScienceIconInfo.OnDisable = OnDisable
AlScienceIconInfo.OnAddListener = OnAddListener
AlScienceIconInfo.OnRemoveListener = OnRemoveListener
AlScienceIconInfo.RefreshData = RefreshData
AlScienceIconInfo.Update1000MS = Update1000MS
AlScienceIconInfo.SetCondition = SetCondition
AlScienceIconInfo.ShowPreConditions = ShowPreConditions
AlScienceIconInfo.RefreshUpgradeCost = RefreshUpgradeCost
AlScienceIconInfo.OnUpdateRecommendId = OnUpdateRecommendId
AlScienceIconInfo.OnClickNeedRes = OnClickNeedRes
AlScienceIconInfo.OnClickRateBtn = OnClickRateBtn
AlScienceIconInfo.OnUpdateDonate = OnUpdateDonate
return AlScienceIconInfo
