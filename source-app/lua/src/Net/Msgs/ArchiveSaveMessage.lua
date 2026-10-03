local ArchiveSaveMessage = BaseClass("ArchiveSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, key, value)
  base.OnCreate(self)
  key = tonumber(key)
  self.sfsObj:PutInt("type", key)
  if key == ArchiveSaveType.Comic then
    local obj = SFSObject.New()
    if value.readMap then
      local array = SFSArray.New()
      for k, v in pairs(value.readMap) do
        array:AddInt(k)
      end
      obj:PutSFSArray("readList", array)
    end
    if value.archiveMap then
      local array = SFSArray.New()
      for k, v in pairs(value.archiveMap) do
        array:AddInt(k)
      end
      obj:PutSFSArray("archiveList", array)
    end
    self.sfsObj:PutSFSObject("obj", obj)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t[tostring(ArchiveSaveType.Comic)] then
    local obj = t[tostring(ArchiveSaveType.Comic)]
    if not table.IsNullOrEmpty(obj) then
      DataCenter.ComicManager:OnReadOrArchiveComicHandler(obj)
    end
  end
end

ArchiveSaveMessage.OnCreate = OnCreate
ArchiveSaveMessage.HandleMessage = HandleMessage
return ArchiveSaveMessage
