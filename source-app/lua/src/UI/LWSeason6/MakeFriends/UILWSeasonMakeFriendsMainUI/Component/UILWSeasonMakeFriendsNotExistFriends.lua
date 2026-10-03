local UILWSeasonMakeFriendsNotExistFriends = BaseClass("UILWSeasonMakeFriendsNotExistFriends", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local red_point_root_path = "icon/RedPointNum"
local red_point_text_path = "icon/RedPointNum/Text"
local btn_search_path = "BtnSearch"
local btn_history_path = "BtnHistory"
local p_btn_help1_path = "p_btn_help1"
local p_btn_help2_path = "p_btn_help2"
local my_alli_icon_path = "MyAlliIcon"
local my_alli_path = "MyAlliIcon/MyAlli"
local red_point_num_history_path = "BtnHistory/RedPointNumHistory"
local text_history_path = "BtnHistory/RedPointNumHistory/TextHistory"
local green_point_num_path = "BtnSearch/GreenPointNum"
local green_text_path = "BtnSearch/GreenPointNum/GreenText"

function UILWSeasonMakeFriendsNotExistFriends:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self.my_alli_icon = self:AddComponent(UIImage, my_alli_icon_path)
  self.my_alli_txt = self:AddComponent(UITextMeshProUGUIEx, my_alli_path)
  self.red_point_root = self:AddComponent(UIBaseContainer, red_point_root_path)
  self.red_point_text = self:AddComponent(UITextMeshProUGUIEx, red_point_text_path)
  self.btn_search = self:AddComponent(UIButton, btn_search_path)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.p_btn_help1 = self:AddComponent(UIButton, p_btn_help1_path)
  self.p_btn_help2 = self:AddComponent(UIButton, p_btn_help2_path)
  self.icon = self:AddComponent(UIButton, icon_path)
  self.icon:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsSearchAlliance)
  end)
  self.btn_search:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsSearchAlliance)
  end)
  self.btn_history:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsHistory)
  end)
  self.p_btn_help1:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600001}
    })
  end)
  self.p_btn_help2:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600002}
    })
  end)
  self.history_red_point_root = self:AddComponent(UIBaseContainer, red_point_num_history_path)
  self.history_red_point_text = self:AddComponent(UITextMeshProUGUIEx, text_history_path)
  self.green_point_root = self:AddComponent(UIBaseContainer, green_point_num_path)
  self.green_point_text = self:AddComponent(UITextMeshProUGUIEx, green_text_path)
end

function UILWSeasonMakeFriendsNotExistFriends:OnDestroy()
  self.history_red_point_root = nil
  self.history_red_point_text = nil
  self.green_point_root = nil
  self.green_point_text = nil
  self.icon = nil
  self.red_point_root = nil
  self.red_point_text = nil
  self.btn_search = nil
  self.btn_history = nil
  self.p_btn_help1 = nil
  self.p_btn_help2 = nil
  self.my_alli_icon = nil
  self.my_alli_txt = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsNotExistFriends:OnEnable()
  base.OnEnable(self)
  self:OnAllyLogUpdate()
end

function UILWSeasonMakeFriendsNotExistFriends:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonMakeFriendsNotExistFriends:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MFAllyCombinedListUpdate, self.UpdateData)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:AddUIListener(EventId.MFAllyLogUpdate, self.OnAllyLogUpdate)
end

function UILWSeasonMakeFriendsNotExistFriends:OnRemoveListener()
  self:RemoveUIListener(EventId.MFAllyCombinedListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:RemoveUIListener(EventId.MFAllyLogUpdate, self.OnAllyLogUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsNotExistFriends:OnAllyLogUpdate()
  if self.green_point_root ~= nil then
    local allyCombinedList = DataCenter.SeasonAllyFriendManager:GetAllyCombinedList()
    if allyCombinedList == nil or allyCombinedList.sendList == nil then
      self.green_point_root:SetActive(false)
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      local count = 0
      for _, v in ipairs(allyCombinedList.sendList) do
        if v.applyBaseInfo ~= nil and v.allianceUid ~= nil and now < v.applyBaseInfo.expireTime then
          count = count + 1
        end
      end
      self.green_point_root:SetActive(0 < count)
      self.green_point_text:SetText(tostring(count))
    end
  end
  if self.history_red_point_root ~= nil then
    local newCount = DataCenter.SeasonAllyFriendManager:GetNewLogCount()
    if newCount and 0 < newCount then
      self.history_red_point_root:SetActive(true)
      self.history_red_point_text:SetText(tostring(newCount))
    else
      self.history_red_point_root:SetActive(false)
    end
  end
end

function UILWSeasonMakeFriendsNotExistFriends:UpdateData()
  if self.red_point_root and self:AsyncLoadDone() then
    local allyCombinedList = DataCenter.SeasonAllyFriendManager:GetAllyCombinedList()
    if allyCombinedList == nil then
      self.red_point_root:SetActive(false)
    else
      local dataCount = table.count(allyCombinedList.recList)
      if dataCount == 0 then
        self.red_point_root:SetActive(false)
      else
        self.red_point_root:SetActive(true)
        self.red_point_text:SetText(tostring(dataCount))
      end
    end
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.abbr ~= nil then
      self.my_alli_icon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
      self.my_alli_txt:SetText(UIUtil.FormatServerAllianceName(data.createServer or data.ownerServerId, data.abbr))
    end
    self:OnAllyLogUpdate()
  end
end

return UILWSeasonMakeFriendsNotExistFriends
