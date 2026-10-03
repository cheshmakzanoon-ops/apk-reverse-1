local UIDesertJumpToItem = BaseClass("UIDesertJumpToItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local finish_path = "finish"
local name_text_path = "NameText"
local go_btn_path = "GoBtn"

function UIDesertJumpToItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.finish = self:AddComponent(UIImage, finish_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:TryGo()
  end)
end

function UIDesertJumpToItem:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertJumpToItem:OnEnable()
  base.OnEnable(self)
end

function UIDesertJumpToItem:OnDisable()
  base.OnDisable(self)
end

function UIDesertJumpToItem:Setup(checkType, bfType)
  local valid, checkRst, failedParam = BattleFieldUtil.CheckCanEnterBattlefieldByCheckType(bfType, checkType)
  if not valid then
    self:SetActive(false)
  else
    self:SetActive(true)
    self.finish:SetActive(checkRst)
    if checkRst then
      self.bg:SetColorRGBA(1, 1, 1, 1)
    else
      self.bg:SetColorRGBA(1, 0.7098039215686275, 0.6627450980392157, 1)
    end
    self.name_text:SetLocalText(table.unpack(failedParam))
  end
  if checkType == BattlefieldEnterCheckType.AllianceIsValid then
    self.go_btn:SetActive(not checkRst)
  elseif checkType == BattlefieldEnterCheckType.BattlefieldMemberFull then
    self.go_btn:SetActive(false)
  elseif checkType == BattlefieldEnterCheckType.YouAreLowBeMember then
    self.go_btn:SetActive(false)
  elseif checkType == BattlefieldEnterCheckType.InBlackRect then
    self.go_btn:SetActive(false)
  end
end

function UIDesertJumpToItem:ReInit(index, bfType)
  if bfType == BattleFieldType.DsbDuel then
    self:Setup(index, bfType)
    return
  end
  local isOK = true
  local dragonInfo
  if bfType == BattleFieldType.Desert then
    dragonInfo = DataCenter.ActDragonManager:GetCurGroup()
  elseif bfType == BattleFieldType.EpidemicZone then
    dragonInfo = DataCenter.ActEpidemicZoneManager:GetCurGroup()
  end
  self.index = index
  if index == 1 then
    self.name_text:SetLocalText(458135, "")
    local signUp = 0
    if bfType == BattleFieldType.Desert then
      signUp = dragonInfo ~= nil and dragonInfo.signUp or 0
    elseif bfType == BattleFieldType.EpidemicZone then
      local signFlag = dragonInfo ~= nil and (dragonInfo.state == 1 or dragonInfo.state == 4)
      signUp = signFlag and 1 or 0
    end
    if signUp == 1 then
      isOK = true
    else
      isOK = false
      Logger.LogInfo("dragon.fail ==> \229\156\168\230\138\165\229\144\141\231\154\132\229\144\140\231\155\159\229\134\133\230\151\182\239\188\140\230\137\141\232\131\189\229\143\130\228\184\142\230\136\152\229\156\186")
    end
    self.finish:SetActive(isOK)
    self.go_btn:SetActive(not isOK)
  elseif index == 2 then
    self.name_text:SetLocalText(458136)
    if bfType == BattleFieldType.Desert then
      local vsInfoArr = dragonInfo ~= nil and dragonInfo.vsInfoArr or nil
      if vsInfoArr ~= nil then
        for _, v in ipairs(vsInfoArr) do
          if v.allianceId == LuaEntry.Player:GetAllianceUid() then
            isOK = v.battleNum < v.mainNum
            break
          end
        end
      end
    elseif bfType == BattleFieldType.EpidemicZone then
      local battleInfo = DataCenter.ActEpidemicZoneManager:GetBattleInfo()
      local vsInfoArr = battleInfo ~= nil and battleInfo.vsInfo or nil
      if vsInfoArr ~= nil then
        local myRole = DataCenter.ActEpidemicZoneManager:GetCurRole()
        local maxNumMain = LuaEntry.DataConfig:TryGetNum("YiBianJinQu", "k6", 20)
        local max = maxNumMain * (myRole == EpidemicZoneRole.Farmer and 2 or 1)
        for i, v in ipairs(vsInfoArr) do
          if v.role == myRole then
            isOK = max > (v.count or 0)
            break
          end
        end
      end
    end
    if not isOK then
      Logger.LogInfo("dragon.fail ==> \230\136\152\229\156\186\229\183\178\230\187\161\229\145\152")
    end
    self.finish:SetActive(isOK)
    self.go_btn:SetActive(not isOK)
  elseif index == 3 then
    self.name_text:SetLocalText(458137)
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
    local assigned = 0
    if bfType == BattleFieldType.Desert then
      assigned = dragonInfo ~= nil and dragonInfo.assigned or 0
    elseif bfType == BattleFieldType.EpidemicZone then
      assigned = dragonInfo ~= nil and dragonInfo.selfAssigned or 0
    end
    isOK = 0 < assigned
    if isOK then
      self.finish:LoadSpriteAuto("Assets/Main/Sprites/UI/LWAllianceTask/zyf_tongmenglichengbei_ditu.png")
    else
      Logger.LogInfo("dragon.fail ==> \228\184\141\230\152\175\230\156\172\230\172\161\230\136\152\230\150\151\231\154\132\229\143\130\230\136\152\230\136\150\230\155\191\232\161\165\228\186\186\229\145\152")
      self.finish:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertPath, "lrb_shamofengbao_tiaojianweiman"))
    end
  elseif index == 4 then
    self.name_text:SetLocalText(458138)
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
    isOK = not LuaEntry.Player:IsInBlackRange(true) and not LuaEntry.Player:IsInCityField()
    if isOK then
      self.finish:LoadSpriteAuto("Assets/Main/Sprites/UI/LWAllianceTask/zyf_tongmenglichengbei_ditu.png")
    else
      Logger.LogInfo("dragon.fail ==> \229\156\168\233\187\145\229\156\159\229\156\176\228\184\173")
      self.finish:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDesertPath, "lrb_shamofengbao_tiaojianweiman"))
    end
  elseif index == 5 then
    self.name_text:SetLocalText(458139)
    isOK = true
    self.finish:SetActive(isOK)
    self.go_btn:SetActive(not isOK)
  elseif index == 6 then
    self.name_text:SetLocalText(458140)
    if DataCenter.HospitalManager:IsHaveInjuredSolider() then
      isOK = false
    else
      local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
      if queue ~= nil and queue:GetQueueState() ~= NewQueueState.Free then
        isOK = false
      end
    end
    if not isOK then
      Logger.LogInfo("dragon.fail ==> \229\140\187\233\153\162\228\184\173\229\176\154\230\156\137\230\156\170\230\178\187\231\150\151\231\154\132\229\163\171\229\133\181")
    end
    self.finish:SetActive(isOK)
    self.go_btn:SetActive(not isOK)
  end
  if isOK then
    self.bg:SetColorRGBA(1, 1, 1, 1)
  else
    self.bg:SetColorRGBA(1, 0.7098039215686275, 0.6627450980392157, 1)
  end
end

function UIDesertJumpToItem:TryGo()
  local index = self.index
  if index == 1 then
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if hasAlliance then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertJumpTo)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMain, {anim = true})
    else
      UIUtil.ShowTipsId(390856)
    end
  elseif index == 2 then
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData == nil or baseData:CheckIfIsVirtualLeader() then
      return
    end
    local userInfo = {}
    userInfo.uid = baseData.leaderUid
    userInfo.userName = baseData.leaderName
    local data = {}
    data.privateUserInfo = userInfo
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
    GoToUtil.OpenChatView(false, {anim = false}, data)
  elseif index == 5 then
    local curScene = CS.SceneManager.CurrSceneID
    if curScene == SceneManagerSceneID.City then
      local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
      if 0 < mainWorldPos then
        local v3 = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World)
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, serverId)
      end
    else
      local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
      if 0 < mainWorldPos then
        local v3 = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertJumpTo)
        GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, serverId)
      end
    end
  elseif index == 6 then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertJumpTo)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital)
  end
end

return UIDesertJumpToItem
