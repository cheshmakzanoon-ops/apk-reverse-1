local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UILWTorchRelayMainComponent = BaseClass("UILWTorchRelayMainComponent", base)
local Localization = CS.GameEntry.Localization
local UILWTorchRelayMainGrowUpItemComponent = require("UI/LWTorchRelay/Activity/Main/UILWTorchRelayMainGrowUpItemComponent")
local UILWTorchRelayMainCheerItemComponent = require("UI/LWTorchRelay/Activity/Main/UILWTorchRelayMainCheerItemComponent")

function UILWTorchRelayMainComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayMainComponent:OnDestroy()
  self:DataDestroy()
  self:ClearCheer()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayMainComponent:ComponentDefine()
  self.btnEnter = self:AddComponent(UIButton, "BottomContent/EnterBtn")
  self.btnEnter:SetOnClick(function()
    self:OnBtnEnterClick()
  end)
  self.textEnter = self:AddComponent(UIText, "BottomContent/EnterBtn/Btn/EnterText")
  self.textEnter:SetText(Localization:GetString("activity_torch_relay_button_6"))
  self.imgEnter = self:AddComponent(UIImage, "BottomContent/EnterBtn/Btn/Layout/EnterImage")
  self.textEnterValue = self:AddComponent(UIText, "BottomContent/EnterBtn/Btn/Layout/EnterValueText")
  self.textTitle = self:AddComponent(UIText, "TopContent/Layout/TitleText")
  self.textTitle:SetText(Localization:GetString("activity_name_99086"))
  self.compTitleLayout = self:AddComponent(UIBaseContainer, "TopContent/Layout")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compTitleLayout.transform)
  self.textDes = self:AddComponent(UIText, "TopContent/DesText")
  self.textDes:SetText(Localization:GetString("activity_description_99086"))
  self.btnInfo = self:AddComponent(UIButton, "TopContent/Layout/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTime = self:AddComponent(UIText, "TopContent/TimeText")
  self.btnRank = self:AddComponent(UIButton, "TopContent/RankBtn")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textRank = self:AddComponent(UIText, "TopContent/RankBtn/RankText")
  self.textRank:SetText(Localization:GetString(456813))
  self.btnRankReward = self:AddComponent(UIButton, "TopContent/RankBtn/RankRewardBtn")
  self.btnRankReward:SetOnClick(function()
    self:OnBtnRankRewardClick()
  end)
  self.compRankUICommonResItem = self:AddComponent(UICommonResItem, "TopContent/RankBtn/RankRewardBtn/RankUICommonResItem")
  self.btnGacha = self:AddComponent(UIButton, "TopContent/GachaBtn")
  self.btnGacha:SetOnClick(function()
    self:OnBtnGachaClick()
  end)
  self.textGacha = self:AddComponent(UIText, "TopContent/GachaBtn/GachaText")
  self.textGacha:SetText(Localization:GetString("activity_torch_relay_button_2"))
  self.btnGaxchaReward = self:AddComponent(UIButton, "TopContent/GachaBtn/GaxchaRewardBtn")
  self.btnGaxchaReward:SetOnClick(function()
    self:OnBtnGaxchaRewardClick()
  end)
  self.compGachaUICommonResItem = self:AddComponent(UICommonResItem, "TopContent/GachaBtn/GaxchaRewardBtn/GachaUICommonResItem")
  self.btnMission = self:AddComponent(UIButton, "TopContent/MissionBtn")
  self.btnMission:SetOnClick(function()
    self:OnBtnMissionClick()
  end)
  self.textMission = self:AddComponent(UIText, "TopContent/MissionBtn/MissionText")
  self.textMission:SetText(Localization:GetString("activity_torch_relay_button_3"))
  self.btnPackage = self:AddComponent(UIButton, "TopContent/PackageBtn")
  self.btnPackage:SetOnClick(function()
    self:OnBtnPackageClick()
  end)
  self.textPackage = self:AddComponent(UIText, "TopContent/PackageBtn/PackageText")
  self.textPackage:SetText(Localization:GetString("activity_torch_relay_button_4"))
  self.btnResBar = self:AddComponent(UIButton, "TopContent/ResBar")
  self.btnResBar:SetOnClick(function()
    self:OnBtnResBarClick()
  end)
  self.imgResourceIcon = self:AddComponent(UIImage, "TopContent/ResBar/root/resourceIcon")
  self.textResourceNum = self:AddComponent(UIText, "TopContent/ResBar/root/resourceNum")
  self.btnAdd = self:AddComponent(UIButton, "TopContent/ResBar/addBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.compAddRedPoint = self:AddComponent(UIBaseContainer, "TopContent/ResBar/addBtn/addRedPoint")
  self.textGrowUpTitle = self:AddComponent(UIText, "GrowUpContent/TitleLayout/GrowUpTitleText")
  self.textGrowUpTitle:SetText(Localization:GetString("activity_torch_relay_desc_1"))
  self.textGrowUpValue = self:AddComponent(UIText, "GrowUpContent/TitleLayout/GrowUpValueText")
  self.compGrowUpItemTemplate01 = self:AddComponent(UILWTorchRelayMainGrowUpItemComponent, "GrowUpContent/GrowUpDetailContent/GrowUpItemTemplate1")
  self.compGrowUpItemTemplate02 = self:AddComponent(UILWTorchRelayMainGrowUpItemComponent, "GrowUpContent/GrowUpDetailContent/GrowUpItemTemplate2")
  self.compGrowUpItemTemplate03 = self:AddComponent(UILWTorchRelayMainGrowUpItemComponent, "GrowUpContent/GrowUpDetailContent/GrowUpItemTemplate3")
  self.compsGrowUp = {
    self.compGrowUpItemTemplate01,
    self.compGrowUpItemTemplate02,
    self.compGrowUpItemTemplate03
  }
  self.btnSelect = self:AddComponent(UIButton, "CheerContent/SelectBtn")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.textSelect = self:AddComponent(UIText, "CheerContent/SelectBtn/Btn/SelectText")
  self.textSelect:SetText(Localization:GetString("110073"))
  self.textCheerTitle = self:AddComponent(UIText, "CheerContent/TitleLayout/CheerTitleText")
  self.textCheerTitle:SetText(Localization:GetString("activity_torch_relay_desc_6"))
  self.textCheerValue = self:AddComponent(UIText, "CheerContent/TitleLayout/CheerValueText")
  self.compCheerItemTemplate = self:AddComponent(UILWTorchRelayMainCheerItemComponent, "CheerContent/CheerItemTemplate")
  self.compCheerItemTemplate:SetActive(false)
  self.compCheerItemTemplate.gameObject:GameObjectCreatePool()
  self.compGrowUpDetailContent = self:AddComponent(UIBaseContainer, "GrowUpContent/GrowUpDetailContent")
  self.compCheer = self:AddComponent(UIBaseContainer, "CheerContent")
  self.compCheerDetailContent = self:AddComponent(UIBaseContainer, "CheerContent/CheerDetailContent")
  self.btnCheerInfo = self:AddComponent(UIButton, "CheerContent/TitleLayout/CheerInfoBtn")
  self.btnCheerInfo:SetOnClick(function()
    self:OnCheerInfoClick()
  end)
  self.btnAuto = self:AddComponent(UIButton, "AutoLayout/AutoBtn")
  self.btnAuto:SetOnClick(function()
    self:OnBtnAutoClick()
  end)
  self.compAutoBeSelect = self:AddComponent(UIBaseContainer, "AutoLayout/AutoBtn/AutoBeSelect")
  self.compAuto = self:AddComponent(UIBaseContainer, "AutoLayout")
  self.textAuto = self:AddComponent(UIText, "AutoLayout/AutoText")
  self.textAuto:SetText(Localization:GetString("activity_torch_relay_desc_7"))
  self.compRedDotGacha = self:AddComponent(UIBaseContainer, "TopContent/GachaBtn/RedDotGacha")
  self.compRedDotMission = self:AddComponent(UIBaseContainer, "TopContent/MissionBtn/RedDotMission")
  self.compRedDotPackage = self:AddComponent(UIBaseContainer, "TopContent/PackageBtn/RedDotPackage")
  self.compRedDotAdd = self:AddComponent(UIBaseContainer, "TopContent/ResBar/RedDotAdd")
  self.ImageBg = self:AddComponent(UIRawImage, "BgRoot/Mask/ImageBg")
  self.GrowUpImage = self:AddComponent(UIImage, "GrowUpContent/GrowUpImage")
  self.skillTitleBg = self:AddComponent(UIImage, "GrowUpContent/skillTitleBg")
  self.BackgroundImage = self:AddComponent(UIImage, "CheerContent/BackgroundImage")
  self.bottomBackBg = self:AddComponent(UIImage, "BgRoot/Mask/bottomBackBg")
end

function UILWTorchRelayMainComponent:ComponentDestroy()
  self.btnEnter = nil
  self.textEnter = nil
  self.imgEnter = nil
  self.textEnterValue = nil
  self.textTitle = nil
  self.textDes = nil
  self.textTime = nil
  self.btnRank = nil
  self.textRank = nil
  self.btnRankReward = nil
  self.compRankUICommonResItem = nil
  self.btnGacha = nil
  self.textGacha = nil
  self.btnGaxchaReward = nil
  self.compGachaUICommonResItem = nil
  self.btnMission = nil
  self.textMission = nil
  self.btnPackage = nil
  self.textPackage = nil
  self.btnResBar = nil
  self.imgResourceIcon = nil
  self.textResourceNum = nil
  self.btnAdd = nil
  self.compAddRedPoint = nil
  self.textGrowUpTitle = nil
  self.textGrowUpValue = nil
  self.compGrowUpItemTemplate01 = nil
  self.compGrowUpItemTemplate02 = nil
  self.compGrowUpItemTemplate03 = nil
  self.btnSelect = nil
  self.textSelect = nil
  self.textCheerTitle = nil
  self.textCheerValue = nil
  self.compCheerItemTemplate = nil
  self.compGrowUpDetailContent = nil
  self.compCheerDetailContent = nil
  self.btnCheerInfo = nil
  self.btnAuto = nil
  self.compAutoBeSelect = nil
  self.textAuto = nil
  self.compAuto = nil
  self.btnInfo = nil
  self.compTitleLayout = nil
  self.compRedDotGacha = nil
  self.compRedDotMission = nil
  self.compRedDotPackage = nil
  self.compRedDotAdd = nil
  self.compCheer = nil
end

function UILWTorchRelayMainComponent:DataDefine()
end

function UILWTorchRelayMainComponent:DataDestroy()
end

function UILWTorchRelayMainComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayActReceiveExtraData, self.OnGetExtraData)
  self:AddUIListener(EventId.ActivityTorchRelayActReceiveData, self.OnGetData)
  self:AddUIListener(EventId.ActivityTorchRelayActGrowUp, self.OnGrowUp)
  self:AddUIListener(EventId.ActivityTorchRelayActUpdateRed, self.OnRedUpdate)
  self:AddUIListener(EventId.BoxItemDrawShowDrawSuccess, self.OnBoxItemDrawSuccess)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
  self:AddUIListener(EventId.ActivityTorchRelayCheerMemberSelectEnd, self.OnMemberSelectUpdate)
  self:AddUIListener(EventId.ActivityTorchRelayActResUpdate, self.OnResUpdate)
  self:AddUIListener(EventId.ActivityTorchRelayMilesRewardGet, self.OnRedUpdate)
end

function UILWTorchRelayMainComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTorchRelayActReceiveExtraData, self.OnGetExtraData)
  self:RemoveUIListener(EventId.ActivityTorchRelayActReceiveData, self.OnGetData)
  self:RemoveUIListener(EventId.ActivityTorchRelayActGrowUp, self.OnGrowUp)
  self:RemoveUIListener(EventId.ActivityTorchRelayActUpdateRed, self.OnRedUpdate)
  self:RemoveUIListener(EventId.BoxItemDrawShowDrawSuccess, self.OnBoxItemDrawSuccess)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
  self:RemoveUIListener(EventId.ActivityTorchRelayCheerMemberSelectEnd, self.OnMemberSelectUpdate)
  self:RemoveUIListener(EventId.ActivityTorchRelayActResUpdate, self.OnResUpdate)
  self:RemoveUIListener(EventId.ActivityTorchRelayMilesRewardGet, self.OnRedUpdate)
  base.OnRemoveListener(self)
end

function UILWTorchRelayMainComponent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  self.skillTitleBg:LoadSpriteAsync(data.config:GetGameSkillTitleBg())
  self.BackgroundImage:LoadSpriteAsync(data.config:GetGameTeamTitleBg())
  self.bottomBackBg:LoadSpriteAsync(data.config:GetGameMainBg())
  local activityConfigData = LocalController:instance():getLine(TableName.Activity, toInt(self.activityId))
  if activityConfigData then
    self.textTitle:SetLocalText(activityConfigData.name)
    self.textDes:SetLocalText(activityConfigData.desc)
    self.ImageBg:LoadSpriteAsync(activityConfigData.banner)
  end
  local stageConfig = data.config:GetStageConfigTemplate()
  self.GrowUpImage:LoadSpriteAsync(stageConfig:getMiniMileIcon())
  local curStage = data:GetCurStage()
  if curStage == DataCenter.ActivityTorchRelayManager.Stage.Normal then
    DataCenter.ActivityTorchRelayManager:RequestExtraData(self.activityId)
    self.compCheer:SetActive(false)
    self:UpdateNormalStage()
  end
  if curStage == DataCenter.ActivityTorchRelayManager.Stage.Final then
  end
end

function UILWTorchRelayMainComponent:UpdateNormalStage()
  self:UpdateTop()
  self:UpdateEnter()
  self:UpdateAutoCheer()
  self:UpdateGrowUp()
  self:UpdateRed()
end

function UILWTorchRelayMainComponent:UpdateTop()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  local rankRewards = data.config:GetShowRankReward()
  if rankRewards[1] ~= nil then
    self.compRankUICommonResItem:ReInit(rankRewards[1])
  end
  local drawReward = data.config:GetShowDrawReward()
  self.btnGaxchaReward:SetActive(drawReward ~= nil)
  if drawReward ~= nil then
    self.compGachaUICommonResItem:ReInit(drawReward)
  end
  self:Update1000MS()
  self:UpdateRes()
end

function UILWTorchRelayMainComponent:UpdateEnter()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  local costId, costNum = data.config:GetGameCost()
  if costId ~= nil and costNum ~= nil then
    self.textEnterValue:SetText("\195\151" .. tostring(costNum))
    if DataCenter.ActivityTorchRelayManager:IsGameCostItemEnough(self.activityId) then
      self.textEnterValue:SetColor(WhiteColor)
    else
      self.textEnterValue:SetColor(RedColor)
    end
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costId)
    self.imgEnter:LoadSprite(iconPath)
  end
end

function UILWTorchRelayMainComponent:UpdateRes()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  local costId, costNum = data.config:GetGameCost()
  if costId ~= nil and costNum ~= nil then
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costId)
    self.imgResourceIcon:LoadSprite(iconPath)
    local curNum = DataCenter.ItemData:GetItemRealCount(costId)
    self.textResourceNum:SetText(curNum)
  end
end

function UILWTorchRelayMainComponent:Update1000MS()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil then
    return
  end
  local leftTime = data:GetLeftTime()
  if self.textTime ~= nil then
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, leftTime)))
  end
end

function UILWTorchRelayMainComponent:UpdateAutoCheer()
  local isOn = DataCenter.ActivityTorchRelayManager:IsAutoCheerOn()
  self.compAutoBeSelect:SetActive(isOn)
end

function UILWTorchRelayMainComponent:UpdateGrowUp()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  self.textGrowUpValue:SetText(tostring(data:GetCurGrowUpLevelCostItemCount()))
  for i, v in pairs(DataCenter.ActivityTorchRelayManager.GrowUpType) do
    if self.compsGrowUp[v] ~= nil then
      self.compsGrowUp[v]:ReInit(self.activityId, v)
    end
  end
end

function UILWTorchRelayMainComponent:UpdateCheerAutoSelect()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil then
    return
  end
  if DataCenter.ActivityTorchRelayManager:IsAutoCheerOn() then
    data:UpdateAutoSelect()
  end
end

function UILWTorchRelayMainComponent:UpdateCheer()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  local allData = data:GetAllCheerPlayersData()
  local curData = data:GetCheerCurSelectUidList()
  local curCount = 0
  if curData then
    curCount = #curData
  end
  local totalCount = 0
  if allData then
    totalCount = #allData
  end
  self.textCheerValue:SetText("(" .. tostring(curCount) .. "/" .. tostring(totalCount) .. ")")
  local data01, data02
  if curData ~= nil then
    if curData[1] ~= nil then
      data01 = data:GetCheerPlayerDataByUid(curData[1])
    end
    if curData[2] ~= nil then
      data02 = data:GetCheerPlayerDataByUid(curData[2])
    end
  end
  if self.compsCheer == nil then
    self:ClearCheer()
    self.compsCheer = {}
    for i = 1, 2 do
      local itemData
      if i == 1 then
        itemData = data01
      else
        itemData = data02
      end
      local item = self.compCheerItemTemplate.gameObject:GameObjectSpawn(self.compCheerDetailContent.transform)
      item.name = "cheer_item_" .. tostring(i)
      local obj = self.compCheerDetailContent:AddComponent(UILWTorchRelayMainCheerItemComponent, item.name)
      obj:SetActive(true)
      self.compsCheer[tostring(i)] = obj
      obj:ReInit(self.activityId, itemData)
    end
  else
    for i = 1, 2 do
      local itemData
      if i == 1 then
        itemData = data01
      else
        itemData = data02
      end
      if self.compsCheer[tostring(i)] ~= nil then
        self.compsCheer[tostring(i)]:ReInit(self.activityId, itemData)
      end
    end
  end
end

function UILWTorchRelayMainComponent:ClearCheer()
  self.compCheerDetailContent:RemoveComponents(UILWTorchRelayMainCheerItemComponent)
  for _, v in ipairs(self.compCheerDetailContent.transform) do
    if not IsNull(v) then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.compCheerItemTemplate.gameObject:GameObjectRecycleAll()
  self.compsCheer = nil
end

function UILWTorchRelayMainComponent:OnGetExtraData()
  if self.activityId == nil then
    return
  end
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  local curStage = data:GetCurStage()
  if curStage == DataCenter.ActivityTorchRelayManager.Stage.Normal then
    self.compCheer:SetActive(true)
    self:UpdateCheerAutoSelect()
    self:UpdateCheer()
  end
  if curStage == DataCenter.ActivityTorchRelayManager.Stage.Final then
  end
end

function UILWTorchRelayMainComponent:OnGrowUp()
  self:UpdateGrowUp()
end

function UILWTorchRelayMainComponent:OnGetData()
  self:SetData(self.activityId)
end

function UILWTorchRelayMainComponent:OnRedUpdate()
  self:UpdateRed()
end

function UILWTorchRelayMainComponent:OnResUpdate()
  self:UpdateRes()
  self:UpdateEnter()
  self:UpdateGrowUp()
end

function UILWTorchRelayMainComponent:OnBoxItemDrawSuccess()
  self:UpdateRed()
  self:UpdateRes()
  self:UpdateEnter()
end

function UILWTorchRelayMainComponent:OnPackageInfoUpdated()
  self:UpdateRes()
  self:UpdateEnter()
end

function UILWTorchRelayMainComponent:OnMemberSelectUpdate()
  self:UpdateAutoCheer()
  self:UpdateCheer()
end

function UILWTorchRelayMainComponent:UpdateRed()
  if self.activityId then
    self.compRedDotAdd:SetActive(DataCenter.ActivityTorchRelayManager:GetGiftPackageRedCount(self.activityId) > 0)
    self.compRedDotGacha:SetActive(0 < DataCenter.ActivityTorchRelayManager:GetBoxItemDrawRedCount(self.activityId))
    self.compRedDotPackage:SetActive(DataCenter.ActivityTorchRelayManager:GetGiftPackageRedCount(self.activityId) > 0)
    self.compRedDotMission:SetActive(0 < DataCenter.ActivityTorchRelayManager:GetTaskRedCount(self.activityId))
  end
end

function UILWTorchRelayMainComponent:OnBtnEnterClick()
  if self.activityId == nil then
    return
  end
  if not DataCenter.ActivityTorchRelayManager:IsGameCostItemEnough(self.activityId) then
    DataCenter.ActivityTorchRelayManager:OnCostItemLack(self.activityId)
    return false
  end
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local memberList = activityData:GetAllCheerPlayersData()
  local cheerList = activityData:GetCheerCurSelectUidList()
  local memberCount = 0
  if memberList then
    memberCount = #memberList
  end
  local cheerCount = 0
  if cheerList then
    cheerCount = #cheerList
  end
  if cheerCount == 2 then
    DataCenter.ActivityTorchRelayManager:EnterBattle(self.activityId)
  elseif cheerCount < 2 and memberCount > cheerCount then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITorchRelayCheerSelectMember, {anim = true}, self.activityId)
  elseif cheerCount == memberCount and memberCount < 2 then
    UIUtil.ShowMessage(Localization:GetString("activity_torch_relay_desc_18"), 2, "activity_torch_relay_button_8", "activity_torch_relay_button_6", function()
      DataCenter.ActivityTorchRelayManager:ShareCheerToChat(self.activityId)
    end, function()
      DataCenter.ActivityTorchRelayManager:EnterBattle(self.activityId)
    end)
  else
    Logger.LogError(" > 2 ??????!!!!!!!!!!!!")
  end
end

function UILWTorchRelayMainComponent:OnBtnRankClick()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.TorchRelayRank, {anim = true}, {
      activityId = self.activityId
    })
  end
end

function UILWTorchRelayMainComponent:OnBtnRankRewardClick()
end

function UILWTorchRelayMainComponent:OnBtnGachaClick()
  if self.activityId then
    local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if data and data.config and data.config.draw_box_id > 0 then
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(data.config.draw_box_id)
      if template then
        local groupId = checknumber(template.para1)
        local drawBoxData = DataCenter.BoxItemDrawManager:GetUserData(groupId)
        if drawBoxData ~= nil then
          if drawBoxData:GetTemplate(drawBoxData:GetCurRound()) == nil then
            UIUtil.ShowTipsId("activity_torch_relay_desc_53")
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBoxItemDraw, {anim = true}, {
              itemId = data.config.draw_box_id
            })
          end
        end
      end
    end
  end
end

function UILWTorchRelayMainComponent:OnBtnGaxchaRewardClick()
end

function UILWTorchRelayMainComponent:OnBtnMissionClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITorchRelayTaskView, self.activityId)
end

function UILWTorchRelayMainComponent:OnBtnPackageClick()
  if self.activityId then
    DataCenter.ActivityTorchRelayManager:OpenCostItemPackage(self.activityId)
  end
end

function UILWTorchRelayMainComponent:OnBtnResBarClick()
end

function UILWTorchRelayMainComponent:OnBtnAddClick()
  if self.activityId then
    DataCenter.ActivityTorchRelayManager:OpenCostItemPackage(self.activityId)
  end
end

function UILWTorchRelayMainComponent:OnBtnSelectClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.TorchRelayCheerInfo, {anim = true}, {
    activityId = self.activityId
  })
end

function UILWTorchRelayMainComponent:OnBtnAutoClick()
  DataCenter.ActivityTorchRelayManager:SetAutoCheerOn(not DataCenter.ActivityTorchRelayManager:IsAutoCheerOn())
  self:UpdateAutoCheer()
  self:UpdateCheerAutoSelect()
  self:UpdateCheer()
end

function UILWTorchRelayMainComponent:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 13)
end

function UILWTorchRelayMainComponent:OnCheerInfoClick()
  if self.activityId then
    local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if data and data.config then
      local param = {
        activityRulesStr = Localization:GetString("activity_torch_relay_rule_2new", tostring(data.config.cheer_num_max), "2", tostring(data.config.cheer_other_num), tostring(data.config.rare_cheer_reward_num))
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end
end

return UILWTorchRelayMainComponent
