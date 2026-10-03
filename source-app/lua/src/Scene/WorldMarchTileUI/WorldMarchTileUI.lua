local WorldMarchTileUI = BaseClass("WorldMarchTileUI")
local Localization = CS.GameEntry.Localization
local march_time_obj_path = "GameObject/marchTimeBg"
local march_time_txt_path = "GameObject/marchTimeBg/marchTime"
local march_btn_1_path = "GameObject/BuildBtnGo/btn1"
local march_btn_1_img_path = "GameObject/BuildBtnGo/btn1/Image"
local march_btn_2_path = "GameObject/BuildBtnGo/btn2"
local march_btn_2_img_path = "GameObject/BuildBtnGo/btn2/Image"
local march_btn_3_path = "GameObject/BuildBtnGo/btn3"
local march_btn_3_img_path = "GameObject/BuildBtnGo/btn3/Image"
local march_btn_4_path = "GameObject/BuildBtnGo/btn4"
local march_btn_4_img_path = "GameObject/BuildBtnGo/btn4/Image"
local btn_obj_path = "GameObject/BuildBtnGo"
local WorldMarchStickerUI = require("Scene.WorldMarchTileUI.WorldMarchStickerUI")
local LeftNormalPos = Vector3.New(-134, -5, 0)
local LeftChangePos = Vector3.New(-84, -35, 0)
local RightNormalPos = Vector3.New(134, -5, 0)
local RightChangePos = Vector3.New(84, -35, 0)
local middlePos = Vector3.New(0, -55, 0)
local poss = {
  Vector3.New(77, -54, 0),
  Vector3.New(-85, -54, 0),
  Vector3.New(195, 48, 0),
  Vector3.New(-200, 48, 0)
}

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.march_time_obj = self.transform:Find(march_time_obj_path).gameObject
  self.btn_obj = self.transform:Find(btn_obj_path).gameObject
  
  function self.onClick1()
    self:OnBtn1Click()
  end
  
  function self.onClick2()
    self:OnBtn2Click()
  end
  
  function self.onClick3()
    self:OnBtn3Click()
  end
  
  function self.onClick4()
    self:OnBtn4Click()
  end
  
  self.march_time_txt = self.transform:Find(march_time_txt_path):GetComponent(typeof(CS.UnityEngine.UI.Text))
  self.march_btn_1 = self.transform:Find(march_btn_1_path):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.march_btn_1.onClick:AddListener(self.onClick1)
  self.march_btn_1_img = self.transform:Find(march_btn_1_img_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.march_btn_2 = self.transform:Find(march_btn_2_path):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.march_btn_2.onClick:AddListener(self.onClick2)
  self.march_btn_2_img = self.transform:Find(march_btn_2_img_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.march_btn_3 = self.transform:Find(march_btn_3_path):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.march_btn_3.onClick:AddListener(self.onClick3)
  self.march_btn_3_img = self.transform:Find(march_btn_3_img_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.march_btn_4 = self.transform:Find(march_btn_4_path):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.march_btn_4.onClick:AddListener(self.onClick4)
  self.march_btn_4_img = self.transform:Find(march_btn_4_img_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.btnRoot = self.transform:Find("GameObject")
  self.stickerPanel = self.transform:Find("sticker")
  self.isUpdate = false
  self.totalTime = 0
  self.btnListType = {}
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  self.btnRoot.gameObject:SetActive(true)
  self.stickerPanel.gameObject:SetActive(false)
  self.gmHappyKey = GMUtils.AddHappy(BindRet(self, self.DebugHappyInfo))
end

local function ComponentDestroy(self)
  self.isUpdate = false
  self:RemoveTimer()
  pcall(function()
    self.march_btn_1.onClick:Clear()
    self.march_btn_2.onClick:Clear()
    self.march_btn_3.onClick:Clear()
    self.march_btn_4.onClick:Clear()
  end)
  if self.stickerPanelCell then
    self.stickerPanelCell:Delete()
  end
  self.march_time_obj = nil
  self.march_time_txt = nil
  self.march_btn_1 = nil
  self.march_btn_1_img = nil
  self.march_btn_2 = nil
  self.march_btn_2_img = nil
  self.march_btn_3 = nil
  self.march_btn_3_img = nil
  self.march_btn_4 = nil
  self.march_btn_4_img = nil
  GMUtils.DelHappy(self.gmHappyKey)
  self.gmHappyKey = nil
end

local function RemoveTimer(self)
  UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
  self.__update_handle = nil
end

local function GetMarchUuid(self)
  return self.marchUuid
end

local function RefreshTroop(self, marchUuid)
  self.isUpdate = false
  self.marchUuid = marchUuid
  local marchInfo = CS.SceneManager.World:GetMarch(self.marchUuid)
  if marchInfo ~= nil then
    self.btnListType = {}
    self.marchInfo = marchInfo
    EventManager:GetInstance():Broadcast(EventId.OnClickMarch, marchInfo.ownerFormationUuid)
    local marchType = marchInfo:GetMarchType()
    if marchInfo.ownerUid == LuaEntry.Player.uid then
      self.btnListType = {}
      if marchType == NewMarchType.DIRECT_MOVE_MARCH then
        table.insert(self.btnListType, WorldMarchTileBtnType.March_ViewTroop)
      elseif marchType == NewMarchType.TRAIN then
      elseif marchType == NewMarchType.DETECT_ZOMBIE_BUS_TRAIN then
        table.insert(self.btnListType, WorldMarchTileBtnType.March_AttackZombieBusTrain)
      elseif marchType == NewMarchType.SCOUT then
      elseif marchType == NewMarchType.TREAT_VIRUS then
      elseif marchType == NewMarchType.LOTTO_RECEIVE then
      elseif marchType == NewMarchType.ZONE_MOBILIZATION_DONATE then
      elseif marchType == NewMarchType.MONSTER_CHALLENGE_DONATE then
      elseif marchType == NewMarchType.ASSEMBLY_MARCH then
      elseif marchType == NewMarchType.GOLLOES_EXPLORE or marchType == NewMarchType.GOLLOES_TRADE then
      elseif marchType == NewMarchType.RESOURCE_HELP then
      else
        table.insert(self.btnListType, WorldMarchTileBtnType.March_ViewTroop)
        table.insert(self.btnListType, WorldMarchTileBtnType.March_Rapid)
        if marchType ~= NewMarchType.ASSEMBLY_MARCH then
          table.insert(self.btnListType, WorldMarchTileBtnType.March_Sticker)
        end
      end
      if marchInfo:GetMarchTargetType() ~= MarchTargetType.BACK_HOME and marchInfo:GetMarchTargetType() ~= MarchTargetType.DIRECT_ATTACK_ACT_BOSS and marchType ~= NewMarchType.TRAIN and marchType ~= NewMarchType.ASSEMBLY_MARCH and marchType ~= NewMarchType.DETECT_ZOMBIE_BUS_TRAIN and not marchInfo:UnContinuousMarch() then
        table.insert(self.btnListType, WorldMarchTileBtnType.March_Callback)
      end
    else
      table.insert(self.btnListType, WorldMarchTileBtnType.March_PlayerInfo)
      if marchType == NewMarchType.ASSEMBLY_MARCH then
      elseif marchType == NewMarchType.TRAIN then
        local allianceId = LuaEntry.Player.allianceId
        if not string.IsNullOrEmpty(allianceId) and allianceId == marchInfo.allianceUid then
        else
          table.insert(self.btnListType, WorldMarchTileBtnType.March_AttackTrain)
        end
      end
    end
    if #self.btnListType == 2 then
      table.insert(self.btnListType, WorldMarchTileBtnType.None)
    end
    if marchInfo:GetIsBroken() or #self.btnListType <= 0 then
      self.btn_obj.gameObject:SetActive(false)
    else
      self.btn_obj.gameObject:SetActive(true)
      self:RefreshBtn()
    end
    self:OnMarchUpdate()
  end
  self.isUpdate = true
  self:Update()
end

function WorldMarchTileUI:OnBtnClick(type)
  if type == WorldMarchTileBtnType.March_Sticker then
    self.btnRoot.gameObject:SetActive(false)
    self.stickerPanel.gameObject:SetActive(true)
    if not self.stickerPanelCell then
      self.stickerPanelCell = WorldMarchStickerUI:New()
      self.stickerPanelCell:ReInit(self.stickerPanel.gameObject, self.marchUuid, function()
        self.btnRoot.gameObject:SetActive(true)
        self.stickerPanel.gameObject:SetActive(false)
      end)
    end
    return
  end
  if type == WorldMarchTileBtnType.March_Rapid and LuaEntry.Player:IsInBlackRange() then
    UIUtil.ShowMessage(Localization:GetString("457092"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    end)
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
  if self.marchInfo.targetPos == kingCityPosIndex and type == WorldMarchTileBtnType.March_Rapid then
    UIUtil.ShowMessage(Localization:GetString("457092"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    end)
    return
  end
  if type ~= nil and type ~= WorldMarchTileBtnType.None then
    WorldMarchTileUIManager:GetInstance():OnBtnClick(type, self.marchUuid)
  end
end

local function OnBtn1Click(self)
  self:OnBtnClick(self.btnListType[1])
end

local function OnBtn2Click(self)
  self:OnBtnClick(self.btnListType[2])
end

local function OnBtn3Click(self)
  self:OnBtnClick(self.btnListType[3])
end

function WorldMarchTileUI:OnBtn4Click()
  self:OnBtnClick(self.btnListType[4])
end

local function RefreshBtn(self)
  local count = #self.btnListType
  if count == 1 then
    self.march_btn_2.gameObject:SetActive(false)
    self.march_btn_3.gameObject:SetActive(false)
    self.march_btn_4.gameObject:SetActive(false)
    local type1 = self.btnListType[1]
    if type1 ~= nil and type1 ~= WorldMarchTileBtnType.None then
      self.march_btn_1.gameObject:SetActive(true)
      local img1 = WorldMarchBtnTypeImage[type1]
      self.march_btn_1_img:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, img1))
    else
      self.march_btn_1.gameObject:SetActive(false)
    end
  elseif count == 3 then
    local type1 = self.btnListType[1]
    local type2 = self.btnListType[2]
    local type3 = self.btnListType[3]
    if type1 ~= nil and type1 ~= WorldMarchTileBtnType.None then
      self.march_btn_1.gameObject:SetActive(true)
      local img1 = WorldMarchBtnTypeImage[type1]
      self.march_btn_1_img:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, img1))
      self.march_btn_1.gameObject.transform.localPosition = middlePos
      self.march_btn_2.gameObject.transform.localPosition = LeftNormalPos
      self.march_btn_3.gameObject.transform.localPosition = RightNormalPos
    else
      self.march_btn_1.gameObject:SetActive(false)
      self.march_btn_2.gameObject.transform.localPosition = LeftChangePos
      self.march_btn_3.gameObject.transform.localPosition = RightChangePos
    end
    if type2 ~= nil and type2 ~= WorldMarchTileBtnType.None then
      self.march_btn_2.gameObject:SetActive(true)
      local img2 = WorldMarchBtnTypeImage[type2]
      self.march_btn_2_img:LoadSprite(string.format(LoadPath.UIBuildBtns, img2))
    else
      self.march_btn_2.gameObject:SetActive(false)
    end
    if type3 ~= nil and type3 ~= WorldMarchTileBtnType.None then
      self.march_btn_3.gameObject:SetActive(true)
      local img3 = WorldMarchBtnTypeImage[type3]
      self.march_btn_3_img:LoadSprite(string.format(LoadPath.UIBuildBtns, img3))
    else
      self.march_btn_3.gameObject:SetActive(false)
    end
    self.march_btn_4.gameObject:SetActive(false)
  elseif count == 4 then
    local type1 = self.btnListType[1]
    local type2 = self.btnListType[2]
    local type3 = self.btnListType[3]
    local type4 = self.btnListType[4]
    if type1 ~= nil and type1 ~= WorldMarchTileBtnType.None then
      self.march_btn_1.gameObject:SetActive(true)
      local img1 = WorldMarchBtnTypeImage[type1]
      self.march_btn_1_img:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, img1))
      self.march_btn_1.gameObject.transform.localPosition = poss[1]
      self.march_btn_2.gameObject.transform.localPosition = poss[2]
      self.march_btn_3.gameObject.transform.localPosition = poss[4]
      self.march_btn_4.gameObject.transform.localPosition = poss[3]
    else
      self.march_btn_1.gameObject:SetActive(false)
      self.march_btn_2.gameObject.transform.localPosition = LeftChangePos
      self.march_btn_3.gameObject.transform.localPosition = RightChangePos
    end
    if type2 ~= nil and type2 ~= WorldMarchTileBtnType.None then
      self.march_btn_2.gameObject:SetActive(true)
      local img2 = WorldMarchBtnTypeImage[type2]
      self.march_btn_2_img:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, img2))
    else
      self.march_btn_2.gameObject:SetActive(false)
    end
    if type3 ~= nil and type3 ~= WorldMarchTileBtnType.None then
      self.march_btn_3.gameObject:SetActive(true)
      local img3 = WorldMarchBtnTypeImage[type3]
      self.march_btn_3_img:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, img3))
    else
      self.march_btn_3.gameObject:SetActive(false)
    end
    if type4 ~= nil and type4 ~= WorldMarchTileBtnType.None then
      self.march_btn_4.gameObject:SetActive(true)
      local img4 = WorldMarchBtnTypeImage[type4]
      self.march_btn_4_img:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, img4))
    else
      self.march_btn_4.gameObject:SetActive(false)
    end
  else
    self.march_btn_1.gameObject:SetActive(false)
    self.march_btn_2.gameObject:SetActive(false)
    self.march_btn_3.gameObject:SetActive(false)
    self.march_btn_4.gameObject:SetActive(false)
  end
end

local function Update(self)
  if self.isUpdate then
    self.totalTime = self.totalTime + Time.deltaTime
    if self.totalTime > 1 then
      if CS.SceneManager.World then
        local marchInfo = CS.SceneManager.World:GetMarch(self.marchUuid)
        if marchInfo ~= nil and not IsNull(marchInfo) then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local endTime = marchInfo.endTime
          if endTime == nil then
            endTime = 0
          end
          local timeLeft = endTime - curTime
          if 0 < timeLeft then
            self.march_time_txt.text = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
          else
            if self.march_time_obj.gameObject then
              self.march_time_obj.gameObject:SetActive(false)
            end
            self.isUpdate = false
          end
        end
      end
      self.totalTime = 0
    end
  end
end

local function OnMarchUpdate(self)
  local world = CS.SceneManager.World
  if world == nil then
    return
  end
  local marchInfo = world:GetMarch(self.marchUuid)
  if marchInfo ~= nil then
    if marchInfo.inBattle == true or marchInfo:GetMarchStatus() == MarchStatus.MOVING or marchInfo:GetMarchStatus() == MarchStatus.CHASING or marchInfo:GetMarchStatus() == MarchStatus.BACK_HOME or marchInfo:GetMarchStatus() == MarchStatus.ATTACKING or marchInfo:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or marchInfo:GetMarchStatus() == MarchStatus.CROSS_SERVER or marchInfo:GetMarchStatus() == MarchStatus.SAMPLING or marchInfo:GetMarchStatus() == MarchStatus.PICKING or marchInfo:GetMarchStatus() == MarchStatus.DESTROY_WAIT or marchInfo:GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME then
      self.isUpdate = true
      if self.march_time_obj.gameObject then
        self.march_time_obj.gameObject:SetActive(true)
      end
      self.totalTime = 1
    else
      if self.march_time_obj.gameObject then
        self.march_time_obj.gameObject:SetActive(false)
      end
      self.isUpdate = false
    end
  end
end

local function UpdatePosition(self)
  local troop = CS.SceneManager.World:GetTroop(self.marchUuid)
  if troop ~= nil then
    self.transform.position = troop:GetPosition()
  end
end

function WorldMarchTileUI:DebugHappyInfo()
  if not self.marchUuid then
    return nil
  end
  local marchInfo = CS.SceneManager.World:GetMarch(self.marchUuid)
  if marchInfo ~= nil then
    return marchInfo:Description()
  else
    return "March is null"
  end
end

WorldMarchTileUI.OnCreate = OnCreate
WorldMarchTileUI.OnDestroy = OnDestroy
WorldMarchTileUI.ComponentDefine = ComponentDefine
WorldMarchTileUI.ComponentDestroy = ComponentDestroy
WorldMarchTileUI.UpdatePosition = UpdatePosition
WorldMarchTileUI.Update = Update
WorldMarchTileUI.RemoveTimer = RemoveTimer
WorldMarchTileUI.OnMarchUpdate = OnMarchUpdate
WorldMarchTileUI.RefreshTroop = RefreshTroop
WorldMarchTileUI.OnBtn1Click = OnBtn1Click
WorldMarchTileUI.OnBtn2Click = OnBtn2Click
WorldMarchTileUI.OnBtn3Click = OnBtn3Click
WorldMarchTileUI.RefreshBtn = RefreshBtn
WorldMarchTileUI.GetMarchUuid = GetMarchUuid
return WorldMarchTileUI
