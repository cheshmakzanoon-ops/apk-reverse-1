local base = UIAsyncContainer
local UIBFBaseSelectUserTopBar = BaseClass("UIBFBaseSelectUserTopBar", base)
local Localization = CS.GameEntry.Localization
local icon_text0_path = "Icons/Icon0/IconText0"
local icon_btn0_path = "Icons/Icon0/IconBtn0"
local icon_text1_path = "Icons/Icon1/IconText1"
local icon_btn1_path = "Icons/Icon1/IconBtn1"
local icon_text2_path = "Icons/Icon2/IconText2"
local icon_btn2_path = "Icons/Icon2/IconBtn2"
local combbox_path = "Combbox"
local combbox_text_path = "Combbox/CombboxText"
local combbox_btn_path = "Combbox/CombboxBtn"
local btn_info_path = "BtnInfo"
local tip_root_path = "Combbox/TipRoot"
local expand_path = "Combbox/expand"
local filter_battle_time_tips_path = "Combbox/expand/FilterBattleTimeTipsContent"
local filter_battle_time_tips_text_path = "Combbox/expand/FilterBattleTimeTipsContent/FilterBattleTimeTipsText"
local change_filter_battle_time_show_btn_path = "Combbox/expand/FilterBattleTimeTipsContent/ChangeFilterBattleTimeShowBtn"
local filter_battle_time_content_path = "Combbox/expand/FilterBattleTimeContent"
local time_item_path = "Combbox/TimeItem"
local btn_close_tip_path = "Combbox/TipRoot/BtnCloseTip"
local btn_close_combox_path = "Combbox/expand/BtnCloseCombox"

function UIBFBaseSelectUserTopBar:OnCreate()
  base.OnCreate(self)
  self.isCommanderModuleEnable = self.view.ctrl:IsCommanderModuleEnable()
  self.IsTeamSelectBattleTimeModuleEnable = self.view.ctrl:IsTeamSelectBattleTimeModuleEnable()
  self.UIBFBaseFilterBattleTimeItem = self.view.ctrl:GetFilterBattleTimeItemClass()
  self.isPrepTime = self.view.ctrl:IsInPrepTime()
  self.icon_text1 = self:AddComponent(UIText, icon_text1_path)
  self.icon_btn1 = self:AddComponent(UIButton, icon_btn1_path)
  self.icon_btn1:SetOnClick(function()
    local strTip = Localization:GetString("Desert_strom_tips1066")
    UIUtil.ShowBubbleTips(strTip, self.icon_btn1.transform.position, 0, -30, 0, nil, nil)
  end)
  self.icon_text2 = self:AddComponent(UIText, icon_text2_path)
  self.icon_btn2 = self:AddComponent(UIButton, icon_btn2_path)
  self.icon_btn2:SetOnClick(function()
    local strTip = Localization:GetString("Desert_strom_tips1067")
    UIUtil.ShowBubbleTips(strTip, self.icon_btn2.transform.position, 0, -30, 0, nil, nil)
  end)
  self.combox = self:AddComponent(UIBaseContainer, combbox_path)
  self.combox_text = self:AddComponent(UIText, combbox_text_path)
  self.combox_btn = self:AddComponent(UIButton, combbox_btn_path)
  self.combox_btn:SetActive(self.IsTeamSelectBattleTimeModuleEnable)
  self.combox_btn:SetOnClick(function()
    self.expand:SetAlpha(0)
    self.expand:SetActive(true)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.expand:FadeIn(0.2))
    sequence:Join(self.expand.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
  end)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(true)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeIn(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
  end)
  self.tip_root = self:AddComponent(UICanvasGroup, tip_root_path)
  self.expand = self:AddComponent(UICanvasGroup, expand_path)
  self.filter_battle_time_tips_path = self:AddComponent(UIBaseComponent, filter_battle_time_tips_path)
  self.filter_battle_time_tips_text = self:AddComponent(UIText, filter_battle_time_tips_text_path)
  self.change_filter_battle_time_show_btn = self:AddComponent(UIButton, change_filter_battle_time_show_btn_path)
  self.change_filter_battle_time_show_btn:SetOnClick(function()
    self.view:ChangeShowTimeBtnClick()
  end)
  self.filter_battle_time_content = self:AddComponent(UIBaseContainer, filter_battle_time_content_path)
  self.filterBattleTimeObj = self.transform:Find(time_item_path).gameObject
  self.filterBattleTimeObj:GameObjectCreatePool()
  self.btn_close_tip = self:AddComponent(UIButton, btn_close_tip_path)
  self.btn_close_tip:SetOnClick(function()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeOut(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
    sequence:AppendCallback(function()
      if self.tip_root then
        self.tip_root:SetActive(false)
      end
    end)
  end)
  self.btn_close_combox = self:AddComponent(UIButton, btn_close_combox_path)
  self.btn_close_combox:SetOnClick(function()
    self:DoComboxCollapse(false)
  end)
  self.tip_root:SetActive(false)
  self.expand:SetActive(false)
  self:CreateFilterBattleTimeItem()
  if self.isCommanderModuleEnable then
    self.icon_text0 = self:AddComponent(UIText, icon_text0_path)
    self.icon_btn0 = self:AddComponent(UIButton, icon_btn0_path)
    self.icon_btn0:SetOnClick(function()
      local strTip = Localization:GetString("Desert_strom_tips1065")
      UIUtil.ShowBubbleTips(strTip, self.icon_btn0.transform.position, 0, -30, 0, nil, nil)
    end)
  end
end

function UIBFBaseSelectUserTopBar:OnDestroy()
  self.filter_battle_time_content:RemoveComponents(self.UIBFBaseFilterBattleTimeItem)
  self.filter_battle_time_content = nil
  self.filterBattleTimeObj:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UIBFBaseSelectUserTopBar:DoComboxCollapse(sort)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.expand:FadeOut(0.2))
  sequence:Join(self.expand.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
  sequence:AppendCallback(function()
    self.expand:SetActive(false)
  end)
  self.view:DoComboxCollapse(sort)
end

function UIBFBaseSelectUserTopBar:UpdateNum(curNumMain, curNumSub, curNumCom)
  if not self:AsyncLoadDone() then
    return
  end
  local maxNumMain = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
  local maxNumSub = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k5", 10)
  local curTabIdx = self.view.curTabIdx
  if curNumMain == nil then
    curNumMain = self.view.ctrl:GetCurNumByState(DragonPlayerState.Main, curTabIdx)
    curNumMain = math.min(curNumMain, maxNumMain)
  end
  if curNumSub == nil then
    curNumSub = self.view.ctrl:GetCurNumByState(DragonPlayerState.Sub, curTabIdx)
    curNumSub = math.min(curNumSub, maxNumSub)
  end
  local hadTeam2 = self.view.ctrl:IsHadTeam2()
  if hadTeam2 and curTabIdx == 0 then
    maxNumMain = maxNumMain * 2
    maxNumSub = maxNumSub * 2
  end
  self.icon_text1:SetText(curNumMain .. "/" .. maxNumMain)
  self.icon_text2:SetText(curNumSub .. "/" .. maxNumSub)
  if self.isCommanderModuleEnable then
    local maxNumCom = 3
    if hadTeam2 and curTabIdx == 0 then
      maxNumCom = maxNumCom * 2
    end
    if curNumCom == 0 then
      curNumCom = self.view.ctrl:GetCurCommanderNum(curTabIdx)
      curNumCom = math.min(curNumCom, maxNumCom)
    end
    self.icon_text0:SetText(curNumCom .. "/" .. maxNumCom)
  end
end

function UIBFBaseSelectUserTopBar:CreateFilterBattleTimeItem()
  if not self:AsyncLoadDone() then
    return
  end
  self.filter_battle_time_content:RemoveComponents(self.UIBFBaseFilterBattleTimeItem)
  self.filterBattleTimeObj:GameObjectRecycleAll()
  if self.isPrepTime then
    self.combox:SetActive(true)
    local hadTeam2 = self.view.ctrl:IsHadTeam2()
    local max = hadTeam2 and 2 or 1
    for i = 0, max do
      local obj = self.filterBattleTimeObj:GameObjectSpawn(self.filter_battle_time_content.transform)
      obj.name = "time_" .. i
      obj:SetActive(true)
      local itemRender = self.filter_battle_time_content:AddComponent(self.UIBFBaseFilterBattleTimeItem, obj.name)
      itemRender:SetTeamShow(i, self.view.curTabIdx)
    end
  else
    self.view.battleTime = self.view.ctrl:GetBattleTimeInfo()
    if table.IsNullOrEmpty(self.view.battleTime) then
      self.combox:SetActive(false)
      return
    end
    self.combox:SetActive(true)
    for i, v in ipairs(self.view.battleTime) do
      if v ~= nil then
        local obj = self.filterBattleTimeObj:GameObjectSpawn(self.filter_battle_time_content.transform)
        obj.name = "time_item" .. i
        obj:SetActive(true)
        local itemRender = self.filter_battle_time_content:AddComponent(self.UIBFBaseFilterBattleTimeItem, obj.name)
        itemRender:ReInit(v)
      end
    end
  end
  self:RefreshFilterBattleTimeShow()
end

function UIBFBaseSelectUserTopBar:ShowFilterResult()
  if not self:AsyncLoadDone() then
    return
  end
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.expand:FadeOut(0.2))
  sequence:Join(self.expand.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
  sequence:AppendCallback(function()
    self.expand:SetActive(false)
  end)
  self:RefreshFilterBattleTimeShow()
  self.view:RefreshFilterRankingMember()
end

function UIBFBaseSelectUserTopBar:RefreshFilterBattleTimeShow()
  if not self:AsyncLoadDone() then
    return
  end
  if self.isPrepTime then
    local langStr
    if self.view.curTabIdx == 0 then
      langStr = CS.GameEntry.Localization:GetString("Desert_strom_tips1036")
    else
      local baseStr = CS.GameEntry.Localization:GetString("Desert_strom_tips1034")
      langStr = baseStr .. " " .. (self.view.curTabIdx == 1 and "A" or "B")
    end
    self.combox_text:SetText(langStr)
    self.filter_battle_time_tips_path:SetActive(false)
    return
  end
  self.filter_battle_time_tips_path:SetActive(true)
  self.filter_battle_time_tips_text:SetLocalText(self.view.isShowLocalBattleTime and "Desert_strom_tips1001" or "Desert_strom_tips1002")
  local filterBattleTimeData = self.view.ctrl:GetFilterBattleTimeData()
  if filterBattleTimeData == nil then
    self.combox_text:SetLocalText("Desert_strom_tips1003")
  elseif self.view.isShowLocalBattleTime then
    local dataStr = Localization:GetString("Desert_strom_tips1001") .. ": " .. UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(filterBattleTimeData.startTime))
    local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(filterBattleTimeData.startTime, true, true)
    local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(filterBattleTimeData.endTime, true, true)
    self.combox_text:SetText(dataStr .. " " .. startTimeLocalStr .. " ~ " .. endTimeLocalStr)
  else
    local dataStr = Localization:GetString("Desert_strom_tips1002") .. ": " .. UITimeManager:GetInstance():GetTimeToMD(math.modf(filterBattleTimeData.startTime / 1000))
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(filterBattleTimeData.startTime, true)
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(filterBattleTimeData.endTime, true)
    self.combox_text:SetText(dataStr .. " " .. startTimeStr .. " ~ " .. endTimeStr)
  end
end

return UIBFBaseSelectUserTopBar
