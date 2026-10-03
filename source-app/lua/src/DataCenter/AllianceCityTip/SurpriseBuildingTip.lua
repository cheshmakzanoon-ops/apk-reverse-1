local SurpriseBuildingTip = BaseClass("SurpriseBuildingTip")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local open_tips_path = "OpenTips"
local open_tips_icon_path = "OpenTips/icon"
local open_tips_time_path = "OpenTips/time"
local opened_path = "Opened"
local opened_label = "Opened/label"
local posOffset = Vector3.New(0, 4, 0)
local namePadding = 0.6
local colliderPadding = 0.6
local levelOffset = 0.3
local maxLod

function SurpriseBuildingTip:OnCreate(request)
  self.request = request
  self.gameObject = request.gameObject
  self.transform = request.gameObject.transform
  self.notOpen_tips_node = self.transform:Find(open_tips_path).gameObject
  self.notOpen_tips_icon_text = self.transform:Find(open_tips_icon_path).gameObject
  self.notOpen_tips_time_text = self.transform:Find(open_tips_time_path):GetComponent(typeof(CS.TextMeshProEx))
  self.opened_path = self.transform:Find(opened_path).gameObject
  self.opened_label = self.transform:Find(opened_label):GetComponent(typeof(CS.TextMeshProEx))
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  local isDawn = DataCenter.BloodyNightDataManager:IsDawn(LuaEntry.Player:GetCurServerId())
  if isDawn then
    self.isDawn = true
  else
    self.isDawn = false
  end
  if maxLod == nil then
    local lod = GetTableData(TableName.WorldLod, 65, "lod")
    if lod then
      local lod1, lod2 = string.match(lod, "([^-]+)-([^-]+)")
      if lod1 and lod2 then
        maxLod = toInt(lod2)
      end
    end
  end
  self:AddListeners()
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  
  function self.__update_handle()
    self:OnUpdate()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

function SurpriseBuildingTip:OnDestroy()
  self:RemoveListeners()
  self.notOpen_tips_node:SetActive(false)
  self.opened_path:SetActive(false)
  self:DeleteTimer()
  self.timer_action = nil
  self.timer = nil
  self.gameObject = nil
  self.transform = nil
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
end

function SurpriseBuildingTip:OnUpdate()
end

function SurpriseBuildingTip:OnPointDateUpdate()
  local data = self.data
  ProfilerUtil.BeginSample("SurpriseBuildingTip:OnPointDateUpdate")
  ProfilerUtil.EndSample()
end

local function StringToNumber(posStr)
  local commaIndex = string.find(posStr, ",")
  local num1 = string.sub(posStr, 1, commaIndex - 1)
  local num2 = string.sub(posStr, commaIndex + 1)
  num1 = tonumber(num1)
  num2 = tonumber(num2)
  return num1, num2
end

function SurpriseBuildingTip:SetData(data, offset, unlocked_prompt, prompt)
  self.data = data
  self.openTime = data.openTime
  self.unlocked_prompt = unlocked_prompt
  self.prompt = prompt
  local offsetX, offsetY = StringToNumber(offset)
  local tilePos = SceneUtils.IndexToTilePos(data.mainIndex)
  self:SetTilePos(tilePos, offsetX, offsetY)
  self:CheckLod(DisplaySettings.currentLod)
end

function SurpriseBuildingTip:ChangeToDawn()
  self.isDawn = true
  self:ShowTip()
  self:CheckLod(DisplaySettings.currentLod)
end

function SurpriseBuildingTip:ShowTip()
  if self.openTime == nil or self.openTime == 0 or self.isDawn then
    self.opened_path:SetActive(true)
    self.notOpen_tips_node:SetActive(false)
    local txt = Localization:GetString(self.unlocked_prompt)
    self.opened_label.text = txt
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.openTime - curTime
    if 0 < remainTime then
      self.opened_path:SetActive(false)
      self.timer_action()
      self:AddTimer()
    else
      self.opened_path:SetActive(true)
      self.notOpen_tips_node:SetActive(false)
      local txt = Localization:GetString(self.unlocked_prompt)
      self.opened_label.text = txt
    end
  end
end

function SurpriseBuildingTip:HideTip()
  self:DeleteTimer()
  self.opened_path:SetActive(false)
  self.notOpen_tips_node:SetActive(false)
end

function SurpriseBuildingTip:SetTilePos(tilePos, offsetX, offsetY)
  local pos = SceneUtils.TileToWorld(tilePos)
  self:SetPos(pos, offsetX, offsetY)
end

function SurpriseBuildingTip:SetPos(pos, offsetX, offsetY)
  local pos = Vector3.New(pos.x + offsetX, pos.y + offsetY, pos.z)
  self.OriginalPos = pos
  self.transform:Set_position(pos.x, pos.y, pos.z)
end

function SurpriseBuildingTip:TryUpdatePosition()
  local t = self.OriginalPos
  if self.transform == nil or t == nil then
    return
  end
  self.transform:Set_position(t.x, t.y, t.z)
end

function SurpriseBuildingTip:CheckLod(lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if 3 <= lod then
      self:HideTip()
    else
      self:ShowTip()
    end
    self:TryUpdatePosition()
  end
end

function SurpriseBuildingTip:AddTimer()
  self:DeleteTimer()
  if self.openTime == nil or self.openTime == 0 then
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function SurpriseBuildingTip:TimerAction()
  if self.openTime ~= nil and self.openTime ~= 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.openTime - curTime
    if 0 < remainTime then
      local txt = Localization:GetString(self.prompt, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.notOpen_tips_time_text.text = txt
      local textWidth = self.notOpen_tips_time_text:GetWidth()
      self.notOpen_tips_icon_text.transform:Set_localPosition(-textWidth * 0.5 - 0.14, 0, 0)
      self.notOpen_tips_node:SetActive(true)
    else
      self.openTime = nil
      self.notOpen_tips_node:SetActive(false)
      self.opened_path:SetActive(true)
    end
  end
  if self.openTime == nil or self.openTime == 0 then
    self:DeleteTimer()
  end
end

function SurpriseBuildingTip:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function SurpriseBuildingTip:AddListeners()
end

function SurpriseBuildingTip:RemoveListeners()
end

return SurpriseBuildingTip
