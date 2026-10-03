local MailSoldierPage = BaseClass("MailSoldierPage", UIBaseContainer)
local base = UIBaseContainer
local MailSoldierCell = require("UI.UILWMail.UILWMailMain.Component.MailSoldierCell")
local UILostSoldierTip = require("UI.UILostSoldierTip.View.UILostSoldierTipView")
local MailSoldierPageItem = require("UI.UILWMail.UILWMailMain.Component.MailSoldierPageItem")
local MailSoldierPageItemAsync = require("UI.UILWMail.UILWMailMain.Component.MailSoldierPageItemAsync")
local Localization = CS.GameEntry.Localization

function MailSoldierPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailSoldierPage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailSoldierPage:DataDefine()
end

function MailSoldierPage:DataDestroy()
end

function MailSoldierPage:OnEnable()
  base.OnEnable(self)
end

function MailSoldierPage:OnDisable()
  base.OnDisable(self)
end

function MailSoldierPage:OnAddListener()
  base.OnAddListener(self)
end

function MailSoldierPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailSoldierPage:ComponentDefine()
  self.HospitalTip = self:AddComponent(UIText, "HospitalTipContainer/HospitalTip")
  self.HospitalTip:SetLocalText(GameDialogDefine.HOSPITAL_IS_FULL)
  self.soldierCell = self.transform:Find("SoldierContent/SoldierCell").gameObject
  self.soldierCell:GameObjectCreatePool()
  self.soldierContent = self:AddComponent(UIBaseContainer, "SoldierContent")
  local DeathText = self:AddComponent(UIText, "TableHead/DeathText")
  DeathText:SetLocalText(GameDialogDefine.DEATH)
  local DeathText2 = self:AddComponent(UIText, "TableHead/DeathText2")
  DeathText2:SetLocalText(GameDialogDefine.DEATH)
  local InjuredText = self:AddComponent(UIText, "TableHead/InjuredText")
  InjuredText:SetLocalText(GameDialogDefine.INJURED)
  local InjuredText2 = self:AddComponent(UIText, "TableHead/InjuredText2")
  InjuredText2:SetLocalText(GameDialogDefine.INJURED)
  local WoundedText = self:AddComponent(UIText, "TableHead/WoundedText")
  WoundedText:SetLocalText(GameDialogDefine.WOUNDED)
  local WoundedText2 = self:AddComponent(UIText, "TableHead/WoundedText2")
  WoundedText2:SetLocalText(GameDialogDefine.WOUNDED)
  local HealthyText = self:AddComponent(UIText, "TableHead/HealthyText")
  HealthyText:SetLocalText(GameDialogDefine.HEALTHY)
  local HealthyText2 = self:AddComponent(UIText, "TableHead/HealthyText2")
  HealthyText2:SetLocalText(GameDialogDefine.HEALTHY)
  local degrades_info_cell_path = "SoldierContent/DegradesInfoCell"
  local degrades1_path = "SoldierContent/DegradesInfoCell/Degrades1"
  local degrades_text1_path = "SoldierContent/DegradesInfoCell/Degrades1/DegradesText1"
  local degrades_count_text1_path = "SoldierContent/DegradesInfoCell/Degrades1/DegradesCountText1"
  local degrades2_path = "SoldierContent/DegradesInfoCell/Degrades2"
  local degrades_text2_path = "SoldierContent/DegradesInfoCell/Degrades2/DegradesText2"
  local degrades_count_text2_path = "SoldierContent/DegradesInfoCell/Degrades2/DegradesCountText2"
  self.degrades_info_cell = self:AddComponent(UIBaseContainer, degrades_info_cell_path)
  self.degrades1 = self:AddComponent(UIButton, degrades1_path)
  self.degrades_text1 = self:AddComponent(UITextMeshProUGUIEx, degrades_text1_path)
  self.degrades_count_text1 = self:AddComponent(UITextMeshProUGUIEx, degrades_count_text1_path)
  self.degrades2 = self:AddComponent(UIButton, degrades2_path)
  self.degrades_text2 = self:AddComponent(UITextMeshProUGUIEx, degrades_text2_path)
  self.degrades_count_text2 = self:AddComponent(UITextMeshProUGUIEx, degrades_count_text2_path)
  self.degrades_text1:SetLocalText("season_mastery_UI_tips_19")
  self.degrades_text2:SetLocalText("season_mastery_UI_tips_19")
  self.degrades1:SetOnClick(function()
    self:ShowDegradesTip1()
  end)
  self.degrades2:SetOnClick(function()
    self:ShowDegradesTip2()
  end)
  self.defCityBreak_tip = self:AddComponent(MailSoldierPageItem, "SoldierContent/defCityBreakLost")
  self.hospitalFull_tip = self:AddComponent(MailSoldierPageItem, "SoldierContent/hospitalFullLost")
  self.ricochet_tip = self:AddComponent(MailSoldierPageItem, "SoldierContent/ricochetLost")
  self.mummyBlowUp_tip = self:AddComponent(MailSoldierPageItem, "SoldierContent/MummyBlowUp")
  self.reduceNum_tip = self:AddComponent(MailSoldierPageItem, "SoldierContent/ReduceNum")
  self.rule_btn = self:AddComponent(UIButton, "TableHead/rule_btn")
  self.rule_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSoldierDeadRateRule, {anim = true})
  end)
end

function MailSoldierPage:ComponentDestroy()
  self:ClearTips()
  self.soldierContent:RemoveComponents(MailSoldierCell)
  self.soldierCell.gameObject:GameObjectRecycleAll()
end

function MailSoldierPage:Refresh(extData)
  self.extData = extData
  self:RefreshView()
end

local SOLDIER_LOST_TIP_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/SoldierLostTip.prefab"

function MailSoldierPage:RefreshView()
  self.HospitalTip:SetActive(self.extData.myHospitalFull)
  self.soldierContent:RemoveComponents(MailSoldierCell)
  self.soldierCell.gameObject:GameObjectRecycleAll()
  self:ClearTips()
  local soldiers = {}
  local degradeSoldiers = {}
  local degrade1 = 0
  local degrade2 = 0
  for i = 1, 2 do
    for k, v in pairs(self.extData.player[i].soldierLost) do
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(v.soldierId)
      local isSuperSoldier = soldierTemplate and T11Util.IsSuperSoldier(soldierTemplate.lv, soldierTemplate.type) or false
      local key = v.soldierId
      if isSuperSoldier then
        local soldierEleven = self.extData.player[i].soldierEleven
        if soldierEleven then
          local stage = soldierEleven and soldierEleven.stage or 0
          local type = T11Util.GetSoldierTypeByEffectList(soldierEleven.effects)
          key = v.soldierId .. "|" .. type
          v.soldierEleven = {type = type, stage = stage}
        end
      end
      if not soldiers[key] then
        soldiers[key] = {}
        soldiers[key].id = v.soldierId
      end
      soldiers[key][i] = v
      if v.degrade ~= nil and 0 < v.degrade then
        if not degradeSoldiers[i] then
          degradeSoldiers[i] = {}
        end
        degradeSoldiers[i][v.soldierId] = v
        if i == 1 then
          degrade1 = degrade1 + v.degrade
        elseif i == 2 then
          degrade2 = degrade2 + v.degrade
        end
      end
    end
  end
  self.degradeSoldiers = degradeSoldiers
  local soldierCount = 0
  local sortedSoldiers = {}
  for k, v in pairs(soldiers) do
    table.insert(sortedSoldiers, v)
  end
  table.sort(sortedSoldiers, function(a, b)
    return a.id < b.id
  end)
  for k, v in pairs(sortedSoldiers) do
    soldierCount = soldierCount + 1
    local item = self.soldierCell:GameObjectSpawn(self.soldierContent.transform)
    item.name = "SoldierCell" .. soldierCount
    local obj = self.soldierContent:AddComponent(MailSoldierCell, item.name)
    obj:SetData(v)
  end
  if 0 < degrade1 then
    self.degrades_info_cell:SetActive(true)
    self.degrades_info_cell.transform:SetAsLastSibling()
    self.degrades1:SetActive(true)
    self.degrades2:SetActive(false)
    self.degrades_count_text1:SetText(tostring(degrade1))
  elseif 0 < degrade2 then
    self.degrades_info_cell:SetActive(true)
    self.degrades_info_cell.transform:SetAsLastSibling()
    self.degrades1:SetActive(false)
    self.degrades2:SetActive(true)
    self.degrades_count_text2:SetText(tostring(degrade2))
  else
    self.degrades_info_cell:SetActive(false)
  end
  local defSoldierEleven = self.extData.player[2].soldierEleven
  self.defCityBreak_tip:ReInit(self.extData.winKillSoldierList, "soldier_death_rule_panel_1", nil, defSoldierEleven)
  self.hospitalFull_tip:ReInit(self.extData.hospitalFullSoldierList, "soldier_death_rule_panel_2", nil, defSoldierEleven)
  self.ricochet_tip:ReInit(self.extData.ricochetSoldierList, "season_mastery_s2_tips_3", "Assets/Main/Sprites/UI/UIMastery/zyf_s2_wuweifangyu.png", defSoldierEleven)
  local selfIndex = self.extData.isAttack == false and 2 or 1
  local seasonPvpDeadReduce = self.extData.player[selfIndex].seasonPvpDeadReduce
  local selfSoldierEleven = self.extData.player[selfIndex].soldierEleven
  self.reduceNum_tip:ReInit(seasonPvpDeadReduce, "season_s6_callback_UI_11", "Assets/Main/SeasonRes/S6/Textures/Callback/mjc_s6_liandong_icon.png", selfSoldierEleven, "season_s6_callback_UI_12", true)
  local atkMummyBlowUpList = self.extData.atkMummyBlowUpList
  local defMummyBlowUpList = self.extData.defMummyBlowUpList
  local iconPath
  local meta = LocalController:instance():getLine(TableName.StatusTab, 703020)
  if meta then
    iconPath = meta.icon
  end
  if 0 < table.count(atkMummyBlowUpList) then
    if self.extData.isAttack then
      self.mummyBlowUp_tip:ReInit(atkMummyBlowUpList, "season_s3_Mummy_tips017", iconPath)
    else
      self.mummyBlowUp_tip:ReInit(atkMummyBlowUpList, "season_s3_Mummy_tips006", iconPath)
    end
  elseif 0 < table.count(defMummyBlowUpList) then
    if self.extData.isAttack then
      self.mummyBlowUp_tip:ReInit(defMummyBlowUpList, "season_s3_Mummy_tips006", iconPath)
    else
      self.mummyBlowUp_tip:ReInit(defMummyBlowUpList, "season_s3_Mummy_tips017", iconPath)
    end
  else
    self.mummyBlowUp_tip:SetActive(false)
  end
  local attackWoundedToRemainDetail = self.extData.player[1] and self.extData.player[1].woundedToRemainDetail or {}
  local defendWoundedToRemainDetail = self.extData.player[2] and self.extData.player[2].woundedToRemainDetail or {}
  local minorInjuryInfo = self.extData:GetMinorInjuryInfo()
  local attTotalDeathCount = 0
  for k, v in pairs(attackWoundedToRemainDetail) do
    attTotalDeathCount = attTotalDeathCount + toInt(v.count)
  end
  local defTotalDeathCount = 0
  for k, v in pairs(defendWoundedToRemainDetail) do
    defTotalDeathCount = defTotalDeathCount + toInt(v.count)
  end
  local t11AttEffNum = minorInjuryInfo.t11AttValue or 0
  local t11DefEffNum = minorInjuryInfo.t11DefValue or 0
  local attEffectData1 = self.extData:GetEffectFromPlayer(1)
  local attTotalNum_42001 = 0
  if attEffectData1 then
    attTotalNum_42001 = attEffectData1[EffectDefine.Minor_Injury_Recovery] or 0
  end
  local defEffectData2 = self.extData:GetEffectFromPlayer(2)
  local defTotalNum_42001 = 0
  if defEffectData2 then
    defTotalNum_42001 = defEffectData2[EffectDefine.Minor_Injury_Recovery] or 0
  end
  local t11AttDeath = 0
  local cardAttDeath = 0
  local t11DefDeath = 0
  local cardDefDeath = 0
  if 0 < attTotalNum_42001 then
    t11AttDeath = math.floor(t11AttEffNum / attTotalNum_42001 * attTotalDeathCount)
    cardAttDeath = attTotalDeathCount - t11AttDeath
  end
  if 0 < defTotalNum_42001 then
    t11DefDeath = math.floor(t11DefEffNum / defTotalNum_42001 * defTotalDeathCount)
    cardDefDeath = defTotalDeathCount - t11DefDeath
  end
  local attViewData = {}
  for k, v in pairs(self.extData.player[1].woundedToRemainDetail) do
    table.insert(attViewData, {
      id = v.soldierId,
      count = v.count
    })
  end
  local defViewData = {}
  for k, v in pairs(self.extData.player[2].woundedToRemainDetail) do
    table.insert(defViewData, {
      id = v.soldierId,
      count = v.count
    })
  end
  if cardAttDeath and 0 < cardAttDeath then
    local cardAttViewData = {}
    for _, v in pairs(attViewData) do
      table.insert(cardAttViewData, {
        id = v.id,
        count = math.floor(v.count * (cardAttDeath / attTotalDeathCount))
      })
    end
    local soldierTip = self:LoadComponentAsync(MailSoldierPageItemAsync, SOLDIER_LOST_TIP_PREFAB_PATH, self.soldierContent.transform)
    local soldierData = self.extData.player[1].soldierEleven
    soldierTip:ReInit(cardAttViewData, "battle_report_recover_attack", "Assets/Main/Sprites/UI/UILWMail/FX_zhanshukapai_fenxiang4_icon.png", true, soldierData, cardAttDeath)
    if not self.soldierTips then
      self.soldierTips = {}
    end
    table.insert(self.soldierTips, soldierTip)
  end
  if t11AttDeath and 0 < t11AttDeath then
    local t11AttViewData = {}
    for _, v in pairs(attViewData) do
      table.insert(t11AttViewData, {
        id = v.id,
        count = math.floor(v.count * (t11AttDeath / attTotalDeathCount))
      })
    end
    local soldierTip = self:LoadComponentAsync(MailSoldierPageItemAsync, SOLDIER_LOST_TIP_PREFAB_PATH, self.soldierContent.transform)
    local soldierData = self.extData.player[1].soldierEleven
    soldierTip:ReInit(t11AttViewData, "t11_battle_report_recover_attack", "Assets/Main/Sprites/UI/UIT11Icon/ljq_zhanbao_t11.png", true, soldierData, t11AttDeath)
    if not self.soldierTips then
      self.soldierTips = {}
    end
    table.insert(self.soldierTips, soldierTip)
  end
  if cardDefDeath and 0 < cardDefDeath then
    local cardDefViewData = {}
    for _, v in pairs(defViewData) do
      table.insert(cardDefViewData, {
        id = v.id,
        count = math.floor(v.count * (cardDefDeath / defTotalDeathCount))
      })
    end
    local soldierData = self.extData.player[2].soldierEleven
    local soldierTip = self:LoadComponentAsync(MailSoldierPageItemAsync, SOLDIER_LOST_TIP_PREFAB_PATH, self.soldierContent.transform)
    soldierTip:ReInit(cardDefViewData, "battle_report_recover_defend", "Assets/Main/Sprites/UI/UILWMail/FX_zhanshukapai_fenxiang4_icon.png", true, soldierData, cardDefDeath)
    if not self.soldierTips then
      self.soldierTips = {}
    end
    table.insert(self.soldierTips, soldierTip)
  end
  if t11DefDeath and 0 < t11DefDeath then
    local t11DefViewData = {}
    for _, v in pairs(defViewData) do
      table.insert(t11DefViewData, {
        id = v.id,
        count = math.floor(v.count * (t11DefDeath / defTotalDeathCount))
      })
    end
    local soldierData = self.extData.player[2].soldierEleven
    local soldierTip = self:LoadComponentAsync(MailSoldierPageItemAsync, SOLDIER_LOST_TIP_PREFAB_PATH, self.soldierContent.transform)
    soldierTip:ReInit(t11DefViewData, "t11_battle_report_recover_defend", "Assets/Main/Sprites/UI/UIT11Icon/ljq_zhanbao_t11.png", true, soldierData, t11DefDeath)
    if not self.soldierTips then
      self.soldierTips = {}
    end
    table.insert(self.soldierTips, soldierTip)
  end
end

function MailSoldierPage:ShowDegradesTip1()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDegradesTip, {anim = true}, self.degradeSoldiers[1], self.degrades1, true)
end

function MailSoldierPage:ShowDegradesTip2()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDegradesTip, {anim = true}, self.degradeSoldiers[2], self.degrades2, false)
end

function MailSoldierPage:ClearTips()
  if self.soldierTips then
    for k, v in pairs(self.soldierTips) do
      self:RemoveAsyncComponent(v)
    end
    self.soldierTips = {}
  end
end

return MailSoldierPage
