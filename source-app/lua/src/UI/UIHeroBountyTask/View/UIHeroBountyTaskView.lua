local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local HeroBountyCampItem = require("UI.UIHeroBountyTask.Component.HeroBountyCampItem")
local HeroBountyShowHeroItem = require("UI.UIHeroBountyTask.Component.HeroBountyShowHeroItem")
local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local HeroBountySelectHeroItem = require("UI.UIHeroBountyTask.Component.HeroBountySelectHeroItem")
local UIHeroBountyTaskView = BaseClass("UIHeroBountyTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local anim_path = "Root/animLayout"
local txt_title_path = "Root/animLayout/leftPanel/Image/Image/Text_name"
local close_btn_path = "Root/BtnBack"
local info_btn_path = "Root/animLayout/leftPanel/Image/Image/Text_name/desButton"
local reward_layout_path = "Root/animLayout/leftPanel/Image/rewardLayout"
local reward_txt_path = "Root/animLayout/leftPanel/Image/rewardDes"
local refresh_btn_path = "Root/animLayout/leftPanel/Image/refreshButton"
local refresh_btn_num_path = "Root/animLayout/leftPanel/Image/refreshButton/refreshCost"
local hero_des_txt_path = "Root/animLayout/leftPanel/Image/heroDesLayout/herodes"
local task_des_txt_path = "Root/animLayout/leftPanel/Image/taskDesLayout/taskdes"
local hero_index_obj_1_path = "Root/animLayout/leftPanel/Image/heroLayout/HeroDispathCell1"
local hero_index_obj_2_path = "Root/animLayout/leftPanel/Image/heroLayout/HeroDispathCell2"
local hero_index_obj_3_path = "Root/animLayout/leftPanel/Image/heroLayout/HeroDispathCell3"
local start_btn_path = "Root/animLayout/leftPanel/Image/Button"
local start_txt_path = "Root/animLayout/leftPanel/Image/Button/btnTxt"
local star_btn_path = "Root/animLayout/leftPanel/Image/limitLayout/starLimit/Image"
local star_limit_path = "Root/animLayout/leftPanel/Image/limitLayout/starLimit"
local star_OK_img_path = "Root/animLayout/leftPanel/Image/limitLayout/starLimit/starIsOk"
local star_num_path = "Root/animLayout/leftPanel/Image/limitLayout/starLimit/star_num"
local rarity_limit_path = "Root/animLayout/leftPanel/Image/limitLayout/rarityLimit"
local rarity_OK_img_path = "Root/animLayout/leftPanel/Image/limitLayout/rarityLimit/rarityIsOk"
local rarity_num_path = "Root/animLayout/leftPanel/Image/limitLayout/rarityLimit/rarity_num"
local rarity_img_path = "Root/animLayout/leftPanel/Image/limitLayout/rarityLimit/rarityImg"
local camp_limit_path = "Root/animLayout/leftPanel/Image/limitLayout/campLayout"
local camp1_path = "Root/animLayout/leftPanel/Image/limitLayout/campLayout/camp1"
local camp2_path = "Root/animLayout/leftPanel/Image/limitLayout/campLayout/camp2"
local camp3_path = "Root/animLayout/leftPanel/Image/limitLayout/campLayout/camp3"
local hero_tab_all_path = "Root/animLayout/rightPanel/RightPanel/TabContent/all"
local hero_tab_camp1_path = "Root/animLayout/rightPanel/RightPanel/TabContent/1"
local hero_tab_camp2_path = "Root/animLayout/rightPanel/RightPanel/TabContent/2"
local hero_tab_camp3_path = "Root/animLayout/rightPanel/RightPanel/TabContent/3"
local hero_scroll_view_path = "Root/animLayout/rightPanel/RightPanel/ScrollView"
local extra_desc_path = "Root/policeObj/policeDes"
local extra_desc_intro_btn_path = "Root/policeObj/PoliceBtn"
local send_effect_path = "finish"
local send_txt_path = "finish/Text_send"

local function OnCreate(self)
  base.OnCreate(self)
  local taskIndex = self:GetUserData()
  self.index = tonumber(taskIndex)
  self.ctrl:InitData()
  self.anim = self:AddComponent(UISimpleAnimation, anim_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.tabCamps = {}
  local tab1 = self:AddComponent(UIButton, hero_tab_all_path)
  tab1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSwitchCamp(1)
  end)
  local tab2 = self:AddComponent(UIButton, hero_tab_camp1_path)
  tab2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSwitchCamp(2)
  end)
  local tab3 = self:AddComponent(UIButton, hero_tab_camp2_path)
  tab3:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSwitchCamp(3)
  end)
  local tab4 = self:AddComponent(UIButton, hero_tab_camp3_path)
  tab4:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSwitchCamp(4)
  end)
  self.tabCamps[1] = tab1
  self.tabCamps[2] = tab2
  self.tabCamps[3] = tab3
  self.tabCamps[4] = tab4
  self.heroIndexObj = {}
  self.heroEffectObj = {}
  local index1 = self:AddComponent(UIButton, hero_index_obj_1_path)
  index1:SetOnClick(function()
    self:OnChangeClick()
  end)
  local effect1 = index1.transform:Find("effect").gameObject
  self.heroEffectObj[1] = effect1
  self.heroIndexObj[1] = index1
  local index2 = self:AddComponent(UIButton, hero_index_obj_2_path)
  index2:SetOnClick(function()
    self:OnChangeClick()
  end)
  local effect2 = index2.transform:Find("effect").gameObject
  self.heroEffectObj[2] = effect2
  self.heroIndexObj[2] = index2
  local index3 = self:AddComponent(UIButton, hero_index_obj_3_path)
  index3:SetOnClick(function()
    self:OnChangeClick()
  end)
  local effect3 = index3.transform:Find("effect").gameObject
  self.heroEffectObj[3] = effect3
  self.heroIndexObj[3] = index3
  self.reward_layout = self:AddComponent(UIBaseContainer, reward_layout_path)
  self.reward_txt = self:AddComponent(UIText, reward_txt_path)
  self.reward_txt:SetLocalText(132231)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:SetOnClick(function()
    self:OnRefreshClick()
  end)
  self.refresh_btn_num = self:AddComponent(UIText, refresh_btn_num_path)
  local k2 = LuaEntry.DataConfig:TryGetNum("hero_bounty", "k2")
  self.refresh_btn_num:SetText(math.floor(k2))
  self.hero_des_txt = self:AddComponent(UIText, hero_des_txt_path)
  self.hero_des_txt:SetLocalText(132202)
  self.task_des_txt = self:AddComponent(UIText, task_des_txt_path)
  self.task_des_txt:SetLocalText(130060)
  self.start_btn = self:AddComponent(UIButton, start_btn_path)
  self.start_btn:SetOnClick(function()
    self:OnStartClick()
  end)
  self.start_txt = self:AddComponent(UIText, start_txt_path)
  self.start_txt:SetLocalText(390146)
  self.star_btn = self:AddComponent(UIButton, star_btn_path)
  self.star_btn:SetOnClick(function()
    self:OnStarDesClick()
  end)
  self.star_limit = self:AddComponent(UIBaseContainer, star_limit_path)
  self.star_OK_img = self:AddComponent(UIBaseContainer, star_OK_img_path)
  self.star_num = self:AddComponent(UIText, star_num_path)
  self.rarity_limit = self:AddComponent(UIBaseContainer, rarity_limit_path)
  self.rarity_OK_img = self:AddComponent(UIBaseContainer, rarity_OK_img_path)
  self.rarity_num = self:AddComponent(UIText, rarity_num_path)
  self.rarity_img = self:AddComponent(UIImage, rarity_img_path)
  self.rarity_btn = self:AddComponent(UIButton, rarity_img_path)
  self.rarity_btn:SetOnClick(function()
    self:OnRarityDesClick()
  end)
  self.camp_limit = self:AddComponent(UIBaseContainer, camp_limit_path)
  self.camp1 = self:AddComponent(HeroBountyCampItem, camp1_path)
  self.camp2 = self:AddComponent(HeroBountyCampItem, camp2_path)
  self.camp3 = self:AddComponent(HeroBountyCampItem, camp3_path)
  self.ScrollView = self:AddComponent(UIScrollView, hero_scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.extra_desc_text = self:AddComponent(UIText, extra_desc_path)
  self.extra_desc_intro_btn = self:AddComponent(UIButton, extra_desc_intro_btn_path)
  self.extra_desc_intro_btn:SetOnClick(function()
    self:OnDescInfoClick()
  end)
  self.heroItemList = {}
  local showAnim = DataCenter.HeroBountyDataManager:GetShowUIAnim()
  if showAnim then
    self.anim:Play("hide")
  else
    self.anim:Play("idle")
  end
  for k, v in pairs(self.heroEffectObj) do
    v:SetActive(true)
  end
  self.send_effect = self:AddComponent(UIBaseContainer, send_effect_path)
  self.send_effect:SetActive(false)
  self.send_txt = self:AddComponent(UIText, send_txt_path)
  self.send_txt:SetLocalText(132205)
end

local function OnChangeClick(self)
  local showAnim = DataCenter.HeroBountyDataManager:GetShowUIAnim()
  if showAnim then
    DataCenter.HeroBountyDataManager:SetShowUIAnim()
    self.anim:Play("change")
  else
    UIUtil.ShowTipsId(132232)
  end
end

local function OnDestroy(self)
  self:ClearScroll()
  self:RemoveShowHeroList()
  self:RemoveRewardList()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
  local percent = Mathf.Round(effectValue) .. "%"
  self.extra_desc_text:SetText(percent)
  self:InitData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnHeroBountyTaskRefresh, self.InitData)
  self:AddUIListener(EventId.OnHeroBountyOneTaskRefresh, self.InitData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnHeroBountyTaskRefresh, self.InitData)
  self:RemoveUIListener(EventId.OnHeroBountyOneTaskRefresh, self.InitData)
  base.OnRemoveListener(self)
end

local function InitData(self, data)
  self.ctrl:InitData()
  self:OnSwitchCamp(1)
  self:RemoveShowHeroList()
  self.taskData = self.ctrl:GetTaskDataByIndex(self.index)
  if self.taskData ~= nil then
    if self.taskData.description ~= nil and self.taskData.description ~= "" then
      self.info_btn:SetActive(true)
    else
      self.info_btn:SetActive(false)
    end
    self.txt_title:SetLocalText(self.taskData.name)
    self.txt_title:SetColor(HeroBountyRarityColor[self.taskData.rarity])
    if self.taskData.star_requirements ~= nil and self.taskData.star_requirements > 0 then
      self.star_limit:SetActive(true)
      self.star_OK_img:SetActive(false)
      self.star_num:SetText("0" .. "/" .. math.floor(self.taskData.star_requirements))
    else
      self.star_limit:SetActive(false)
    end
    if self.taskData.rarity_requirement ~= nil and self.taskData.rarity_num_requirement ~= nil then
      self.rarity_limit:SetActive(true)
      self.rarity_img:LoadSprite(HeroUtils.GetRarityIconName(self.taskData.rarity_requirement, true))
      self.rarity_OK_img:SetActive(false)
      self.rarity_num:SetText("0" .. "/" .. math.floor(self.taskData.rarity_num_requirement))
    else
      self.rarity_limit:SetActive(false)
    end
    self.campNeedList = {}
    if 0 < #self.taskData.camp_requirements_list then
      self.camp_limit:SetActive(true)
      local count = #self.taskData.camp_requirements_list
      if 1 <= count then
        self.camp1:SetActive(true)
        local campIndex1 = self.taskData.camp_requirements_list[1]
        self.camp1:InitData(campIndex1, 1)
        table.insert(self.campNeedList, self.camp1)
        if 2 <= count then
          self.camp2:SetActive(true)
          local campIndex2 = self.taskData.camp_requirements_list[2]
          self.camp2:InitData(campIndex2, 2)
          table.insert(self.campNeedList, self.camp2)
          if 3 <= count then
            self.camp3:SetActive(true)
            local campIndex3 = self.taskData.camp_requirements_list[3]
            self.camp3:InitData(campIndex3, 3)
            table.insert(self.campNeedList, self.camp3)
          else
            self.camp3:SetActive(false)
          end
        else
          self.camp2:SetActive(false)
          self.camp3:SetActive(false)
        end
      else
        self.camp_limit:SetActive(false)
      end
    else
      self.camp_limit:SetActive(false)
    end
    local heroNum = self.taskData.needHeroNum
    for k, v in pairs(self.heroIndexObj) do
      if k <= heroNum then
        v:SetActive(true)
      else
        v:SetActive(false)
      end
    end
    self:ShowRewardList()
  end
  self:RefreshLimit()
end

local function RefreshLimit(self)
  local isStarFinish = false
  local isRarityFinish = false
  local isCampFinish = false
  if self.taskData ~= nil then
    if self.taskData.star_requirements ~= nil and self.taskData.star_requirements > 0 then
      local num = self.ctrl:GetHeroTotalStarNum()
      if num >= self.taskData.star_requirements then
        isStarFinish = true
        self.star_OK_img:SetActive(true)
      else
        self.star_OK_img:SetActive(false)
      end
      self.star_num:SetText(math.floor(num) .. "/" .. math.floor(self.taskData.star_requirements))
    else
      isStarFinish = true
    end
    if self.taskData.rarity_requirement ~= nil and self.taskData.rarity_num_requirement ~= nil then
      local rarity = self.ctrl:GetHeroMaxRarity()
      local num = self.ctrl:GetHeroNumByRarity(self.taskData.rarity_requirement)
      if rarity <= self.taskData.rarity_requirement and num >= self.taskData.rarity_num_requirement then
        isRarityFinish = true
        self.rarity_OK_img:SetActive(true)
      else
        self.rarity_OK_img:SetActive(false)
      end
      self.rarity_num:SetText(math.floor(num) .. "/" .. math.floor(self.taskData.rarity_num_requirement))
    else
      isRarityFinish = true
    end
    if 0 < #self.campNeedList then
      isCampFinish = true
      local campList = {}
      for i = 1, #self.campNeedList do
        local camp = self.campNeedList[i].index
        if campList[camp] ~= nil then
          campList[camp] = campList[camp] + 1
        else
          campList[camp] = 1
        end
        local finish = self.ctrl:CheckHasHeroByCampIndex(camp, campList[camp])
        self.campNeedList[i]:SetIsFinishByCampIndex(finish)
        if finish == false then
          isCampFinish = false
        end
      end
    else
      isCampFinish = true
    end
  end
  self.isStarFinish = isStarFinish
  self.isRarityFinish = isRarityFinish
  self.isCampFinish = isCampFinish
  self:CheckButtonState()
end

local function CheckButtonState(self)
  local gray = self.isStarFinish == false or self.isRarityFinish == false or self.isCampFinish == false
  UIGray.SetGray(self.start_btn.transform, gray, true)
  local shadow = self.start_btn.transform:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
  if shadow then
    shadow.enabled = not gray
  end
  local outlines = self.start_txt.gameObject:GetComponents(typeof(CS.UnityEngine.UI.Outline))
  for i = 0, outlines.Length - 1 do
    outlines[i].effectColor = gray and Color.black or Color.New(0.5568627450980392, 0.24313725490196078, 0.09411764705882353)
    outlines[i].enabled = true
  end
end

local function OnSelectHeroFinish(self, index)
  if self.heroIndexObj[index] ~= nil then
    self.heroIndexObj[index]:RemoveComponents(HeroBountyShowHeroItem)
    if self.model[index] ~= nil then
      self:GameObjectDestroy(self.model[index])
      self.model[index] = nil
    end
    self.HeroCellList[index] = nil
    if self.heroEffectObj[index] ~= nil then
      self.heroEffectObj[index]:SetActive(true)
    end
    local heroData = self.ctrl:GetCurHeroData()
    self:CreateHeroByIndex(index, heroData)
    self:RefreshLimit()
  end
end

local function CreateHeroByIndex(self, index, heroData)
  if heroData[index] ~= nil and self.model[index] == nil then
    self.model[index] = self:GameObjectInstantiateAsync(UIAssets.HeroBountyItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.heroIndexObj[index].transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.heroIndexObj[index]:AddComponent(HeroBountyShowHeroItem, nameStr)
      cell:SetData(heroData[index], index)
      self.HeroCellList[index] = cell
      if self.heroEffectObj[index] ~= nil then
        self.heroEffectObj[index]:SetActive(false)
      end
    end)
  end
end

local function RemoveShowHeroList(self)
  table.walk(self.heroIndexObj, function(k, v)
    v:RemoveComponents(HeroBountyShowHeroItem)
  end)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.HeroCellList = {}
  self.model = {}
end

local function OnSwitchCamp(self, camp)
  for k, tab in pairs(self.tabCamps) do
    tab.transform:Find("selected").gameObject:SetActive(k == camp)
    tab.transform:Find("normal").gameObject:SetActive(k ~= camp)
  end
  local selectCamp = camp - 1
  self:ClearScroll()
  self.list = self.view.ctrl:GetCurrentHeroDataList(selectCamp)
  if self.list ~= nil and #self.list > 0 then
    self.ScrollView:SetTotalCount(#self.list)
    self.ScrollView:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(HeroBountySelectHeroItem, itemObj)
  cellItem:SetItemShow(self.list[index])
  self.heroItemList[self.list[index]] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
  local uuid = self.list[index]
  if uuid ~= nil then
    self.heroItemList[uuid] = nil
  end
  self.ScrollView:RemoveComponent(itemObj.name, HeroBountySelectHeroItem)
end

local function ShowRewardList(self)
  self:RemoveRewardList()
  if self.taskData.exp_hero ~= nil and self.taskData.exp_hero > 0 then
    self.model[-1] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.reward_layout.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local oneData = {}
      oneData.count = self.taskData.exp_hero
      oneData.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
      oneData.iconName = "Assets/Main/Sprites/Guide/UIPVEExplore_icon.png"
      oneData.itemFlag = ""
      oneData.rewardType = RewardType.HERO_EXP
      oneData.itemName = Localization:GetString("100083")
      oneData.itemDesc = Localization:GetString("302010", string.GetFormattedSeperatorNum(self.taskData.exp_hero))
      oneData.isLocal = true
      local cell = self.reward_layout:AddComponent(RewardItem, nameStr)
      cell:RefreshData(oneData)
    end)
  end
  local list = self.taskData.rewardStr
  if list ~= nil then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.rewardModel[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.reward_layout.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.reward_layout:AddComponent(RewardItem, nameStr)
        cell:RefreshData(list[i])
      end)
    end
  end
end

local function RemoveRewardList(self)
  self.reward_layout:RemoveComponents(RewardItem)
  if self.rewardModel ~= nil then
    for k, v in pairs(self.rewardModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModel = {}
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(HeroBountySelectHeroItem)
  self.heroItemList = {}
  self.list = {}
end

local function OnInfoClick(self)
  if self.taskData ~= nil and self.taskData.description ~= nil and self.taskData.description ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.info_btn.transform.position + Vector3.New(0, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString(self.taskData.description)
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 240
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnStartClick(self)
  if self.isStarFinish == true and self.isRarityFinish == true and self.isCampFinish == true then
    self.send_effect:SetActive(true)
    self.ctrl:OnStartClick(self.index)
    TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
    end, 1.5)
  elseif self.isStarFinish == false then
    self:OnStarDesClick()
  elseif self.isRarityFinish == false then
    self:OnRarityDesClick()
  elseif self.isCampFinish == false and #self.campNeedList > 0 then
    local campList = {}
    for i = 1, #self.campNeedList do
      local camp = self.campNeedList[i].index
      if campList[camp] ~= nil then
        campList[camp] = campList[camp] + 1
      else
        campList[camp] = 1
      end
      local finish = self.ctrl:CheckHasHeroByCampIndex(camp, campList[camp])
      if finish == false then
        self.campNeedList[i]:OnCampDesClick()
        return
      end
    end
  end
end

local function OnDescInfoClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.extra_desc_intro_btn.transform.position + Vector3.New(-2, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("162115")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 300
  param.pivot = 0.85
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnCampDesClick(self, index, pos)
  local count = 0
  for i = 1, #self.campNeedList do
    local camp = self.campNeedList[i].index
    if camp == index then
      count = count + 1
    end
  end
  local des = ""
  if index == 1 then
    des = Localization:GetString("132211", count)
  elseif index == 2 then
    des = Localization:GetString("132209", count)
  elseif index == 3 then
    des = Localization:GetString("132210", count)
  elseif index == 0 then
    des = Localization:GetString("132235", count)
  end
  if des ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = pos + Vector3.New(-2, 30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = des
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 240
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnRarityDesClick(self)
  if self.taskData.rarity_requirement ~= nil and self.taskData.rarity_num_requirement ~= nil then
    local des = ""
    if self.taskData.rarity_requirement == 1 then
      des = Localization:GetString("132208", self.taskData.rarity_num_requirement)
    elseif self.taskData.rarity_requirement == 2 then
      des = Localization:GetString("132207", self.taskData.rarity_num_requirement)
    elseif self.taskData.rarity_requirement == 3 then
      des = Localization:GetString("132206", self.taskData.rarity_num_requirement)
    end
    if des ~= "" then
      local scaleFactor = UIManager:GetInstance():GetScaleFactor()
      local position = self.rarity_btn.transform.position + Vector3.New(-2, 30, 0) * scaleFactor
      local param = UIHeroTipView.Param.New()
      param.content = des
      param.dir = UIHeroTipView.Direction.ABOVE
      param.defWidth = 240
      param.pivot = 0.5
      param.position = position
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
    end
  end
end

local function OnStarDesClick(self)
  if self.taskData.star_requirements ~= nil and self.taskData.star_requirements > 0 then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.star_btn.transform.position + Vector3.New(-2, 30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("132212", self.taskData.star_requirements)
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 240
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnRefreshClick(self)
  if self.index ~= 0 then
    local k2 = LuaEntry.DataConfig:TryGetNum("hero_bounty", "k2")
    if LuaEntry.Player.gold < tonumber(k2) then
      GoToUtil.GotoPayTips(k2)
      return
    end
    local showFlag = Setting:GetPrivateInt("SHOW_REFRESH_BOUNTY", 1)
    if showFlag == 1 then
      UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("132218"), 2, "", "", function()
        SFSNetwork.SendMessage(MsgDefines.RefreshHeroBountyTask, self.index)
      end, function()
        Setting:SetPrivateInt("SHOW_REFRESH_BOUNTY", 0)
      end)
    else
      SFSNetwork.SendMessage(MsgDefines.RefreshHeroBountyTask, self.index)
    end
  end
end

UIHeroBountyTaskView.OnCreate = OnCreate
UIHeroBountyTaskView.OnDestroy = OnDestroy
UIHeroBountyTaskView.OnEnable = OnEnable
UIHeroBountyTaskView.OnDisable = OnDisable
UIHeroBountyTaskView.OnAddListener = OnAddListener
UIHeroBountyTaskView.OnRemoveListener = OnRemoveListener
UIHeroBountyTaskView.ShowRewardList = ShowRewardList
UIHeroBountyTaskView.ClearScroll = ClearScroll
UIHeroBountyTaskView.OnInfoClick = OnInfoClick
UIHeroBountyTaskView.RemoveRewardList = RemoveRewardList
UIHeroBountyTaskView.OnItemMoveOut = OnItemMoveOut
UIHeroBountyTaskView.OnItemMoveIn = OnItemMoveIn
UIHeroBountyTaskView.OnSwitchCamp = OnSwitchCamp
UIHeroBountyTaskView.RemoveShowHeroList = RemoveShowHeroList
UIHeroBountyTaskView.CreateHeroByIndex = CreateHeroByIndex
UIHeroBountyTaskView.OnSelectHeroFinish = OnSelectHeroFinish
UIHeroBountyTaskView.CheckButtonState = CheckButtonState
UIHeroBountyTaskView.RefreshLimit = RefreshLimit
UIHeroBountyTaskView.InitData = InitData
UIHeroBountyTaskView.OnStartClick = OnStartClick
UIHeroBountyTaskView.OnDescInfoClick = OnDescInfoClick
UIHeroBountyTaskView.OnCampDesClick = OnCampDesClick
UIHeroBountyTaskView.OnRarityDesClick = OnRarityDesClick
UIHeroBountyTaskView.OnStarDesClick = OnStarDesClick
UIHeroBountyTaskView.OnRefreshClick = OnRefreshClick
UIHeroBountyTaskView.OnChangeClick = OnChangeClick
return UIHeroBountyTaskView
