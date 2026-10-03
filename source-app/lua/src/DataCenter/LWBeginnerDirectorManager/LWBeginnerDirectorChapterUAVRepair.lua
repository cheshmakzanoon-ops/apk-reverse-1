local base = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorChapterBase")
local LWBeginnerDirectorChapterUAVRepair = BaseClass("LWBeginnerDirectorChapterUAVRepair", base)

function LWBeginnerDirectorChapterUAVRepair:__init()
  self.directorScript = {
    {
      Id = 1,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6001},
      Conditions = {
        [BeginnerScriptPointTriggerType.Time] = {0}
      }
    },
    {
      Id = 2,
      PointType = BeginnerScriptPointType.GuideFLow,
      Params = {6002},
      Conditions = {
        [BeginnerScriptPointTriggerType.TaskAllReceived] = {1}
      }
    },
    {
      Id = 3,
      PointType = BeginnerScriptPointType.SetMonopolyVisble,
      Params = {
        {
          35,
          false,
          false
        },
        {
          36,
          false,
          true
        },
        {
          37,
          true,
          false
        },
        {
          38,
          true,
          false
        },
        {
          39,
          true,
          false
        },
        {
          40,
          true,
          false
        }
      },
      Conditions = {
        [BeginnerScriptPointTriggerType.WaitPreDone] = {1}
      }
    }
  }
  self.chapterName = "LWBeginnerDirectorChapterUAVRepair"
end

function LWBeginnerDirectorChapterUAVRepair:__delete()
  self.directorScript = nil
end

return LWBeginnerDirectorChapterUAVRepair
